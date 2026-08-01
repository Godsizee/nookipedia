# Modul-Plan — „Meine Sammlung" (Fang-Tracker für die Faunapädie)

**Stand:** 2026-08-01 · **Status:** ✅ umgesetzt (M1–M4) + Überarbeitung auf Arten-Trennung
und Zeitreise-Tauglichkeit, auf `main`

**Entscheidungen von Basti (2026-08-01):** eigener Nav-Eintrag „Sammlung" · Nordhalbkugel
als Standard · „gefangen" und „gespendet" werden **nicht** getrennt → das reservierte Feld
`donated` ist ersatzlos aus dem Datenmodell gestrichen.

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
| Und der Rest? | Fang-Plan Januar → Dezember, je Art, mit Uhrzeit, Wetter und Fundort |
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
| E2 | **Ein Zustand: „gefangen"** — kein zweiter Zustand, auch nicht reserviert (Basti-Entscheid) | KISS. Zwei Häkchen pro Tier verdoppeln die Reibung. Die Museums-Listen zeigen denselben einen Zustand an. |
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
| `src/lib/sync-code.js` | **Kodierung des Sammlungsstands** als Bitmaske + Fingerprint. Kennt weder Storage noch DOM. |
| `src/components/CaughtBootstrap.astro` | Inline-Skript, das den gefangen-Zustand vor dem ersten Paint setzt (kein Flackern). |
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
| `src/pages/museum/{fische,insekten,meerestiere}.astro` | Gefangene Tiere markiert, Stand pro Ausstellung, Offline-Fallback ergänzt. |
| `src/components/EntityCard.astro` | Optionales `creatureId` → Häkchen-Badge und Anbindung an den Fang-Log. |

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
currentWindowEnd(creature, now)      // → Stunde | null → "noch bis 19:00 Uhr"
nextWindowStart(creature, now)       // → Stunde | null → "ab 16:00 Uhr"
daysLeftInMonth(now)                 // für den Countdown der Dringlichkeitskarten
```

```js
// collection.js — der einzige Ort, der localStorage kennt
isCaught(id) → boolean
toggle(id)   → { caught: boolean, undo: () => void }
stats(creatures, now, hemisphere) → {
  total, caught, byCategory: { fish:{caught,total}, insect:{…}, sea:{…} },
  missingNow: [], laterToday: [], lastChance: [], newThisMonth: [],
  byNextMonth: Map<month, []>, sortedNextMonths: [], missingOther: [],
  matrix: { fish: number[12], insect: number[12], sea: number[12] }
}
subscribe(fn) → unsubscribe · setMany(ids, value) → { changed, undo }
getHemisphere() / setHemisphere('north' | 'south')
```

```js
// sync-code.js — Kodierung, ohne Storage-Zugriff
encode(allIds, caughtIds) → "AC1-<base64url-bitmask>-<fingerprint>"
decode(code, allIds)      → { ok: true, ids } | { ok: false, reason }
```

`stats()` ist bewusst **eine** Funktion, die alle Sichten aus einem Durchlauf ableitet —
kein verstreuter Filter-Code in vier Templates.

---

## 6 · Die Seite `/sammlung/` — Aufbau von oben nach unten

Die Seite ist nach der **Art** gegliedert, nicht nach der Uhrzeit: Fische, Insekten und
Meerestiere werden getrennt geplant, weil sie unterschiedliche Fangbedingungen haben.
Der Fang-Plan läuft immer von **Januar bis Dezember** — die Systemzeit bestimmt nur,
welcher Monat hervorgehoben und aufgeklappt ist.

1. **Hero mit Gesamtfortschritt** — großer Ring, drei Kategorie-Ringe, Hemisphären-Umschalter.
2. **Kategorie-Leiste** (Fische / Insekten / Meerestiere) mit der Anzahl noch fehlender Tiere
   je Art. Sticky, damit sie beim Scrollen erreichbar bleibt; die Auswahl steuert die ganze Seite.
3. **Fang-Plan** *(die Kernsektion)* — zwölf aufklappbare Monatsgruppen, Januar zuerst.
   Jede Zeile eines Tiers nennt **Uhrzeit · Wetter · Fundort** und dazu, was pro Art
   wirklich unterscheidet:
   - **Fische:** Fundort (Meer / Fluss / Teich / Steg / Flussmündung / Fluss-Plateau) + Schattengröße
   - **Insekten:** der konkrete Fundort (an Bäumen, auf Blumen, an Palmen, …) — 24 verschiedene
   - **Meerestiere:** „Beim Tauchen" (die Daten führen keinen Ort), dafür Schatten **und** Tempo

   Ganzjährig verfügbare Tiere tragen ein `ganzjährig`-Kürzel und stehen in jedem Monat, weil
   ein Zeitreisender pro Zielmonat die vollständige Liste braucht. Sortierung innerhalb eines
   Monats: alphabetisch. Zeilen entstehen erst beim Aufklappen — zwölf volle Listen auf einmal
   wären mehrere tausend DOM-Knoten ohne Nutzen.

   **Gefangene ein-/ausblenden** schaltet die Sicht um: standardmäßig zeigt der Plan nur
   Offenes; eingeblendet stehen gefangene Tiere ausgegraut mit Haken dazwischen und der
   Monats-Badge wechselt von „13" auf „13 von 31". Die Einstellung gilt für alle drei Arten
   und überlebt den Reload.
4. **Letzte Chance** und **Gerade fangbar** — die uhrzeitbasierten Sichten für alle, die mit
   dem echten Datum spielen. Beide zeigen nur die aktive Art.
5. **Dein Jahr** — 12 Monate × 3 Arten, Zellenintensität = Anzahl fehlender Tiere. Die aktive
   Zeile ist hervorgehoben, ein Klick auf das Art-Symbol schaltet die Kategorie um.
6. **Daten & Werkzeuge** — Sync-Code kopieren/einlesen, Kategorie-Massenerfassung, Zurücksetzen.

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

## 9 · Inkremente — alle umgesetzt

### M1 · Fundament & Abhaken ✅
- [x] `catch-window.js` extrahiert; `faunapaedie.astro` und `tier/[id].astro` nutzen es
      (die beiden Inline-Kopien der Zeitfenster-Logik sind weg).
- [x] `collection.js` inkl. In-Memory-Fallback und Tab-Sync über das `storage`-Event.
- [x] `CatchToggle` in `CreatureCard` und auf der Detailseite, `collection-ui.js`,
      Toast mit Rückgängig, Meilensteine bei 25/50/75/100 %.
- [x] Segment-Filter „Alle / Fehlend / Gefangen" und Fortschrittszeile in der Faunapädie.

### M2 · Die Seite `/sammlung/` ✅
- [x] Ringe (gesamt + drei Kategorien), „Letzte Chance" mit Countdown, „Jetzt fangbar",
      „Neu diesen Monat" — plus die im Plan noch fehlende Klasse **„Heute noch"**
      (richtiger Monat, falsche Uhrzeit), damit kein fehlendes Tier durchs Raster fällt.
- [x] `stats()` als einzige Ableitungsstelle; Nav- und Footer-Eintrag.

### M3 · Planung über das Jahr ✅
- [x] „Nächste Gelegenheit", nach Nähe sortiert und gruppiert.
- [x] Jahres-Matrix (3 Kategorien × 12 Monate, aktueller Monat hervorgehoben).
- [x] Hemisphären-Umschalter auf `/sammlung/` **und** als Kurz-Umschalter in der
      Faunapädie; wirkt auf Filter, Monatsraster der Karten und den Saison-Planer
      der Detailseite.

### M4 · Teilen & Ausbau ✅
- [x] Sync-Code (`sync-code.js`): 200 Tiere → 43 Zeichen, mit Fingerprint gegen
      Codes aus einem anderen Datenbestand. Code kopieren, Link kopieren, einlesen.
- [x] Import über `#code=` — beim Laden **und** wenn der Link auf einer bereits
      offenen Seite landet (reiner Hash-Wechsel löst kein Laden aus).
