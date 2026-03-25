<!-- Premium Horizontal/Vertical Card -->
<a href="/blume?id=<?= $flower->id ?>" class="flower-card-premium" id="flower-<?= $flower->id ?>">
    
    <!-- 1. The Visual (Floating Image) -->
    <div class="flower-visual-wrapper">
        <img src="<?= htmlspecialchars($flower->getImageUrl()) ?>" 
             alt="<?= htmlspecialchars($flower->name) ?>"
             loading="lazy"
             onerror="this.src='/assets/img/acnh/koeder.png'">
    </div>
    
    <!-- 2. The Header Info (Name, Badge & Desc) -->
    <div class="flower-header-info">
        <h3 class="flower-title"><?= htmlspecialchars($flower->name) ?></h3>
        
        <div class="guide-badge" title="Zum Zucht-Guide für <?= htmlspecialchars($flower->name) ?>">
            <span>📖</span> Zucht-Guide
        </div>
        
        <p class="flower-desc">
            <?= htmlspecialchars($flower->description) ?>
        </p>
    </div>

    <!-- 3. The Color Pills (Zuchtfarben) -->
    <div class="flower-color-section">
        <span class="flower-color-label">Mögliche Zuchtfarben</span>
        <div class="flower-color-badges">
            <?php foreach($flower->colors as $color): ?>
                <?php 
                    // CSS-sichere Klasse für die neuen, echten Blumennamen (z.B. "Grengjer-Tulpe" -> "grengjer-tulpe")
                    // Wir wandeln alles in Kleinbuchstaben um, für ein einfaches Matching im CSS.
                    $colorClass = strtolower(trim($color)); 
                    $colorClass = str_replace(' ', '-', $colorClass); // Falls Leerzeichen existieren
                ?>
                <span class="color-badge color-<?= $colorClass ?>">
                    <?= htmlspecialchars(trim($color)) ?>
                </span>
            <?php endforeach; ?>
        </div>
    </div>
    
</a>