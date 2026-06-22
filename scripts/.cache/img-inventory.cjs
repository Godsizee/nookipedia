// Read-only inventory of every image field: uuid / http / local(ok|missing) / null.
const axios = require('axios');
const fs = require('fs');
const path = require('path');
const BASE = process.env.PUBLIC_DIRECTUS_URL || 'https://backend-nookipedia.2.godsize.info';
const auth = { Authorization: `Bearer ${process.env.DIRECTUS_TOKEN}` };
const PUB = path.resolve(__dirname, '../../public/assets/img/acnh');

// (collection, field, callsite-folder) — folder mirrors how the frontend calls getImageUrl.
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
  ['artworks', 'image_real', 'museum'],
  ['artworks', 'image_fake', 'museum'],
  ['events', 'image_path', 'events'],
  ['villagers', 'image_path', ''],
  ['fossils', 'image_path', 'museum'],
  ['special_npcs', 'image_path', 'museum'],
];
const isUuid = (s) => /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(s);
function collapse(p) { const o = []; for (const s of p.split('/')) { if (s === '..') o.pop(); else if (s && s !== '.') o.push(s); } return o.join('/'); }
function localRel(val, folder) {
  let c = val.replace(/^\/+/, '');
  if (c.startsWith('assets/')) c = c.slice(7);
  if (c.startsWith('img/acnh/')) c = c.slice(9);
  const anchored = folder && (!c.includes('/') || c.startsWith('../')) ? `${folder}/${c}` : c;
  return collapse(anchored);
}
async function all(coll, fields) {
  const out = []; let page = 1;
  for (;;) {
    const r = await axios.get(`${BASE}/items/${coll}`, { headers: auth, params: { fields, limit: 500, page } });
    out.push(...r.data.data);
    if (r.data.data.length < 500) break; page++;
  }
  return out;
}
(async () => {
  const localFiles = new Set();
  let grand = { uuid: 0, http: 0, localOk: 0, localMissing: 0, nul: 0 };
  for (const [coll, field, folder] of TARGETS) {
    let rows;
    try { rows = await all(coll, `id,${field}`); } catch (e) { console.log(`${coll}.${field}: nicht lesbar (${e.response?.status || e.message})`); continue; }
    const c = { uuid: 0, http: 0, localOk: 0, localMissing: 0, nul: 0 };
    const miss = [];
    for (const r of rows) {
      const v = r[field];
      if (!v) { c.nul++; continue; }
      if (isUuid(v)) { c.uuid++; continue; }
      if (/^https?:/i.test(v)) { c.http++; continue; }
      const rel = localRel(v, folder);
      if (fs.existsSync(path.join(PUB, rel))) { c.localOk++; localFiles.add(rel); }
      else { c.localMissing++; if (miss.length < 4) miss.push(`${v} -> ${rel}`); }
    }
    for (const k in grand) grand[k] += c[k];
    const flag = c.localOk + c.localMissing > 0 ? '  <<< LOKAL' : '';
    console.log(`${coll}.${field} (${rows.length}): uuid=${c.uuid} http=${c.http} localOk=${c.localOk} localMissing=${c.localMissing} null=${c.nul}${flag}`);
    miss.forEach((m) => console.log(`      fehlt: ${m}`));
  }
  console.log('\n=== GESAMT ===');
  console.log(grand);
  console.log(`Eindeutige lokale Dateien zu migrieren: ${localFiles.size}`);
  let bytes = 0; localFiles.forEach((f) => { try { bytes += fs.statSync(path.join(PUB, f)).size; } catch {} });
  console.log(`Gesamtgröße: ${(bytes / 1048576).toFixed(1)} MB`);
})().catch((e) => { console.error('FATAL:', e.response?.data || e.message); process.exit(1); });
