import axios from 'axios';
import Papa from 'papaparse';
import { createDirectus, rest, staticToken, readItems, createItem, updateItem } from '@directus/sdk';

const MASTER_SHEET_ID = '13d_LAJPlxMa_DubPTuirkIV4DERBMXbrWQsmSh8ReK4';
const TRANSLATION_SHEET_ID = '1GwUuCKgJC61qWEjWyeG3nVjkHesszRL6XbPA_dHfLoI';
const DIRECTUS_URL = 'https://backend-nookipedia.2.godsize.info';
const TOKEN = 'JSeWKMH1ZYXiSfLzJiLnOnTVSIwIr3pZ';

const directus = createDirectus(DIRECTUS_URL)
    .with(rest())
    .with(staticToken(TOKEN));

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

async function ensureField(collection, fieldName, fieldType) {
    try {
        const res = await axios.get(`${DIRECTUS_URL}/fields/${collection}/${fieldName}`, {
            headers: { 'Authorization': `Bearer ${TOKEN}` }
        }).catch(() => null);

        if (res && res.data) return;

        console.log(`🔧 Schema API: Creating missing field ${fieldName} (${fieldType}) in ${collection}...`);
        await axios.post(`${DIRECTUS_URL}/fields/${collection}`, {
            field: fieldName,
            type: fieldType,
            meta: {}
        }, {
            headers: { 'Authorization': `Bearer ${TOKEN}` }
        });
    } catch (e) {
        console.error(`Failed to ensure field ${collection}.${fieldName}:`, e.message);
    }
}

async function ensureFieldDynamic(collection, fieldName, value) {
    const existingFields = await cacheCollectionFields(collection);
    if (existingFields.has(fieldName)) return;
    
    let type = 'string';
    if (typeof value === 'boolean') {
        type = 'boolean';
    } else if (typeof value === 'number') {
        type = Number.isInteger(value) ? 'integer' : 'float';
    } else if (value && String(value).length > 255) {
        type = 'text';
    }
    
    await ensureField(collection, fieldName, type);
    existingFields.add(fieldName);
}

async function mergeItem(collection, uniqueKeyField, uniqueValue, newPayload) {
    try {
        for (const [key, val] of Object.entries(newPayload)) {
            await ensureFieldDynamic(collection, key, val);
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

async function syncEvents() {
    console.log('📡 Fetching Events data...');
    const masterData = await downloadCSV(MASTER_SHEET_ID, 'Seasons and Events');
    
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

syncEvents().then(() => console.log("🎉 Events Sync Done!")).catch(console.error);
