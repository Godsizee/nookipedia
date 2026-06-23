/**
 * api.js · Data access layer (SRP: fetching + shaping only, no view logic).
 *
 * Resilient by design: a build must never fail because the Directus backend
 * is briefly unreachable. Every loader degrades to an empty array (or a
 * caller-supplied fallback) instead of throwing — so "the database provides
 * everything flawlessly" without ever taking the site down.
 *
 * Open-Closed: a new collection becomes available by adding one thin
 * `getX = (url, fb) => getCollection(url, 'x', fb)` wrapper — no edits to the
 * existing loaders.
 */

const DEFAULT_DIRECTUS = 'https://backend-nookipedia.2.godsize.info';

// Builds run unattended on a small server: when the backend is down we want to
// fail fast to the bundled fallbacks rather than stall the whole build on long
// retry waits. A couple of quick attempts still rides out a momentary blip.
async function fetchWithRetry(url, retries = 3, delay = 1000) {
  let currentUrl = url;
  for (let i = 0; i < retries; i++) {
    try {
      if (i >= 2 && currentUrl.includes('directus.2.godsize.info')) {
        currentUrl = currentUrl.replace('directus.2.godsize.info', 'backend-nookipedia.2.godsize.info');
        console.warn(`Swapping domain to backend-nookipedia.2.godsize.info for retry: ${currentUrl}`);
      }
      const res = await fetch(currentUrl);
      if (res.ok) return res;
      if ([502, 503, 504, 408].includes(res.status)) {
        console.warn(`Directus returned ${res.status} for ${currentUrl}, retry ${i + 1}/${retries}...`);
        if (i === retries - 1) throw new Error(`HTTP ${res.status}: ${res.statusText}`);
      } else {
        throw new Error(`HTTP ${res.status}: ${res.statusText}`);
      }
    } catch (err) {
      if (i === retries - 1) {
        throw new Error(`Failed to fetch ${currentUrl} after ${retries} attempts. Last: ${err.message}`);
      }
      console.warn(`Fetch failed for ${currentUrl} (${err.message}). Retry ${i + 1}/${retries}...`);
    }
    await new Promise((resolve) => setTimeout(resolve, delay));
  }
}

/** Fetch a JSON list endpoint and return its `.data` rows; never throws. */
async function fetchRows(url) {
  try {
    const res = await fetchWithRetry(url);
    const json = await res.json();
    return json.data || [];
  } catch (err) {
    console.warn(`[api] Soft-fail for ${url}: ${err.message} — using fallback.`);
    return [];
  }
}

/**
 * Generic collection loader. Returns the live rows, or `fallback` when the
 * backend yields nothing (offline build / empty collection).
 */
export async function getCollection(directusUrl, name, fallback = []) {
  const rows = await fetchRows(`${directusUrl}/items/${name}?limit=-1`);
  return rows.length ? rows : fallback;
}

/* ── Creatures (fish / insects / sea) with their 1:N detail joins ───────── */
export async function getCreatures(directusUrl, fallback = []) {
  const [creatures, locations, shadows, speeds, weathers] = await Promise.all([
    fetchRows(`${directusUrl}/items/creatures?limit=-1`),
    fetchRows(`${directusUrl}/items/creature_locations?limit=-1`),
    fetchRows(`${directusUrl}/items/creature_shadows?limit=-1`),
    fetchRows(`${directusUrl}/items/creature_speeds?limit=-1`),
    fetchRows(`${directusUrl}/items/creature_weathers?limit=-1`),
  ]);

  // Backend unreachable → keep the build alive with the bundled fallback, which
  // already carries the joined location/shadow/speed/weather fields.
  if (!creatures.length) return fallback;

  const locationsMap = new Map(locations.map((i) => [i.creature_id, i.location_name]));
  const shadowsMap = new Map(shadows.map((i) => [i.creature_id, i.shadow_image]));
  const speedsMap = new Map(speeds.map((i) => [i.creature_id, i.speed]));
  const weathersMap = new Map(weathers.map((i) => [i.creature_id, i.weather]));

  return creatures.map((c) => ({
    ...c,
    location_name: locationsMap.get(c.id) || null,
    shadow_image: shadowsMap.get(c.id) || null,
    speed: speedsMap.get(c.id) || null,
    weather: weathersMap.get(c.id) || null,
  }));
}

