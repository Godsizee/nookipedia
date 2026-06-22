// Fix English name_de left by legacy upsert (only patched null fields).
// Refreshes name_de from the DE-map where a differing German name exists.
// Also reports any global duplicate display names as a sanity check.
const fs = require('fs');
const axios = require('axios');
const URL = process.env.PUBLIC_DIRECTUS_URL || 'https://backend-nookipedia.2.godsize.info';
const auth = { Authorization: `Bearer ${process.env.DIRECTUS_TOKEN}` };
const APPLY = process.argv.includes('--apply');
const deMap = require('./item-de-map.json');
const norm = (s) => (s || '').trim().toLowerCase();
async function all(path, params) {
  const out = []; let page = 1;
  for (;;) {
    const res = await axios.get(`${URL}${path}`, { headers: auth, params: { ...params, limit: 500, page } });
    out.push(...res.data.data);
    if (res.data.data.length < 500) break; page++;
  }
  return out;
}
(async () => {
  const items = await all('/items/items', { fields: 'id,name_en,name_de,category' });

  // sanity: global duplicate display names
  const byName = {};
  items.forEach((it) => { const k = norm(it.name_de); (byName[k] ||= []).push(it); });
  const dups = Object.entries(byName).filter(([, g]) => g.length > 1);
  console.log(`Globale Anzeige-Namen-Dubletten (name_de): ${dups.length} Gruppen`);
  dups.slice(0, 10).forEach(([k, g]) => console.log(`  "${k}": ${g.map((x) => x.id + '/' + x.category).join(', ')}`));

  // build patch list
  const toFix = [];
  for (const it of items) {
    const de = deMap[norm(it.name_en)];
    if (de && de !== it.name_de) toFix.push({ id: it.id, from: it.name_de, to: de });
  }
  console.log(`\nname_de zu korrigieren: ${toFix.length}`);
  toFix.slice(0, 12).forEach((t) => console.log(`  id=${t.id} "${t.from}" -> "${t.to}"`));
  fs.writeFileSync(__dirname + '/name-fix-backup.json', JSON.stringify(toFix, null, 2));

  if (!APPLY) { console.log('\n(DRY-RUN — mit --apply ausführen)'); return; }
  let done = 0;
  for (const t of toFix) {
    await axios.patch(`${URL}/items/items/${t.id}`, { name_de: t.to }, { headers: auth });
    if (++done % 50 === 0) process.stdout.write(`\r  gepatcht: ${done}/${toFix.length}`);
  }
  console.log(`\r✅ name_de gepatcht: ${done}/${toFix.length}        `);
})().catch((e) => { console.error('FATAL:', e.response?.data || e.message); process.exit(1); });
