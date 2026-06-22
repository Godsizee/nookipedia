// Read-only audit: where do frontend images resolve to placeholders?
const axios = require('axios');
const BASE = process.env.PUBLIC_DIRECTUS_URL || 'https://backend-nookipedia.2.godsize.info';
const auth = { Authorization: `Bearer ${process.env.DIRECTUS_TOKEN}` };
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
  // ---- Catalog: replicate getItemsCatalog firstImage logic ----
  const variants = await all('item_variants', 'item_id,image_path,id');
  const firstImg = new Map();      // first-seen (current frontend logic)
  const anyImg = new Map();        // does the item have ANY non-null image?
  variants.forEach((v) => {
    if (!firstImg.has(v.item_id)) firstImg.set(v.item_id, v.image_path);
    if (v.image_path) anyImg.set(v.item_id, true);
  });
  const items = await all('items', 'id,name_de,category');
  let placeholderItems = 0, fixableByAnyImage = 0, trulyImageless = 0;
  const fixSample = [];
  for (const it of items) {
    const shown = firstImg.get(it.id) || null;
    if (!shown) {
      placeholderItems++;
      if (anyImg.get(it.id)) { fixableByAnyImage++; if (fixSample.length < 12) fixSample.push(it.name_de + ' / ' + it.category); }
      else trulyImageless++;
    }
  }
  console.log('=== KATALOG (items) ===');
  console.log(`Items gesamt:                 ${items.length}`);
  console.log(`Items zeigen Platzhalter:     ${placeholderItems}`);
  console.log(`  davon FIXBAR (erstes Var-Bild null, aber andere Variante hat Bild): ${fixableByAnyImage}`);
  console.log(`  davon echt bildlos (alle Varianten null = 3.0.0):                   ${trulyImageless}`);
  if (fixSample.length) { console.log('  Beispiele fixbar:'); fixSample.forEach((s) => console.log('    - ' + s)); }

  const nullVar = variants.filter((v) => !v.image_path).length;
  console.log(`Varianten ohne Bild gesamt:   ${nullVar} / ${variants.length}`);

  // ---- Other collections: null image fields ----
  console.log('\n=== ANDERE COLLECTIONS (Null-Bildfeld) ===');
  const checks = [
    ['creatures', 'image_path'], ['fossils', 'image_path'], ['villagers', 'image_path'],
    ['flowers', 'image_path'], ['artworks', 'image_real'], ['special_npcs', 'image_path'],
  ];
  for (const [coll, field] of checks) {
    try {
      const rows = await all(coll, `id,${field}`);
      const nulls = rows.filter((r) => !r[field]).length;
      console.log(`  ${coll}.${field}: ${nulls} null / ${rows.length}`);
    } catch (e) { console.log(`  ${coll}: nicht lesbar (${e.response?.status || e.message})`); }
  }
})().catch((e) => { console.error('FATAL:', e.response?.data || e.message); process.exit(1); });
