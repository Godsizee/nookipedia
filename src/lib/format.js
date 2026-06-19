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
};

export function accentFor(key) {
  return CATEGORY_ACCENT[key] || 'guide';
}

/** Turn a shadow label ("Sehr Groß") into its size class ("shadow-sehr-groß"). */
export function shadowClass(label) {
  if (!label) return '';
  return 'shadow-' + String(label).toLowerCase().trim().replace(/\s+/g, '-');
}
