/**
 * locations.js · Was ein Fundort im Spiel wirklich bedeutet (SRP: nur Daten).
 * Schlüssel = exakter `location_name` aus dem Datensatz. Unbekannte Werte
 * liefern null → die Anzeige bleibt dann einfach nicht antippbar.
 */
export const LOCATION_INFO = {
  'Meer': { emoji: '🌊', text: 'Das offene Wasser rund um deine Insel. Stell dich an den Strand und wirf hinaus — auf einem Mysteriösen Eiland zählt der Strand genauso.' },
  'Steg': { emoji: '🪵', text: 'Der Holzsteg, der vom Strand ins Meer hinausragt. Ein paar Fische beißen ausschließlich hier: Du musst wirklich auf den Planken stehen und von dort auswerfen — vom Sand daneben zählt nicht.' },
  'Fluss': { emoji: '🏞️', text: 'Jedes fließende Gewässer auf deiner Insel, von der Quelle bis kurz vor den Strand. Teiche und die breite Mündung zählen nicht dazu.' },
  'Fluss (Plateau)': { emoji: '⛰️', text: 'Flussabschnitte oben auf den Klippen — überall dort, wo dein Wasserfall herunterstürzt, und nur mit der Leiter erreichbar. Ein kurzes, mindestens drei Felder breites Stück Klippenfluss reicht schon. Weil dort so wenig Wasser ist, beißen die seltenen Plateau-Fische umso häufiger.' },
  'Flussmündung': { emoji: '🏖️', text: 'Das breite Ende deines Flusses direkt am Strand, wo er ins Meer läuft. Gemeint ist nur dieses letzte Stück — nicht der Fluss weiter oben.' },
  'Teich': { emoji: '💧', text: 'Ein stehendes Gewässer ohne Verbindung zum Fluss, von Natur aus da oder selbst gebuddelt. Wichtig: rundum geschlossen, sonst behandelt das Spiel es als Fluss.' },
  'Beim Tauchen': { emoji: '🤿', text: 'Meerestiere bekommst du nicht mit der Angel. Zieh den Taucheranzug an, spring vom Strand oder Steg ins Meer und halte Ausschau nach aufsteigenden Luftblasen: direkt darüber schwimmen, mit Y abtauchen und dem Schatten am Meeresboden folgen.' },
  'an Bäumen': { emoji: '🌳', text: 'Sitzt am Stamm von Laub- und Nadelbäumen. Lauf langsam heran und halte den Kescher bereit — Rennen verscheucht sie.' },
  'an Palmen': { emoji: '🌴', text: 'Sitzt nur am Stamm von Palmen, also am Strand oder auf einem Mysteriösen Eiland.' },
  'an Bäumen und Palmen': { emoji: '🌲', text: 'Sitzt an jedem Baumstamm: Laubbaum, Nadelbaum und Palme.' },
  'Bäume schütteln': { emoji: '🍃', text: 'Versteckt sich in der Baumkrone. Stell dich an den Stamm und schüttle mit A — fällt das Tier heraus, sofort mit dem Kescher hinterher. Achtung: manchmal kommt stattdessen ein Wespennest.' },
  'auf Baumstümpfen': { emoji: '🪵', text: 'Sitzt auf frisch abgesägten Baumstümpfen. Also erst mit der Axt fällen, dann täglich vorbeischauen.' },
  'Boden': { emoji: '🌱', text: 'Krabbelt einfach über den Erdboden deiner Insel — Wiese, Wege, überall.' },
  'in der Erde': { emoji: '⛏️', text: 'Steckt unter der Erde und verrät sich nur durchs Zirpen. Lauf dem Geräusch nach, such die kleine Erdstelle und grab mit der Schaufel.' },
  'Felsen schlagen': { emoji: '🪨', text: 'Kommt aus einem Stein heraus, wenn du mit Schaufel oder Axt draufhaust. Kescher vorher bereithalten.' },
  'auf Steinen und Büschen': { emoji: '🪨', text: 'Sitzt an Felsen oder in Büschen.' },
  'auf Felsen am Strand': { emoji: '🏝️', text: 'Nur auf den Steinen, die unten im Sand am Meer liegen — und die flitzen los, sobald du zu nah kommst.' },
  'am Strand': { emoji: '🏖️', text: 'Krabbelt über den Sandstreifen am Meer.' },
  'auf Blumen': { emoji: '🌷', text: 'Sitzt direkt auf einer Blüte. Je mehr Blumen auf deiner Insel blühen, desto mehr tauchen auf.' },
  'auf weißen Blumen': { emoji: '🤍', text: 'Sitzt ausschließlich auf weißen Blüten. Ein kleines weißes Beet wirkt wie eine Falle.' },
  'fliegt nahe Blumen': { emoji: '🦋', text: 'Flattert über deinen Blumenbeeten, ohne sich hinzusetzen — mit dem Kescher aus der Luft holen.' },
  'fliegt nahe dunkler Blumen': { emoji: '🖤', text: 'Flattert nur über schwarzen und lila Blüten. Ohne dunkles Beet siehst du das Tier praktisch nie.' },
  'fliegt in der Luft': { emoji: '💨', text: 'Schwirrt frei durch die Gegend, ohne Bezug zu Blumen oder Bäumen.' },
  'fliegt nahe Gewässern': { emoji: '💧', text: 'Fliegt über Fluss, Teich oder Meer.' },
  'Fluss, auf dem Wasser': { emoji: '🌊', text: 'Treibt auf der Wasseroberfläche von Fluss oder Teich. Vom Ufer aus mit dem Kescher zuschlagen.' },
  'bei Lichtquellen': { emoji: '💡', text: 'Kommt nachts ans Licht: Laternen, leuchtende Bauobjekte und das erhellte Fenster deines Hauses.' },
  'an Müll': { emoji: '🗑️', text: 'Sitzt auf weggeworfenem Müll. Angel dir Dose, Stiefel oder Reifen aus dem Wasser und stell das Teil irgendwo hin — schon hast du deinen Köder.' },
  'an verfaulten Rüben oder Bonbons': { emoji: '🍬', text: 'Kommt an vergammelte weiße Rüben oder an ein hingelegtes Bonbon. Beides einfach auf den Boden stellen und warten.' },
  'an Schneebällen': { emoji: '⛄', text: 'Sitzt im Winter an den beiden Schneekugeln, die du über die Insel rollst.' },
  'auf Dorfbewohnern': { emoji: '🧍', text: 'Setzt sich deinen Nachbarn auf den Kopf. Wenn ein Bewohner sich auffällig kratzt, ist es Zeit für den Kescher — sonst wird er sauer.' },
  'unter Bäumen (getarnt als Blatt)': { emoji: '🍂', text: 'Sieht aus wie ein heruntergefallenes Blatt unter einem Baum. Wenn ein „Blatt" sich bewegt oder plötzlich woanders liegt, ist es keins.' }
};

export const locationInfo = (name) => LOCATION_INFO[name] || null;
