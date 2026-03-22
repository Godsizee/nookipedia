<div class="faunapedia-header" style="border-left-color: #ff69b4;">
    <h2>🌷 Die botanische Oase</h2>
    <p>
        Willkommen in der farbenfrohen Pflanzenwelt von <i>Animal Crossing: New Horizons</i>! 
        Blumen verschönern nicht nur deine Insellandschaft, sondern locken auch exklusive und seltene Insekten an.
    </p>
    <p>
        <strong>Hybriden züchten:</strong> Schnapp dir deine Gießkanne! Durch geschicktes Aneinanderpflanzen und Gießen kannst du völlig neue Farben wie Pink, Schwarz oder sogar die extrem seltene blaue Rose erschaffen. 
    </p>
    <p>
        <strong>Prestige-Tipp:</strong> Hast du erst einmal ein makelloses 5-Sterne-Rating für deine Insel erreicht, wachsen an deinen Klippen ganz von allein die edlen <em>Maiglöckchen</em>. Ein wahres Statussymbol!
    </p>
</div>

<link rel="stylesheet" href="/assets/css/faunapedia.css">
<!-- Wir laden ein spezifisches Stylesheet für die Farb-Badges der Blumen -->
<link rel="stylesheet" href="/assets/css/flowers.css">

<!-- ✨ FABULOUS GRID SECTION (Ohne Filter, da Blumen ganzjährig da sind) ✨ -->
<div class="faunapedia-section" data-category="flowers" style="background-image: radial-gradient(#f8bbd0 2px, transparent 2px);">
    <!-- 3x3 Grid für die 9 Blumenarten -->
    <div class="creature-grid-mini grid-3-cols">
        <?php if(!empty($flowers)): ?>
            <?php foreach ($flowers as $f): ?>
                <a href="#flower-<?= $f->id ?>" 
                   class="mini-card" 
                   data-id="<?= $f->id ?>"
                   title="<?= htmlspecialchars($f->name) ?>">
                    <div class="mini-card-inner" style="border-radius: 20px;">
                        <img src="/assets/img/acnh/<?= htmlspecialchars($f->image_path) ?>" 
                             alt="<?= htmlspecialchars($f->name) ?>" 
                             loading="lazy"
                             onerror="this.src='/assets/img/acnh/koeder.png'">
                    </div>
                </a>
            <?php endforeach; ?>
        <?php endif; ?>
    </div>
</div>

<!-- Das bestehende JS sorgt hier weiterhin automatisch für das Smooth-Scrolling! -->
<script type="module" src="/assets/js/faunapedia.js"></script>