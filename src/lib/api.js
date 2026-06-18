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

async function fetchWithRetry(url, retries = 5, delay = 3000) {
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
export async function getCreatures(directusUrl) {
  const [creatures, locations, shadows, speeds, weathers] = await Promise.all([
    fetchRows(`${directusUrl}/items/creatures?limit=-1`),
    fetchRows(`${directusUrl}/items/creature_locations?limit=-1`),
    fetchRows(`${directusUrl}/items/creature_shadows?limit=-1`),
    fetchRows(`${directusUrl}/items/creature_speeds?limit=-1`),
    fetchRows(`${directusUrl}/items/creature_weathers?limit=-1`),
  ]);

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

/* ── Items catalog: join the first variant image + variant count ────────── */
export async function getItemsCatalog(directusUrl) {
  const [items, variants] = await Promise.all([
    fetchRows(`${directusUrl}/items/items?limit=-1`),
    fetchRows(`${directusUrl}/items/item_variants?limit=-1`),
  ]);
  const firstImage = new Map();
  const variantCount = new Map();
  variants.forEach((v) => {
    if (!firstImage.has(v.item_id)) firstImage.set(v.item_id, v.image_path);
    variantCount.set(v.item_id, (variantCount.get(v.item_id) || 0) + 1);
  });
  return items.map((it) => ({
    ...it,
    image_path: firstImage.get(it.id) || null,
    variant_count: variantCount.get(it.id) || 0,
  }));
}

/* ── Thin collection wrappers (Open-Closed extension point) ─────────────── */
export const getEvents = (url, fb = []) => getCollection(url, 'events', fb);
export const getVillagers = (url, fb = []) => getCollection(url, 'villagers', fb);
export const getItems = (url, fb = []) => getCollection(url, 'items', fb);
export const getItemVariants = (url, fb = []) => getCollection(url, 'item_variants', fb);
export const getArtworks = (url, fb = []) => getCollection(url, 'artworks', fb);
export const getFossils = (url, fb = []) => getCollection(url, 'fossils', fb);
export const getSpecialNpcs = (url, fb = []) => getCollection(url, 'special_npcs', fb);

export { DEFAULT_DIRECTUS };
