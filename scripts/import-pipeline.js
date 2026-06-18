import fs from 'fs';
import path from 'path';
import axios from 'axios';
import Papa from 'papaparse';
import FormData from 'form-data';
import { createDirectus, rest, staticToken, readItems, createItem, updateItem } from '@directus/sdk';
import { forgeryDescriptions } from './forgery-map.js';

const MASTER_SHEET_ID = '13d_LAJPlxMa_DubPTuirkIV4DERBMXbrWQsmSh8ReK4';
const TRANSLATION_SHEET_ID = '1GwUuCKgJC61qWEjWyeG3nVjkHesszRL6XbPA_dHfLoI';
const DIRECTUS_URL = 'https://backend-nookipedia.2.godsize.info';
const TOKEN = 'JSeWKMH1ZYXiSfLzJiLnOnTVSIwIr3pZ';

const directus = createDirectus(DIRECTUS_URL)
    .with(rest())
    .with(staticToken(TOKEN));

const SPECIES_MAP = {
    'alligator': 'Krokodil', 'anteater': 'Ameisenbär', 'bear': 'Bär', 'bird': 'Vogel',
    'bull': 'Stier', 'cat': 'Katze', 'chicken': 'Huhn', 'cow': 'Kuh', 'cub': 'Bärchen',
    'deer': 'Hirsch', 'dog': 'Hund', 'duck': 'Ente', 'eagle': 'Adler', 'elephant': 'Elefant',
    'frog': 'Frosch', 'goat': 'Ziege', 'gorilla': 'Gorilla', 'hamster': 'Hamster',
    'hippo': 'Nilpferd', 'horse': 'Pferd', 'kangaroo': 'Känguru', 'koala': 'Koala',
    'lion': 'Löwe', 'monkey': 'Affe', 'mouse': 'Maus', 'octopus': 'Krake', 'ostrich': 'Strauß',
    'penguin': 'Pinguin', 'pig': 'Schwein', 'rabbit': 'Hase', 'rhino': 'Nashorn',
    'sheep': 'Schaf', 'squirrel': 'Eichhörnchen', 'tiger': 'Tiger', 'wolf': 'Wolf'
};

const PERSONALITY_MAP = {
    'cranky': 'Miesepeter', 'jock': 'Sportlich', 'lazy': 'Schlafmütze', 'normal': 'Ausgeglichen',
    'peppy': 'Schwungvoll', 'smug': 'Selbstgefällig', 'snooty': 'Hochnäsig', 'big sister': 'Große Schwester',
    'sisterly': 'Große Schwester'
};

const HOBBY_MAP = {
    'nature': 'Natur', 'fitness': 'Fitness', 'play': 'Spielen', 'education': 'Bildung',
    'fashion': 'Mode', 'music': 'Musik'
};

const STYLE_MAP = {
    'active': 'Sportlich', 'cool': 'Cool', 'cute': 'Süß', 'elegant': 'Elegant',
    'gorgeous': 'Prachtvoll', 'simple': 'Schlicht'
};

const MONTH_MAP = {
    'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
    'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
};

function toSnakeCase(str) {
    if (!str) return '';
    return str
        .toLowerCase()
        .replace(/[^a-z0-9]+/g, '_')
        .replace(/(^_+|_+$)/g, '');
}

async function downloadCSV(sheetId, tabName) {
    const url = `https://docs.google.com/spreadsheets/d/${sheetId}/gviz/tq?tqx=out:csv&sheet=${encodeURIComponent(tabName)}`;
    const res = await axios.get(url);
    return Papa.parse(res.data, { header: true, skipEmptyLines: true }).data;
}

const collectionFieldsCache = {};

async function cacheCollectionFields(collection) {
    if (collectionFieldsCache[collection]) return collectionFieldsCache[collection];
    try {
        const res = await axios.get(`${DIRECTUS_URL}/fields/${collection}`, {
            headers: { 'Authorization': `Bearer ${TOKEN}` }
        });
        const fields = new Set(res.data.data.map(f => f.field));
        collectionFieldsCache[collection] = fields;
        return fields;
    } catch (e) {
        const fields = new Set();
        collectionFieldsCache[collection] = fields;
        return fields;
    }
}

