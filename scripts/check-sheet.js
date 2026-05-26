import { createDirectus, rest, staticToken, readItems } from '@directus/sdk';

async function run() {
    const directus = createDirectus('https://backend-nookipedia.2.godsize.info')
        .with(rest())
        .with(staticToken('JSeWKMH1ZYXiSfLzJiLnOnTVSIwIr3pZ'));

    try {
        console.log('Fetching villagers count from DB...');
        const res = await directus.request(readItems('villagers', { limit: -1, fields: ['id', 'name_en', 'name_de', 'image_path', 'house_image_path'] }));
        console.log('Total villagers in DB after sync:', res.length);
        console.log('First 5 entries details:');
        console.log(res.slice(0, 5));
    } catch (e) {
        console.error('Fetch failed:', e);
    }
}

run();
