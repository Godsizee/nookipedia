// Read-only: find duplicate catalog items + name-language issues.
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

  // 1) Duplicates by (category + name_en)
  const byKey = {};
  items.forEach((it) => { const k = it.category + '|' + norm(it.name_en); (byKey[k] ||= []).push(it); });
  const dupKeys = Object.entries(byKey).filter(([, g]) => g.length > 1);
  console.log(`=== Dubletten nach (category + name_en lower): ${dupKeys.length} Gruppen ===`);
  dupKeys.slice(0, 20).forEach(([k, g]) => {
    console.log(`  [${k}]`);
    g.forEach((it) => console.log(`     id=${it.id} en="${it.name_en}" de="${it.name_de}" cat=${it.category} var=${vc[it.id] || 0}`));
  });
  const totalDupItems = dupKeys.reduce((s, [, g]) => s + g.length, 0);
  console.log(`  -> betroffene Item-Zeilen: ${totalDupItems} (überzählig: ${totalDupItems - dupKeys.length})`);

  // 2) name_de == name_en (English fallback shown to user)
  const eng = items.filter((it) => it.name_de && norm(it.name_de) === norm(it.name_en));
  console.log(`\n=== name_de == name_en (englischer Fallback sichtbar): ${eng.length} ===`);
  eng.slice(0, 15).forEach((it) => console.log(`  id=${it.id} en="${it.name_en}" de="${it.name_de}" cat=${it.category}`));
  const engByCat = {};
  eng.forEach((it) => (engByCat[it.category] = (engByCat[it.category] || 0) + 1));
  console.log('  pro Kategorie:', JSON.stringify(engByCat));

  // 3) name_de null
  const noDe = items.filter((it) => !it.name_de);
  console.log(`\n=== name_de IS NULL: ${noDe.length} ===`);
})().catch((e) => { console.error('FATAL:', e.response?.data || e.message); process.exit(1); });
