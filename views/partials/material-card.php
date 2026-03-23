<div class="material-card">
    <div class="material-img">
        <img src="<?= htmlspecialchars($material->getImageUrl()) ?>" 
             alt="<?= htmlspecialchars($material->name) ?>"
             loading="lazy"
             onerror="this.src='/assets/img/acnh/koeder.png'">
    </div>
    
    <div class="material-details">
        <span class="material-name"><?= htmlspecialchars($material->name) ?></span>
        
        <span class="material-source" title="<?= htmlspecialchars($material->source) ?>">
            📍 <?= htmlspecialchars($material->source) ?>
        </span>
        
        <span class="material-price">
            💰 <?= htmlspecialchars($material->sell_price) ?>
        </span>
    </div>
</div>