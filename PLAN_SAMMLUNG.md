# Modul-Plan — „Meine Sammlung" (Fang-Tracker für die Faunapädie)

**Stand:** 2026-08-01 · **Branch:** `claude/nookipedia-fauna-tracker-3ik8lw` · **Status:** geplant, nicht implementiert

Ziel: In der Faunapädie ankreuzen, welche Tiere schon gefangen sind — und daraus
automatisch die Antwort auf die einzige Frage bekommen, die im Spiel wirklich zählt:
**„Was fehlt mir noch, und wann kriege ich es?"**

---

## 1 · Nutzenversprechen

Der Datenbestand (200 Kreaturen: 80 Fische, 80 Insekten, 40 Meerestiere) enthält bereits
alles, was für eine echte Fang-Planung nötig ist: Monate (`months_northern`) und
Zeitfenster (`time_active`). Bisher wird das nur als Filter genutzt. Aus „gefangen ja/nein"
+ diesen Feldern entsteht ohne eine einzige neue Datenquelle:

| Frage des Spielers | Antwort des Moduls |
|---|---|
| Wie weit bin ich? | Fortschritt gesamt + pro Kategorie (z. B. 137/200) |
| Was kann ich **jetzt sofort** fangen? | Fehlende Tiere, gefiltert auf Monat **und** aktuelle Stunde |
| Was ist **dringend**? | „Letzte Chance" — fehlt mir und verschwindet Ende des Monats |
| Was ist **neu**? | Seit Monatsanfang erstmals wieder verfügbar |
| Und der Rest? | Zeitstrahl „nächste Gelegenheit": ab welchem Monat wieder fangbar |
| Wann lohnt sich Grind? | Jahres-Matrix: wie viele fehlende Tiere pro Monat verfügbar sind |

Zahlen aus dem echten Datenbestand für August (belegt die Relevanz der „Letzte Chance"-
Sektion): 147 Kreaturen im August verfügbar, **29 verschwinden Ende August**, 7 sind neu
dazugekommen. Im September verschwinden sogar 48. Genau diese 29 bzw. 48 Karten sind das
Herz des Moduls — alles andere ist Beiwerk.

**Wow-Effekt = Dringlichkeit sichtbar machen**, nicht noch eine Häkchenliste.

---

## 2 · Kernentscheidungen (bewusst, vorab)

| # | Entscheidung | Begründung |
|---|---|---|
| E1 | **Rein clientseitig**, `localStorage`, kein Login, kein Backend-Schreibpfad | Frictionless: Häkchen ohne Account. Directus bleibt read-only, kein neuer Angriffs-/Wartungspfad, funktioniert offline in der PWA. |
| E2 | **Ein Zustand: „gefangen"** (Feld `donated` im Schema reserviert, UI später) | KISS. Zwei Häkchen pro Tier (gefangen/gespendet) verdoppeln die Reibung; der Museums-Aspekt kommt als Ausbaustufe, ohne späteres Datenmigrations-Problem. |
| E3 | **Südhalbkugel = Nordhalbkugel + 6 Monate** (berechnet, nicht gespeichert) | Entspricht exakt der ACNH-Regel; Zeitfenster sind hemisphärenunabhängig. Spart ein Backend-Feld (`months_southern` existiert heute nicht). |
| E4 | **Sync per Code statt per Konto** | 200 Tiere = 200 Bits = ~34 Zeichen Base64URL. Handy↔PC teilen per Link/QR, ohne Server. |
| E5 | **Zeitlogik in ein eigenes Modul extrahieren** (`catch-window.js`) | Die Fensterlogik liegt heute dupliziert inline in `faunapaedie.astro` und `tier/[id].astro`. Das Modul braucht sie ein drittes Mal — jetzt ist der richtige Moment für eine Single Source of Truth. |
| E6 | **Keine neue Route-Ebene**: eine Seite `/sammlung/`, Toggles direkt in bestehenden Karten | Das Modul ist eine Sicht auf vorhandene Daten, kein eigener Bereich mit Unterseiten. |

---

## 3 · Datenmodell

```jsonc
// localStorage-Key: "nook_collection_v1"
{
  "v": 1,
  "hemisphere": "north",        // "north" | "south"
  "caught":   [1, 4, 17, 88],   // Kreatur-IDs, aufsteigend
  "donated":  [],               // reserviert (E2), heute immer leer
  "updated":  "2026-08-01T09:12:00.000Z"
}
```

- **Schlüssel = Kreatur-`id`** (stabil aus der DB). Der Sync-Code trägt zusätzlich einen
  4-Zeichen-Hash über die sortierte ID-Liste des Datenbestands; passt er beim Import nicht,
  wird gewarnt statt still falsch importiert.
