$baseDir = "views\partials\guides"

# Erstelle das Verzeichnis, falls es nicht existiert
if (-not (Test-Path $baseDir)) {
    New-Item -ItemType Directory -Force -Path $baseDir | Out-Null
    Write-Host "Verzeichnis erstellt: $baseDir" -ForegroundColor Green
}

# --- STIEFMÜTTERCHEN / ALPENVEILCHEN (ID 2) ---
$intro2 = @"
<p>
    <strong>Stiefmütterchen (engl. Pansies)</strong> bestechen durch ihre zweifarbigen Blütenblätter und sind ein Muss für jeden Garten. Während die Grundfarben einfach zu erhalten sind, erfordert die lila Variante eine präzise Planung und Geduld.
</p>
"@

$tips2 = @"
<div class="tip-card">
    <h3><span class="tip-icon">💧</span> Besucher-Bonus</h3>
    <div class="tip-content">
        <p>Die Chance auf eine neue Blume pro Tag ist ohne Hilfe gering (~5%).</p>
        <div class="tip-highlight">Lass <strong>5 Besucher</strong> gießen, um die Chance auf ~80% zu erhöhen. Dies ist der absolut schnellste Weg zu Lila!</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">👯</span> Klonen</h3>
    <div class="tip-content">
        <p>Sobald du deine erste lila Blume hast, solltest du sie isolieren.</p>
        <div class="tip-highlight">Stelle sie so auf, dass sie keine andere Blume berührt, und gieße sie. Sie kopiert sich selbst zu 100%.</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">📏</span> Das Paar-System</h3>
    <div class="tip-content">
        <p>Verwende für die Erzeugung von Hybrid-Rot das Paar-System (Rot und Blau direkt nebeneinander).</p>
        <div class="tip-highlight">So verhinderst du, dass sich blaue Blumen ungewollt untereinander kreuzen.</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">🔖</span> Kennzeichnung</h3>
    <div class="tip-content">
        <p>Da Hybrid-Rot optisch identisch mit normalem Rot ist, markiere deine Beete mit einem Bodendesign.</p>
        <div class="tip-highlight">Nur das Hybrid-Rot aus der Blau+Rot-Kreuzung kann Lila hervorbringen. Es gibt übrigens keine Goldvariante bei Stiefmütterchen.</div>
    </div>
</div>
"@

# --- HYAZINTHEN (ID 5) ---
$intro5 = @"
<p>
    <strong>Hyazinthen (engl. Hyacinths)</strong> sind aufgrund ihrer kräftigen Farben und der wunderschönen lila Variante eine der beliebtesten Blumen im Spiel. Besonders die lila Hyazinthe ist essentiell, um das begehrte "Hyazinthen-Lampen"-Bastelrezept optisch perfekt umzusetzen.
</p>
"@

$tips5 = @"
<div class="tip-card">
    <h3><span class="tip-icon">👯</span> Klonen-Prinzip</h3>
    <div class="tip-content">
        <p>Sobald du eine lila Hyazinthe hast, ist der schnellste Weg zu mehr Blumen nicht die weitere Zucht, sondern das <strong>Klonen</strong>.</p>
        <div class="tip-highlight">Platziere die Blume so, dass sie keine andere Hyazinthe berührt, und gieße sie. Die Chance auf eine exakte Kopie ist extrem hoch.</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">💧</span> Besucher-Bonus</h3>
    <div class="tip-content">
        <p>Die Vermehrungsrate steigt massiv an, wenn Freunde aus anderen Städten deine Blumen gießen:</p>
        <ul>
            <li><strong>Du allein:</strong> ca. 5% Chance</li>
            <li><strong style="color: var(--ac-green);">5 Besucher:</strong> ca. 80% Chance <br><em>(Die Blumen glitzern dann besonders hell und groß!)</em></li>
        </ul>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">📏</span> Platzierung (Layout)</h3>
    <div class="tip-content">
        <p>Verwende für die Zucht von Lila am besten das <strong>Paar-System</strong>.</p>
        <div class="tip-highlight">Setze eine orange und eine blaue Blume direkt nebeneinander und lasse ansonsten in alle Richtungen ein Feld Platz. So verhinderst du ungewollte Gen-Mischungen.</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">🧬</span> Blau ist nicht Blau</h3>
    <div class="tip-content">
        <p>Eine blaue Hyazinthe aus weißen Samen ist genetisch <strong>anders</strong> als eine blaue Hyazinthe aus Orange und Orange!</p>
        <div class="tip-highlight">Um Frust zu vermeiden, markiere deine Zuchtfelder zwingend mit Bodendesigns, damit du die "Qualität" der Hybride kennst.</div>
    </div>