// Recipe categories come from two sync sources (legacy German seed vs. the
// English master sheet import), so the same ACNH category can show up under
// either label. Normalize both to one German label per category.
const RECIPE_CATEGORY_DE = {
  Tools: 'Werkzeuge',
  Equipment: 'Ausrüstung',
  Housewares: 'Einrichtung',
  Miscellaneous: 'Kleinkram',
  'Wall-mounted': 'Wanddeko',
  'Ceiling Decor': 'Deckendeko',
  Wallpaper: 'Tapeten/Böden/Teppiche',
  Floors: 'Tapeten/Böden/Teppiche',
  Rugs: 'Tapeten/Böden/Teppiche',
  Other: 'Sonstiges',
  Savory: 'Herzhaft',
  Sweet: 'Süß',
};
const toCategoryDe = (category) => RECIPE_CATEGORY_DE[category] || category;

/* ── Recipes (DIY + cooking) with joined materials ──────────────────────── */
export async function getRecipes(directusUrl) {
  const [diys, cookings, materials, itemMats] = await Promise.all([
    fetchRows(`${directusUrl}/items/diy_recipes?limit=-1`),
    fetchRows(`${directusUrl}/items/cooking_recipes?limit=-1`),
    fetchRows(`${directusUrl}/items/materials?limit=-1`),
    fetchRows(`${directusUrl}/items/item_materials?limit=-1`),
  ]);

  const materialsMap = new Map(materials.map((m) => [m.id, m]));
  const diyMaterialsMap = new Map();
  const cookingMaterialsMap = new Map();

  itemMats.forEach((im) => {
    const mat = materialsMap.get(im.material_id);
    if (!mat) return;
    const joinedMat = { id: mat.id, amount: im.amount, name: mat.name, image_path: mat.image_path };
    if (im.diy_recipe_id) {
      if (!diyMaterialsMap.has(im.diy_recipe_id)) diyMaterialsMap.set(im.diy_recipe_id, []);
      diyMaterialsMap.get(im.diy_recipe_id).push(joinedMat);
    } else if (im.cooking_recipe_id) {
      if (!cookingMaterialsMap.has(im.cooking_recipe_id)) cookingMaterialsMap.set(im.cooking_recipe_id, []);
      cookingMaterialsMap.get(im.cooking_recipe_id).push(joinedMat);
    }
  });

  const diyRecipesJoined = diys.map((r) => ({
    ...r,
    id: `diy-${r.id}`,
    type: 'diy',
    group_name: toCategoryDe(r.category) || 'Sonstiges',
    materials: diyMaterialsMap.get(r.id) || [],
  }));

  const cookingRecipesJoined = cookings.map((r) => ({
    ...r,
    id: `cooking-${r.id}`,
    type: 'cooking',
    group_name: toCategoryDe(r.category) || 'Sonstiges',
    materials: cookingMaterialsMap.get(r.id) || [],
  }));

  return [...diyRecipesJoined, ...cookingRecipesJoined];
}

export async function getMaterials(directusUrl) {
  return fetchRows(`${directusUrl}/items/materials?limit=-1`);
}

