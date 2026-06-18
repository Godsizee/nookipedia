import axios from 'axios';
import Papa from 'papaparse';

const TRANSLATION_SHEET_ID = '1GwUuCKgJC61qWEjWyeG3nVjkHesszRL6XbPA_dHfLoI';

async function run() {
    const url = `https://docs.google.com/spreadsheets/d/${TRANSLATION_SHEET_ID}/gviz/tq?tqx=out:csv&sheet=Events`;
    const res = await axios.get(url);
    const parsed = Papa.parse(res.data, { header: true, skipEmptyLines: true }).data;
    
    parsed.forEach((row, idx) => {
        const keys = Object.keys(row);
        const englishKey = keys.find(k => k.startsWith('English ') || k === 'English');
        const germanKey = keys.find(k => k.startsWith('German ') || k === 'German');
        if (englishKey && germanKey) {
            console.log(`Event ${idx}: "${row[englishKey]}" -> "${row[germanKey]}"`);
        }
    });
}

run();
