import { createDirectus, rest, staticToken, readCollections, uploadFiles } from '@directus/sdk';

async function run() {
    const directus = createDirectus('https://backend-nookipedia.2.godsize.info')
        .with(rest())
        .with(staticToken('JSeWKMH1ZYXiSfLzJiLnOnTVSIwIr3pZ'));

    try {
        console.log('Fetching collections...');
        const collections = await directus.request(readCollections());
        console.log('Collections list:', collections.map(c => c.collection));
    } catch (e) {
        console.error('Fetch collections failed:', e);
    }

    try {
        console.log('Testing file upload...');
        const blob = new Blob(['hello world'], { type: 'text/plain' });
        const formData = new FormData();
        formData.append('file', blob, 'test.txt');

        const uploadRes = await directus.request(uploadFiles(formData));
        console.log('Upload successful! File details:', uploadRes);
    } catch (e) {
        console.error('File upload failed:', e);
    }
}

run();
