# Bilder & Assets

Wie die App Bildpfade auflöst und wie fehlende Bilder ergänzt werden.

## Auflösung (Single Source of Truth: `src/lib/format.js`)

`getImageUrl(path, { folder })` löst jede Bildreferenz auf:

| Eingabe (aus der DB)              | Beispiel                                | Ergebnis |
|-----------------------------------|-----------------------------------------|----------|
| Pfad mit eigenem Unterordner      | `faunapedia/insects/Ant.png`            | `/assets/img/acnh/faunapedia/insects/Ant.png` |
| Reiner Dateiname + `folder`       | `64px-Wood.png` (folder `materials`)    | `/assets/img/acnh/materials/64px-Wood.png` |
| `../`-relativ + `folder`          | `../diy/tools/Axe.png` (folder `materials`) | `/assets/img/acnh/diy/tools/Axe.png` |
| Bare Token ohne Endung            | `a1b2c3…` (Directus-Asset-ID)           | `https://<directus>/assets/a1b2c3…` |
| Voll-URL                          | `https://…/x.png`                       | unverändert |

Die `folder`-Angabe pro Kategorie (materials / events / museum …) bildet die
ursprünglichen Backend-Pfade ab. Ohne sie landeten reine Dateinamen im
Asset-Root und fielen still auf den Platzhalter zurück — die Ursache, warum
zuvor „viele Bilder“ als Platzhalter erschienen.

## Fehlende Bilddateien

Die meisten Kategorien sind vollständig im Repo (`public/assets/img/acnh/`).
Genuin fehlende **Dateien** (kein Pfad-Bug):

- **Bewohner-Porträts** – die DB referenziert `villagers/<Name>.png`, der Ordner
  existierte nie. → mit dem Sync-Script unten beheben.
- **`diy/Housewares/Mush screen.png`** – einzelnes DIY-Icon, in keiner Quelle
  vorhanden; zeigt bis dahin den Platzhalter.

## Bewohner-Bilder nachladen

```bash
npm run db:sync-villagers:report   # nur anzeigen, was fehlt (kein Download)
npm run db:sync-villagers          # fehlende Porträts herunterladen
```

Das Script (`scripts/sync-villager-images.js`):

1. liest die Bewohner aus Directus (`name_en`, `name_de`, `image_path`),
2. ermittelt das lokale Zielfile exakt wie das Frontend (`resolveLocal`
   spiegelt `getImageUrl`),
3. lädt für jedes fehlende Ziel das ACNH-Icon und speichert es unter dem
   **von der DB referenzierten Dateinamen**.

Der Join läuft über den **englischen Namen** (`name_en`), nicht den deutschen:
die deutschen Namen in Fremddatensätzen weichen teils ab (z. B. Marshal heißt
hier `Mischka`, upstream `Huschke`). Die Bildquellen liegen reviewbar in
`scripts/villager-image-sources.json` (413 Bewohner, aus dem öffentlichen
Datensatz `Norviah/animal-crossing` erzeugt). Das Script ist idempotent —
vorhandene Dateien werden übersprungen, Re-Runs laden nur Neues.

### Netzwerk

Benötigt Egress zu:

- dem Directus-Backend (`PUBLIC_DIRECTUS_URL`, Default
  `https://backend-nookipedia.2.godsize.info`) und
- `acnhcdn.com` (die Bildquelle).

In abgeschotteten Umgebungen (z. B. Claude Code on the web mit restriktiver
Netzwerk-Policy) diese Hosts vorher zur Allowlist hinzufügen, sonst lokal mit
`PUBLIC_DIRECTUS_URL=… npm run db:sync-villagers` ausführen.
