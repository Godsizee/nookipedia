/**
 * fill-variant-images-from-wiki.js — füllt fehlende Variantenbilder (image_path
 * == null) aus dem animalcrossingwiki.de-Katalog nach: lädt je Variante das Bild
 * anhand ihres eigenen `filename`-Felds, lädt es in den Directus-Storage und setzt
 * `image_path` auf die Asset-UUID. Frontend braucht keine Änderung
 * (getImageUrl löst UUID → /assets/<uuid>).
 *
 * Quelle-URL: <WIKI>/<folder>/<lowercase(filename)>.png
 *   z. B. FtrWireShelf_Remake_0_0 → …/einrichtung/ftrwireshelf_remake_0_0.png
 *
 * Idempotent: Varianten mit bereits gesetztem image_path werden übersprungen;
 * Uploads werden über filename_download wiederverwendet (kein Doppel-Upload).
 *
 * Flags:
 *   --apply                 schreiben (sonst Dry-Run)
 *   --items=4320,4321,…     Item-IDs (Default: Alurohr-Serie)
 *   --wiki-folder=einrichtung   Katalog-Unterordner auf der Wiki (Default: einrichtung)
 * ENV: DIRECTUS_TOKEN (Schreibzugriff), PUBLIC_DIRECTUS_URL.
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
const CACHE = path.resolve(__dirname, '.cache');
const APPLY = process.argv.includes('--apply');
const flag = (n) => (process.argv.find((a) => a.startsWith(`--${n}=`)) || '').split('=')[1] || '';

const DEFAULT_ITEMS = [4320, 4321, 5147, 5148, 5149]; // Alurohr-Serie
const ITEMS = (flag('items') ? flag('items').split(',').map(Number) : DEFAULT_ITEMS).filter(Boolean);
const WIKI = 'https://animalcrossingwiki.de/data/media/acnh/katalog/klein';
const FOLDER = flag('wiki-folder') || 'einrichtung';

const isUuid = (s) => /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(s);
const wikiUrl = (filename) => `${WIKI}/${FOLDER}/${filename.toLowerCase()}.png`;

async function variantsFor(items) {
  const r = await axios.get(`${BASE}/items/item_variants`, {
    headers: TOKEN ? auth : {},
    params: { filter: { item_id: { _in: items } }, fields: 'id,item_id,filename,image_path', limit: -1 },
  });
  return r.data.data;
}

/** filename_download → uuid (vorhandene Directus-Files für Dedup). */
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
  if (APPLY && !TOKEN) throw new Error('DIRECTUS_TOKEN fehlt (für Schreibzugriff).');

  // 1) Plan: Varianten ohne Bild, aber mit filename.
  const rows = await variantsFor(ITEMS);
  const stat = { total: rows.length, alreadySet: 0, noFilename: 0, toFill: 0 };
  const plan = []; // {id, filename, dl, old}
  for (const r of rows) {
    if (r.image_path) { stat.alreadySet++; continue; }
    if (!r.filename) { stat.noFilename++; continue; }
    plan.push({ id: r.id, filename: r.filename, dl: `${r.filename}.png`, old: r.image_path ?? null });
    stat.toFill++;
  }
  console.log('── Plan ──');
  console.log('Items:', ITEMS.join(', '), '| Wiki-Ordner:', FOLDER);
  console.log(stat);
  const uniqueDls = [...new Set(plan.map((p) => p.dl))];
  console.log(`Eindeutige Bilder: ${uniqueDls.length}`);

  fs.mkdirSync(CACHE, { recursive: true });
  fs.writeFileSync(path.join(CACHE, 'wiki-image-backup.json'), JSON.stringify(plan.map(({ id, old }) => ({ id, old })), null, 2));
  console.log(`Backup geschrieben: .cache/wiki-image-backup.json (${plan.length} Einträge)`);

  if (!APPLY) {
    // Dry-Run: Quellbilder per HEAD prüfen, damit der Apply sicher durchläuft.
    let ok = 0, miss = 0; const missing = [];
    for (const dl of uniqueDls) {
      const fn = dl.replace(/\.png$/i, '');
      try { const h = await axios.head(wikiUrl(fn)); if (h.status === 200) ok++; else { miss++; missing.push(fn); } }
      catch { miss++; missing.push(fn); }
    }
    console.log(`Quell-Check: ${ok} erreichbar, ${miss} fehlen`);
    if (missing.length) missing.slice(0, 10).forEach((m) => console.log('   fehlt: ' + m));
    console.log('\n(DRY-RUN — mit --apply ausführen)');
    return;
  }

  // 2) Upload-Phase (Download von der Wiki → Directus, dedup über filename_download).
  console.log('\nLade vorhandene Directus-Files …');
  const fileMap = await loadFileMap();
  console.log(`   ${fileMap.size} vorhandene Files.`);
  const dlUuid = new Map();
  let up = 0, reused = 0, upFail = 0;
  for (const dl of uniqueDls) {
    if (fileMap.has(dl)) { dlUuid.set(dl, fileMap.get(dl)); reused++; continue; }
    const fn = dl.replace(/\.png$/i, '');
    try {
      const img = await axios.get(wikiUrl(fn), { responseType: 'arraybuffer' });
      const form = new FormData();
      form.append('file', Buffer.from(img.data), { filename: dl, contentType: 'image/png' });
      const res = await axios.post(`${BASE}/files`, form, { headers: { ...form.getHeaders(), ...auth } });
      const id = res.data.data.id;
      dlUuid.set(dl, id); fileMap.set(dl, id); up++;
    } catch (e) { upFail++; if (upFail <= 5) console.log(`   Upload-Fehler ${dl}: ${e.response?.status || e.message}`); }
    if ((up + reused) % 50 === 0) process.stdout.write(`\r   Upload: neu ${up}, reused ${reused}, fail ${upFail}`);
  }
  console.log(`\r   Upload fertig: neu ${up}, reused ${reused}, fail ${upFail}        `);

  // 3) Patch-Phase: image_path → UUID.
  let patched = 0, patchFail = 0, skip = 0;
  for (const p of plan) {
    const uuid = dlUuid.get(p.dl);
    if (!uuid) { skip++; continue; }
    try {
      await axios.patch(`${BASE}/items/item_variants/${p.id}`, { image_path: uuid }, { headers: auth });
      patched++;
    } catch (e) { patchFail++; if (patchFail <= 5) console.log(`   Patch-Fehler #${p.id}: ${e.response?.status || e.message}`); }
    if (patched % 100 === 0) process.stdout.write(`\r   Patch: ${patched}/${plan.length}`);
  }
  console.log(`\r   Patch fertig: ${patched}/${plan.length} (fail ${patchFail}, ohne-uuid ${skip})        `);
  console.log('\n✅ Fertig.');
}

run().catch((e) => { console.error('FATAL:', e.response?.data || e.message); process.exit(1); });
