/**
 * sync-item-catalog.js · Vollständiger Item-Katalog aus dem Community-Master-Sheet
 * nach Directus spiegeln – inkl. Bilder und deutscher Namen, in Batches.
 *
 * WARUM
 * -----
 * Directus hatte nur ~939 Items (6 Möbel-Kategorien, je auf 150 gedeckelt) und
 * deren item_variants verwiesen auf tote Directus-Asset-UUIDs → der Katalog zeigt
 * überall den Köder-Platzhalter. Dieses Skript importiert ALLE Katalog-Tabs
 * (Möbel + Kleidung + Tools + Music/Photos/Posters/Fencing/Gyroids), lädt pro
 * Variante das echte acnhcdn-Icon in den Directus-Storage und schreibt dessen
 * UUID nach item_variants.image_path. Das Frontend (getImageUrl) löst die UUID
 * bereits zu /assets/<uuid> auf – keine Frontend-Änderung nötig.
 *
 * Voraussetzung Anzeige: `directus_files` braucht Public-Read (Permission id 22
 * für die Public-Policy gesetzt am 2026-06-21), sonst liefert /assets 403.
 *
 * BILDQUELLE   https://acnhcdn.com/latest/FtrIcon/<Filename>.png  (deckt Möbel
 *             UND Kleidung – verifiziert).
 * NAMEN (DE)   Translations-Sheet, Spalten EUen→EUde (über alle Tabs vereint,
 *             lokal gecached unter scripts/.cache/item-de-map.json).
 *
 * IDEMPOTENZ   Items werden per (name_en+category) ge-upsertet. Varianten per
 *             `unique_entry_id` (global eindeutig im Sheet): existierende werden
 *             übersprungen → jeder Batch ist gefahrlos wiederholbar. Die alten
 *             kaputten Varianten (unique_entry_id=null) werden einmalig per
 *             --purge-legacy entfernt. Hochgeladene Dateien werden über
 *             filename_download wiederverwendet → kein Doppel-Download.
 *
 * NUTZUNG
 *   node scripts/sync-item-catalog.js --report                 # nur Analyse
 *   DIRECTUS_TOKEN=… node … --purge-legacy                     # Alt-Varianten löschen (einmalig)
 *   DIRECTUS_TOKEN=… node … --tabs=Tops,Bottoms                # mehrere Tabs
 *   DIRECTUS_TOKEN=… node … --tab=Housewares --offset=0 --limit=170   # Item-Fenster (großer Tab)
 *   … --skip-images          # Daten ohne Bild-Upload
 *   … --refresh-map          # DE-Map-Cache neu bauen
 *
 * NETZ: braucht Egress zu docs.google.com, acnhcdn.com und der Directus-API.
 */
import fs from 'fs';
import path from 'path';
import axios from 'axios';
import Papa from 'papaparse';
import FormData from 'form-data';

const DIRECTUS_URL = process.env.PUBLIC_DIRECTUS_URL || 'https://backend-nookipedia.2.godsize.info';
const TOKEN = process.env.DIRECTUS_TOKEN || '';

// Veröffentlichtes Daten-Sheet (pub?gid=…&output=csv) – Kategorie → gid.
const DATA_PUB =
  'https://docs.google.com/spreadsheets/d/e/2PACX-1vTGrIfAI5ybCvaiIux5kEbermRFZe6aooAs7I1iVrJF27DrXSOJQxxEcQXzIw6KRacx1721da2oN2SM/pub?single=true&output=csv&gid=';
const TABS = {
  Housewares: '1095915930',
  'Wall-mounted': '1070641835',
  Wallpaper: '538528185',
  Floors: '854415471',
  Rugs: '1995330463',
  'Ceiling Decor': '2053509204',
  Miscellaneous: '1908332537',
  'Tools/Goods': '821113275',
  Tops: '311161081',
  Bottoms: '1082151672',
  'Dress-Up': '2001558184',
  Headwear: '1633665839',
  Accessories: '1577018746',
  Socks: '904658376',
  Shoes: '129826056',
  Bags: '978151150',
  Umbrellas: '899748669',
  'Clothing Other': '1485168676',
  Music: '338594892',
  Photos: '1252944026',
  Posters: '638227409',
  Fencing: '333662712',
  Gyroids: '1445742533',
};

