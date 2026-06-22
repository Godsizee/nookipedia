/**
 * migrate-local-images.js — Konsolidiert alle Bildquellen auf DB-Ebene:
 * lädt lokale Dateien (public/assets/img/acnh/…) in den Directus-Storage und
 * ersetzt das jeweilige image-Feld durch die Asset-UUID. Frontend braucht keine
 * Änderung (getImageUrl löst UUID → /assets/<uuid>).
 *
 * Idempotent: bereits-UUID/http/null-Werte werden übersprungen; Uploads werden
 * über filename_download wiederverwendet (kein Doppel-Upload, gefahrlos re-runbar).
 *
 * Flags: --apply (sonst Dry-Run), --collection=NAME (nur eine Collection).
 * Token via ENV DIRECTUS_TOKEN, URL via PUBLIC_DIRECTUS_URL.
 */
import axios from 'axios';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import FormData from 'form-data';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const BASE = process.env.PUBLIC_DIRECTUS_URL || 'https://backend-nookipedia.2.godsize.info';
const TOKEN = process.env.DIRECTUS_TOKEN;
const auth = { Authorization: `Bearer ${TOKEN}` };
const PUB = path.resolve(__dirname, '../public/assets/img/acnh');
const CACHE = path.resolve(__dirname, '.cache');
const APPLY = process.argv.includes('--apply');
const ONLY = (process.argv.find((a) => a.startsWith('--collection=')) || '').split('=')[1];

// (collection, field, callsite-folder) — folder spiegelt die getImageUrl-Aufrufe im Frontend.
const TARGETS = [
  ['creatures', 'image_path', ''],
  ['diy_recipes', 'image_path', ''],
  ['cooking_recipes', 'image_path', ''],
  ['materials', 'image_path', 'materials'],
  ['flowers', 'image_path', ''],
  ['flower_seeds', 'image_path', ''],
  ['flower_combinations', 'parent1_image', ''],
  ['flower_combinations', 'parent2_image', ''],
  ['flower_combinations', 'child_image', ''],
  ['events', 'image_path', 'events'],
].filter(([c]) => !ONLY || c === ONLY);