async function ensureCollection(collectionName) {
    try {
        const res = await axios.get(`${DIRECTUS_URL}/collections/${collectionName}`, {
            headers: { 'Authorization': `Bearer ${TOKEN}` }
        }).catch(() => null);
        
        if (res && res.data) return;
        
        console.log(`🔧 Schema API: Creating missing collection "${collectionName}"...`);
        await axios.post(`${DIRECTUS_URL}/collections`, {
            collection: collectionName,
            schema: {},
            meta: { icon: 'insert_drive_file' }
        }, {
            headers: { 'Authorization': `Bearer ${TOKEN}` }
        });
        
        await ensureField(collectionName, 'id', 'integer');
    } catch (e) {
        console.error(`Failed to ensure collection ${collectionName}:`, e.response ? e.response.data : e.message);
    }
}

async function ensureField(collection, fieldName, fieldType, relationCollection = null) {
    try {
        const res = await axios.get(`${DIRECTUS_URL}/fields/${collection}/${fieldName}`, {
            headers: { 'Authorization': `Bearer ${TOKEN}` }
        }).catch(() => null);

        if (res && res.data) return;

        console.log(`🔧 Dynamic Schema API: Creating missing field ${fieldName} (${fieldType}) in ${collection}...`);
        let fieldData = { field: fieldName, type: fieldType, meta: {} };
        if (relationCollection) {
            fieldData.type = 'uuid';
            fieldData.schema = { foreign_key_column: 'id', foreign_key_table: relationCollection };
            fieldData.meta = { interface: 'file', special: ['file'] };
        }
        await axios.post(`${DIRECTUS_URL}/fields/${collection}`, fieldData, {
            headers: { 'Authorization': `Bearer ${TOKEN}` }
        });
    } catch (e) {
        console.error(`Failed to ensure field ${collection}.${fieldName}:`, e.response ? e.response.data : e.message);
    }
}

async function ensureFieldDynamic(collection, fieldName, value, isImage = false) {
    const existingFields = await cacheCollectionFields(collection);
    if (existingFields.has(fieldName)) return;
    
    let type = 'string';
    let relationCollection = null;
    
    if (isImage) {
        type = 'uuid';
        relationCollection = 'directus_files';
    } else if (typeof value === 'boolean') {
        type = 'boolean';
    } else if (typeof value === 'number') {
        type = Number.isInteger(value) ? 'integer' : 'float';
    } else if (value && String(value).length > 255) {
        type = 'text';
    }
    
    await ensureField(collection, fieldName, type, relationCollection);
    existingFields.add(fieldName);
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
        return null;
    }
}

async function mergeItem(collection, uniqueKeyField, uniqueValue, newPayload) {
    try {
        for (const [key, val] of Object.entries(newPayload)) {
            const isImage = key.endsWith('image') || key.endsWith('image_path') || key === 'image' || key.endsWith('texture') || key === 'image_genuine' || key === 'image_fake';
            await ensureFieldDynamic(collection, key, val, isImage);
        }
        
        const existing = await directus.request(readItems(collection, {
            filter: { [uniqueKeyField]: { _eq: uniqueValue } },
            limit: 1
        }));
        
        if (existing && existing.length > 0) {
            const existingItem = existing[0];
            const patchPayload = {};
            let hasChanges = false;
            
            for (const [key, val] of Object.entries(newPayload)) {
                const existingVal = existingItem[key];
                if (existingVal === undefined || existingVal === null || existingVal === '') {
                    if (val !== undefined && val !== null && val !== '') {
                        patchPayload[key] = val;
                        hasChanges = true;
                    }
                }
            }
            
            if (hasChanges) {
                console.log(`Updating ${collection} "${uniqueValue}" with missing attributes...`);
                await directus.request(updateItem(collection, existingItem.id, patchPayload));
            } else {
                console.log(`No missing attributes to update for ${collection} "${uniqueValue}".`);
            }
            return existingItem.id;
        } else {
            console.log(`Creating new ${collection} "${uniqueValue}"...`);
            const created = await directus.request(createItem(collection, newPayload));
            return created.id;
        }
    } catch (e) {
        console.error(`Failed to merge item in ${collection}:`, e.message);
        return null;
    }
}

