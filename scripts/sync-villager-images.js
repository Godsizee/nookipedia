/**
 * sync-villager-images.js · Fetch the missing villager portraits.
 *
 * WHY THIS EXISTS
 * ----------------
 * The app resolves a villager's `image_path` (e.g. "villagers/Gunnar.png") to
 * a local file under public/assets/img/acnh/. Those files were never committed,
 * so every villager fell back to the placeholder. This script downloads the
 * real ACNH portrait for each villager and writes it to exactly the path the
 * database references — making the site self-contained (and PWA/offline ready)
 * instead of depending on the live Directus assets.
 *
 * HOW IT WORKS
 * ------------
 *  1. Read the villager rows from Directus (name_en, name_de, image_path).
 *  2. Resolve image_path the same way the front-end does (lib/format.js) to get
 *     the local target file.
 *  3. For any target that is missing, join on the *English* name (the reliable
 *     key — German names in third-party datasets do not always match this DB,
 *     e.g. Marshal → "Mischka" here vs. "Huschke" upstream) against the bundled
 *     villager-image-sources.json and download the round NpcIcon to the target.
 *
 * Idempotent: existing files are skipped, so re-runs only fetch what's missing.
 *
 * USAGE
 *   node scripts/sync-villager-images.js            # download missing portraits
 *   node scripts/sync-villager-images.js --report   # list missing, download nothing
 *   node scripts/sync-villager-images.js --photo    # use full-body bromide instead of the icon
 *
 * NETWORK: needs egress to the Directus backend and to acnhcdn.com. In a
 * restricted environment add those hosts to the allowlist first.
 */
import fs from 'fs';
import path from 'path';
import axios from 'axios';

const DIRECTUS_URL =
  process.env.PUBLIC_DIRECTUS_URL || 'https://backend-nookipedia.2.godsize.info';
const ASSET_ROOT = path.join(process.cwd(), 'public', 'assets', 'img', 'acnh');
const SOURCES = JSON.parse(
  fs.readFileSync(new URL('./villager-image-sources.json', import.meta.url), 'utf8')
);

const REPORT_ONLY = process.argv.includes('--report');
const USE_PHOTO = process.argv.includes('--photo');
const delay = (ms) => new Promise((r) => setTimeout(r, ms));

/**
 * Resolve a stored image_path to a repo-relative file under public/assets/img/acnh.
 * Mirrors getImageUrl() in src/lib/format.js so the script and the app agree on
 * where a file must live. Returns null for empty values or Directus asset IDs
 * (those are served remotely and need no local file).
 */
function resolveLocal(imagePath, folder = 'villagers') {
  if (!imagePath || imagePath.startsWith('http')) return null;
  let clean = imagePath.replace(/^\/+/, '');
  if (clean.startsWith('assets/')) clean = clean.slice('assets/'.length);
  if (clean.startsWith('img/acnh/')) clean = clean.slice('img/acnh/'.length);
  if (!clean.includes('/') && !clean.includes('.')) return null; // Directus asset id
  const anchored =
    folder && (!clean.includes('/') || clean.startsWith('../')) ? `${folder}/${clean}` : clean;
  const segs = [];
  for (const s of anchored.split('/')) {
    if (s === '..') segs.pop();
    else if (s && s !== '.') segs.push(s);
  }
  return segs.join('/');
}

async function fetchVillagers() {
  const res = await axios.get(`${DIRECTUS_URL}/items/villagers?limit=-1`, { timeout: 30000 });
  return res.data?.data || [];
}

async function downloadTo(url, absPath) {
  const res = await axios.get(url, {
    responseType: 'arraybuffer',
    timeout: 30000,
    headers: { 'User-Agent': 'nookipedia-asset-sync' },
  });
  fs.mkdirSync(path.dirname(absPath), { recursive: true });
  fs.writeFileSync(absPath, Buffer.from(res.data));
}

async function main() {
  console.log(`📡 Lese Bewohner aus ${DIRECTUS_URL} …`);
  let villagers = [];
  try {
    villagers = await fetchVillagers();
  } catch (err) {
    console.error(`❌ Konnte Bewohner nicht laden: ${err.message}`);
    console.error('   (Directus erreichbar? PUBLIC_DIRECTUS_URL korrekt?)');
    process.exit(1);
  }
  console.log(`   ${villagers.length} Bewohner gefunden.\n`);

  let have = 0;
  let downloaded = 0;
  const missingNoSource = [];
  const failed = [];

  for (const v of villagers) {
    const rel = resolveLocal(v.image_path);
    if (!rel) continue; // remote/Directus asset — nothing to mirror locally
    const abs = path.join(ASSET_ROOT, rel);

    if (fs.existsSync(abs)) {
      have++;
      continue;
    }

    const src = SOURCES[v.name_en];
    const url = src && (USE_PHOTO ? src.photo : src.icon);
    if (!url) {
      missingNoSource.push(`${v.name_de || v.name_en} (en: ${v.name_en || '—'})`);
      continue;
    }

    if (REPORT_ONLY) {
      console.log(`• fehlt: ${rel}  ←  ${url}`);
      downloaded++; // counted as "würde geladen"
      continue;
    }

    try {
      await downloadTo(url, abs);
      console.log(`✓ ${rel}  ←  ${url}`);
      downloaded++;
      await delay(60); // be polite to the CDN
    } catch (err) {
      failed.push(`${rel} (${err.response?.status || err.message})`);
    }
  }

  console.log('\n── Zusammenfassung ──');
  console.log(`vorhanden:        ${have}`);
  console.log(`${REPORT_ONLY ? 'würde laden:     ' : 'geladen:         '} ${downloaded}`);
  if (missingNoSource.length) {
    console.log(`ohne Bildquelle:  ${missingNoSource.length}`);
    missingNoSource.slice(0, 20).forEach((n) => console.log(`   – ${n}`));
    if (missingNoSource.length > 20) console.log(`   … und ${missingNoSource.length - 20} weitere`);
  }
  if (failed.length) {
    console.log(`fehlgeschlagen:   ${failed.length}`);
    failed.slice(0, 20).forEach((n) => console.log(`   ! ${n}`));
  }
  console.log(REPORT_ONLY ? '\n(Report-Modus: nichts heruntergeladen.)' : '\n✅ Fertig.');
}

main();