const isUuid = (s) => /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(s);
const collapse = (p) => { const o = []; for (const s of p.split('/')) { if (s === '..') o.pop(); else if (s && s !== '.') o.push(s); } return o.join('/'); };
function localRel(val, folder) {
  let c = val.replace(/^\/+/, '');
  if (c.startsWith('assets/')) c = c.slice(7);
  if (c.startsWith('img/acnh/')) c = c.slice(9);
  const anchored = folder && (!c.includes('/') || c.startsWith('../')) ? `${folder}/${c}` : c;
  return collapse(anchored);
}
const encName = (rel) => rel.replace(/\//g, '__'); // stabiler, kollisionsfreier filename_download
const ctype = (rel) => (rel.toLowerCase().endsWith('.webp') ? 'image/webp' : rel.toLowerCase().endsWith('.jpg') || rel.toLowerCase().endsWith('.jpeg') ? 'image/jpeg' : 'image/png');

async function all(coll, fields) {
  const out = []; let page = 1;
  for (;;) {
    const r = await axios.get(`${BASE}/items/${coll}`, { headers: auth, params: { fields, limit: 500, page } });
    out.push(...r.data.data);
    if (r.data.data.length < 500) break; page++;
  }
  return out;
}

/** filename_download → uuid (alle vorhandenen Directus-Files einmal laden). */
async function loadFileMap() {
  const map = new Map(); let page = 1;
  for (;;) {
    const r = await axios.get(`${BASE}/files`, { headers: auth, params: { fields: 'id,filename_download', limit: 500, page } });
    for (const f of r.data.data) if (f.filename_download) map.set(f.filename_download, f.id);
    if (r.data.data.length < 500) break; page++;
  }
  return map;
}

async function run() {
  if (APPLY && !TOKEN) throw new Error('DIRECTUS_TOKEN fehlt');

  // 1) Plan + Backup bauen
  const plan = []; // {coll, field, id, rel, old}
  const stat = { total: 0, alreadyUuid: 0, http: 0, nul: 0, missing: 0, toMigrate: 0 };
  const missingFiles = [];
  for (const [coll, field, folder] of TARGETS) {
    const rows = await all(coll, `id,${field}`);
    for (const r of rows) {
      stat.total++;
      const v = r[field];
      if (!v) { stat.nul++; continue; }
      if (isUuid(v)) { stat.alreadyUuid++; continue; }
      if (/^https?:/i.test(v)) { stat.http++; continue; }
      const rel = localRel(v, folder);
      if (!fs.existsSync(path.join(PUB, rel))) { stat.missing++; missingFiles.push(`${coll}.${field}#${r.id}: ${v}`); continue; }
      plan.push({ coll, field, id: r.id, rel, old: v });
      stat.toMigrate++;
    }
  }
  console.log('── Plan ──');
  console.log(stat);
  if (missingFiles.length) { console.log(`Fehlende Dateien (bleiben unverändert): ${missingFiles.length}`); missingFiles.slice(0, 5).forEach((m) => console.log('   ' + m)); }
  const uniqueRels = [...new Set(plan.map((p) => p.rel))];
  console.log(`Eindeutige Dateien: ${uniqueRels.length}`);

  fs.mkdirSync(CACHE, { recursive: true });
  fs.writeFileSync(path.join(CACHE, 'img-migration-backup.json'), JSON.stringify(plan.map(({ coll, field, id, old }) => ({ coll, field, id, old })), null, 2));
  console.log(`Backup geschrieben: .cache/img-migration-backup.json (${plan.length} Einträge)`);

  if (!APPLY) { console.log('\n(DRY-RUN — mit --apply ausführen)'); return; }

  // 2) Upload-Phase (dedup über filename_download)
  console.log('\nLade vorhandene Directus-Files …');
  const fileMap = await loadFileMap();
  console.log(`   ${fileMap.size} vorhandene Files.`);
  const relUuid = new Map();
  let up = 0, reused = 0, upFail = 0;
  for (const rel of uniqueRels) {
    const fname = encName(rel);
    if (fileMap.has(fname)) { relUuid.set(rel, fileMap.get(fname)); reused++; continue; }
    try {
      const form = new FormData();
      form.append('file', fs.createReadStream(path.join(PUB, rel)), { filename: fname, contentType: ctype(rel) });
      const res = await axios.post(`${BASE}/files`, form, { headers: { ...form.getHeaders(), ...auth } });
      const id = res.data.data.id;
      relUuid.set(rel, id); fileMap.set(fname, id); up++;
    } catch (e) { upFail++; if (upFail <= 5) console.log(`   Upload-Fehler ${rel}: ${e.response?.status || e.message}`); }
    if ((up + reused) % 100 === 0) process.stdout.write(`\r   Upload: neu ${up}, reused ${reused}, fail ${upFail}`);
  }
  console.log(`\r   Upload fertig: neu ${up}, reused ${reused}, fail ${upFail}        `);

  // 3) Patch-Phase
  let patched = 0, patchFail = 0, skipNoUuid = 0;
  for (const p of plan) {
    const uuid = relUuid.get(p.rel);
    if (!uuid) { skipNoUuid++; continue; }
    try {
      await axios.patch(`${BASE}/items/${p.coll}/${p.id}`, { [p.field]: uuid }, { headers: auth });
      patched++;
    } catch (e) { patchFail++; if (patchFail <= 5) console.log(`   Patch-Fehler ${p.coll}#${p.id}: ${e.response?.status || e.message}`); }
    if (patched % 200 === 0) process.stdout.write(`\r   Patch: ${patched}/${plan.length}`);
  }
  console.log(`\r   Patch fertig: ${patched}/${plan.length} (fail ${patchFail}, ohne-uuid ${skipNoUuid})        `);
  console.log('\n✅ Migration fertig.');
}

run().catch((e) => { console.error('FATAL:', e.response?.data || e.message); process.exit(1); });
