# Todo

Offene Punkte aus dem Bild-Platzhalter-Fix (Branch `claude/image-placeholder-issue-c2ao0y`).

- [ ] `acnhcdn.com` (und ggf. weitere ACNH-CDN-Hosts) zur Netzwerk-Allowlist
      hinzufügen — ohne Egress dorthin kann `sync-villager-images.js` keine
      echten Bilddaten laden (in dieser Sandbox 403).
- [ ] `npm run db:sync-villagers` in einer Umgebung mit Netzwerkzugriff
      ausführen, um die fehlenden Bewohner-Porträts nach
      `public/assets/img/acnh/villagers/` herunterzuladen.
- [ ] Quelle für `public/assets/img/acnh/diy/Housewares/Mush screen.png`
      finden — bisher in keinem erreichbaren Datensatz vorhanden.
- [ ] Entscheiden, ob für den Branch `claude/image-placeholder-issue-c2ao0y`
      ein Pull Request erstellt werden soll.