- [x] Zurücksetzen mit Rückfrage, Kategorie-Massenerfassung, langer Druck auf die
      Schnellauswahl-Kacheln.
- [x] Museums-Listen (Fische, Insekten, Meerestiere) markieren gefangene Tiere und
      zeigen den Stand pro Ausstellung.

### Überarbeitung nach dem ersten Durchlauf (2026-08-01)

Der erste Wurf war zu sehr auf „jetzt gerade" gebaut. Umgestellt auf:

- **Trennung nach Art** — Fische, Insekten und Meerestiere haben eine eigene Kategorie-Leiste
  und je eigene Angaben (s. §6.3). Alle Sektionen der Seite folgen der gewählten Art.
- **Zeitreise-tauglich** — der Fang-Plan läuft stur Januar → Dezember, unabhängig von der
  Systemzeit, mit Uhrzeit, Wetter und Fundort an jedem Tier. Wer die Datums-Synchro der
  Switch abgeschaltet hat, springt damit gezielt auf Monat und Stunde.
- **Ersetzt** wurden dadurch die Sektionen „Heute noch", „Neu diesen Monat" und
  „Nächste Gelegenheit" — der Monatsplan beantwortet dieselben Fragen vollständiger.
- **Gefangene ein-/ausblenden** als Umschalter im Plan (Wunsch aus dem Review).