- **Kein Schreiben nach Directus.** Wer mehrere Geräte will, nutzt den Sync-Code (E4).
- **Migration:** Key ist versioniert (`_v1`). Ein späteres `_v2` liest `_v1` und schreibt um.

---

## 4 · Dateien

### Neu

| Datei | Verantwortung (SRP) |
|---|---|
| `src/lib/catch-window.js` | **Pure Zeitlogik**, keine DOM-/Storage-Berührung: `parseWindows`, `isActiveAtHour`, `monthsFor(creature, hemisphere)`, `isCatchableNow`, `isLastChance`, `isNewThisMonth`, `nextAvailability`, `hoursLeftToday`, `daysLeftInMonth`. Import-fähig aus Astro-Frontmatter **und** aus dem Browser-Bundle. |
| `src/lib/collection.js` | **Client-Store**: `load`, `isCaught`, `toggle`, `setHemisphere`, `stats`, `subscribe`, `exportCode`, `importCode`, `reset`. Kapselt `localStorage` komplett (inkl. Fallback, s. §8). Pub/Sub, damit Karten, Zähler und Ringe ohne Re-Render synchron bleiben. |
| `src/components/CatchToggle.astro` | Ein Button pro Karte („Gefangen"-Häkchen), rein Markup + `data-creature-id`. Kein eigenes JS. |
| `src/components/ProgressRing.astro` | SVG-Ring mit Prozentwert, akzentgefärbt (`--accent`), animierbar über `stroke-dashoffset`. |
| `src/scripts/collection-ui.js` | Bindeglied: hängt Klick-Handler an alle `[data-creature-id]`, spiegelt den Store in CSS-Klassen (`.is-caught`), aktualisiert Zähler/Ringe, zeigt Undo-Toast. Wird von den Seiten per gebündeltem `<script>` importiert. |
| `src/pages/sammlung.astro` | Die neue Seite (§6). |

### Geändert

| Datei | Änderung |
|---|---|
| `src/components/CreatureCard.astro` | `<CatchToggle>` + `data-creature-id` ergänzen; sonst unverändert. |
| `src/pages/faunapaedie.astro` | Zwei Filter-Chips „🎯 Nur fehlende" / „✅ Nur gefangene"; Fortschrittsleiste über der Tab-Rail; Zeitlogik-Duplikate durch Import aus `catch-window.js` ersetzen. |
| `src/pages/tier/[id].astro` | Großer „Gefangen"-Button im Hero; lokale `getImageUrl`-Kopie nebenbei durch `format.js` ersetzen (bestehende Inkonsistenz). |
| `src/layouts/Layout.astro` | Nav-Eintrag `{ href:'/sammlung/', emoji:'🎣', label:'Sammlung', short:'Sammlung', match:['/sammlung'] }` + Footer-Link. |
| `src/components/BottomTabBar.astro` | Achter Eintrag → auf schmalen Phones horizontal scrollbar machen (`overflow-x:auto`, `scroll-snap`), statt Labels zu kürzen. |
| `src/styles/main.css` | Neuer Akzent `.accent-collection`; Komponenten: `.is-caught`-Zustand, `.catch-toggle`, `.progress-ring`, `.urgency-card`, `.year-matrix`, `.toast`. |
| `src/pages/museum/*.astro` | Optional in M4: gefangene Tiere in den Museums-Listen markieren (nur Anzeige, gleicher Store). |

---

## 5 · Modul-API (Vertrag, bevor Code entsteht)

```js
// catch-window.js — pure, testbar, ohne Seiteneffekte
monthsFor(creature, hemisphere)      // → [1..12], Süd = (m+5)%12+1
isActiveAtHour(timeStr, hour)        // "09:00 – 16:00 & 21:00 – 04:00" | "Ganztägig (Regen)"
isCatchableNow(creature, now, hemi)  // Monat ∧ Stunde
isLastChance(creature, now, hemi)    // verfügbar diesen Monat, nicht nächsten
isNewThisMonth(creature, now, hemi)  // verfügbar diesen Monat, nicht letzten
nextAvailability(creature, now, hemi)// → { month, monthsAway } | null (wenn ganzjährig)
hoursLeftToday(creature, now)        // → Zahl | null (bei Ganztägig)
daysLeftInMonth(now)                 // für den Countdown der Dringlichkeitskarten
```

```js
// collection.js — der einzige Ort, der localStorage kennt
isCaught(id) → boolean
toggle(id)   → { caught: boolean, undo: () => void }
stats(creatures, now, hemisphere) → {
  total, caught, byCategory: { fish:{caught,total}, insect:{…}, sea:{…} },
  missingNow: [], lastChance: [], newThisMonth: [], byNextMonth: Map<month, []>,
  perMonthMissing: number[12]          // Futter für die Jahres-Matrix
}
subscribe(fn) → unsubscribe
exportCode() → "AC1-<base64url-bitmask>-<hash4>"
importCode(code) → { ok, added, skipped, reason? }
```

`stats()` ist bewusst **eine** Funktion, die alle Sichten aus einem Durchlauf ableitet —
kein verstreuter Filter-Code in vier Templates.

---

## 6 · Die Seite `/sammlung/` — Aufbau von oben nach unten

1. **Hero mit Gesamtfortschritt** — großer Ring „137 / 200", darunter drei kleine Ringe
   (🐟 / 🦋 / 🐙) in ihren Kategorie-Akzenten. Hemisphären-Umschalter Nord/Süd rechts.
2. **⏳ Letzte Chance im August** *(die Kernsektion)* — nur fehlende Tiere, die Ende des
   Monats verschwinden. Kopfzeile mit Countdown „noch 30 Tage". Karten zeigen zusätzlich
   „heute noch bis 19:00 Uhr" bzw. „läuft gerade". Leer = grüne Erfolgsmeldung statt leerer Kasten.
3. **🎯 Jetzt fangbar** — fehlend ∧ Monat ∧ aktuelle Stunde. Aktualisiert sich per
   `setInterval` zur vollen Stunde (kein Reload nötig).
4. **🆕 Neu diesen Monat** — fehlend ∧ erst seit diesem Monat wieder da.
5. **📅 Nächste Gelegenheit** — restliche fehlende Tiere, gruppiert nach dem Monat ihres
   nächsten Auftauchens („Ab September (12)", „Ab November (5)"), Gruppen eingeklappt.
6. **🗓️ Jahres-Matrix** — 12 Spalten × 3 Kategorie-Zeilen, Zellenintensität = Anzahl noch
   fehlender Tiere in diesem Monat. Klick auf eine Zelle filtert Sektion 5. Zeigt auf einen
   Blick, welcher Monat der Grind-Monat wird.
7. **⚙️ Daten** — Sync-Code kopieren/einfügen, „Alles zurücksetzen" (mit Bestätigung),
   Hinweis, dass die Daten lokal im Browser liegen.

Alle Sektionen sind **fehlend-zentriert**: Was schon gefangen ist, verschwindet aus dem
Blickfeld. Das ist der Unterschied zu einer Checkliste.

---

## 7 · Interaktion & Feinschliff (das „frictionless")

- **Ein Tap, kein Dialog.** Häkchen sofort, Karte klappt beim nächsten Filterlauf weg,
  Toast „Abendzikade eingetragen · Rückgängig" (5 s). Kein Bestätigen, kein Speichern-Button.
- **Kein Flackern.** Der gefangen-Zustand wird von einem `is:inline`-Bootstrap direkt nach
  dem Grid gesetzt, also vor dem ersten Paint — analog zum bestehenden Anti-FOUC-Theme-Skript.
- **Tastatur & A11y.** Toggle ist ein `<button aria-pressed>`, 44 px Trefferfläche
  (Projekt-Standard aus `main.css`), Statusänderung per `aria-live` angesagt.
- **View Transitions.** Initialisierung an `astro:page-load` gehängt (Store bleibt bestehen,
  Handler werden idempotent gesetzt — Muster wie beim Theme-Toggle).
- **Meilensteine statt Konfetti-Spam.** Feedback nur bei 25/50/75/100 % einer Kategorie und
  beim Leerlaufen der „Letzte Chance"-Liste. `prefers-reduced-motion` wird respektiert.
- **Long-press auf die Mini-Grid-Kacheln** togglet ebenfalls — Massenerfassung beim
  Ersteinrichten geht so in Sekunden statt Minuten.
- **Ersteinrichtung**: Hinweiszeile „Schon alles gefangen? Kategorie komplett abhaken" mit
  einem Klick pro Kategorie — danach nur noch das Fehlende abwählen.

---

## 8 · Randfälle & Risiken

| Fall | Umgang |
|---|---|
| `localStorage` gesperrt (Privatmodus, iOS-Sonderfälle) | `collection.js` fällt auf In-Memory zurück, UI funktioniert, einmaliger Hinweis „wird nicht dauerhaft gespeichert". Kein Absturz. |
| `time_active` in 20 Varianten inkl. `"Ganztägig (Regen)"`, Doppelfenster `"09:00 – 16:00 & 21:00 – 04:00"`, Mitternachtsüberlauf `"17:00 – 04:00"` | `parseWindows` deckt alle 20 im Datenbestand vorkommenden Werte ab; Unbekanntes → „ganztägig" (fail-open, nie fälschlich „nicht fangbar"). Unit-Tests über genau diese 20 Strings. |
| 38 Kreaturen sind ganzjährig | `nextAvailability` → `null`, landen nie in „Letzte Chance" oder im Zeitstrahl. |
| IDs ändern sich bei einem Re-Sync der DB | Hash im Sync-Code erkennt es beim Import; lokal bleibt der Bestand gültig, da IDs aus derselben Quelle stammen. Risiko benannt, nicht wegdefiniert. |
| Uhr des Nutzers ≠ Spielzeit (Zeitreisen) | Bewusst ignoriert: Gerätezeit ist die Wahrheit. Der bestehende Fang-Planer erlaubt weiterhin freie Monat/Stunde-Abfragen. |
| Datenverlust beim Browser-Aufräumen | Sync-Code + expliziter Hinweis in §6.7. Ein Backend-Konto ist bewusst nicht Teil dieses Moduls. |
| Achter Nav-Eintrag sprengt die Bottom-Bar | Scrollbare Tab-Bar (§4) statt Label-Kürzung; auf Desktop ist Platz. |

