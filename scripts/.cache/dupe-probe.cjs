const axios = require('axios');
const URL = process.env.PUBLIC_DIRECTUS_URL || 'https://backend-nookipedia.2.godsize.info';
const auth = { Authorization: `Bearer ${process.env.DIRECTUS_TOKEN}` };
async function all(path, params) {
  const out = []; let page = 1;
  for (;;) {
    const res = await axios.get(`${URL}${path}`, { headers: auth, params: { ...params, limit: 500, page } });
    out.push(...res.data.data);
    if (res.data.data.length < 500) break; page++;
  }
  return out;
}
const norm = (s) => (s || '').trim().toLowerCase();
(async () => {
  const items = await all('/items/items', { fields: 'id,name_en,name_de,category' });
  const vc = {};
  (await all('/items/item_variants', { fields: 'item_id' })).forEach((v) => (vc[v.item_id] = (vc[v.item_id] || 0) + 1));

  // probes
  const probes = ['bath stool', 'bathroom stall', 'basketball hoop', 'basketballkorb'];
  console.log('=== Probe-Items (Match auf name_en ODER name_de) ===');
  probes.forEach((p) => {
    const hits = items.filter((it) => norm(it.name_en) === p || norm(it.name_de) === p);
    hits.forEach((it) => console.log(`  "${p}" -> id=${it.id} en="${it.name_en}" de="${it.name_de}" cat=${it.category} var=${vc[it.id] || 0}`));
  });

  // duplicate DISPLAY names (what the user sees), within same category
  const byDisp = {};
  items.forEach((it) => { const k = it.category + '|' + norm(it.name_de); (byDisp[k] ||= []).push(it); });
  const dispDup = Object.entries(byDisp).filter(([, g]) => g.length > 1);
  const overcount = dispDup.reduce((s, [, g]) => s + g.length - 1, 0);
  console.log(`\n=== Doppelte Anzeige-Namen (category + name_de): ${dispDup.length} Gruppen, ${overcount} überzählige Karten ===`);
  dispDup.slice(0, 25).forEach(([k, g]) => {
    console.log(`  [${k}]  (${g.length}x)`);
    g.forEach((it) => console.log(`     id=${it.id} en="${it.name_en}" de="${it.name_de}" var=${vc[it.id] || 0}`));
  });
})().catch((e) => { console.error('FATAL:', e.response?.data || e.message); process.exit(1); });
