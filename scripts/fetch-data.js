import fs from 'fs';
import path from 'path';
import axios from 'axios';
import Papa from 'papaparse';

// 1. Die Haupt-Datenbank
const SPREADSHEET_ID = '13d_LAJPlxMa_DubPTuirk_g4gRkaY-0AHSqbYxfFIP4';
// 2. Die Übersetzungs-Datenbank
const TRANSLATION_SHEET_ID = '1GwUuCKgJC61qWEjWyeG3nVjkHesszRL6XbPA_dHfLoI';

const TABS = {
    villagers: 'Villagers',
    items: 'Housewares',
    recipes: 'Recipes'
};

async function downloadAndConvert(tabName, outputFilename) {
    const dataUrl = `https://docs.google.com/spreadsheets/d/${SPREADSHEET_ID}/gviz/tq?tqx=out:csv&sheet=${encodeURIComponent(tabName)}`;
    const transUrl = `https://docs.google.com/spreadsheets/d/${TRANSLATION_SHEET_ID}/gviz/tq?tqx=out:csv&sheet=${encodeURIComponent(tabName)}`;
    
    try {
        console.log(`📡 Lade Hauptdaten & Übersetzungen für "${tabName}" herunter...`);
        
        // Beide Tabellen parallel herunterladen für maximale Geschwindigkeit
        const [dataResponse, transResponse] = await Promise.all([
            axios.get(dataUrl),
            axios.get(transUrl).catch(() => ({ data: '' })) // Fallback, falls ein Tab in den Übersetzungen fehlt
        ]);
        
        const parsedData = Papa.parse(dataResponse.data, {
            header: true, skipEmptyLines: true, dynamicTyping: true
        });
        
        const parsedTrans = Papa.parse(transResponse.data, {
            header: true, skipEmptyLines: true, dynamicTyping: true
        });

        // 3. Übersetzungs-Wörterbuch aufbauen (Englisch -> Deutsch)
        const translationMap = {};
        parsedTrans.data.forEach(row => {
            // Die Spaltennamen im Translation-Sheet heißen meist 'US en' (Englisch) und 'EU de' (Deutsch)
            const enName = row['US en'] || row['Name'] || row['English'];
            const deName = row['EU de'] || row['German'];
            
            if (enName && deName) {
                translationMap[enName.toString().toLowerCase()] = deName;
            }
        });
        
        // 4. Daten bereinigen und übersetzen
        const cleanData = parsedData.data.map(row => {
            const cleanRow = {};
            for (const key in row) {
                if (key && !key.startsWith('__')) {
                    cleanRow[key.trim()] = row[key];
                }
            }
            
            // DEN DEUTSCHEN NAMEN ANHEFTEN!
            const engName = cleanRow['Name'];
            if (engName) {
                const searchKey = engName.toString().toLowerCase();
                // Falls eine Übersetzung existiert, fügen wir sie hinzu, sonst Fallback auf Englisch
                cleanRow['Translations (German)'] = translationMap[searchKey] || engName;
            }
            
            return cleanRow;
        });

        const outputPath = path.join(process.cwd(), 'src', 'data', `${outputFilename}.json`);
        fs.mkdirSync(path.dirname(outputPath), { recursive: true });
        fs.writeFileSync(outputPath, JSON.stringify(cleanData, null, 2));
        console.log(`💾 Erfolgreich gespeichert: ${outputPath} (${cleanData.length} Einträge inkl. deutscher Namen)`);
    } catch (error) {
        console.error(`❌ Fehler bei ${tabName}:`, error.message);
    }
}

/** slugify an English achievement name into a stable id. */
function slugify(s) {
    return (s || '').toString().toLowerCase().trim()
        .replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
}

// Internal sheet category → German group label used on the Erfolge page.
const ACH_CATEGORY_DE = {
    Event: 'Inselleben & Meilensteine', Fish: 'Angeln & Strand', Insect: 'Insekten',
    Communication: 'Gemeinschaft', DIY: 'Basteln & Handwerk', HHA: 'Zuhause & Werkzeug',
    Plant: 'Gärtnern & Natur', Smartphone: 'NookPhone & Katalog', Money: 'Wirtschaft',
    Negative: 'Pech & Pannen', LandMaking: 'Inselgestaltung', MyDesign: 'Mode & Design',
};

