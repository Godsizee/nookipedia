<div class="faunapedia-header flower-header-premium">
    <h2 class="flower-intro-heading">🌷 Die botanische Oase</h2>
    <p class="flower-intro-text">
        Willkommen in der farbenfrohen Pflanzenwelt von <i>Animal Crossing: New Horizons</i>! 
        Blumen verschönern nicht nur deine Insellandschaft, sondern locken auch exklusive und seltene Insekten an.
    </p>
    <div class="flower-tips-container">
        <div class="flower-tip-box pink">
            <strong class="flower-tip-title">🧬 Hybriden züchten</strong>
            Schnapp dir deine Gießkanne! Durch geschicktes Aneinanderpflanzen und tägliches Gießen kannst du völlig neue Farben wie Pink, Schwarz oder sogar die extrem seltene blaue Rose erschaffen.
        </div>
        <div class="flower-tip-box gold">
            <strong class="flower-tip-title">⭐ Prestige-Tipp</strong>
            Hast du erst einmal ein makelloses 5-Sterne-Rating für deine Insel erreicht, wachsen an deinen Klippen ganz von allein die edlen <em>Maiglöckchen</em>. Ein wahres Statussymbol!
        </div>
    </div>
</div>

<link rel="stylesheet" href="/assets/css/faunapedia.css">
<link rel="stylesheet" href="/assets/css/flowers.css">

<!-- ✨ FABULOUS MINI GRID SECTION ✨ -->
<div class="faunapedia-section" data-category="flowers">
    <div class="quick-nav-header">
        <h3>Schnellnavigation</h3>
        <p>Springe direkt zur gewünschten Art</p>
    </div>

    <!-- 3x3 Grid für die 9 Blumenarten -->
    <div class="creature-grid-mini">
        <?php if(!empty($flowers)): ?>
            <?php foreach ($flowers as $f): ?>
                <a href="#flower-<?= $f->id ?>" 
                   class="mini-card" 
                   data-id="<?= $f->id ?>"
                   title="<?= htmlspecialchars($f->name) ?>">
                    <div class="mini-card-inner flower-mini-card-inner">
                        <img src="<?= htmlspecialchars($f->getImageUrl()) ?>" 
                             alt="<?= htmlspecialchars($f->name) ?>" 
                             loading="lazy"
                             onerror="this.src='/assets/img/acnh/koeder.png'">
                    </div>
                </a>
            <?php endforeach; ?>
        <?php endif; ?>
    </div>
</div>

<!-- JS für Smooth-Scrolling -->
<script type="module" src="/assets/js/faunapedia.js"></script>