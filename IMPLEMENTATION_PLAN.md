# Implementation Plan — Nookipedia (Stand 2026-07-02)

Verpflichtender, inkrementeller Plan aus dem Voll-Audit (Performance · Layout/Design ·
Sicherheit · Funktionen · Inkonsistenzen). Reihenfolge = Priorität. Jedes Inkrement ist
einzeln shipbar; ein Inkrement gilt erst als fertig, wenn sein Akzeptanzkriterium erfüllt ist.

**Deploy-Kontext:** Docker → nginx serviert nur `dist/` (statisch). Die Legacy-PHP-App
(`app/`, `views/`, `public/index.php`) läuft in Produktion NICHT — sie ist totes Gewicht
mit Sicherheits-Nebenwirkungen.

---

## P0 · Sicherheits-Notfall (SOFORT, ~1–2 h)

Das GitHub-Repo `Godsizee/nookipedia` ist **öffentlich** und enthält in `HEAD` und in der
Historie echte Zugangsdaten: `.env` (DB-Passwort, `ADMIN_USER`/`ADMIN_PASS`, interne
DB-IP) ist getrackt, und `code_parts/combined_code_part_1.txt` enthält die komplette
`.env` noch einmal im Klartext. `.env` wurde in der Historie bereits 2× gelöscht und
wieder eingecheckt — Löschen allein reicht nicht.

- [ ] **0.1 Repo sofort privat schalten** (GitHub → Settings → Danger Zone).
      *Akzeptanz:* `https://github.com/Godsizee/nookipedia` liefert anonym 404.
- [ ] **0.2 Alle Credentials rotieren** — gilt als kompromittiert:
      Postgres-Passwort (`n8n_user`), Admin-Login der PHP-App, vorsorglich den
      Directus-Schreibtoken und das Directus-Admin-Passwort.
      *Akzeptanz:* alte Werte funktionieren nachweislich nicht mehr.
- [ ] **0.3 Secrets & Datenmüll aus dem Tracking nehmen:** `.env`,
      `.env.production`, `code_parts/`, `dump-nookipedia_db-*.sql`, `db-init/data.dump`,
      `directus_snapshot.json`, `build_log*.txt`, `scripts/.cache/` →
      `git rm --cached` + `.gitignore` erweitern (`.env`, `*.sql`, `*.dump`,
      `build_log*`, `scripts/.cache/`, `code_parts/`).
      *Akzeptanz:* `git ls-files | grep -Ei "env|dump|sql|log|cache|code_parts"` leer
      (bis auf gewollte Dateien wie `db-setup.sql`, falls benötigt — vorher auf Secrets prüfen).
