const axios = require('axios');
const fs = require('fs');
const path = require('path');
const BASE = process.env.PUBLIC_DIRECTUS_URL || 'https://backend-nookipedia.2.godsize.info';
const auth = { Authorization: `Bearer ${process.env.DIRECTUS_TOKEN}` };
const PUB = path.resolve(__dirname, '../../public/assets/img/acnh');
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
  console.log('=== LOKALE DATEIEN (existieren auf der Platte?) ===');
  for (const coll of ['creatures', 'flowers']) {
    const rows = await all(coll, 'id,image_path');
    let missing = 0; const sample = [];
    for (const r of rows) {
      if (!r.image_path) continue;
      if (/^https?:|^[0-9a-f-]{36}$/i.test(r.image_path)) continue; // skip http/uuid
      const rel = r.image_path.replace(/^\/+/, '').replace(/^assets\//, '').replace(/^img\/acnh\//, '');
      if (!fs.existsSync(path.join(PUB, rel))) { missing++; if (sample.length < 10) sample.push(rel); }
    }
    console.log(`  ${coll}: ${missing} fehlende Datei(en) / ${rows.length}`);
    sample.forEach((s) => console.log('     ✗ ' + s));
  }

  console.log('\n=== DIRECTUS-ASSETS (HTTP-Status Stichprobe) ===');
  for (const coll of ['item_variants', 'villagers', 'fossils', 'special_npcs']) {
    const r = await all(coll, 'image_path');
    const uuid = r.map((x) => x.image_path).find((p) => p && /^[0-9a-f-]{36}$/i.test(p));
    if (!uuid) { console.log(`  ${coll}: keine UUID gefunden`); continue; }
    try {
      const res = await axios.get(`${BASE}/assets/${uuid}`, { responseType: 'arraybuffer', validateStatus: () => true });
      console.log(`  ${coll}: /assets/${uuid.slice(0, 8)}… -> HTTP ${res.status} (${res.headers['content-type'] || '?'})`);
    } catch (e) { console.log(`  ${coll}: Fehler ${e.message}`); }
  }
})().catch((e) => { console.error('FATAL:', e.response?.data || e.message); process.exit(1); });