/* ── Flowers with seeds + breeding combinations ─────────────────────────── */
export async function getFlowers(directusUrl) {
  const [flowers, seeds, combos] = await Promise.all([
    fetchRows(`${directusUrl}/items/flowers?limit=-1`),
    fetchRows(`${directusUrl}/items/flower_seeds?limit=-1`),
    fetchRows(`${directusUrl}/items/flower_combinations?limit=-1`),
  ]);

  const seedsMap = new Map();
  const combinationsMap = new Map();
  seeds.forEach((s) => {
    if (!seedsMap.has(s.flower_id)) seedsMap.set(s.flower_id, []);
    seedsMap.get(s.flower_id).push(s);
  });
  combos.forEach((c) => {
    if (!combinationsMap.has(c.flower_id)) combinationsMap.set(c.flower_id, []);
    combinationsMap.get(c.flower_id).push(c);
  });

  return flowers.map((f) => ({
    ...f,
    seeds: seedsMap.get(f.id) || [],
    combinations: combinationsMap.get(f.id) || [],
  }));
}

/* ── Items with their full variant list (detail pages) ──────────────────── */
export async function getItemsWithVariants(directusUrl, fallback = []) {
  const [items, variants] = await Promise.all([
    fetchRows(`${directusUrl}/items/items?limit=-1`),
    fetchRows(`${directusUrl}/items/item_variants?limit=-1`),
  ]);
  if (!items.length) return fallback;
  const byItem = new Map();
  for (const v of variants) {
    if (!byItem.has(v.item_id)) byItem.set(v.item_id, []);
    byItem.get(v.item_id).push(v);
  }
  return items.map((it) => ({ ...it, variants: byItem.get(it.id) || [] }));
}

/* ── Items enriched with their crafting recipe (detail pages) ───────────── */
/**
 * Each item gets a `recipe` (its DIY/cooking recipe with joined materials) when
 * one matches by German name (`recipe.name === item.name_de`) — the only stable
 * key the recipe rows carry. ~92% of named recipes match; the rest fall back to
 * no structured materials. Resilient: degrades to plain items, never throws.
 */
export async function getItemsWithRecipes(directusUrl) {
  const [items, recipes] = await Promise.all([
    getItemsWithVariants(directusUrl),
    getRecipes(directusUrl),
  ]);
  if (!items.length) return items;
  const norm = (s) => (s || '').toString().trim().toLowerCase();
  const recipeByName = new Map();
  for (const r of recipes) {
    const k = norm(r.name);
    if (k && !recipeByName.has(k)) recipeByName.set(k, r);
  }
  return items.map((it) => ({ ...it, recipe: recipeByName.get(norm(it.name_de)) || null }));
}

/* ── Items catalog: thin view derived from the full join (first image + count) */
export async function getItemsCatalog(directusUrl) {
  const items = await getItemsWithVariants(directusUrl);
  return items.map(({ variants, ...it }) => ({
    ...it,
    image_path: variants.find((v) => v.image_path)?.image_path || variants[0]?.image_path || null,
    variant_count: variants.length,
  }));
}

