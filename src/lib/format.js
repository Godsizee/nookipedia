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

/**
 * Resolve an image reference to a usable URL.
 * Handles: absolute URLs, local /assets/img/acnh paths, and bare Directus
 * asset IDs. Keeps one rule set so every page renders images identically.
 */
export function getImageUrl(path, fallback = '/assets/img/acnh/koeder.png') {
  if (!path) return fallback;
  if (path.startsWith('http')) return path;
  if (path.includes('/') || path.includes('.')) {
    let clean = path.startsWith('/') ? path.slice(1) : path;
    if (clean.startsWith('assets/')) clean = clean.slice(7);
    if (clean.startsWith('img/acnh/')) clean = clean.slice(9);
    return `/assets/img/acnh/${clean}`;
  }
  return `${DIRECTUS_URL}/assets/${path}`;
}

/** Resolve a museum asset (fossils / artworks / NPCs live in the museum/ folder). */
export function museumImage(path, fallback = '/assets/img/acnh/placeholder.png') {
  if (!path) return fallback;
  if (path.startsWith('http')) return path;
  if (path.includes('/') || path.includes('.')) return `/assets/img/acnh/museum/${path}`;
  return `${DIRECTUS_URL}/assets/${path}`;
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
