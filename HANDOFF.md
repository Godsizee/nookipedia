# HANDOFF · Item-Katalog-Bildimport (Stand 2026-06-21)

Diese Datei erklärt einer KI **ohne Vorwissen**, was läuft, was fertig ist und was
morgen noch zu tun ist. Lies zuerst `.agents/agents.md` (Projektregeln).

---

## 1. Ziel / Kontext

Im Web-Katalog (`https://acnh.godsize.info/katalog/`) luden keine Item-Bilder.
**Zwei Ursachen, beide gelöst bzw. in Arbeit:**

1. **Permission-Bug (gelöst):** Directus (v11, Policy-basiert) hatte für die
   Public-Policy `abf8a154-5b1c-4a46-ac9c-7300570f4f17` **keine Read-Permission auf
   `directus_files`** → `/assets/<uuid>` lieferte 403 → Browser-Bilder kaputt.
   Fix: Permission **id 22** angelegt (`collection=directus_files, action=read,
   fields=["*"]`). Seitdem sind alle Asset-UUIDs öffentlich ladbar (200).

2. **Unvollständiger Katalog (in Arbeit):** Directus hatte nur 939 Items (6
   Möbel-Kategorien, je auf 150/300 gedeckelt durch die alte
   `scripts/import-pipeline.js` → `syncItems()`, `syncLimit=150`). Es fehlten
   Kleidung, Tools, Floors, Music, Photos, Posters, Gyroids u. v. m.
   Lösung: neues Skript **`scripts/sync-item-catalog.js`** importiert ALLE 23
   Katalog-Tabs (Ziel: 5.569 Items / 24.924 Varianten) aus dem Community-Sheet,
   lädt acnhcdn-Icons in den Directus-Storage und schreibt die UUID nach
   `item_variants.image_path`. **Frontend braucht keine Änderung** (getImageUrl
   löst UUID → `/assets/<uuid>`).

---

## 2. Datenquellen

- **Daten-Sheet (veröffentlicht, CSV):** `…/pub?single=true&output=csv&gid=<gid>`
  Doc-ID `2PACX-1vTGrIfAI5ybCvaiIux5kEbermRFZe6aooAs7I1iVrJF27DrXSOJQxxEcQXzIw6KRacx1721da2oN2SM`.
  Tab→gid-Map steht oben in `scripts/sync-item-catalog.js` (`TABS`).
- **Bilder:** `https://acnhcdn.com/latest/FtrIcon/<Filename>.png` (deckt Möbel UND
  Kleidung). Pro Varianten-Zeile gibt es die Spalte `Filename`.
- **Deutsche Namen:** Translations-Sheet `1MMbsvDfu59OY9YBEAfHhFJ6O8vRTllNFgMrX7RBZuyI`,
  Spalten **EUen→EUde** (über alle Tabs vereint). Lokal gecached unter
  `scripts/.cache/item-de-map.json`. Trefferquote 99,8 %.

---

## 3. Das Skript: `scripts/sync-item-catalog.js`

- **Idempotent:** Items per `(name_en+category)` upsert; Varianten per
  `unique_entry_id` (global eindeutig). Bereits importierte Varianten werden
  übersprungen → **jeder Batch ist gefahrlos wiederholbar**, keine Duplikate.
  Hochgeladene Dateien werden über `filename_download` wiederverwendet (kein
  Doppel-Download).
- **Flags:** `--report` (read-only), `--tabs=A,B` / `--tab=A`,
  `--offset=N --limit=M` (Item-Fenster pro Tab, für große Tabs),
  `--purge-legacy` (einmalig erledigt), `--skip-images`, `--refresh-map`.
- **Token:** per ENV `DIRECTUS_TOKEN`. Directus-URL per `PUBLIC_DIRECTUS_URL`
  (Default `https://backend-nookipedia.2.godsize.info`).

### WICHTIG zur Ausführung (Windows / Git-Bash)
- Aus dem Projekt-Root ausführen, **kein `cd`** voranstellen (Git-Bash-Pfad
  `/c/xampp/...` bricht sonst). Die Bash-Tool-Arbeitsverzeichnis ist bereits der
  Root.
- Schreib-Token (Directus, hat Schreibrechte auf items/item_variants/files,
  ist NICHT Admin): `t9gWWOyAW_iLVW53LUzFU3Gdm807CdUa`
  → als ENV mitgeben: `DIRECTUS_TOKEN=t9gWWOyAW_iLVW53LUzFU3Gdm807CdUa node …`
  (Geheim behandeln; ggf. neu rotieren.)
- Läufe dauern ~25–40 Min → **im Hintergrund** laufen lassen und überwachen.

---

## 4. Stand JETZT (nach Batch 10)

- `items` total: **4.746**   ·   `item_variants` total: **16.009**
- Varianten **ohne Bild**: **585** (= bekannte 3.0.0-Lücke, siehe §6)
- Permission id 22 gesetzt, purge-legacy erledigt (4.852 kaputte Alt-Varianten
  mit `unique_entry_id=null` entfernt).

