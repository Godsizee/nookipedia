<div class="faunapedia-header">
    <h2>🦋 Die faszinierende Welt der Insekten</h2>
    <p>
        Hier findest du eine vollständige und fabelhafte Übersicht aller 80 Insekten in <i>Animal Crossing: New Horizons</i>. 
        Schnapp dir deinen <strong>Kescher</strong> und los geht's!
    </p>
    <p>
        <strong>Deko-Tipp:</strong> Du kannst gefangene Insekten mit ihren schicken Tierbehältnissen wundervoll in deinem Haus oder überall auf deiner Insel platzieren.
    </p>
    <p>
        <strong>Gut zu wissen:</strong> Bei Regen verkriechen sich die meisten Insekten und sind nicht anzutreffen. Ein kleiner Lifehack für die Jagd: Wenn du ein Gebäude betrittst und wieder verlässt, werden die Insekten draußen komplett neu geladen. Happy Bug Catching!
    </p>
</div>

<!-- Native HTTP/2 CSS Import für Faunapädie (modular, kein Render-Blocking-Wasserfall) -->
<link rel="stylesheet" href="/assets/css/faunapedia.css">

<!-- ✨ FABULOUS FILTER & GRID SECTION ✨ -->
<div class="faunapedia-section" data-category="insect">
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

    <!-- 8x10 Grid (8 Spalten, 10 Reihen = 80 Items) -->
    <div class="creature-grid-mini grid-8-cols">
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