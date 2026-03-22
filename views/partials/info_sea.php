<div class="faunapedia-header">
    <h2>🐙 Ab ins kühle Nass!</h2>
    <p>
        Hier findest du eine vollständige Übersicht aller 40 Meerestiere in <i>Animal Crossing: New Horizons</i>.
        Zum Schwimmen und Tauchen benötigst du einen <strong>Taucheranzug</strong>.
    </p>
    <p>
        <strong>Anschleichen für Profis:</strong> Du kannst dich an schnelle Meerestiere „anschleichen“, indem du nur durch sanftes Bewegen des linken Sticks schwimmst, ohne den A-Knopf zu drücken. Befindest du dich direkt über dem Tier (an den Blasen erkennbar), fängst du es mit einem direkten Tauchvorgang.
    </p>
    <p>
        Du kannst Meerestiere wundervoll in Tierbehältnissen in deinem Haus oder auf der Insel ausstellen. <strong>Achtung:</strong> Im Gegensatz zu Insekten und Fischen kannst du von Meerestieren leider keine Modelle in Auftrag geben lassen.
    </p>
</div>

<!-- Native HTTP/2 CSS Import für Faunapädie (modular, kein Render-Blocking-Wasserfall) -->
<link rel="stylesheet" href="/assets/css/faunapedia.css">

<!-- ✨ FABULOUS FILTER & GRID SECTION ✨ -->
<div class="faunapedia-section" data-category="sea">
    <div class="filter-controls">
        <label class="ac-checkbox">
            <input type="checkbox" id="filter-month">
            <span class="checkmark"></span>
            <span class="label-text">📅 Nur in diesem Monat</span>
        </label>
        <label class="ac-checkbox">
            <input type="checkbox" id="filter-now">
            <span class="checkmark"></span>
            <span class="label-text">⏰ Jetzt gerade fangbar</span>
        </label>
        <button id="clear-filters" class="btn-clear">🧹 Filter löschen</button>
    </div>

    <!-- 5x8 Grid (5 Spalten, 8 Reihen = 40 Items) -->
    <div class="creature-grid-mini grid-5-cols">
        <?php if(!empty($creatures)): ?>
            <?php foreach ($creatures as $c): ?>
                <?php 
                    $months = implode(',', $c->months_northern ?? []);
                    $time = $c->time_active ?? '';
                ?>
                <a href="#creature-<?= $c->id ?>" 
                   class="mini-card" 
                   data-id="<?= $c->id ?>"
                   data-months="<?= htmlspecialchars($months) ?>" 
                   data-time="<?= htmlspecialchars($time) ?>"
                   title="<?= htmlspecialchars($c->name) ?>">
                    <div class="mini-card-inner">
                        <img src="/assets/img/acnh/<?= htmlspecialchars($c->image_path) ?>" 
                             alt="<?= htmlspecialchars($c->name) ?>" 
                             loading="lazy"
                             onerror="this.src='/assets/img/acnh/koeder.png'">
                    </div>
                </a>
            <?php endforeach; ?>
        <?php endif; ?>
    </div>
</div>

<!-- Native ES Module Import (Wird asynchron und isoliert ausgeführt) -->
<script type="module" src="/assets/js/faunapedia.js"></script>