async function syncVillagers() {
    console.log('📡 Fetching Villagers data...');
    const masterData = await downloadCSV(MASTER_SHEET_ID, 'Villagers');
    const nameTransData = await downloadCSV(TRANSLATION_SHEET_ID, 'Villagers');
    const catchTransData = await downloadCSV(TRANSLATION_SHEET_ID, 'Villagers Catch Phrase');

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

    for (let i = 0; i < masterData.length; i++) {
        const row = masterData[i];
        const nameEn = row['Name'];
        if (!nameEn) continue;

        const filename = row['Filename'];
        if (!filename) continue;

        console.log(`[Villagers] [${i + 1}/${masterData.length}] ${nameEn}...`);

        const iconUrl = `https://acnhcdn.com/latest/NpcIcon/${filename}.png`;
        const photoUrl = `https://acnhcdn.com/latest/NpcBromide/NpcNml${filename.charAt(0).toUpperCase() + filename.slice(1)}.png`;
        
        const iconId = await getOrCreateFile(`${filename}_icon.png`, iconUrl);
        const photoId = await getOrCreateFile(`${filename}_photo.png`, photoUrl);

        const dynamicPayload = {};
        for (const [key, val] of Object.entries(row)) {
            if (!key || key.startsWith('__')) continue;
            const snakeKey = toSnakeCase(key);
            
            if (['name', 'display_name', 'english', 'us_en'].includes(snakeKey)) {
                dynamicPayload['name_en'] = nameEn;
                continue;
            }
            
            if (snakeKey === 'icon_image' || snakeKey === 'icon_filename') {
                dynamicPayload['image_path'] = iconId || null;
                continue;
            }
            if (snakeKey === 'photo_image' || snakeKey === 'photo_filename') {
                dynamicPayload['house_image_path'] = photoId || null;
                continue;
            }
            
            if (val === null || val === undefined || val === 'NA' || val === '') {
                dynamicPayload[snakeKey] = null;
            } else if (typeof val === 'boolean') {
                dynamicPayload[snakeKey] = val;
            } else if (!isNaN(val) && String(val).trim() !== '') {
                dynamicPayload[snakeKey] = Number(val);
            } else {
                dynamicPayload[snakeKey] = String(val).trim();
            }
        }

        const deName = nameMap[nameEn.toLowerCase().trim()] || nameEn;
        dynamicPayload['name_de'] = deName;
        
        const deCatch = catchMap[filename.toLowerCase().trim()] || row['Catchphrase'] || '';
        dynamicPayload['catchphrase'] = deCatch;

        await mergeItem('villagers', 'name_en', nameEn, dynamicPayload);
    }
}