### Fertige Batches
| Batch | Inhalt | Status |
|---|---|---|
| 0 | purge-legacy | ✅ |
| 1 | Tops | ✅ |
| 2 | Dress-Up + Headwear | ✅ |
| 3 | Bottoms + Shoes + Socks + Accessories | ✅ |
| 4 | Wall-mounted + Bags + Posters + Gyroids + Music + Fencing + Umbrellas + Clothing Other | ✅ |
| 5 | Wallpaper + Floors + Rugs + Ceiling Decor + Tools/Goods | ✅ |
| 6 | Miscellaneous 0–390 | ✅ |
| 7 | Miscellaneous 390–Ende | ✅ |
| 8 | Housewares 0–170 | ✅ |
| 9 | Housewares 170–340 | ✅ |
| 10 | Housewares 340–510 | ✅ |

---

## 5. WAS MORGEN NOCH ZU TUN IST

### A) Restliche Housewares-Batches (Pflicht — Tab hat 1.004 Items)
Genau diese 3 Befehle nacheinander (Projekt-Root, je im Hintergrund, auf
Abschluss warten):

```bash
DIRECTUS_TOKEN=t9gWWOyAW_iLVW53LUzFU3Gdm807CdUa node scripts/sync-item-catalog.js --tab=Housewares --offset=510 --limit=170    # Batch 11
DIRECTUS_TOKEN=t9gWWOyAW_iLVW53LUzFU3Gdm807CdUa node scripts/sync-item-catalog.js --tab=Housewares --offset=680 --limit=170    # Batch 12
DIRECTUS_TOKEN=t9gWWOyAW_iLVW53LUzFU3Gdm807CdUa node scripts/sync-item-catalog.js --tab=Housewares --offset=850                # Batch 13 (bis Ende)
```

Nach jedem Lauf zeigt die Zusammenfassung `Items / Varianten neu / übersprungen /
Bilder geladen / Fehler`. `Fehler` = 3.0.0-Bilder (erwartet, siehe §6).

### B) Abschluss-Verifikation (nach Batch 13)
```bash
# Erwartung: items ~5.569, item_variants ~24.000+
curl -s -H "Authorization: Bearer t9gWWOyAW_iLVW53LUzFU3Gdm807CdUa" "https://backend-nookipedia.2.godsize.info/items/items?limit=0&meta=total_count"
curl -s -H "Authorization: Bearer t9gWWOyAW_iLVW53LUzFU3Gdm807CdUa" "https://backend-nookipedia.2.godsize.info/items/item_variants?limit=0&meta=total_count"
```
- `https://acnh.godsize.info/katalog/` öffnen → Bilder sollten flächendeckend da
  sein (außer 3.0.0-Items, §6).
- `Recent.md` im Vault aktualisieren (`C:\Users\bades\OneDrive\Desktop\Ideen\02 Projekte\Nookipedia\Recent.md`).
- Diese `HANDOFF.md` danach löschen.

---

## 6. Bekannte Rest-Lücke: 3.0.0-Bilder (~585+, NICHT über acnhcdn behebbar)

`acnhcdn.com/latest/FtrIcon/` ist auf Spielversion **2.0.x eingefroren**. Alle
**3.0.0**-Items (Happy Home Paradise, „artful"-Serie, viele customizable Möbel mit
`_Remake_body_pattern`-Filenames) liefern dort 404 (verifiziert: 3.0.0 = 0 ok /
7 bad; ≤2.0.0 = 113 ok / 0 bad). **Kein acnhcdn-Pfad/Prefix behebt das** — die
Assets liegen dort nicht. Betroffene Varianten haben `image_path=null` → Frontend
zeigt Platzhalter (`koeder.png`).

**Recovery (Follow-up, optional):** Nur eine Quelle mit 3.0.0-Content hilft →
**Nookipedia-API** (`api.nookipedia.com`, gepflegt, alle Versionen, liefert
Bild-URLs). Braucht einen **kostenlosen API-Key** (Nutzer hat aktuell keinen).
Dann gezieltes Nachlade-Skript bauen, das NUR Varianten mit `image_path=null`
über die Nookipedia-API auffüllt (Join über `unique_entry_id`/Name). Befund &
Details auch in der Memory `directus-permissions-gap.md`.

---

## 7. Wichtige Dateien
- `scripts/sync-item-catalog.js` — der Importer (dieser Task).
- `scripts/import-pipeline.js` — ALT, gedeckelt (Quelle des ursprünglichen Caps);
  nicht erneut blind laufen lassen.
- `src/lib/api.js#getItemsCatalog` — Katalog-Loader (nimmt erstes Varianten-Bild).
- `src/lib/format.js#getImageUrl` — UUID → `/assets/<uuid>`.
- Memory: `…/memory/directus-permissions-gap.md` (Permission-Fix + acnhcdn-Lücke).