---

## 9 · Inkremente (jedes einzeln shipbar)

### M1 · Fundament & Abhaken *(~3–4 h)*
- [ ] `catch-window.js` extrahieren, `faunapaedie.astro` + `tier/[id].astro` darauf umstellen (Verhalten unverändert).
- [ ] `collection.js` inkl. In-Memory-Fallback.
- [ ] `CatchToggle` in `CreatureCard` + Detailseite, `collection-ui.js`, Toast mit Undo.
- [ ] Filter-Chips „Nur fehlende / Nur gefangene" + Fortschrittszeile in der Faunapädie.
- **Akzeptanz:** Häkchen überlebt Reload und Seitenwechsel; kein Flackern beim Laden;
  bestehende Filter/Planer-Funktionen unverändert; `npm run build` grün.

### M2 · Die Seite `/sammlung/` *(~4–5 h)*
- [ ] Seite mit Sektionen 1–4 (Ringe, Letzte Chance, Jetzt fangbar, Neu diesen Monat).
- [ ] `stats()` als einzige Ableitungsstelle; Nav- und Footer-Einträge.
- **Akzeptanz:** Bei 0 Häkchen zeigt „Letzte Chance" im August genau die 29 Tiere, die im
  September fehlen; nach Abhaken verschwinden sie live aus der Liste.