/* ── Artworks joined with their (German) forgery hints ──────────────────── */
// `fake_description` in Directus is an English art-history blurb about the
// real-world piece (Wikipedia-style), not a description of the forgery tell —
// so it's never shown. These are the actual real-vs-fake differences per
// artwork id, in German (source: Nookipedia/community forgery guides).
const FORGERY_TELL_DE = {
  1: 'Auf der Fälschung ist oben rechts ein großer Kaffeefleck zu sehen.',
  2: 'Der Mann in der Mitte trägt auf der Fälschung keinen Hut.',
  3: 'Die Fälschung hat zwei Antennen am Kopf, die dem Original fehlen.',
  4: 'Auf der Fälschung hat der Junge einen durchgehenden Pony; im Original fehlt dieser.',
  5: 'Die Fälschung trägt eine Perlenkette um den Hals.',
  8: 'Die Blumen auf der Fälschung sind lila statt blau.',
  11: 'Auf der Fälschung sind die Augenbrauen der Mona Lisa stark nach oben gezogen.',
  13: 'Die Fälschung hält ein Buch unter dem Arm; das Original hat leere Hände.',
  15: 'Im Original ist die Frau kleiner und blickt nach rechts; auf der Fälschung ist sie größer und blickt nach links.',
  17: 'Die Fälschung ist blau gefärbt; das Original ist dunkelgrau.',
  18: 'Bei der Fälschung fehlt die Knospe an der Brust des Gemüsemanns.',
  20: 'Die Wölfin streckt auf der Fälschung die Zunge heraus; im Original ist ihr Maul geschlossen.',
  21: 'Auf der Fälschung fehlen die Bäume oben rechts im Bild.',
  23: 'Die Fälschung trägt einen Ohrring am rechten Ohr; das Original ist ohne Ohrring.',
  27: 'Auf der Fälschung schießt ein dicker Milchstrahl aus dem Krug; im Original ist es nur ein dünner Strahl.',
  28: 'Die Fälschung trägt eine Armbanduhr; das Original hat ein nacktes Handgelenk.',
  29: 'Die Fälschung lächelt leicht; das Original hat einen neutralen, ernsten Ausdruck.',
  30: 'Im Original blickt die Figur wütend mit nach unten gezogenen Augenbrauen; auf der Fälschung sind sie anders geneigt.',
  31: 'Im Original sind drei Jäger im Vordergrund zu sehen; auf der Fälschung ist nur einer übrig.',
  32: 'Das Hermelin (Tier) ist im Original weiß; auf der Fälschung ist es braun.',
  34: 'Im Original berührt die Hand des Mannes im Hintergrund die Tür; auf der Fälschung ist sein Arm erhoben.',
  35: 'Die Fälschung hat einen Deckel mit Griff; das Original ist oben offen.',
  37: 'Im Original tritt die Statue mit dem rechten Bein vor; auf der Fälschung mit dem linken.',
  39: 'Die Fälschung hält eine Schaufel in der Hand; dem Original fehlt sie.',
  40: 'Im Original ist die Gottheit hell gefärbt; auf der Fälschung ist sie grün/dunkel.',
  41: 'Im Original ist die Gottheit grün/dunkel gefärbt; auf der Fälschung ist sie hell.',
  42: 'Auf der Fälschung ist der Perlenohrring sternförmig statt rund.',
};

// `real_world_name` is the English title of the real-world piece. German
// titles for these (mostly famous, public-domain) works, keyed by artwork id.
const REAL_WORLD_NAME_DE = {
  1: 'Der vitruvianische Mensch',
  2: 'Die Nachtwache',
  3: 'Dogū-Figur „Shakōki-dogū" (Jōmon-Zeit)',
  4: 'Der blaue Junge',
  5: 'Venus von Milo',
  6: 'Ein Sonntagnachmittag auf der Insel La Grande Jatte',
  7: 'Die Ährenleserinnen',
  9: 'Die große Welle vor Kanagawa',
  10: 'Der Denker',
  12: 'Sonnenblumen',
  14: 'Die kämpfende Temeraire',
  15: 'Schöne, die sich umblickt',
  16: 'König Kamehameha I.',
  17: 'Stein von Rosette',
  18: 'Der Sommer',
  19: 'Der Sämann',
  20: 'Kapitolinische Wölfin',
  21: 'Die Geburt der Venus',
  22: 'Die Toteninsel',
  23: 'Nofretete-Büste',
  24: 'Der Pfeifer',
  25: 'Äpfel und Orangen',
  26: 'Die Bar in den Folies-Bergère',
  27: 'Das Milchmädchen',
  28: 'Diskuswerfer',
  29: 'Olmekischer Kolossalkopf',
  30: 'Ōtani Oniji III. als Yakko Edobei',
  31: 'Die Jäger im Schnee',
  32: 'Dame mit dem Hermelin',
  36: 'Die Sternennacht',
  37: 'Nike von Samothrake',
  38: 'Die bekleidete Maja',
  39: 'Terrakotta-Armee',
  40: 'Wandschirm der Windgott- und Donnergott-Bilder (links)',
  41: 'Wandschirm der Windgott- und Donnergott-Bilder (rechts)',
  42: 'Das Mädchen mit dem Perlenohrring',
  43: 'Die Freiheit führt das Volk',
};

