Leitfaden: ACNH v3.0.3-Datenbank & Assets komplett selbst hosten

Wenn du keine externen APIs nutzen möchtest und die volle Kontrolle über deine Website anstrebst, ist die lokale Daten- und Assethaltung die beste Wahl.

Da der gesamte Datensatz (v3.0.3) tausende Zeilen und Bilder umfasst, ist ein manuelles Kopieren unmöglich. Dieser Leitfaden bietet dir eine vollautomatische Pipeline, die die Rohdaten strukturiert, bereinigt und alle zugehörigen Bild-Assets (Icons, Fotos) lokal auf deine Festplatte zieht, damit du sie direkt in deinem Projekt hosten kannst.

Die System-Architektur deines Projekts

Für ein sauberes, performantes Webprojekt (z. B. mit React, Vue, Svelte oder Next.js) empfiehlt sich folgende Ordnerstruktur:

mein-acnh-projekt/
├── public/
│   └── assets/              <-- Hier landen alle heruntergeladenen Bilder
│       ├── villagers/       <-- Bewohner-Icons (z.B. bento.png, aegis.png)
│       ├── items/           <-- Möbel, Werkzeuge, Kleidung
│       └── recipes/         <-- DIY-Karten
├── src/
│   └── data/                <-- Hier liegen deine lokalen JSON-Datenbanken
│       ├── villagers.json
│       ├── items.json
│       └── recipes.json
├── scripts/
│   ├── fetch-data.js        <-- Skript 1: Holt die CSVs & generiert JSON
│   └── download-assets.js   <-- Skript 2: Lädt alle Bild-Links lokal herunter
└── package.json


Schritt 1: Die Daten-Pipeline (fetch-data.js)

Dieses Skript zieht die aktuellsten v3.0.3-Rohdaten aus dem kooperativen Google Spreadsheet der Datamining-Community, bereinigt die Spaltennamen und übersetzt die Datenstruktur in sauberes JSON.

Erstelle die Datei scripts/fetch-data.js:

import fs from 'fs';
import path from 'path';
import axios from 'axios';
import Papa from 'papaparse';

const SPREADSHEET_ID = '13d_LAJPlxMa_DubPTuirk_g4gRkaY-0AHSqbYxfFIP4';

// Tabs, die wir für unsere Datenbank extrahieren
const TABS = {
    villagers: 'Villagers',
    items: 'Housewares',
    recipes: 'Recipes'
};

async function downloadAndConvert(tabName, outputFilename) {
    const url = `https://docs.google.com/spreadsheets/d/${SPREADSHEET_ID}/gviz/tq?tqx=out:csv&sheet=${encodeURIComponent(tabName)}`;
    
    try {
        console.log(`📡 Lade Daten für "${tabName}" herunter...`);
        const response = await axios.get(url);
        
        const parsed = Papa.parse(response.data, {
            header: true,
            skipEmptyLines: true,
            dynamicTyping: true
        });
        
        // Datenbereinigung und deutsche Normalisierung
        const cleanData = parsed.data.map(row => {
            const cleanRow = {};
            for (const key in row) {
                if (key && !key.startsWith('__')) {
                    // Normalisiere unschöne Keys aus dem Google Sheet
                    let cleanKey = key.trim();
                    cleanRow[cleanKey] = row[key];
                }
            }
            return cleanRow;
        });

        const outputPath = path.join(process.cwd(), 'src', 'data', `${outputFilename}.json`);
        fs.mkdirSync(path.dirname(outputPath), { recursive: true });
        fs.writeFileSync(outputPath, JSON.stringify(cleanData, null, 2));
        console.log(`💾 Erfolgreich gespeichert: ${outputPath} (${cleanData.length} Einträge)`);
    } catch (error) {
        console.error(`❌ Fehler bei ${tabName}:`, error.message);
    }
}

async function run() {
    console.log('--- STARTE DATEN-DOWNLOAD (v3.0.3) ---');
    await downloadAndConvert(TABS.villagers, 'villagers');
    await downloadAndConvert(TABS.items, 'items');
    await downloadAndConvert(TABS.recipes, 'recipes');
    console.log('✅ Datenimport vollständig abgeschlossen!\n');
}

run();


Schritt 2: Der Asset-Scraper (download-assets.js)

Im Community-Sheet sind URLs zu hochauflösenden PNGs (gehostet auf dodo.ac oder Nookipedia) hinterlegt. Wenn du deine Seite produktiv hostest, willst du diese Bilder nicht hotlinken (das führt oft zu Ladefehlern oder Blockaden).