### M3 · Planung über das Jahr *(~3–4 h)*
- [ ] Sektion 5 (nächste Gelegenheit, gruppiert) + Sektion 6 (Jahres-Matrix, klickbar).
- [ ] Hemisphären-Umschalter (E3), wirkt auf alle Sektionen **und** die Faunapädie-Filter.
- **Akzeptanz:** Umschalten auf Süd verschiebt jede Monatsangabe um exakt 6 Monate;
  Summe aller Gruppen + ganzjährige = Anzahl fehlender Tiere.

### M4 · Teilen & Ausbau *(~3 h)*
- [ ] Sync-Code Export/Import inkl. `#code=`-Import-Link, Reset mit Bestätigung.
- [ ] Meilenstein-Feedback, Long-press-Massenerfassung, Museums-Listen markieren.
- **Akzeptanz:** Code aus Browser A in Browser B importiert ergibt identische Statistik;
  manipulierter Code wird abgelehnt statt teilweise importiert.

**Gesamt: ~13–16 h.** M1+M2 allein liefern bereits den vollen Kernnutzen.

---

## 10 · Ausdrücklich nicht geplant

- **Kein Benutzerkonto / kein serverseitiges Speichern.** Widerspricht E1 und würde den
  aktuellen Sicherheits- und Deploy-Stand (statisches `dist/`) aufreißen.
- **Kein Tracking für Fossilien, Kunstwerke, Items, Bewohner.** Erst wenn das Fauna-Modul
  im Alltag trägt — die Architektur (`collection.js` mit ID-Mengen) ist dafür offen.
- **Kein „gespendet"-Zweitzustand in v1** (E2).
- **Keine Push-Erinnerungen** („dein Tier verschwindet morgen"). Braucht Service-Worker-
  Notifications + Permission-Prompt = Reibung, gegen die Modul-Prämisse.

---

## 11 · Offene Punkte für Basti

1. **Einstiegspunkt:** eigener Nav-Eintrag „Sammlung" (Vorschlag) — oder lieber als
   vierter Tab innerhalb der Faunapädie, damit die Navigation bei sieben Einträgen bleibt?
2. **Hemisphäre:** Bist du auf der Nordhalbkugel unterwegs? Wenn ja, kommt der Umschalter
   nach M3 und die Standardeinstellung bleibt Nord.
3. **Museum:** Soll „gefangen" später in „gefangen / gespendet" aufgeteilt werden? Wenn ja,
   bleibt das Feld reserviert (E2) — die Antwort ändert nichts an M1–M3.
