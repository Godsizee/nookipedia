/**
 * format.js · Presentation helpers (SRP: pure view logic, no fetching)
 * Single source of truth for image resolution, number/label formatting
 * and the category → accent mapping used across the UI.
 */

const DIRECTUS_URL =
  import.meta.env.PUBLIC_DIRECTUS_URL || 'https://backend-nookipedia.2.godsize.info';

export const MONTHS_SHORT = ['Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'];

/** Format a bell price the German way, e.g. 2000 → "2.000 Sternis". */
export function formatBells(value) {
  return new Intl.NumberFormat('de-DE').format(value || 0) + ' Sternis';
}

const LOCAL_BASE = '/assets/img/acnh';

/**
 * Resolve an image reference to a usable URL.
 *
 * The dataset stores image references in two shapes:
 *   • a path that already carries its category sub-folder, e.g.
 *     "faunapedia/insects/Ant.png" or "flowers/Rose.png"
 *   • a bare file name whose folder is *implied* by the entity, e.g.
 *     materials → "64px-Wood…png", events → "…Nook_shopping.webp"
 *   A bare token without an extension is treated as a Directus asset ID.
 *
 * `folder` supplies the implied sub-folder for the bare-filename case, so each
 * entity lands in its correct directory (materials/, events/, museum/, …) —
 * mirroring the per-model paths the original backend used. Without it, bare
 * file names resolved to the asset root and silently fell back to placeholders.
 *
 * Accepts either an options object `{ folder, fallback }` or, for backwards
 * compatibility, a plain string fallback as the second argument.
 */
export function getImageUrl(path, opts = {}) {
  const { folder = '', fallback = '/assets/img/acnh/koeder.png' } =
    typeof opts === 'string' ? { fallback: opts } : opts;

  if (!path) return fallback;
  if (path.startsWith('http')) return path;

  // Normalise accidental local prefixes ("/assets/img/acnh/…", "assets/…").
  let clean = path.replace(/^\/+/, '');
  if (clean.startsWith('assets/')) clean = clean.slice('assets/'.length);
  if (clean.startsWith('img/acnh/')) clean = clean.slice('img/acnh/'.length);

  // A bare token with no folder and no extension → a Directus asset ID.
  if (!clean.includes('/') && !clean.includes('.')) {
    return `${DIRECTUS_URL}/assets/${clean}`;
  }

  // Decide what the value is relative to. Bare file names and "../"-relative
  // paths (materials reuse DIY icons via "../diy/tools/…") are anchored at the
  // category folder; a value that already carries its own sub-folder is
  // anchored at the asset root.
  const anchored =
    folder && (!clean.includes('/') || clean.startsWith('../'))
      ? `${folder}/${clean}`
      : clean;

  return `${LOCAL_BASE}/${collapseRelative(anchored)}`;
}

/** Collapse "." / ".." segments so e.g. "materials/../diy/x.png" → "diy/x.png". */
function collapseRelative(p) {
  const out = [];
  for (const seg of p.split('/')) {
    if (seg === '..') out.pop();
    else if (seg && seg !== '.') out.push(seg);
  }
  return out.join('/');
}

/** Resolve a museum asset (fossils / artworks / NPCs live in the museum/ folder). */
export function museumImage(path, fallback = '/assets/img/acnh/placeholder.png') {
  return getImageUrl(path, { folder: 'museum', fallback });
}

/**
 * Map a domain category to a design-system accent context (.accent-*).
 * Open-Closed: add a category here, the whole UI themes itself.
 */
const CATEGORY_ACCENT = {
  fish: 'fish',
  insect: 'insect',
  sea: 'sea',
  flower: 'flower',
  event: 'event',
  museum: 'museum',
  recipe: 'recipe',
  material: 'material',
  villager: 'villager',
  fossil: 'fossil',
  achievement: 'achievement',
};

export function accentFor(key) {
  return CATEGORY_ACCENT[key] || 'guide';
}

/**
 * Map an item-catalog category (the English master-sheet tab name) to its
 * German display label. Single source of truth for the catalog and the item
 * detail page. Unknown categories pass through unchanged.
 */
const CATEGORY_DE = {
  Housewares: 'Möbel',
  'Wall-mounted': 'Wandobjekte',
  Wallpaper: 'Tapeten',
  Floors: 'Böden',
  Rugs: 'Teppiche',
  'Ceiling Decor': 'Deckenobjekte',
  Miscellaneous: 'Verschiedenes',
  'Tools/Goods': 'Werkzeuge & Utensilien',
  Tops: 'Oberteile',
  Bottoms: 'Unterteile',
  'Dress-Up': 'Kleider',
  Headwear: 'Kopfbedeckungen',
  Accessories: 'Accessoires',
  Socks: 'Strümpfe',
  Shoes: 'Schuhe',
  Bags: 'Taschen',
  Umbrellas: 'Schirme',
  'Clothing Other': 'Sonstige Kleidung',
  Music: 'Musiktitel',
  Photos: 'Fotos',
  Posters: 'Poster',
  Fencing: 'Zäune',
  Gyroids: 'Gyroiden',
};

export function categoryLabel(category) {
  return CATEGORY_DE[category] || category;
}

/**
 * Map an item's English `source` to a German label. Sources can be
 * "; "-separated (e.g. "Saharah; Saharah's Co-op"); each token is translated
 * individually and unknown tokens pass through unchanged (Open-Closed). NPC
 * proper names are only renamed when the German name is well-established.
 */
const SOURCE_DE = {
  Crafting: 'Herstellung',
  Cooking: 'Kochen',
  "Nook's Cranny": 'Nooks Laden',
  'Able Sisters': 'Schneiderei',
  'High Friendship': 'Bewohner (hohe Freundschaft)',
  Cyrus: 'Björn',
  'Dig Spot': 'Fundstelle (graben)',
  Gulliver: 'Gulliver',
  Gullivarrr: 'Gulliver (Pirat)',
  "Redd's Co-op Raffle": 'Reiner (Tombola)',
  'Nook Shopping': 'Nook-Shopping',
  'Nook Shopping Posters': 'Nook-Shopping (Poster)',
  'Nook Shopping Promotion': 'Nook-Shopping (Aktion)',
  'Nook Shopping Seasonal': 'Nook-Shopping (saisonal)',
  'Nook Shopping Daily Selection': 'Nook-Shopping (Tagesangebot)',
  'Nook Miles Redemption': 'Nook-Meilen-Prämie',
};

export function sourceLabel(source) {
  if (!source) return null;
  return String(source)
    .split(/\s*;\s*/)
    .map((s) => SOURCE_DE[s] || s)
    .join(' · ');
}

/** Format a numeric exchange price with its currency, e.g. "1.200 Poki". */
const CURRENCY_DE = {
  Poki: 'Poki',
  'Nook Miles': 'Meilen',
  'Hotel Tickets': 'Hotel-Tickets',
  'Nook Points': 'Nook-Punkte',
  'Heart Crystals': 'Herzkristalle',
};

export function formatExchange(price, currency) {
  if (price == null || price === '' || !currency) return null;
  const n = Number(String(price).replace(/[^\d.-]/g, ''));
  if (!Number.isFinite(n)) return null;
  return `${new Intl.NumberFormat('de-DE').format(n)} ${CURRENCY_DE[currency] || currency}`;
}

/** Turn a shadow label ("Sehr Groß") into its size class ("shadow-sehr-groß"). */
export function shadowClass(label) {
  if (!label) return '';
  return 'shadow-' + String(label).toLowerCase().trim().replace(/\s+/g, '-');
}