</div>
"@

# --- LILIEN (ID 6) ---
$intro6 = @"
<p>
    <strong>Lilien (engl. Lilies)</strong> sind elegante Blumen, die besonders durch ihre kräftigen Farben bestechen. Im Gegensatz zu komplexeren Arten wie Rosen oder Chrysanthemen ist die Lilienzucht relativ geradlinig, bietet aber mit der schwarzen Lilie ein echtes Highlight für jede Inselgestaltung.
</p>
"@

$tips6 = @"
<div class="tip-card">
    <h3><span class="tip-icon">💧</span> Gieß-System & Bonus</h3>
    <div class="tip-content">
        <p>Die Chance, dass ein Blumenpaar überhaupt einen Nachkommen zeugt, steigt durch Besucher:</p>
        <ul>
            <li><strong>Eigenes Gießen:</strong> ca. 5% Chance</li>
            <li><strong style="color: var(--ac-green);">5 Besucher:</strong> ca. 80% Chance <br><em>(Goldenes Glitzern)</em></li>
        </ul>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">👯</span> Klonen von Hybriden</h3>
    <div class="tip-content">
        <p>Wenn du eine Pinke, Orange oder Schwarze Lilie erhalten hast, stelle sie einzeln auf ein leeres Feld.</p>
        <div class="tip-highlight">Gießt du sie nun, "klont" sich die Blume selbst. Das Kind hat garantiert dieselbe Farbe und dieselben Gene wie das Elternteil!</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">📏</span> Layout & Sauberkeit</h3>
    <div class="tip-content">
        <p>Am effizientesten ist das <strong>Paar-System</strong>. Entferne zudem rote oder gelbe Nachkommen sofort aus deinen Hybrid-Beeten.</p>
        <div class="tip-highlight">Diese könnten "Hybrid-Rot" sein und die Genetik deines Beetes komplett verfälschen!</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">🎀</span> Dekorative Nutzung</h3>
    <div class="tip-content">
        <p>Schwarze Lilien eignen sich hervorragend für <strong>"Gothic"-Designs</strong> oder Friedhofs-Themen.</p>
        <div class="tip-highlight">Kombiniert mit lilafarbenen Hyazinthen-Lampen erzeugen sie nachts eine herrlich mystische Atmosphäre.</div>
    </div>
</div>
"@

# --- ROSEN (ID 7) ---
$intro7 = @"
<p>
    Die <strong>Rosenzucht</strong> gilt als die "Königsdisziplin" des Gärtnerns in ACNH. Während einfache Farben wie Rosa oder Orange schnell entstehen, erfordert die legendäre blaue Rose eine extrem präzise Planung über mehrere Generationen hinweg.
</p>
"@

$tips7 = @"
<div class="tip-card">
    <h3><span class="tip-icon">🧬</span> Die "Test-Kreuzung"</h3>
    <div class="tip-content">
        <p>Da viele Hybride exakt gleich aussehen (z. B. normales Rot vs. Hybrid-Rot), musst du deine Beete immer strengstens trennen.</p>
        <div class="tip-highlight">Nutze eigens erstellte Designs auf dem Boden, um die Generationen und Gene genau zu beschriften!</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">👯</span> Das Klonen</h3>
    <div class="tip-content">
        <p>Wenn du die erste blaue Rose hast, feiere kurz und <strong>isoliere sie dann sofort!</strong></p>
        <div class="tip-highlight">Stelle sie alleine auf ein Feld und gieße sie. So kopiert sie sich selbst, ohne dass ihre harten Gene durch andere Rosen "verwässert" werden.</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">💧</span> Besucher-Gießen</h3>
    <div class="tip-content">
        <p>Nichts beschleunigt die zähe Rosenzucht so sehr wie Hilfe aus dem Internet:</p>
        <ul>
            <li><strong>Selbst gießen:</strong> ca. 5% Chance</li>
            <li><strong style="color: var(--ac-green);">5 Besucher:</strong> ca. 80% Chance <br><em>(Breites, extrem helles Glitzern)</em></li>
        </ul>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">📏</span> Das Layout</h3>
    <div class="tip-content">
        <p>Für die komplexen blauen Pfade empfiehlt sich zwingend das <strong>Paar-System</strong> (zwei Eltern nebeneinander, dann Platz).</p>
        <div class="tip-highlight">Nur so stellst du sicher, dass du zu 100% weißt, welche Rose von welchen Eltern abstammt!</div>
    </div>
</div>
"@