async function syncItems() {
    console.log('📡 Fetching Items data...');
    const ITEM_TABS = ['Housewares', 'Miscellaneous', 'Wall-mounted', 'Ceiling Decor', 'Rugs', 'Flooring', 'Wallpaper'];
    
    const transData = await downloadCSV(TRANSLATION_SHEET_ID, 'Furniture');
    const translationMap = {};
    transData.forEach(row => {
        const en = row['English'] || row['Name'];
        const de = row['German'];
        if (en && de) translationMap[en.toLowerCase().trim()] = de.trim();
    });

    for (const tab of ITEM_TABS) {
        console.log(`Syncing Items tab: ${tab}...`);
        const masterData = await downloadCSV(MASTER_SHEET_ID, tab);
        
        const itemsGrouped = {};
        masterData.forEach(row => {
            const name = row['Name'];
            if (!name) return;
            if (!itemsGrouped[name]) itemsGrouped[name] = [];
            itemsGrouped[name].push(row);
        });

        const itemNames = Object.keys(itemsGrouped);
        const syncLimit = 150; 

        for (let i = 0; i < Math.min(itemNames.length, syncLimit); i++) {
            const nameEn = itemNames[i];
            const rows = itemsGrouped[nameEn];
            const baseRow = rows[0];

            const nameDe = translationMap[nameEn.toLowerCase().trim()] || nameEn;
            console.log(`[Items - ${tab}] [${i + 1}/${Math.min(itemNames.length, syncLimit)}] ${nameEn} (${nameDe})...`);

            const itemData = {};
            for (const [key, val] of Object.entries(baseRow)) {
                if (!key || key.startsWith('__')) continue;
                const snakeKey = toSnakeCase(key);
                
                if (['variation', 'pattern', 'filename', 'image', 'high_res_texture'].includes(snakeKey)) continue;

                if (['name', 'display_name', 'english', 'us_en'].includes(snakeKey)) {
                    itemData['name_en'] = nameEn;
                    continue;
                }
                
                if (val === null || val === undefined || val === 'NA' || val === '') {
                    itemData[snakeKey] = null;
                } else if (typeof val === 'boolean') {
                    itemData[snakeKey] = val;
                } else if (!isNaN(val) && String(val).trim() !== '') {
                    itemData[snakeKey] = Number(val);
                } else {
                    itemData[snakeKey] = String(val).trim();
                }
            }
            
            itemData['name_de'] = nameDe;
            itemData['category'] = tab;

            const itemId = await mergeItem('items', 'name_en', nameEn, itemData);

            for (let j = 0; j < rows.length; j++) {
                const variantRow = rows[j];
                const filename = variantRow['Filename'];
                if (!filename) continue;
                const variantNameEn = variantRow['Variation'] || 'Normal';
                const patternNameEn = variantRow['Pattern'] || '';

                const imageUrl = `https://acnhcdn.com/latest/FtrIcon/${filename}.png`;
                const imageId = await getOrCreateFile(`${filename}.png`, imageUrl);

                const variantData = {};
                for (const [key, val] of Object.entries(variantRow)) {
                    if (!key || key.startsWith('__')) continue;
                    const snakeKey = toSnakeCase(key);
                    
                    if (['name', 'display_name', 'english', 'us_en'].includes(snakeKey)) continue;

                    if (val === null || val === undefined || val === 'NA' || val === '') {
                        variantData[snakeKey] = null;
                    } else if (typeof val === 'boolean') {
                        variantData[snakeKey] = val;
                    } else if (!isNaN(val) && String(val).trim() !== '') {
                        variantData[snakeKey] = Number(val);
                    } else {
                        variantData[snakeKey] = String(val).trim();
                    }
                }
                
                variantData['item_id'] = itemId;
                variantData['variant_name_de'] = variantNameEn;
                variantData['pattern_name_de'] = patternNameEn;
                variantData['image_path'] = imageId || null;

                await mergeItem('item_variants', 'filename', filename, variantData);
            }
        }
    }
}

async function syncRecipes() {
    console.log('📡 Fetching Recipes data...');
    const masterRecipes = await downloadCSV(MASTER_SHEET_ID, 'Recipes');
    const transData = await downloadCSV(TRANSLATION_SHEET_ID, 'Recipes');

    const transMap = {};
    transData.forEach(row => {
        const en = row['English'] || row['Name'];
        const de = row['German'];
        if (en && de) transMap[en.toLowerCase().trim()] = de.trim();
    });

    for (let i = 0; i < masterRecipes.length; i++) {
        const row = masterRecipes[i];
        const nameEn = row['Name'];
        if (!nameEn) continue;

        const isCooking = row['Category'] === 'Recipes' || row['Crafting Group'] === 'Cooking' || String(row['DIY Icon Filename']).startsWith('Food');
        const collection = isCooking ? 'cooking_recipes' : 'diy_recipes';

        const filename = row['DIY Icon Filename'];
        let imageId = null;
        if (filename) {
            const imageUrl = `https://acnhcdn.com/latest/FtrIcon/${filename}.png`;
            imageId = await getOrCreateFile(`${filename}.png`, imageUrl);
        }

        const recipeData = {};
        for (const [key, val] of Object.entries(row)) {
            if (!key || key.startsWith('__')) continue;
            const snakeKey = toSnakeCase(key);

            if (['name', 'display_name', 'english', 'us_en'].includes(snakeKey)) {
                recipeData['name_en'] = nameEn;
                continue;
            }

            if (snakeKey === 'diy_icon_filename') {
                recipeData['image_path'] = imageId || null;
                continue;
            }

            if (val === null || val === undefined || val === 'NA' || val === '') {
                recipeData[snakeKey] = null;
            } else if (typeof val === 'boolean') {
                recipeData[snakeKey] = val;
            } else if (!isNaN(val) && String(val).trim() !== '') {
                recipeData[snakeKey] = Number(val);
            } else {
                recipeData[snakeKey] = String(val).trim();
            }
        }

        recipeData['name_de'] = transMap[nameEn.toLowerCase().trim()] || nameEn;

        console.log(`[Recipes - ${collection}] [${i + 1}/${masterRecipes.length}] ${nameEn}...`);
        await mergeItem(collection, 'name_en', nameEn, recipeData);
    }
}