Dieses Skript liest deine gerade erstellten JSONs aus, holt sich die Bild-URLs, lädt sie herunter und speichert sie lokal ab. Es benennt die Bilder außerdem nach dem englischen Objektnamen (z.B. antonio.png), damit du sie im Code extrem leicht referenzieren kannst.

Erstelle die Datei scripts/download-assets.js:

import fs from 'fs';
import path from 'path';
import axios from 'axios';

// Helfer für Dateinamen-Sicherheits-Formatierung (z.B. "Agent S" -> "agent_s")
function sanitizeFilename(name) {
    if (!name) return 'unknown';
    return name.toString().toLowerCase()
        .replace(/['"]/g, '') // Entferne Anführungszeichen
        .replace(/[^a-z0-9]/g, '_') // Ersetze Leerzeichen & Sonderzeichen durch Unterstrich
        .replace(/_+/g, '_'); // Verhindere doppelte Unterstriche
}

// Wartet eine kurze Zeit (Verhindert IP-Sperren beim Hoster durch zu schnelles Herunterladen)
const delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function downloadImage(url, folderPath, filename) {
    if (!url || url === 'NA' || url === '') return null;
    
    const extension = path.extname(new URL(url).pathname) || '.png';
    const finalFilename = `${sanitizeFilename(filename)}${extension}`;
    const destination = path.join(folderPath, finalFilename);

    // Bild überspringen, falls es bereits existiert (spart Bandbreite bei wiederholten Runs)
    if (fs.existsSync(destination)) {
        return `assets/${path.relative(path.join(process.cwd(), 'public', 'assets'), destination)}`;
    }

    try {
        const response = await axios({
            method: 'GET',
            url: url,
            responseType: 'stream',
            headers: {
                'User-Agent': 'ACNH-Web-App-Local-Migration-Script (Contact: developer@example.com)'
            }
        });

        fs.mkdirSync(folderPath, { recursive: true });
        const writer = fs.createWriteStream(destination);
        response.data.pipe(writer);

        return new Promise((resolve, reject) => {
            writer.on('finish', () => resolve(`assets/${path.relative(path.join(process.cwd(), 'public', 'assets'), destination)}`));
            writer.on('error', reject);
        });
    } catch (error) {
        console.error(`⚠️ Fehler beim Download von ${url}: ${error.message}`);
        return null;
    }
}

async function scrapeAssets() {
    console.log('--- STARTE ASSET-SCRAPING (BILDER) ---');
    
    // 1. BEWOHNER-ASSETS SCRAPEN (Icons & Fotos)
    const villagersPath = path.join(process.cwd(), 'src', 'data', 'villagers.json');
    if (fs.existsSync(villagersPath)) {
        const villagers = JSON.parse(fs.readFileSync(villagersPath, 'utf8'));
        const targetDir = path.join(process.cwd(), 'public', 'assets', 'villagers');
        
        console.log(`Lade ${villagers.length} Bewohner-Assets herunter...`);
        for (let i = 0; i < villagers.length; i++) {
            const v = villagers[i];
            
            // Das Sheet nutzt für Bewohner-Bilder oft die Spalten 'Icon Image' und 'Photo Image'
            const iconUrl = v['Icon Image'] || v['Icon_Image'];
            if (iconUrl) {
                await downloadImage(iconUrl, targetDir, `${v.Name}_icon`);
            }
            
            const photoUrl = v['Photo Image'] || v['Photo_Image'];
            if (photoUrl) {
                await downloadImage(photoUrl, targetDir, `${v.Name}_photo`);
            }
            
            // Kurze Pause einlegen (50ms), um den Server nicht zu drosseln
            await delay(50);
            if (i % 20 === 0 && i > 0) console.log(`Processed ${i}/${villagers.length} Bewohner...`);
        }
    }

    // 2. MÖBEL- & ITEM-ASSETS SCRAPEN
    const itemsPath = path.join(process.cwd(), 'src', 'data', 'items.json');
    if (fs.existsSync(itemsPath)) {
        const items = JSON.parse(fs.readFileSync(itemsPath, 'utf8'));
        const targetDir = path.join(process.cwd(), 'public', 'assets', 'items');
        
        console.log(`Lade Möbel- und Item-Bilder herunter (Limitierung auf die ersten 100 zum Test)...`);
        // Da die Möbel-Tabelle riesig ist (>3000 Zeilen), kannst du zum Testen 'slice' nutzen.
        // Für den echten Run einfach das ".slice(0, 100)" entfernen.
        const testItems = items.slice(0, 100); 
        
        for (let i = 0; i < testItems.length; i++) {
            const item = testItems[i];
            const imageUrl = item['Image'] || item['Icon Image'];
            if (imageUrl) {
                await downloadImage(imageUrl, targetDir, item.Name);
            }
            await delay(50);
        }
    }

    console.log('✅ Asset-Migration erfolgreich abgeschlossen! Deine Bilder liegen bereit in "public/assets/".');
}

scrapeAssets();


Schritt 3: Ausführen der Pipeline

Installiere die benötigten Pakete in deinem Projektordner:

npm install axios papaparse


Trage in deiner package.json im Bereich "scripts" folgende Befehle ein, um die Synchronisierung jederzeit per Einzeiler zu starten:

"scripts": {
  "db:sync-data": "node scripts/fetch-data.js",
  "db:sync-assets": "node scripts/download-assets.js",
  "db:build-local": "npm run db:sync-data && npm run db:sync-assets"
}


Führe nun einfach aus:

npm run db:build-local


Das Skript lädt erst die vollständigen v3.0.3-Tabellendaten herunter und scannt diese im Anschluss, um alle Bilder lokal in deinem Web-Projekt unter public/assets/ abzuspeichern.

Schritt 4: Nutzung im Code (Einfach & Schnell)

In deinem Web-Code musst du nun keine Web-Anfragen an externe Server mehr stellen. Du kannst die JSON direkt importieren und die Bilder als lokale Pfade referenzieren:

import villagers from '../data/villagers.json';

// Funktion, um einen Bewohner lokal abzufragen (inklusive lokalem Bildpfad)
export function getLocalVillager(germanName) {
    const data = villagers.find(v => v['Translations (German)'] === germanName || v.Name === germanName);
    if (!data) return null;

    const safeName = data.Name.toLowerCase().replace(/[^a-z0-9]/g, '_');

    return {
        name: data['Translations (German)'] || data.Name,
        englishName: data.Name,
        species: data['Translations (German Species)'] || data.Species,
        personality: data['Translations (German Personality)'] || data.Personality,
        birthday: data.Birthday,
        // Lokaler Pfad zu den vorhin heruntergeladenen Bildern in deinem public-Ordner!
        iconUrl: `/assets/villagers/${safeName}_icon.png`,
        photoUrl: `/assets/villagers/${safeName}_photo.png`
    };
}


Um die deutschen Namen vollautomatisch in deine JSON-Dateien zu integrieren, ohne externe APIs (wie Nookipedia) abzufragen, machen wir uns ein kleines Geheimnis der Datamining-Community zunutze: Es gibt ein zweites, offizielles Spreadsheet, das ausschließlich für Übersetzungen gedacht ist.

Hier ist der elegante Weg, wie wir dein fetch-data.js-Skript so anpassen, dass es beim Build-Prozess beide Tabellen lädt, sie anhand des englischen Namens verknüpft (Merge) und die deutschen Namen direkt in deine fertige JSON einfügt.
Schritt 1: Das Übersetzungs-Spreadsheet einbinden

Die ID für das offizielle ACNH-Übersetzungs-Spreadsheet lautet: 1GwUuCKgJC61qWEjWyeG3nVjkHesszRL6XbPA_dHfLoI. Es ist exakt genauso strukturiert wie das Haupt-Sheet (mit Tabs wie "Villagers" und "Housewares").

Wir passen nun die Datei scripts/fetch-data.js an. Anstatt nur einen Request zu senden, feuern wir mit Promise.all gleichzeitig zwei Requests ab (Hauptdaten + Übersetzungen).

Ersetze den Code in deiner fetch-data.js mit dieser Version:
JavaScript

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

Was passiert hier genau?

    Promise.all: Anstatt doppelt so lange zu warten, lädt das Skript die Hauptdatenbank und die Übersetzungsdatenbank für den jeweiligen Tab exakt zeitgleich herunter.

    translationMap: Das Skript baut ein unsichtbares Wörterbuch im Arbeitsspeicher auf. Es sucht in der Übersetzungsdatei nach der Spalte US en (Englisch) und weist ihr den Wert aus EU de (Deutsch) zu.

    Der Merge: Während das Skript deine finale JSON-Datei zusammenbaut, nimmt es den englischen Namen (Name), schlägt ihn in der translationMap nach und erstellt vollautomatisch den Key "Translations (German)".