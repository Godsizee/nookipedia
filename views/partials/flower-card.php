<article class="creature-card" id="flower-<?= $flower->id ?>">
    <!-- Wir machen den gesamten Inhalt der Karte klickbar und leiten zum Zucht-Guide! -->
    <a href="/blume?id=<?= $flower->id ?>" style="text-decoration: none; color: inherit; display: flex; flex-direction: column; gap: 1rem; outline: none;">
        <div class="card-header">
            <div class="img-container" style="border-color: #f8bbd0;">
                <img src="<?= htmlspecialchars($flower->getImageUrl()) ?>" 
                     alt="<?= htmlspecialchars($flower->name) ?>"
                     loading="lazy"
                     onerror="this.src='/assets/img/acnh/koeder.png'">
            </div>
            
            <div class="title-price-wrap">
                <span class="name" style="display: flex; align-items: center; gap: 0.5rem; flex-wrap: wrap;">
                    <?= htmlspecialchars($flower->name) ?>
                    <!-- Auffälliger Button-Badge, der klarmacht, dass man hier klicken kann -->
                    <span style="font-size: 0.75rem; background: var(--ac-green); color: white; padding: 3px 8px; border-radius: 12px; box-shadow: 0 2px 6px rgba(89, 166, 131, 0.4); text-transform: uppercase; font-weight: 900; letter-spacing: 0.5px;">📖 Zucht-Guide</span>
                </span>
                <!-- Kleine Beschreibung statt Sternis -->
                <p style="font-size: 0.85rem; color: var(--ac-text-muted); line-height: 1.3; margin-top: 4px;">
                    <?= htmlspecialchars($flower->description) ?>
                </p>
            </div>
        </div>

        <div class="creature-info" style="border-top-color: #f8bbd0; cursor: pointer;">
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
    </a>
</article>