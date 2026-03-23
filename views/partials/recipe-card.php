<div class="recipe-card">
    <div class="recipe-img">
        <img src="<?= htmlspecialchars($recipe->getImageUrl()) ?>" 
             alt="<?= htmlspecialchars($recipe->name) ?>"
             loading="lazy"
             onerror="this.src='/assets/img/acnh/koeder.png'">
    </div>
    
    <div class="recipe-details">
        <div class="recipe-header">
            <span class="recipe-name"><?= htmlspecialchars($recipe->name) ?></span>
            <?php if($recipe->is_customizable): ?>
                <span class="badge-customizable" title="Dieses Item kann umgestaltet (und so repariert) werden!">🎨 Umgestaltbar</span>
            <?php endif; ?>
        </div>
        
        <div class="recipe-meta">
            <?php if($recipe->source): ?>
                <span class="recipe-source">📍 <?= htmlspecialchars($recipe->source) ?></span>
            <?php endif; ?>
            
            <?php if($recipe->sell_price): ?>
                <span class="recipe-price">💰 <?= htmlspecialchars($recipe->sell_price) ?></span>
            <?php endif; ?>
            
            <?php if($recipe->durability): ?>
                <span class="recipe-durability">🔨 Haltbarkeit: <?= htmlspecialchars($recipe->durability) ?></span>
            <?php endif; ?>
        </div>
        
        <?php if($recipe->materials_desc): ?>
            <div class="recipe-materials">
                <strong>Zutaten:</strong> <?= htmlspecialchars($recipe->materials_desc) ?>
            </div>
        <?php endif; ?>
    </div>
</div>