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

async function run() {
    console.log('--- STARTE DATEN-DOWNLOAD (inkl. Übersetzungen) ---');
    await downloadAndConvert(TABS.villagers, 'villagers');
    await downloadAndConvert(TABS.items, 'items');
    await downloadAndConvert(TABS.recipes, 'recipes');
    console.log('✅ Datenimport vollständig abgeschlossen!\n');
}

run();
