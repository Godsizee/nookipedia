async function fetchWithRetry(url, retries = 5, delay = 3000) {
  for (let i = 0; i < retries; i++) {
    try {
      const res = await fetch(url);
      if (res.ok) return res;
      if (res.status === 503 || res.status === 502 || res.status === 504 || res.status === 408) {
        console.warn(`Directus returned status ${res.status} for ${url}, retrying in ${delay}ms... (Attempt ${i + 1}/${retries})`);
      } else {
        throw new Error(`HTTP ${res.status}: ${res.statusText}`);
      }
    } catch (err) {
      if (i === retries - 1) {
        throw new Error(`Failed to fetch ${url} after ${retries} attempts. Last error: ${err.message}`);
      }
      console.warn(`Fetch failed for ${url} (${err.message}). Retrying in ${delay}ms... (Attempt ${i + 1}/${retries})`);
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