### Abweichungen vom ursprünglichen Plan

- **„Heute noch" ergänzt** — ohne diesen Bucket wären fehlende Tiere unsichtbar
  gewesen, die zwar diesen Monat da sind, aber gerade außerhalb ihrer Uhrzeit.
- **`donated` gestrichen** statt reserviert (Basti-Entscheid E2).
- **Museums-Seiten bekamen den Offline-Fallback** (`creaturesFallback`), den die
  übrigen Seiten schon hatten — ohne ihn sind die Listen bei nicht erreichbarem
  Backend leer, und damit wäre auch die neue Markierung wirkungslos.

### Prüfstand

- `src/lib/catch-window.js` gegen alle 20 im Datenbestand vorkommenden Zeitstrings
  sowie Fenstergrenzen, Mitternachtsüberlauf und Hemisphären-Verschiebung geprüft.
- `stats()`: jedes fehlende Tier liegt in genau einem Bucket (103 + 44 + 53 = 200
  bei leerem Log), Zeitstrahl-Gruppen nie im aktuellen Monat.
- `sync-code.js`: Round-Trip, leerer und voller Stand, Ablehnung von Müll, falschem
  Präfix, falschem Fingerprint, fremdem Datenbestand und abgeschnittenem Payload.
- Browser-Durchlauf (Chromium, 420 px und 1280 px): Abhaken, Zähler, Filter,
  Rückgängig, Persistenz über Reload ohne Flackern, Hemisphären-Verschiebung auf
  Karte und Detailseite, alle Sektionen, Massenerfassung, Sync-Code zwischen zwei
  getrennten Browser-Profilen, Museums-Markierung, langer Druck, kein
  horizontaler Überlauf, keine JS-Fehler.

## 10 · Ausdrücklich nicht geplant

- **Kein Benutzerkonto / kein serverseitiges Speichern.** Widerspricht E1 und würde den
  aktuellen Sicherheits- und Deploy-Stand (statisches `dist/`) aufreißen.
- **Kein Tracking für Fossilien, Kunstwerke, Items, Bewohner.** Erst wenn das Fauna-Modul
  im Alltag trägt — die Architektur (`collection.js` mit ID-Mengen) ist dafür offen.
- **Kein „gespendet"-Zweitzustand in v1** (E2).
- **Keine Push-Erinnerungen** („dein Tier verschwindet morgen"). Braucht Service-Worker-
  Notifications + Permission-Prompt = Reibung, gegen die Modul-Prämisse.

---

## 11 · Geklärte Punkte

1. **Einstiegspunkt:** eigener Nav-Eintrag „Sammlung" ✅ — die Bottom-Bar trägt jetzt
   acht Einträge und scrollt auf schmalen Phones horizontal; der aktive Eintrag wird
   beim Laden in den sichtbaren Bereich geholt.
2. **Hemisphäre:** Nord ist Standard ✅ — der Umschalter existiert trotzdem
   (`/sammlung/` und Faunapädie), kostet als reine Rechenregel nichts.
3. **Museum:** keine Trennung „gefangen / gespendet" ✅ — `donated` ist gestrichen,
   die Museums-Listen zeigen denselben einen Zustand.

## 12 · Was als Nächstes sinnvoll wäre

- Tracking auf Fossilien, Kunstwerke und Bewohner ausweiten — `collection.js` ist mit
  ID-Mengen dafür offen, braucht aber einen zweiten Namensraum pro Domäne.
- Automatisierte Tests dauerhaft im Repo verankern: die Prüfskripte aus §9 laufen
  bisher nur ad hoc (kein Test-Runner im Projekt).
- Sync-Code als QR-Code anzeigen — Handy↔PC ohne Tippen.
