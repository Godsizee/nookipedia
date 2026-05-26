import axios from 'axios';

async function run() {
    const directusUrl = 'https://backend-nookipedia.2.godsize.info';
    const token = 'JSeWKMH1ZYXiSfLzJiLnOnTVSIwIr3pZ';

    try {
        console.log('Fetching collections list...');
        const res = await axios.get(`${directusUrl}/collections`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });
        const collections = res.data.data.map(c => c.collection);
        console.log('Collections in Directus:', collections);
    } catch (e) {
        console.error('Failed:', e.response ? e.response.data : e.message);
    }
}

run();