/**
 * Returns only *displayable* artworks (those with a name + real image), each
 * enriched with a German `forgery_description` and `real_world_name` (falling
 * back to the artwork_forgeries collection / the raw English fields for any
 * id not covered above) plus `always_genuine`.
 */
export async function getArtworks(directusUrl, fallback = []) {
  const [artworks, forgeries] = await Promise.all([
    fetchRows(`${directusUrl}/items/artworks?limit=-1`),
    fetchRows(`${directusUrl}/items/artwork_forgeries?limit=-1`),
  ]);
  if (!artworks.length) return fallback;

  const norm = (s) => (s || '').toString().trim().toLowerCase();
  const has = (x) => Boolean(x) && x !== 'NA';

  // The collection holds two parallel record shapes (a data-quality quirk):
  //  • display rows  → German `name` + `image_real` (the complete catalogue)
  //  • metadata rows → `name_de` + `name_en` (join key) + `image_genuine`
  // We show the display rows and bridge the German forgery hints across via the
  // shared German name (display.name === metadata.name_de).
  const forgeryByEn = new Map(forgeries.map((f) => [norm(f.artwork_name_en), f]));
  const forgeryByDeName = new Map();
  for (const m of artworks) {
    if (!has(m.name_de) || !has(m.name_en)) continue;
    const f = forgeryByEn.get(norm(m.name_en));
    if (f) forgeryByDeName.set(norm(m.name_de), f);
  }

  return artworks
    .filter((a) => has(a.name) && has(a.image_real))
    .map((a) => {
      const f = forgeryByDeName.get(norm(a.name));
      return {
        ...a,
        forgery_description: FORGERY_TELL_DE[a.id] || f?.forgery_description || null,
        real_world_name: REAL_WORLD_NAME_DE[a.id] || a.real_world_name,
        artist_name: (a.artist || '').split(',')[0].trim() || null,
        // An artwork is forgeable iff the game ships a fake image for it.
        always_genuine: !has(a.image_fake),
      };
    });
}

/* ── Fossils: keep only displayable rows, fix single-fossil grouping ─────── */
/**
 * The `fossils` collection carries two parallel record shapes (same import
 * quirk as artworks): display rows (German `name` + `price`) and metadata-only
 * rows (`name_de`/`name_en`, no `name`/price). Only the display rows are real
 * catalogue entries — the metadata rows are import artefacts that would render
 * as nameless "0 Sternis" duplicates, so we drop them.
 *
 * Single fossils (`type === 'Einzel'`) carry the lowercase English internal name
 * in `dinosaur_group` (e.g. "amber"), which the page would otherwise show as a
 * group heading. They are not part of a multi-piece skeleton, so we clear that
 * field to route them into the standalone "Einzelne Fossilien & Spuren" bucket.
 */
export async function getFossils(directusUrl, fallback = []) {
  const rows = await fetchRows(`${directusUrl}/items/fossils?limit=-1`);
  if (!rows.length) return fallback;
  return rows
    .filter((f) => f.name)
    .map((f) => (f.type === 'Einzel' ? { ...f, dinosaur_group: null } : f));
}

/* ── Thin collection wrappers (Open-Closed extension point) ─────────────── */
export const getEvents = (url, fb = []) => getCollection(url, 'events', fb);
export const getVillagers = (url, fb = []) => getCollection(url, 'villagers', fb);
export const getItems = (url, fb = []) => getCollection(url, 'items', fb);
export const getItemVariants = (url, fb = []) => getCollection(url, 'item_variants', fb);
export const getSpecialNpcs = (url, fb = []) => getCollection(url, 'special_npcs', fb);

export { DEFAULT_DIRECTUS };
