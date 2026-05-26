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
