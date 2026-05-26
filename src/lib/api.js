export async function getCreatures(directusUrl) {
  try {
    const [creaturesRes, locationsRes, shadowsRes, speedsRes, weathersRes] = await Promise.all([
      fetch(`${directusUrl}/items/creatures?limit=-1`),
      fetch(`${directusUrl}/items/creature_locations?limit=-1`),
      fetch(`${directusUrl}/items/creature_shadows?limit=-1`),
      fetch(`${directusUrl}/items/creature_speeds?limit=-1`),
      fetch(`${directusUrl}/items/creature_weathers?limit=-1`)
    ]);

    if (!creaturesRes.ok) {
      throw new Error('Failed to fetch creatures');
    }

    const [creaturesData, locationsData, shadowsData, speedsData, weathersData] = await Promise.all([
      creaturesRes.json(),
      locationsRes.ok ? locationsRes.json() : { data: [] },
      shadowsRes.ok ? shadowsRes.json() : { data: [] },
      speedsRes.ok ? speedsRes.json() : { data: [] },
      weathersRes.ok ? weathersRes.json() : { data: [] }
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
  } catch (error) {
    console.error('Error fetching/joining creatures data:', error);
    return [];
  }
}