// Translations-Sheet (EUen→EUde). Tabs werden zur Laufzeit enumeriert.
const TRANS_SHEET_ID = '1MMbsvDfu59OY9YBEAfHhFJ6O8vRTllNFgMrX7RBZuyI';
const DE_CACHE = path.join(process.cwd(), 'scripts', '.cache', 'item-de-map.json');

const IMG_BASE = 'https://acnhcdn.com/latest/FtrIcon/';

// ── CLI-Flags ────────────────────────────────────────────────────────────────
const argv = process.argv.slice(2);
const REPORT = argv.includes('--report');
const PURGE_LEGACY = argv.includes('--purge-legacy');
const SKIP_IMAGES = argv.includes('--skip-images');
const REFRESH_MAP = argv.includes('--refresh-map');
const flag = (name) => (argv.find((a) => a.startsWith(`--${name}=`)) || '').split('=')[1] || '';
const ONLY_TABS = (flag('tabs') || flag('tab'))
  ? (flag('tabs') || flag('tab')).split(',').map((s) => s.trim()).filter(Boolean)
  : null;
const OFFSET = Number(flag('offset')) || 0;
const LIMIT = Number(flag('limit')) || 0;

const auth = { Authorization: `Bearer ${TOKEN}` };
const delay = (ms) => new Promise((r) => setTimeout(r, ms));
const norm = (s) => (s || '').toString().trim().toLowerCase();
const clean = (v) => (v === undefined || v === null || v === 'NA' || v === '' ? null : v);
const num = (v) => {
  const c = clean(v);
  if (c === null) return null;
  const n = Number(String(c).replace(/[^\d.-]/g, ''));
  return Number.isFinite(n) ? n : null;
};

async function csv(url) {
  const res = await axios.get(url, { timeout: 60000 });
  return Papa.parse(res.data, { header: true, skipEmptyLines: true }).data;
}

