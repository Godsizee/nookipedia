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

/**
 * Achievements ("Nook-Meilen-Erfolge") need their own mapper because the page
 * expects a clean shape ({ id, category, name, name_en, tiers, criteria, miles })
 * rather than the raw sheet columns. Falls back gracefully on missing columns so
 * a sheet layout change never produces a broken achievements.json.
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

        const achievements = parsedData.data
            .filter(row => row['Name'])
            .map(row => {
                const nameEn = row['Name'].toString().trim();
                // Sum all per-tier Nook-Mile rewards if present.
                const miles = Object.keys(row)
                    .filter(k => /reward/i.test(k))
                    .reduce((sum, k) => sum + (Number(row[k]) || 0), 0) || null;
                return {
                    id: slugify(nameEn),
                    category: pick(row, 'Internal Category', 'Category') || 'Sonstige Erfolge',
                    name: translationMap[nameEn.toLowerCase()] || nameEn,
                    name_en: nameEn,
                    tiers: Number(pick(row, 'Num of Tiers', 'Number of Tiers', 'Tiers')) || null,
                    criteria: pick(row, 'Achievement Criteria', 'Criteria', 'Description'),
                    miles,
                };
            });

        const outputPath = path.join(process.cwd(), 'src', 'data', 'achievements.json');
        fs.mkdirSync(path.dirname(outputPath), { recursive: true });
        fs.writeFileSync(outputPath, JSON.stringify(achievements, null, 2));
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
