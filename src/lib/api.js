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
    group_name: r.category_name || 'Bastelprojekte',
    materials: diyMaterialsMap.get(r.id) || [],
  }));

  const cookingRecipesJoined = cookings.map((r) => ({
    ...r,
    id: `cooking-${r.id}`,
    type: 'cooking',
    group_name: r.category_name || 'Kochrezepte',
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
/**
 * Returns only *displayable* artworks (those with a name + real image), each
 * enriched with `forgery_description` / `always_genuine` from the
 * artwork_forgeries collection (joined on name_en). Stub rows that only carry
 * a name_en — an import artefact — are dropped so the gallery stays clean.
 *
 * NOTE: today most German catalogue rows have `name_en = null`, so the forgery
 * join is a no-op for them and we fall back to the row's own `fake_description`.
 * The moment `name_en` is populated on those rows in Directus, the German
 * forgery hints light up automatically — no code change needed.
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
        forgery_description: f?.forgery_description || a.fake_description || null,
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
