# Nookipedia Migration: Implementation Plan

Dieser Plan unterteilt die restlose Übertragung der verbleibenden PHP-Views aus dem alten Repository in das neue Astro-Projekt in strenge, isolierte Phasen. Jede Phase kann unabhängig von einem KI-Modell (wie Gemini Flash) umgesetzt und getestet werden.

## Phase 1: Museum Hub Update & Fische-Ansicht
**Ziel:** Die Übersichtsseite des Museums aktualisieren und die erste der drei neuen Tier-Kategorien (Fische) implementieren.

**Aufgaben:**
1. **`src/pages/museum.astro` anpassen:**
   - Die Platzhalter/Links für "Fische", "Insekten" und "Meerestiere" aktualisieren, sodass sie auf die neuen `.astro` Routen verweisen.
2. **`src/pages/museum/fische.astro` erstellen:**
   - Referenz: `views/museum/museum-fish.php` im alten Repo.
   - Layout und Design-Muster von `src/pages/museum/fossilien.astro` übernehmen.
   - Fetch-Logik für `/items/fish` via Directus-API einbauen (mit Fallback-Daten, falls API nicht erreichbar).
   - Grid-Ansicht für Fische mit blauem Hero-Banner.

**Verifikation Phase 1:**
- `npm run build` läuft fehlerfrei.
- Klick auf "Fische" im Museum-Hub öffnet die neue Fische-Seite mit geladenen Daten.

---

## Phase 2: Insekten- & Meerestiere-Ansichten
**Ziel:** Die restlichen Tier-Kategorien im Museum vervollständigen.

**Aufgaben:**
1. **`src/pages/museum/insekten.astro` erstellen:**
   - Referenz: `views/museum/museum-insects.php`.
   - Analog zu `fische.astro` aufbauen.
   - Fetch-Logik für `/items/bugs` (oder passender Endpunkt) via Directus-API (mit Fallback-Daten).
   - Grid-Ansicht für Insekten mit grünem Hero-Banner.
2. **`src/pages/museum/meerestiere.astro` erstellen:**
   - Referenz: `views/museum/museum-sea.php`.
   - Analog zu `fische.astro` aufbauen.
   - Fetch-Logik für `/items/sea_creatures` (oder passender Endpunkt) via Directus-API (mit Fallback-Daten).
   - Grid-Ansicht für Meerestiere mit aquamarinem Hero-Banner.

**Verifikation Phase 2:**
- Beide Seiten sind aus dem Museum-Hub erreichbar, haben das korrekte Farb-Thema und laden die jeweiligen Daten/Bilder (oder Fallbacks).

---

## Phase 3: Rezepte (Bastelanleitungen)
**Ziel:** Die Liste der Bastelanleitungen migrieren.

**Aufgaben:**
1. **`src/pages/rezepte.astro` erstellen:**
   - Referenz: `views/recipe-list.php`.
   - Eigenes Layout/Hero-Banner passend zum Thema Basteln (z.B. Werkbank-Icon, Holz-Farbtöne).
   - Fetch-Logik für `/items/recipes` via Directus-API (mit Fallback-Daten).
   - Anzeige der Rezepte in einer Listen- oder Grid-Form (inkl. benötigter Materialien, falls aus API verfügbar).
2. **Navigation anpassen (falls nötig):**
   - Sicherstellen, dass ein Link zu `/rezepte` im Hauptmenü (z.B. in `Layout.astro` oder `Header.astro`) existiert.

**Verifikation Phase 3:**
- `/rezepte` Route rendert eine saubere Auflistung aller Bastelanleitungen.

---

## Phase 4: Error Handling Pages
**Ziel:** Benutzerdefinierte Fehlerseiten im Nookipedia-Design bereitstellen.

**Aufgaben:**
1. **`src/pages/404.astro` erstellen:**
   - Standard 404 (Seite nicht gefunden) Seite erstellen.
   - Animal Crossing typisches Design integrieren (z.B. Resetti-Grafik oder verirrter Gyroid).
   - Button "Zurück zur Startseite" hinzufügen.
2. **`src/pages/500.astro` erstellen:**
   - Standard 500 (Serverfehler) Seite erstellen.
   - Passendes Design und Fehlertext bereitstellen.

**Verifikation Phase 4:**
- Aufruf von z.B. `/gibtesnicht` im Browser zeigt die gestaltete 404-Seite anstatt der Astro-Standard-Seite.