# --- TULPEN (ID 8) ---
$intro8 = @"
<p>
    <strong>Tulpen (engl. Tulips)</strong> sind klassische Frühlingsblumen und gehören zu den unkomplizierteren Arten im Spiel. Dennoch gibt es auch hier seltene Farben wie Schwarz und Lila, die eine gezielte Zucht erfordern.
</p>
"@

$tips8 = @"
<div class="tip-card">
    <h3><span class="tip-icon">💧</span> Besucher-Bonus</h3>
    <div class="tip-content">
        <p>Die Wahrscheinlichkeit, dass ein Blumenpaar eine neue Knospe hervorbringt, hängt stark vom Gießen ab.</p>
        <div class="tip-highlight">Lass <strong>5 Besucher</strong> gießen, um die Vermehrungschance auf fantastische 80% anzuheben!</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">👯</span> Klonen seltener Farben</h3>
    <div class="tip-content">
        <p>Sobald du deine erste lila oder schwarze Tulpe hast, solltest du sie isolieren.</p>
        <div class="tip-highlight">Stelle sie auf ein Feld ohne Kontakt zu anderen Tulpen. So klont sich die Blume und garantiert dir Nachwuchs derselben Genetik.</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">📏</span> Das "X"-Muster</h3>
    <div class="tip-content">
        <p>Für die Zucht von Lila aus Orange eignet sich ein versetztes Schachbrettmuster.</p>
        <div class="tip-highlight">So hat jede Blume genügend Platz, um in die angrenzenden freien Felder zu "werfen".</div>
    </div>
</div>
<div class="tip-card">
    <h3><span class="tip-icon">🔖</span> Kennzeichnung & Goldkanne</h3>
    <div class="tip-content">
        <p>Markiere Hybrid-Orange mit Bodendesigns, da wilde orange Tulpen andere Gene besitzen.</p>
        <div class="tip-highlight"><strong>Übrigens:</strong> Bei Tulpen gibt es keine Goldvariante. Die Goldgießkanne nützt hier nur für die Reichweite.</div>
    </div>
</div>
"@

# --- MAIGLÖCKCHEN (ID 9) ---
$intro9 = @"
<p>
    Das <strong>Maiglöckchen (engl. Lily-of-the-Valley)</strong> ist das ultimative Statussymbol in Animal Crossing: New Horizons. Es beweist, dass deine Insel die absolute Perfektion erreicht hat!
</p>
"@

$tips9 = @"
<div class="tip-card" style="border-top-color: #ffd700;">
    <h3><span class="tip-icon">⭐</span> 5-Sterne-Rating</h3>
    <div class="tip-content">
        <p>Maiglöckchen können <strong>nicht</strong> durch klassische Methoden gezüchtet werden!</p>
        <div class="tip-highlight">Sie wachsen völlig automatisch an den Klippen deiner Insel, sobald du das perfekte 5-Sterne-Rating bei Melinda erreicht hast.</div>
    </div>
</div>
<div class="tip-card" style="border-top-color: #ffd700;">
    <h3><span class="tip-icon">⏳</span> Geduld ist Gold</h3>
    <div class="tip-content">
        <p>Solange deine Insel auf 5 Sternen bleibt, wachsen nach und nach weitere Maiglöckchen.</p>
        <div class="tip-highlight">Sie tauchen nur in Abständen von mehreren Tagen auf. Du kannst sie jederzeit ausgraben und dekorativ umpflanzen!</div>
    </div>
</div>
"@

# --- DATEIEN ERSTELLEN ---
$files = @{
    "intro_2.php" = $intro2
    "tips_2.php"  = $tips2
    "intro_5.php" = $intro5
    "tips_5.php"  = $tips5
    "intro_6.php" = $intro6
    "tips_6.php"  = $tips6
    "intro_7.php" = $intro7
    "tips_7.php"  = $tips7
    "intro_8.php" = $intro8
    "tips_8.php"  = $tips8
    "intro_9.php" = $intro9
    "tips_9.php"  = $tips9
}

# UTF-8 Ohne BOM (Byte Order Mark) erzwingen
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

foreach ($file in $files.GetEnumerator()) {
    $path = Join-Path $baseDir $file.Name
    $fullPath = Join-Path $PWD.Path $path
    
    # Datei schreiben und dabei BOM vermeiden
    [System.IO.File]::WriteAllText($fullPath, $file.Value, $utf8NoBom)
    
    Write-Host "Datei erfolgreich (ohne BOM) erstellt: $path" -ForegroundColor Cyan
}

Write-Host "`nDie gewünschten Guide-Dateien wurden erfolgreich generiert! ✨" -ForegroundColor Yellow