/**
 * Achievements ("Nook-Meilen-Erfolge") need their own mapper because the page
 * expects a clean shape ({ id, category, name, name_en, tiers, amounts, miles,
 * criteria }) rather than the raw sheet columns. `amounts` are the per-tier
 * thresholds (Tier 1..5); "for each unique X" achievements carry no thresholds,
 * so we derive [1..tiers].
 *
 * The German `name`/`criteria`/`category` are hand-curated in achievements.json.
 * The sheet only ships English, so we MERGE: existing German fields are kept by
 * id and only the numeric data (tiers/amounts/miles) is refreshed — re-running
 * the sync never regresses the translations.
 */
async function downloadAchievements() {
    const dataUrl = `https://docs.google.com/spreadsheets/d/${SPREADSHEET_ID}/gviz/tq?tqx=out:csv&sheet=Achievements`;
    const transUrl = `https://docs.google.com/spreadsheets/d/${TRANSLATION_SHEET_ID}/gviz/tq?tqx=out:csv&sheet=Achievements`;
    try {
        console.log('📡 Lade Erfolge (Nook-Meilen) & Übersetzungen herunter...');
        const [dataResponse, transResponse] = await Promise.all([
            axios.get(dataUrl),
            axios.get(transUrl).catch(() => ({ data: '' })),
        ]);
        const parsedData = Papa.parse(dataResponse.data, { header: true, skipEmptyLines: true, dynamicTyping: true });
        const parsedTrans = Papa.parse(transResponse.data, { header: true, skipEmptyLines: true, dynamicTyping: true });

        const translationMap = {};
        parsedTrans.data.forEach(row => {
            const enName = row['US en'] || row['Name'] || row['English'];
            const deName = row['EU de'] || row['German'];
            if (enName && deName) translationMap[enName.toString().toLowerCase()] = deName;
        });

        const pick = (row, ...keys) => {
            for (const k of keys) if (row[k] != null && row[k] !== '') return row[k];
            return null;
        };

        const outputPath = path.join(process.cwd(), 'src', 'data', 'achievements.json');
        // Existing curated German data, keyed by id, to merge over.
        const existingById = {};
        try {
            JSON.parse(fs.readFileSync(outputPath, 'utf8')).forEach(a => { existingById[a.id] = a; });
        } catch { /* first run: no file yet */ }

        const achievements = parsedData.data
            .filter(row => row['Name'])
            .map(row => {
                const nameEn = row['Name'].toString().trim();
                const id = slugify(nameEn);
                const tiers = Number(pick(row, 'Num of Tiers', 'Number of Tiers', 'Tiers')) || 0;
                let amounts = [1, 2, 3, 4, 5].map(i => Number(row['Tier ' + i]) || 0).slice(0, tiers);
                if (amounts.every(x => x === 0)) amounts = Array.from({ length: tiers }, (_, i) => i + 1);
                const miles = [1, 2, 3, 4, 5, 6]
                    .slice(0, tiers)
                    .reduce((sum, i) => sum + (Number(row['Reward Tier ' + i]) || 0), 0) || null;
                const prev = existingById[id] || {};
                return {
                    id,
                    category: prev.category || ACH_CATEGORY_DE[pick(row, 'Internal Category', 'Category')] || 'Sonstige Erfolge',
                    name: prev.name || translationMap[nameEn.toLowerCase()] || nameEn,
                    name_en: nameEn,
                    tiers,
                    amounts,
                    miles,
                    criteria: prev.criteria || pick(row, 'Award Criteria', 'Achievement Criteria', 'Criteria'),
                };
            });

        fs.mkdirSync(path.dirname(outputPath), { recursive: true });
        fs.writeFileSync(outputPath, JSON.stringify(achievements, null, 2) + '\n');
        console.log(`💾 Erfolgreich gespeichert: ${outputPath} (${achievements.length} Erfolge)`);
    } catch (error) {
        console.error('❌ Fehler bei Achievements:', error.message);
    }
}

async function run() {
    console.log('--- STARTE DATEN-DOWNLOAD (inkl. Übersetzungen) ---');
    await downloadAndConvert(TABS.villagers, 'villagers');
    await downloadAndConvert(TABS.items, 'items');
    await downloadAndConvert(TABS.recipes, 'recipes');
    await downloadAchievements();
    console.log('✅ Datenimport vollständig abgeschlossen!\n');
}

run();
