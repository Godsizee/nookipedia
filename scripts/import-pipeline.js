import fs from 'fs';
import path from 'path';
import axios from 'axios';
import Papa from 'papaparse';
import FormData from 'form-data';
import { createDirectus, rest, staticToken, readItems, createItem, updateItem } from '@directus/sdk';

const MASTER_SHEET_ID = '13d_LAJPlxMa_DubPTuirkIV4DERBMXbrWQsmSh8ReK4';
const TRANSLATION_SHEET_ID = '1GwUuCKgJC61qWEjWyeG3nVjkHesszRL6XbPA_dHfLoI';
const DIRECTUS_URL = 'https://backend-nookipedia.2.godsize.info';
const TOKEN = 'JSeWKMH1ZYXiSfLzJiLnOnTVSIwIr3pZ';

const directus = createDirectus(DIRECTUS_URL)
    .with(rest())
    .with(staticToken(TOKEN));

const SPECIES_MAP = {
    'alligator': 'Krokodil',
    'anteater': 'Ameisenbär',
    'bear': 'Bär',
    'bird': 'Vogel',
    'bull': 'Stier',
    'cat': 'Katze',
    'chicken': 'Huhn',
    'cow': 'Kuh',
    'cub': 'Bärchen',
    'deer': 'Hirsch',
    'dog': 'Hund',
    'duck': 'Ente',
    'eagle': 'Adler',
    'elephant': 'Elefant',
    'frog': 'Frosch',
    'goat': 'Ziege',
    'gorilla': 'Gorilla',
    'hamster': 'Hamster',
    'hippo': 'Nilpferd',
    'horse': 'Pferd',
    'kangaroo': 'Känguru',
    'koala': 'Koala',
    'lion': 'Löwe',
    'monkey': 'Affe',
    'mouse': 'Maus',
    'octopus': 'Krake',
    'ostrich': 'Strauß',
    'penguin': 'Pinguin',
    'pig': 'Schwein',
    'rabbit': 'Hase',
    'rhino': 'Nashorn',
    'sheep': 'Schaf',
    'squirrel': 'Eichhörnchen',
    'tiger': 'Tiger',
    'wolf': 'Wolf'
};

const PERSONALITY_MAP = {
    'cranky': 'Miesepeter',
    'jock': 'Sportlich',
    'lazy': 'Schlafmütze',
    'normal': 'Ausgeglichen',
    'peppy': 'Schwungvoll',
    'smug': 'Selbstgefällig',
    'snooty': 'Hochnäsig',
    'big sister': 'Große Schwester',
    'sisterly': 'Große Schwester'
};

const HOBBY_MAP = {
    'nature': 'Natur',
    'fitness': 'Fitness',
    'play': 'Spielen',
    'education': 'Bildung',
    'fashion': 'Mode',
    'music': 'Musik'
};

const STYLE_MAP = {
    'active': 'Sportlich',
    'cool': 'Cool',
    'cute': 'Süß',
    'elegant': 'Elegant',
    'gorgeous': 'Prachtvoll',
    'simple': 'Schlicht'
};

async function downloadCSV(sheetId, tabName) {
    const url = `https://docs.google.com/spreadsheets/d/${sheetId}/gviz/tq?tqx=out:csv&sheet=${encodeURIComponent(tabName)}`;
    const res = await axios.get(url);
    return Papa.parse(res.data, { header: true, skipEmptyLines: true }).data;
}

async function getOrCreateFile(filename, imageUrl) {
    try {
        const existRes = await axios.get(`${DIRECTUS_URL}/files?filter[filename_download][_eq]=${filename}`, {
            headers: { 'Authorization': `Bearer ${TOKEN}` }
        });
        if (existRes.data.data.length > 0) {
            return existRes.data.data[0].id;
        }

        console.log(`Downloading ${imageUrl} ...`);
        const imgRes = await axios.get(imageUrl, { responseType: 'arraybuffer' }).catch(() => null);
        if (!imgRes) return null;

        const buffer = Buffer.from(imgRes.data);
        const form = new FormData();
        form.append('file', buffer, { filename, contentType: 'image/png' });

        const uploadRes = await axios.post(`${DIRECTUS_URL}/files`, form, {
            headers: {
                ...form.getHeaders(),
                'Authorization': `Bearer ${TOKEN}`
            }
        });
        return uploadRes.data.data.id;
    } catch (e) {
        console.error(`Error processing file ${filename}:`, e.message);
        return null;
    }
}

