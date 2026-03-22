<div class="faunapedia-header">
    <h2>🐟 Petri Heil!</h2>
    <p>
        Hier findest du eine vollständige Übersicht aller 80 Fische in <i>Animal Crossing: New Horizons</i>.
        Zücke deine <strong>Angel</strong>, aber bemühe dich, nicht direkt am Wasser zu rennen, um deine wertvolle Beute nicht zu verscheuchen!
    </p>
    <p>
        <strong>Der Köder-Trick:</strong> Mithilfe der am Strand auszugrabenden Teppichmuscheln lässt sich pro Muschel ein Köder basteln. Die Bastelanleitung lernst du automatisch beim ersten Ausgraben. Köder garantieren an sämtlichen Gewässern das Erscheinen eines passenden Fisches und schließen Müll komplett aus!
    </p>
    <p>
        <strong>Müll-Recycling:</strong> Ohne Köder angelst du manchmal Steine, Stiefel, Dosen oder Reifen. Kein Grund zum Ärgern: Diese kannst du für Bastelanleitungen verwenden, die du beim Angeln von Müll freischaltest.
    </p>
    <p>
        Du kannst Fische auch schick im Aquarium auf deiner Insel platzieren. Und denk dran: Verlässt du ein Gebäude, werden Fische neu geladen.
    </p>
</div>

<!-- Native HTTP/2 CSS Import für Faunapädie (modular, kein Render-Blocking-Wasserfall) -->
<link rel="stylesheet" href="/assets/css/faunapedia.css">

<!-- ✨ FABULOUS FILTER & GRID SECTION ✨ -->
<div class="faunapedia-section" data-category="fish">
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