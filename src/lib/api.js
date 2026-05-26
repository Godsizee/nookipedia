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
      if (res.status === 503 || res.status === 502 || res.status === 504 || res.status === 408) {
        console.warn(`Directus returned status ${res.status} for ${currentUrl}, retrying in ${delay}ms... (Attempt ${i + 1}/${retries})`);
        if (i === retries - 1) {
          throw new Error(`HTTP ${res.status}: ${res.statusText}`);
        }
      } else {
        throw new Error(`HTTP ${res.status}: ${res.statusText}`);
      }
    } catch (err) {
      if (i === retries - 1) {
        throw new Error(`Failed to fetch ${currentUrl} after ${retries} attempts. Last error: ${err.message}`);
      }
      console.warn(`Fetch failed for ${currentUrl} (${err.message}). Retrying in ${delay}ms... (Attempt ${i + 1}/${retries})`);
    }
    await new Promise(resolve => setTimeout(resolve, delay));
  }
}

export async function getCreatures(directusUrl) {
  const [creaturesRes, locationsRes, shadowsRes, speedsRes, weathersRes] = await Promise.all([
    fetchWithRetry(`${directusUrl}/items/creatures?limit=-1`),
    fetchWithRetry(`${directusUrl}/items/creature_locations?limit=-1`),
    fetchWithRetry(`${directusUrl}/items/creature_shadows?limit=-1`),
    fetchWithRetry(`${directusUrl}/items/creature_speeds?limit=-1`),
    fetchWithRetry(`${directusUrl}/items/creature_weathers?limit=-1`)
  ]);

  const [creaturesData, locationsData, shadowsData, speedsData, weathersData] = await Promise.all([
    creaturesRes.json(),
    locationsRes.json(),
    shadowsRes.json(),
    speedsRes.json(),
    weathersRes.json()
  ]);

  const creatures = creaturesData.data || [];
  const locations = locationsData.data || [];
  const shadows = shadowsData.data || [];
  const speeds = speedsData.data || [];
  const weathers = weathersData.data || [];

  const locationsMap = new Map(locations.map(item => [item.creature_id, item.location_name]));
  const shadowsMap = new Map(shadows.map(item => [item.creature_id, item.shadow_image]));
  const speedsMap = new Map(speeds.map(item => [item.creature_id, item.speed]));
  const weathersMap = new Map(weathers.map(item => [item.creature_id, item.weather]));

  return creatures.map(c => ({
    ...c,
    location_name: locationsMap.get(c.id) || null,
    shadow_image: shadowsMap.get(c.id) || null,
    speed: speedsMap.get(c.id) || null,
    weather: weathersMap.get(c.id) || null
  }));
}

export async function getRecipes(directusUrl) {
  const [diyRes, cookingRes, materialsRes, itemMaterialsRes] = await Promise.all([
    fetchWithRetry(`${directusUrl}/items/diy_recipes?limit=-1`),
    fetchWithRetry(`${directusUrl}/items/cooking_recipes?limit=-1`),
    fetchWithRetry(`${directusUrl}/items/materials?limit=-1`),
    fetchWithRetry(`${directusUrl}/items/item_materials?limit=-1`)
  ]);

  const [diyData, cookingData, materialsData, itemMaterialsData] = await Promise.all([
    diyRes.json(),
    cookingRes.json(),
    materialsRes.json(),
    itemMaterialsRes.json()
  ]);

  const diys = diyData.data || [];
  const cookings = cookingData.data || [];
  const materials = materialsData.data || [];
  const itemMats = itemMaterialsData.data || [];

  const materialsMap = new Map(materials.map(m => [m.id, m]));

  const diyMaterialsMap = new Map();
  const cookingMaterialsMap = new Map();

  itemMats.forEach(im => {
    const mat = materialsMap.get(im.material_id);
    if (!mat) return;

    const joinedMat = {
      id: mat.id,
      amount: im.amount,
      name: mat.name,
      image_path: mat.image_path
    };

    if (im.diy_recipe_id) {
      if (!diyMaterialsMap.has(im.diy_recipe_id)) {
        diyMaterialsMap.set(im.diy_recipe_id, []);
      }
      diyMaterialsMap.get(im.diy_recipe_id).push(joinedMat);
    } else if (im.cooking_recipe_id) {
      if (!cookingMaterialsMap.has(im.cooking_recipe_id)) {
        cookingMaterialsMap.set(im.cooking_recipe_id, []);
      }
      cookingMaterialsMap.get(im.cooking_recipe_id).push(joinedMat);
    }
  });

  const diyRecipesJoined = diys.map(r => ({
    ...r,
    id: `diy-${r.id}`,
    type: 'diy',
    group_name: r.category_name || 'Bastelprojekte',
    materials: diyMaterialsMap.get(r.id) || []
  }));

  const cookingRecipesJoined = cookings.map(r => ({
    ...r,
    id: `cooking-${r.id}`,
    type: 'cooking',
    group_name: r.category_name || 'Kochrezepte',
    materials: cookingMaterialsMap.get(r.id) || []
  }));

  return [...diyRecipesJoined, ...cookingRecipesJoined];
}

export async function getMaterials(directusUrl) {
  const res = await fetchWithRetry(`${directusUrl}/items/materials?limit=-1`);
  const data = await res.json();
  return data.data || [];
}