async function syncArtworks() {
    console.log('📡 Fetching Artwork data...');
    const masterData = await downloadCSV(MASTER_SHEET_ID, 'Artwork');
    const transData = await downloadCSV(TRANSLATION_SHEET_ID, 'Art');

    const transMap = {};
    transData.forEach(r => {
        if (r.English && r.German) transMap[r.English.toLowerCase().trim()] = r.German.trim();
    });

    const artGrouped = {};
    masterData.forEach(row => {
        const name = row['Name'];
        if (!name) return;
        if (!artGrouped[name]) artGrouped[name] = [];
        artGrouped[name].push(row);
    });

    const artNames = Object.keys(artGrouped);
    console.log(`Processing ${artNames.length} artworks...`);

    for (let i = 0; i < artNames.length; i++) {
        const nameEn = artNames[i];
        const rows = artGrouped[nameEn];
        const genuineRow = rows.find(r => r.Genuine === 'Yes') || rows[0];
        const fakeRow = rows.find(r => r.Genuine === 'No');

        const deName = transMap[nameEn.toLowerCase().trim()] || nameEn;
        console.log(`[Artwork] [${i + 1}/${artNames.length}] ${nameEn} (${deName})...`);

        const realFilename = genuineRow.Filename;
        const realImageUrl = `https://acnhcdn.com/latest/FtrIcon/${realFilename}.png`;
        const realImageId = await getOrCreateFile(`${realFilename}.png`, realImageUrl);

        let fakeImageId = null;
        if (fakeRow) {
            const fakeFilename = fakeRow.Filename;
            const fakeImageUrl = `https://acnhcdn.com/latest/FtrIcon/${fakeFilename}.png`;
            fakeImageId = await getOrCreateFile(`${fakeFilename}.png`, fakeImageUrl) || null;
        }

        const artData = {};
        for (const [key, val] of Object.entries(genuineRow)) {
            if (!key || key.startsWith('__')) continue;
            const snakeKey = toSnakeCase(key);

            if (['name', 'display_name', 'english', 'us_en'].includes(snakeKey)) {
                artData['name_en'] = nameEn;
                continue;
            }

            if (snakeKey === 'filename' || snakeKey === 'image' || snakeKey === 'high_res_texture') continue;

            if (val === null || val === undefined || val === 'NA' || val === '') {
                artData[snakeKey] = null;
            } else if (typeof val === 'boolean') {
                artData[snakeKey] = val;
            } else if (!isNaN(val) && String(val).trim() !== '') {
                artData[snakeKey] = Number(val);
            } else {
                artData[snakeKey] = String(val).trim();
            }
        }

        artData['name_de'] = deName;
        artData['image_genuine'] = realImageId || null;
        artData['image_fake'] = fakeImageId;
        artData['always_genuine'] = !fakeRow;

        await mergeItem('artworks', 'name_en', nameEn, artData);
    }

    console.log('Populating artwork_forgeries from forgery-map.js...');
    await ensureCollection('artwork_forgeries');
    await ensureField('artwork_forgeries', 'artwork_name_en', 'string');
    await ensureField('artwork_forgeries', 'forgery_description', 'text');
    await ensureField('artwork_forgeries', 'always_genuine', 'boolean');

    for (const [nameEn, desc] of Object.entries(forgeryDescriptions)) {
        const forgeryData = {
            artwork_name_en: nameEn,
            forgery_description: desc,
            always_genuine: false
        };
        await mergeItem('artwork_forgeries', 'artwork_name_en', nameEn, forgeryData);
    }

    console.log('Auto-populating always_genuine artwork_forgeries entries...');
    const dbArtworks = await directus.request(readItems('artworks', { limit: -1 }));
    for (const art of dbArtworks) {
        const nameEn = art.name_en;
        if (!nameEn) continue;
        const searchName = nameEn.toLowerCase().trim();

        if (!forgeryDescriptions[searchName]) {
            const forgeryData = {
                artwork_name_en: nameEn,
                forgery_description: '',
                always_genuine: true
            };
            await mergeItem('artwork_forgeries', 'artwork_name_en', nameEn, forgeryData);
        }
    }
}

