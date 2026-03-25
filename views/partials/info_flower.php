<div class="faunapedia-header" style="border-left-color: #ff69b4; background: var(--ac-surface); padding: 2rem; border-radius: var(--radius-md); box-shadow: var(--ac-shadow); margin-bottom: 2rem;">
    <h2 style="color: #d81b60; font-size: 1.6rem; font-weight: 900; margin-bottom: 1rem;">🌷 Die botanische Oase</h2>
    <p style="font-size: 1.05rem; line-height: 1.6;">
        Willkommen in der farbenfrohen Pflanzenwelt von <i>Animal Crossing: New Horizons</i>! 
        Blumen verschönern nicht nur deine Insellandschaft, sondern locken auch exklusive und seltene Insekten an.
    </p>
    <div style="display: flex; flex-direction: column; gap: 1rem; margin-top: 1.5rem;">
        <div style="background: rgba(248, 187, 208, 0.15); padding: 1rem 1.5rem; border-radius: 16px; border: 1px solid rgba(248, 187, 208, 0.3);">
            <strong style="color: #d81b60; display: block; margin-bottom: 0.3rem;">🧬 Hybriden züchten</strong>
            Schnapp dir deine Gießkanne! Durch geschicktes Aneinanderpflanzen und tägliches Gießen kannst du völlig neue Farben wie Pink, Schwarz oder sogar die extrem seltene blaue Rose erschaffen.
        </div>
        <div style="background: rgba(242, 192, 70, 0.15); padding: 1rem 1.5rem; border-radius: 16px; border: 1px solid rgba(242, 192, 70, 0.3);">
            <strong style="color: #d39e00; display: block; margin-bottom: 0.3rem;">⭐ Prestige-Tipp</strong>
            Hast du erst einmal ein makelloses 5-Sterne-Rating für deine Insel erreicht, wachsen an deinen Klippen ganz von allein die edlen <em>Maiglöckchen</em>. Ein wahres Statussymbol!
        </div>
    </div>
</div>

<link rel="stylesheet" href="/assets/css/faunapedia.css">
<link rel="stylesheet" href="/assets/css/flowers.css">

<!-- ✨ FABULOUS MINI GRID SECTION ✨ -->
<div class="faunapedia-section" data-category="flowers">
    <div style="text-align: center; margin-bottom: 1.5rem; padding-bottom: 1.5rem; border-bottom: 3px dotted rgba(248, 187, 208, 0.5);">
        <h3 style="font-weight: 900; color: var(--ac-text); margin: 0;">Schnellnavigation</h3>
        <p style="font-size: 0.9rem; color: var(--ac-text-muted); margin-top: 0.3rem;">Springe direkt zur gewünschten Art</p>
    </div>

    <!-- 3x3 Grid für die 9 Blumenarten -->
    <div class="creature-grid-mini">
        <?php if(!empty($flowers)): ?>
            <?php foreach ($flowers as $f): ?>
                <a href="#flower-<?= $f->id ?>" 
                   class="mini-card" 
                   data-id="<?= $f->id ?>"
                   title="<?= htmlspecialchars($f->name) ?>">
                    <div class="mini-card-inner" style="border-radius: 20px;">
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