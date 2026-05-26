# Nookipedia Migration: Implementation Plan V2 (Detail-Inhalte & Filter)

Nachdem das Grundgerüst aller Seiten im Astro-Framework steht, sorgt dieser Plan dafür, dass **alle verbleibenden Detail-Texte, UI-Komponenten und interaktiven JavaScript-Filter** aus dem alten PHP-Build (`nookipedia-a921a33e0840008a3ed83e529474e527da06aaad`) vollständig auf das neue Astro-Framework übertragen werden.
*Hinweis: Der Login-Bereich (`login.php`) wurde auf Wunsch explizit exkludiert.*

## Phase 1: Museum Hub Erweitern (`info_museum.php`)
**Ziel:** Die liebevollen Hintergrundinfos zur Museumserweiterung wiederherstellen.

**Aufgaben:**
1. **`src/pages/museum.astro` anpassen:**
   - Den kompletten Block "Freischaltungen & Geheimnisse" (Wie man von Eugens Zelt zum Gebäude kommt, Kunstgalerie freischaltet, Café Taubenschlag eröffnet und Lithografien erhält) aus der alten `views/partials/info_museum.php` in das Layout integrieren.

---

## Phase 2: Faunapädie UI, Filter & Texte (`info_fish.php`, `info_insect.php`, `info_sea.php`)
**Ziel:** Die aktuell statische Liste in eine interaktive, informative Tier-Datenbank verwandeln.

**Aufgaben:**
1. **`src/pages/faunapaedie.astro` anpassen:**
   - **Tabs / Navigation:** Wie im alten `creature-list.php` Tabs für "Fische", "Insekten" und "Meerestiere" hinzufügen, um die Ansichten umzuschalten.
   - **Texte integrieren:** Für jeden Bereich die spezifischen Anleitungstexte einbauen (z.B. den "Köder-Trick" und "Müll-Recycling" aus `info_fish.php`).
   - **Filter-Logik:** Die interaktiven Checkboxen ("Nur in diesem Monat", "Jetzt gerade fangbar") aus den alten Views samt JavaScript-Logik (`faunapedia.js`) in Astro als `<script>`-Block nativ neu implementieren.

---

## Phase 3: Events UI & Filter (`info_event.php`)
**Ziel:** Die Event-Übersicht filterbar und informativer machen.

**Aufgaben:**
1. **`src/pages/events.astro` anpassen:**
   - **Texte integrieren:** Den Einleitungstext ("🎉 Lass uns feiern!") aus der `info_event.php` einbauen.
   - **Filter-Logik:** Die Checkboxen zur Filterung nach Event-Typen (Turniere, Feiertage, Saisons, Nook Shopping) hinzufügen und mit passendem Astro/Client-Side JS verknüpfen.

---

## Phase 4: Blumen Übersicht Erweitern (`info_flower.php`)
**Ziel:** Wichtige Tipps zur Zucht direkt auf der Übersichtsseite anzeigen.

**Aufgaben:**
1. **`src/pages/blumen.astro` anpassen:**
   - **Texte integrieren:** Die Sektion "🌷 Die botanische Oase" samt den Tipp-Boxen zu "Hybriden züchten" (Genetik, blaue Rose) und dem "Prestige-Tipp" (Maiglöckchen bei 5-Sterne-Rating) aus der alten `info_flower.php` übernehmen.