// ── Deutsche Namen: EUen → EUde (gecached) ────────────────────────────────────
async function buildTranslationMap() {
  if (!REFRESH_MAP && fs.existsSync(DE_CACHE)) {
    return new Map(Object.entries(JSON.parse(fs.readFileSync(DE_CACHE, 'utf8'))));
  }
  const html = (await axios.get(`https://docs.google.com/spreadsheets/d/${TRANS_SHEET_ID}/htmlview`, { timeout: 60000 })).data;
  const tabs = [...html.matchAll(/name: "([^"]+)", pageUrl: "[^"]*gid=(\d+)/g)].map((m) => ({ name: m[1], gid: m[2] }));
  const map = new Map();
  for (const t of tabs) {
    try {
      const rows = await csv(`https://docs.google.com/spreadsheets/d/${TRANS_SHEET_ID}/export?format=csv&gid=${t.gid}`);
      for (const r of rows) {
        const en = norm(r.EUen);
        const de = clean(r.EUde);
        if (en && de && !map.has(en)) map.set(en, de.trim());
      }
    } catch {
      /* Tab ohne EUen/EUde – überspringen */
    }
  }
  fs.mkdirSync(path.dirname(DE_CACHE), { recursive: true });
  fs.writeFileSync(DE_CACHE, JSON.stringify(Object.fromEntries(map)));
  return map;
}

// ── Directus-Datei-Cache (filename → uuid) ────────────────────────────────────
const fileCache = new Map();
async function getOrCreateFile(filename, imageUrl) {
  if (fileCache.has(filename)) return fileCache.get(filename);
  try {
    const ex = await axios.get(`${DIRECTUS_URL}/files`, {
      headers: auth,
      params: { 'filter[filename_download][_eq]': filename, limit: 1 },
    });
    if (ex.data.data.length) {
      const id = ex.data.data[0].id;
      fileCache.set(filename, id);
      return id;
    }
    const img = await axios.get(imageUrl, { responseType: 'arraybuffer', timeout: 30000 }).catch(() => null);
    if (!img) {
      fileCache.set(filename, null);
      return null;
    }
    const form = new FormData();
    form.append('file', Buffer.from(img.data), { filename, contentType: 'image/png' });
    const up = await axios.post(`${DIRECTUS_URL}/files`, form, { headers: { ...form.getHeaders(), ...auth } });
    const id = up.data.data.id;
    fileCache.set(filename, id);
    return id;
  } catch {
    fileCache.set(filename, null);
    return null;
  }
}

// ── Item-Upsert per (name_en + category) ──────────────────────────────────────
async function upsertItem(nameEn, category, payload) {
  const ex = await axios.get(`${DIRECTUS_URL}/items/items`, {
    headers: auth,
    params: { 'filter[name_en][_eq]': nameEn, 'filter[category][_eq]': category, limit: 1 },
  });
  if (ex.data.data.length) {
    const cur = ex.data.data[0];
    const patch = {};
    for (const [k, v] of Object.entries(payload)) {
      if ((cur[k] === null || cur[k] === undefined || cur[k] === '') && v != null && v !== '') patch[k] = v;
    }
    if (Object.keys(patch).length) await axios.patch(`${DIRECTUS_URL}/items/items/${cur.id}`, patch, { headers: auth });
    return cur.id;
  }
  const created = await axios.post(`${DIRECTUS_URL}/items/items`, payload, { headers: auth });
  return created.data.data.id;
}

/** Alle bereits importierten unique_entry_id einmalig laden (Idempotenz-Set). */
async function loadExistingUeids() {
  const set = new Set();
  let page = 1;
  for (;;) {
    const res = await axios.get(`${DIRECTUS_URL}/items/item_variants`, {
      headers: auth,
      params: { fields: 'unique_entry_id', limit: 500, page },
    });
    const rows = res.data.data;
    if (!rows.length) break;
    for (const r of rows) if (r.unique_entry_id) set.add(r.unique_entry_id);
    if (rows.length < 500) break;
    page++;
  }
  return set;
}

/** Kaputte Alt-Varianten (unique_entry_id IS NULL) gezielt entfernen. */
async function purgeLegacy() {
  let total = 0;
  for (;;) {
    const res = await axios.get(`${DIRECTUS_URL}/items/item_variants`, {
      headers: auth,
      params: { 'filter[unique_entry_id][_null]': true, fields: 'id', limit: 200 },
    });
    const ids = res.data.data.map((r) => r.id);
    if (!ids.length) break;
    await axios.delete(`${DIRECTUS_URL}/items/item_variants`, { headers: auth, data: ids });
    total += ids.length;
    process.stdout.write(`\r🗑️  Alt-Varianten gelöscht: ${total}`);
  }
  console.log(`\r🗑️  Alt-Varianten (unique_entry_id=null) entfernt: ${total}        `);
}

// ── Haupt-Import ──────────────────────────────────────────────────────────────
async function run() {
  if (!REPORT && !TOKEN) {
    console.error('❌ DIRECTUS_TOKEN fehlt (für Schreibzugriff). Nur --report läuft ohne Token.');
    process.exit(1);
  }

  if (!REPORT && PURGE_LEGACY) await purgeLegacy();

  console.log('📖 Lade deutsche Namen (EUen→EUde) …');
  const deMap = await buildTranslationMap();
  console.log(`   ${deMap.size} Namens-Mappings.`);

  const existingUeids = REPORT ? new Set() : await loadExistingUeids();
  if (!REPORT) console.log(`   ${existingUeids.size} bereits importierte Varianten (werden übersprungen).\n`);

  const tabList = ONLY_TABS || Object.keys(TABS);
  const stat = { items: 0, variants: 0, skipped: 0, images: 0, imgFail: 0, deHit: 0, deMiss: 0 };
  const unmatchedDe = new Set();

  for (const category of tabList) {
    const gid = TABS[category];
    if (!gid) {
      console.warn(`⚠️  Unbekannter Tab "${category}" – übersprungen.`);
      continue;
    }
    const rows = await csv(DATA_PUB + gid);
    const groups = new Map();
    for (const r of rows) {
      const name = clean(r.Name);
      if (!name) continue;
      if (!groups.has(name)) groups.set(name, []);
      groups.get(name).push(r);
    }
    let names = [...groups.keys()];
    if (OFFSET || LIMIT) names = names.slice(OFFSET, LIMIT ? OFFSET + LIMIT : undefined);
    console.log(`📦 ${category}: ${names.length} Items (Fenster ${OFFSET}..${OFFSET + names.length}) / Tab gesamt ${groups.size}`);

    for (let i = 0; i < names.length; i++) {
      const nameEn = names[i];
      const variants = groups.get(nameEn);
      const base = variants[0];
      const nameDe = deMap.get(norm(nameEn)) || nameEn;
      deMap.has(norm(nameEn)) ? stat.deHit++ : (stat.deMiss++, unmatchedDe.add(nameEn));
      stat.items++;

      if (REPORT) {
        stat.variants += variants.length;
        continue;
      }

      const itemId = await upsertItem(nameEn, category, {
        name_en: nameEn,
        name_de: nameDe,
        category,
        buy_price: num(base.Buy),
        sell_price: num(base.Sell),
        size: clean(base.Size),
        source: clean(base.Source),
      });

      for (const v of variants) {
        const uei = clean(v['Unique Entry ID']);
        if (uei && existingUeids.has(uei)) {
          stat.skipped++;
          continue;
        }
        const filename = clean(v.Filename);
        let imageId = null;
        if (filename && !SKIP_IMAGES) {
          imageId = await getOrCreateFile(`${filename}.png`, `${IMG_BASE}${filename}.png`);
          imageId ? stat.images++ : stat.imgFail++;
        }
        await axios.post(
          `${DIRECTUS_URL}/items/item_variants`,
          {
            item_id: itemId,
            variant_name_de: clean(v.Variation) || 'Normal',
            pattern_name_de: clean(v.Pattern) || null,
            image_path: imageId,
            filename,
            unique_entry_id: uei,
          },
          { headers: auth }
        );
        if (uei) existingUeids.add(uei);
        stat.variants++;
      }
      if ((i + 1) % 25 === 0) process.stdout.write(`\r   …${i + 1}/${names.length}`);
      await delay(15);
    }
    process.stdout.write(`\r   ✓ ${category}: ${names.length} Items fertig.            \n`);
  }

  console.log('\n── Zusammenfassung ──');
  console.log(`Items:            ${stat.items}`);
  console.log(`Varianten neu:    ${stat.variants}`);
  if (!REPORT) {
    console.log(`übersprungen:     ${stat.skipped}`);
    console.log(`Bilder geladen:   ${stat.images}   Fehler: ${stat.imgFail}`);
  }
  console.log(`DE-Namen Treffer: ${stat.deHit}   ohne DE: ${stat.deMiss}`);
  if (unmatchedDe.size) {
    [...unmatchedDe].slice(0, 25).forEach((n) => console.log(`   – ${n}`));
    if (unmatchedDe.size > 25) console.log(`   … und ${unmatchedDe.size - 25} weitere`);
  }
  console.log(REPORT ? '\n(Report-Modus: nichts geschrieben.)' : '\n✅ Batch fertig.');
}

run().catch((e) => {
  console.error('FATAL:', e.response?.data || e.message);
  process.exit(1);
});