async function syncFossils() {
    console.log('📡 Fetching Fossils data...');
    const masterData = await downloadCSV(MASTER_SHEET_ID, 'Fossils');
    const transData = await downloadCSV(TRANSLATION_SHEET_ID, 'Fossils');

    const transMap = {};
    transData.forEach(r => {
        if (r.English && r.German) transMap[r.English.toLowerCase().trim()] = r.German.trim();
    });

    console.log(`Processing ${masterData.length} fossils...`);
    for (let i = 0; i < masterData.length; i++) {
        const row = masterData[i];
        const nameEn = row['Name'];
        if (!nameEn) continue;

        const deName = transMap[nameEn.toLowerCase().trim()] || nameEn;
        const filename = row['Filename'];
        const imageUrl = `https://acnhcdn.com/latest/FtrIcon/${filename}.png`;

        console.log(`[Fossils] [${i + 1}/${masterData.length}] ${nameEn} (${deName})...`);
        const imageId = await getOrCreateFile(`${filename}.png`, imageUrl);

        const group = row['Fossil Group'] || '';
        const type = group.toLowerCase() === nameEn.toLowerCase() ? 'Einzel' : 'Teil';

        const fossilData = {};
        for (const [key, val] of Object.entries(row)) {
            if (!key || key.startsWith('__')) continue;
            const snakeKey = toSnakeCase(key);

            if (['name', 'display_name', 'english', 'us_en'].includes(snakeKey)) {
                fossilData['name_en'] = nameEn;
                continue;
            }

            if (snakeKey === 'filename' || snakeKey === 'image') continue;

            if (val === null || val === undefined || val === 'NA' || val === '') {
                fossilData[snakeKey] = null;
            } else if (typeof val === 'boolean') {
                fossilData[snakeKey] = val;
            } else if (!isNaN(val) && String(val).trim() !== '') {
                fossilData[snakeKey] = Number(val);
            } else {
                fossilData[snakeKey] = String(val).trim();
            }
        }

        fossilData['name_de'] = deName;
        fossilData['image_path'] = imageId || null;
        fossilData['dinosaur_group'] = group;
        fossilData['type'] = type;

        await mergeItem('fossils', 'name_en', nameEn, fossilData);
    }
}

async function syncMaterials() {
    console.log('📡 Fetching Materials data...');
    const masterData = await downloadCSV(MASTER_SHEET_ID, 'Other');

    console.log(`Processing materials...`);
    for (let i = 0; i < masterData.length; i++) {
        const row = masterData[i];
        const nameEn = row['Name'];
        if (!nameEn) continue;

        const filename = row['Inventory Filename'];
        if (!filename) continue;

        const imageUrl = `https://acnhcdn.com/latest/FtrIcon/${filename}.png`;
        console.log(`[Materials] [${i + 1}/${masterData.length}] ${nameEn}...`);
        const imageId = await getOrCreateFile(`${filename}.png`, imageUrl);

        const matData = {};
        for (const [key, val] of Object.entries(row)) {
            if (!key || key.startsWith('__')) continue;
            const snakeKey = toSnakeCase(key);

            if (['name', 'display_name', 'english', 'us_en'].includes(snakeKey)) {
                matData['name_en'] = nameEn;
                continue;
            }

            if (snakeKey === 'inventory_filename' || snakeKey === 'image') continue;

            if (val === null || val === undefined || val === 'NA' || val === '') {
                matData[snakeKey] = null;
            } else if (typeof val === 'boolean') {
                matData[snakeKey] = val;
            } else if (!isNaN(val) && String(val).trim() !== '') {
                matData[snakeKey] = Number(val);
            } else {
                matData[snakeKey] = String(val).trim();
            }
        }

        matData['name_de'] = nameEn; 
        matData['image_path'] = imageId || null;

        await mergeItem('materials', 'name_en', nameEn, matData);
    }
}