async function syncVillagers() {
    console.log('📡 Fetching data from Google Sheets...');
    const masterData = await downloadCSV(MASTER_SHEET_ID, 'Villagers');
    const nameTransData = await downloadCSV(TRANSLATION_SHEET_ID, 'Villagers');
    const catchTransData = await downloadCSV(TRANSLATION_SHEET_ID, 'Villagers Catch Phrase');

    console.log('Building translation maps...');
    const nameMap = {};
    nameTransData.forEach(row => {
        const en = row['English'] || row['Name'] || row['US en'];
        const de = row['German'] || row['EU de'];
        if (en && de) nameMap[en.toLowerCase().trim()] = de.trim();
    });

    const catchMap = {};
    catchTransData.forEach(row => {
        const id = row['id'];
        const de = row['German'] || row['EU de'];
        if (id && de) catchMap[id.toLowerCase().trim()] = de.trim();
    });

    console.log('Fetching existing villagers from DB...');
    const dbVillagers = await directus.request(readItems('villagers', { limit: -1 }));
    const dbMap = {};
    dbVillagers.forEach(v => {
        dbMap[v.name_en.toLowerCase().trim()] = v.id;
    });

    console.log(`Processing ${masterData.length} villagers...`);
    for (let i = 0; i < masterData.length; i++) {
        const row = masterData[i];
        const nameEn = row['Name'];
        if (!nameEn) continue;

        const filename = row['Filename'];
        if (!filename) continue;

        const deName = nameMap[nameEn.toLowerCase().trim()] || nameEn;
        const deCatch = catchMap[filename.toLowerCase().trim()] || row['Catchphrase'] || '';

        const species = SPECIES_MAP[row['Species']?.toLowerCase().trim()] || row['Species'] || '';
        const gender = row['Gender'] === 'Female' ? 'Weiblich' : 'Männlich';
        const personality = PERSONALITY_MAP[row['Personality']?.toLowerCase().trim()] || row['Personality'] || '';
        const hobby = HOBBY_MAP[row['Hobby']?.toLowerCase().trim()] || row['Hobby'] || '';
        
        const styles = [];
        if (row['Style 1']) styles.push(STYLE_MAP[row['Style 1'].toLowerCase().trim()] || row['Style 1']);
        if (row['Style 2']) styles.push(STYLE_MAP[row['Style 2'].toLowerCase().trim()] || row['Style 2']);
        const preferredStyles = styles.join(', ');

        const iconUrl = `https://acnhcdn.com/latest/NpcIcon/${filename}.png`;
        const photoUrl = `https://acnhcdn.com/latest/NpcBromide/NpcNml${filename.charAt(0).toUpperCase() + filename.slice(1)}.png`;

        console.log(`[${i + 1}/${masterData.length}] Processing ${nameEn} (${deName})...`);
        const iconId = await getOrCreateFile(`${filename}_icon.png`, iconUrl);
        const photoId = await getOrCreateFile(`${filename}_photo.png`, photoUrl);

        const villagerData = {
            name_en: nameEn,
            name_de: deName,
            species,
            gender,
            personality,
            hobby,
            catchphrase: deCatch,
            birthday: row['Birthday'] || '',
            preferred_styles: preferredStyles,
            image_path: iconId || '',
            house_image_path: photoId || ''
        };

        const existingId = dbMap[nameEn.toLowerCase().trim()];
        if (existingId) {
            await directus.request(updateItem('villagers', existingId, villagerData));
        } else {
            await directus.request(createItem('villagers', villagerData));
        }
    }
    console.log('✅ Villager synchronization successfully completed!');
}

syncVillagers().catch(console.error);