- [ ] **0.4 Historie bereinigen:** Da die Commit-Historie kaum Wert trägt (Messages „1"),
      ist der KISS-Weg: neues Repo-Init mit einem sauberen Initial-Commit und Force-Push
      (Alternative: `git filter-repo`). Erst NACH 0.2 (Rotation), sonst Wettlauf.
      *Akzeptanz:* `git log --all -S "DB_PASS" --oneline` liefert nichts.
- [ ] **0.5 Beispiel-Env anlegen:** `.env.example` ohne Werte, README-Hinweis.

## P1 · Deployment-Härtung & Quick Wins (~2–4 h)

- [ ] **1.1 Eigene `nginx.conf` ins Image** (Dockerfile-Kommentar verspricht sie bereits,
      kopiert wird aber keine): gzip an (text/html/css/js/json/svg),
      `/_astro/*` → `Cache-Control: public, max-age=31536000, immutable`,
      HTML → `no-cache`, `error_page 404 /404.html;`, Security-Header
      (`X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`,
      `X-Frame-Options: SAMEORIGIN`). CSP erst später (inline-Skripte/`onerror` im Markup).
      *Akzeptanz:* `curl -I` zeigt Header; 404-URL rendert die Astro-404-Seite;
      Antworten sind gzip-komprimiert (`/katalog/` 3,7 MB → ~350 KB über die Leitung).
- [ ] **1.2 PHP-Artefakte aus `public/` entfernen:** `public/index.php` und
      `public/.htaccess` fliegen aus dem Astro-`public/` (nginx führt kein PHP aus →
      aktuell ist `https://…/index.php` ein Quelltext-Download; `.htaccess` ist unter
      nginx wirkungslos).
      *Akzeptanz:* `dist/` enthält nach Build kein `.php`/`.htaccess` mehr.
- [ ] **1.3 `.dockerignore` anlegen** (`node_modules`, `dist`, `.git`, `*.sql`, `*.dump`,
      `build_log*`, `code_parts`, `scripts/.cache`) und im Dockerfile `npm ci` statt
      `npm install`.
      *Akzeptanz:* Build-Context < 100 MB, reproduzierbarer Build.
- [ ] **1.4 Viewport-Meta reparieren** (`Layout.astro`): `maximum-scale=1.0,
      user-scalable=no` entfernen — blockiert Pinch-Zoom (WCAG 1.4.4) und konterkariert
      die eigene Kunst-Lightbox („Zum Vergrößern tippen").
      *Akzeptanz:* Pinch-Zoom auf Mobilgerät möglich.
- [ ] **1.5 XSS-Fix `suche.astro`:** Ergebniskarten werden per `innerHTML` mit
      un-escaptem `title`/`subtitle` aus dem Suchindex gebaut (DB-Inhalt = Stored-XSS-
      Fläche). Auf DOM-API/`textContent` umstellen — exakt wie `SearchIsland.astro` es
      bereits vormacht (Inkonsistenz zwischen beiden Suchen beseitigen).
      *Akzeptanz:* Eintrag mit `<img onerror>`-Namen im Index rendert als Text.

## P2 · Frictionless Performance (~1–2 Tage, einzeln shipbar)

- [ ] **2.1 Fonts selbst hosten** (Fredoka + Nunito via `@fontsource`, nur genutzte
      Gewichte, woff2, `font-display: swap`). Entfernt Google-Fonts-Request
      (Latenz, Offline, DSGVO — deutsches Publikum!).
      *Akzeptanz:* keine Requests an `fonts.googleapis.com`/`gstatic.com`.
- [ ] **2.2 Suchindex verschlanken:** `search-index.json` ist 1,2 MB und wird beim ersten
      Tippen im Spotlight geladen. Maßnahmen: Feldnamen kürzen (`t,s,y,u,i`),
      Bild-URLs auf UUID/Kurzform reduzieren (Auflösung erst im Client),
      optional Split „Spotlight-Light-Index" (Titel+URL+Typ) vs. Volltextseite.
      Ziel: < 400 KB unkomprimiert.
      *Akzeptanz:* Dateigröße gemessen; Spotlight funktioniert unverändert.
- [ ] **2.3 `/katalog/` aufteilen:** 3,7 MB HTML / 5.569 Karten in einer Seite ist der
      größte Mobile-Bremser (DOM-Parse + Memory). Pro Kategorie eine Unterseite
      (`/katalog/<kategorie>/`), Übersicht = 23 Kategorie-Kacheln (Accent-System nutzen).
      Zwischeninkrement, falls schneller Bedarf: `content-visibility: auto;
      contain-intrinsic-size` auf `.cat-items`.
      *Akzeptanz:* größte Katalog-HTML < 600 KB; Kategorie-Suche führt weiterhin zum Ziel
      (Suchfeld auf Übersicht kann auf den 2.2-Index umgestellt werden).
- [ ] **2.4 `/rezepte` (1,9 MB) und `/faunapaedie` (0,9 MB) entlasten:** gleiche Strategie
      — Tabs in eigene Seiten (`/rezepte/basteln/`, `/rezepte/kochen/`) oder
      `content-visibility: auto` je Gruppe.
      *Akzeptanz:* je Seite < 600 KB HTML.
- [ ] **2.5 Directus-Bild-Transformationen in `getImageUrl`:** Für UUID-Assets Query
      `?width=<n>&format=webp&quality=80` anhängen (Karten ~160 px, Detail ~640 px,
      Lightbox Original). Zusätzlich `width`/`height`-Attribute auf Karten-`<img>` gegen CLS.
      *Akzeptanz:* Netzwerk-Tab zeigt webp in Kartengröße; Lighthouse-CLS ≈ 0.
- [ ] **2.6 Suchergebnisseite begrenzen:** `/suche` rendert aktuell ALLE Treffer
      (bei „a" tausende Karten). Auf 50 begrenzen + „Mehr anzeigen"-Button.
      *Akzeptanz:* Suche nach „a" bleibt flüssig (< 100 DOM-Karten initial).
- [ ] **2.7 Tote Dependencies entfernen:** kein einziges `client:`-Island im Projekt →
      `@astrojs/react`, `react`, `react-dom` raus (inkl. `react()`-Integration);
      `axios` wird in `src/` nicht genutzt (nur ggf. in `scripts/` — prüfen, sonst raus).
      *Akzeptanz:* Build grün, `dist/_astro/` ohne React-Client-Bundle (~139 KB).

## P3 · SEO & Auffindbarkeit (~0,5–1 Tag)

- [ ] **3.1 `site` + Sitemap + robots.txt:** `astro.config.mjs` →
      `site: 'https://acnh.godsize.info'`, `@astrojs/sitemap`-Integration,
      `public/robots.txt` (Allow all + Sitemap-Verweis).
      *Akzeptanz:* `dist/sitemap-index.xml` existiert und listet die ~7,6k Seiten.
- [ ] **3.2 Meta-Grundausstattung in `Layout.astro`:** `description`-Prop (Pflicht mit
      Default), `<link rel="canonical">`, OpenGraph/Twitter-Tags (Titel, Beschreibung,
      Bild — Detailseiten reichen ihr Entity-Bild durch).
      *Akzeptanz:* Detailseite (z. B. `/tier/1/`) hat einzigartige description + og:image.
- [ ] **3.3 NPC-URLs sluggen:** `[name].astro` nutzt rohe Namen → URLs wie
      `/museum/npc/dj k.k.` (Leerzeichen, Punkte, Umlaute). Ordner mit Punkt am Ende
      (`dj k.k.`, `k.k.`) sind unter Windows defekt und werfen bereits Build-/FS-Fehler.
      Slug-Helfer in `format.js` (lowercase, Umlaute transliterieren, `[^a-z0-9]+`→`-`)
      + interne Links anpassen.
      *Akzeptanz:* `dist/museum/npc/` enthält nur `[a-z0-9-]`-Ordner; keine
      FS-Enumerationsfehler mehr.
- [ ] **3.4 Link-Konsistenz:** Trailing-Slash vereinheitlichen (`/rezepte` → `/rezepte/`
      in Footer + Home-Kachel); `theme_color` Manifest (#1a5c3e) vs. Brand-Grün
      (#58b37b) bewusst entscheiden und angleichen.
      *Akzeptanz:* interne Links lösen ohne Redirect auf.

## P4 · PWA-Entscheid (bewusst nach P2)

- [ ] **4.1 PWA ist aktuell tot konfiguriert:** `VitePWA` steht im `integrations`-Array
      (Astro-Integrationen ≠ Vite-Plugins) → es wird **kein Service Worker** gebaut;
      die gesamte Workbox-Config inkl. Runtime-Caching ist wirkungslos, `manifest.json`
      wird parallel von Hand gepflegt (Duplikat). Entscheidung:
      **(a) Richtig aktivieren** via `@vite-pwa/astro` — dann zwingend: HTML aus dem
      Precache ausschließen (7,6k Seiten!), nur Shell + Assets precachen,
      Runtime-Caching für Directus-Bilder (Config existiert schon) und
      `navigateFallback` auf eine Offline-Seite; **oder (b) rückbauen** —
      `vite-plugin-pwa`/`workbox-*` deinstallieren, nur A2HS-Manifest behalten.
      Empfehlung: (a) — echter Offline-Nutzen für Spieler unterwegs, Infrastruktur
      (statischer Build, gecachte Bilder) ist dafür ideal.
      *Akzeptanz (a):* `dist/sw.js` existiert, Precache < 5 MB, Offline-Reload einer
      besuchten Seite funktioniert. *(b):* keine PWA-Reste in config/package.json.

## P5 · Daten & Funktionen (fortlaufend)

- [ ] **5.1 839 Varianten ohne Bild nachladen:** acnhcdn ist auf Spielversion 2.0
      eingefroren (3.0-Items → 404). Nachlade-Skript gegen die Nookipedia-API
      (kostenloser Key) für alle `item_variants` mit `image_path=null`.
      *Akzeptanz:* `item_variants?filter[image_path][_null]=true` → 0 (bzw. Restliste
      dokumentiert).
- [ ] **5.2 `artworks`-Dualstruktur in Directus bereinigen** (43 Display- vs. 24
      Metadaten-Zeilen): `name_en` auf Display-Zeilen backfillen, Metadaten-Zeilen
      entfernen; danach Frontend-Overrides (`FORGERY_TELL_DE`/`REAL_WORLD_NAME_DE`)
      optional in die DB zurückschreiben.
      *Akzeptanz:* `getArtworks` liefert 100 % deutsche Tells ohne Override-Map.
- [ ] **5.3 Fossil-Suchtreffer verlinken ins Leere-Detail:** Spotlight-Einträge für
      Fossilien zeigen nur auf `/museum/fossilien` (ohne Anker). `id`-Anker je
      Fossil-Karte + Anker in `search-index.json.js`.
      *Akzeptanz:* Klick auf Fossil-Treffer scrollt zur richtigen Karte.
- [ ] **5.4 Legacy-PHP-Stack entfernen:** `app/`, `views/`, `config/`, `db-init/`,
      Dumps, `zusammenfassung.ps1`, `creatures 20260526-*.json` — nach P0-Neuaufsatz
      als Archiv-Branch/Zip sichern, aus `main` löschen. Ebenso ungenutzte
      Legacy-Assets `public/assets/css/themes.css`, `public/assets/js/{theme-switch,
      faunapedia,events,search}.js` (in `src/` nirgends referenziert).
      *Akzeptanz:* `main` enthält nur Astro-App + `scripts/` + Doku; Build grün.
- [ ] **5.5 Lokale Bild-Redundanz ausmisten (51 MB in `public/`, davon 39 MB `diy/`):**
      Alle DB-Bildfelder sind seit 2026-06-22 Directus-UUIDs; lokale Ordner sind
      Alt-Quellen. VOR dem Löschen je Ordner prüfen, was Fallback-/UI-relevant ist:
      behalten → `home/`, `koeder.png`, `placeholder.png`, Wetter-Icons,
      `flowers/TLDR/` (Infografik), `faunapedia/` (Pfade im gebündelten
      `creatures.json`-Fallback), `museum/` (NPC-Fallbacks). Löschkandidat: `diy/`.
      *Akzeptanz:* Build + Offline-Fallback-Build (Backend blockiert) zeigen keine
      kaputten Bilder; `dist/` ≤ ~120 MB.
- [ ] **5.6 `Todo.md` aktualisieren** (Villager-Punkte sind erledigt/überholt) bzw. in
      diesen Plan überführen.

---

## Ausdrücklich NICHT geplant (bewusste Entscheidung)

- Suche durch Fuzzy-Engine (fuse.js o. ä.) ersetzen — erst nach 2.2/2.6 bewerten (KISS).
- CSP mit Nonces — erst sinnvoll, wenn Inline-`onerror`-Handler und `is:inline`-Skripte
  konsolidiert sind (separates Refactoring, geringer Ertrag solange Seite rein statisch).
- Framework-Wechsel/SSR — statischer Build ist genau richtig für dieses Projekt.

## Positiv-Befunde (nicht anfassen)

- Design-System (`main.css`): saubere `@layer`-Architektur, Accent-Kontexte (Open-Closed),
  Dark-Mode, `:focus-visible`, `prefers-reduced-motion` — solide.
- Datenschicht (`api.js`): resilientes Soft-Fail-Muster mit Fallbacks, klare SRP.
- `loading="lazy"` auf allen Karten-Grids vorhanden; Lightbox mit Escape/Klick-Schließen.
- Suche läuft same-origin über Build-Zeit-Index (keine CORS-/Downtime-Abhängigkeit).
