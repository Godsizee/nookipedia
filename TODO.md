# TODO – Offene Punkte für dich

## 🔴 Kritisch: Secrets in Git

`.env` ist von Git getrackt und liegt mit Klartext-Passwörtern im Verlauf
(`DB_PASS`, `ADMIN_PASS`). Das Repo hat einen echten GitHub-Remote
(`github.com/Godsizee/nookipedia`) — falls es **öffentlich** ist, sind die
Zugangsdaten einsehbar.

- [ ] Prüfen, ob das GitHub-Repo public oder private ist
- [ ] DB-Passwort und Admin-Passwort rotieren (egal ob public/private — sie sind in der Historie)
- [ ] `.env` aus dem Tracking nehmen: `git rm --cached .env`
- [ ] `.env` zur `.gitignore` hinzufügen (aktuell stehen dort nur `.env.local` etc., nicht `.env` selbst)
- [ ] Falls Repo public ist: Historie bereinigen (z. B. `git filter-repo` oder neues Repo ohne alte Historie) — sonst bleiben die alten Passwörter trotzdem abrufbar

## 🟡 Directus-Datenqualität: Kunstwerk-Fälschungstexte

Aktuell zeigen **16 von 27** fälschbaren Kunstwerken den deutschen Hinweis aus
`artwork_forgeries`. Die restlichen 11 fallen auf das (oft ungenaue) Feld
`fake_description` zurück, weil der Join-Schlüssel `name_en` nur auf 24 von 67
Zeilen gepflegt ist.

- [ ] In Directus bei den 43 „Display"-Artwork-Zeilen (mit `name` + `image_real`) das Feld `name_en` befüllen
- [ ] Optional: die 24 redundanten „Metadaten"-Stub-Zeilen (nur `name_de`/`name_en`, ohne Bild) aufräumen/löschen
- Kein Code-Change nötig — der Join in `src/lib/api.js` greift automatisch, sobald die Daten vollständig sind

## 🟡 Manuelles QA im Browser

Ich habe die neuen/umgebauten Seiten nicht live im Browser getestet (nur Build-Verifikation). Bitte einmal durchklicken:

- [ ] `/villager/` — Bewohner-Browser mit Such- und Arten-Filter
- [ ] `/katalog/` — Item-Katalog (jetzt mit echten Live-Daten, da Permissions gefixt sind)
- [ ] `/museum/kunst/` und ein paar Detailseiten — Fälschungs-Toggle, „immer echt"-Badges
- [ ] Hell/Dunkel-Umschalter auf 2–3 Seiten je Bereich (Faunapädie, Blumen, Events, Rezepte)
- [ ] Mobile-Ansicht (Bottom-Nav, Touch-Targets) auf echtem Gerät oder im DevTools-Mobile-Modus
- [ ] PWA-Icons prüfen: `astro.config.mjs` referenziert `/assets/img/icon-192x192.png` und `icon-512x512.png` — existieren diese Dateien wirklich in `public/assets/img/`?

## 🟢 Repo-Aufräumen (nice-to-have)

Im Projektroot liegen mehrere Scratch-/Debug-Dateien, die wahrscheinlich nicht mehr gebraucht werden:

- [ ] `build_log.txt`, `build_log_utf8.txt` — alte Build-Logs
- [ ] `dump-nookipedia_db-202605131739.sql`, `dump-nookipedia_db-202605252007.sql` — DB-Dumps (gehören eher in ein Backup-Verzeichnis außerhalb des Repos, nicht ins Git)
- [ ] `creatures 20260526-94740.json` — Export mit Leerzeichen im Dateinamen
- [ ] `code_parts/` — Zweck unklar, prüfen ob noch gebraucht
- [ ] `zusammenfassung.ps1` — Zweck unklar
- [ ] `scripts/forgery-map.js`, `scripts/sync-events-only.js`, `scripts/test-events-trans.js`, `scripts/test-sheet-id.js` — sehen nach Wegwerf-Skripten aus dem Entwicklungsprozess aus

## 🟢 Spätere Erweiterung

- [ ] Sobald Directus-Daten für `villagers` vollständig sind: Bewohner-Detailseite (`/villager/[id]`) analog zu `tier/[id]` ergänzen
- [ ] Item-Katalog: Detailseite `/items/[id]` prüfen, ob sie mit den neuen `item_variants`-Bildern (Farbvarianten) umgehen kann, oder ob das noch fehlt