async function syncSpecialNPCs() {
    console.log('📡 Fetching Special NPCs data...');
    const masterData = await downloadCSV(MASTER_SHEET_ID, 'Special NPCs');
    const transData = await downloadCSV(TRANSLATION_SHEET_ID, 'Special NPCs');

    const transMap = {};
    transData.forEach(r => {
        if (r.English && r.German) transMap[r.English.toLowerCase().trim()] = r.German.trim();
    });

    console.log(`Processing ${masterData.length} special NPCs...`);
    for (let i = 0; i < masterData.length; i++) {
        const row = masterData[i];
        const nameEn = row['Name'];
        if (!nameEn) continue;

        const deName = transMap[nameEn.toLowerCase().trim()] || nameEn;
        const filename = row['Icon Filename'];
        const imageUrl = `https://acnhcdn.com/latest/NpcIcon/${filename}.png`;

        console.log(`[Special NPCs] [${i + 1}/${masterData.length}] ${nameEn} (${deName})...`);
        const imageId = await getOrCreateFile(`${filename}.png`, imageUrl);

        const npcData = {};
        for (const [key, val] of Object.entries(row)) {
            if (!key || key.startsWith('__')) continue;
            const snakeKey = toSnakeCase(key);

            if (['name', 'display_name', 'english', 'us_en'].includes(snakeKey)) {
                npcData['name_en'] = nameEn;
                continue;
            }

            if (snakeKey === 'icon_filename' || snakeKey === 'image') continue;

            if (val === null || val === undefined || val === 'NA' || val === '') {
                npcData[snakeKey] = null;
            } else if (typeof val === 'boolean') {
                npcData[snakeKey] = val;
            } else if (!isNaN(val) && String(val).trim() !== '') {
                npcData[snakeKey] = Number(val);
            } else {
                npcData[snakeKey] = String(val).trim();
            }
        }

        npcData['name_de'] = deName;
        npcData['image_path'] = imageId || null;

        await mergeItem('special_npcs', 'name_en', nameEn, npcData);
    }
}

async function syncEvents() {
    console.log('📡 Fetching Events data...');
    const masterData = await downloadCSV(MASTER_SHEET_ID, 'Seasons and Events');
    
    // Fetch translations
    const transData = await downloadCSV(TRANSLATION_SHEET_ID, 'Events');
    const translationMap = {};
    transData.forEach(row => {
        const keys = Object.keys(row);
        const englishKey = keys.find(k => k.startsWith('English ') || k === 'English');
        const germanKey = keys.find(k => k.startsWith('German ') || k === 'German');
        if (englishKey && germanKey) {
            const en = row[englishKey];
            const de = row[germanKey];
            if (en && de) {
                translationMap[en.toLowerCase().trim()] = de.trim();
            }
        }
    });

    console.log(`Processing ${masterData.length} events...`);
    for (let i = 0; i < masterData.length; i++) {
        const row = masterData[i];
        const nameEn = row['Display Name'] || row['Name'];
        if (!nameEn) continue;

        console.log(`[Events] [${i + 1}/${masterData.length}] ${nameEn}...`);

        let month = 1;
        const sortDate = row['Sort Date'];
        if (sortDate) {
            const parts = sortDate.split(' ');
            if (parts.length > 0) {
                month = MONTH_MAP[parts[0]] || 1;
            }
        }

        const eventData = {};
        for (const [key, val] of Object.entries(row)) {
            if (!key || key.startsWith('__')) continue;
            const snakeKey = toSnakeCase(key);

            if (['name', 'display_name', 'english', 'us_en'].includes(snakeKey)) {
                eventData['name_en'] = nameEn;
                continue;
            }

            if (val === null || val === undefined || val === 'NA' || val === '') {
                eventData[snakeKey] = null;
            } else if (typeof val === 'boolean') {
                eventData[snakeKey] = val;
            } else if (!isNaN(val) && String(val).trim() !== '') {
                eventData[snakeKey] = Number(val);
            } else {
                eventData[snakeKey] = String(val).trim();
            }
        }

        const deName = translationMap[nameEn.toLowerCase().trim()] || nameEn;
        eventData['name_de'] = deName; 
        eventData['month'] = month;

        await mergeItem('events', 'name_en', nameEn, eventData);
    }
}

async function run() {
    await syncVillagers();
    await syncItems();
    await syncRecipes();
    await syncArtworks();
    await syncFossils();
    await syncMaterials();
    await syncSpecialNPCs();
    await syncEvents();
    console.log('🎉 COMPLETE INTEGRATION & MIGRATION PIPELINE FINISHED SUCCESSFULLY!');
}

run().catch(console.error);
