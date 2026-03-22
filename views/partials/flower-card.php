<article class="creature-card" id="flower-<?= $flower->id ?>">
    <div class="card-header">
        <div class="img-container" style="border-color: #f8bbd0;">
<img src="<?= htmlspecialchars($flower->getImageUrl()) ?>" 
     alt="<?= htmlspecialchars($flower->name) ?>"
     loading="lazy"
     onerror="this.src='/assets/img/acnh/blumen/64px-Red_Roses_NH_Inv_Icon.png'">
        </div>
        
        <div class="title-price-wrap">
            <span class="name"><?= htmlspecialchars($flower->name) ?></span>
            <!-- Kleine Beschreibung statt Sternis -->
            <p style="font-size: 0.85rem; color: var(--ac-text-muted); line-height: 1.3;">
                <?= htmlspecialchars($flower->description) ?>
            </p>
        </div>
    </div>

    <div class="creature-info" style="border-top-color: #f8bbd0;">
        <div style="width: 100%;">
            <strong style="display:block; margin-bottom: 8px; color: #d81b60;">Mögliche Zuchtfarben:</strong>
            <div class="flower-color-badges">
                <?php foreach($flower->colors as $color): ?>
                    <?php 
                        // CSS-sichere Klasse generieren (z.B. "Rot" -> "rot")
                        $colorClass = strtolower(trim($color)); 
                    ?>
                    <span class="color-badge color-<?= $colorClass ?>">
                        <?= htmlspecialchars(trim($color)) ?>
                    </span>
                <?php endforeach; ?>
            </div>
        </div>
    </div>
</article>