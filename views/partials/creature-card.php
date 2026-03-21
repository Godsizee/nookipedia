<article class="creature-card">
    <div class="img-container">
        <img src="/assets/img/acnh/<?= htmlspecialchars($creature->image_path) ?>" 
             alt="<?= htmlspecialchars($creature->name) ?>"
             loading="lazy"
             onerror="this.src='/assets/img/acnh/koeder.png'">
    </div>
    
    <span class="name"><?= htmlspecialchars($creature->name) ?></span>
    
    <div class="price-tag">
        <span>💰</span> <?= number_format($creature->price, 0, ',', '.') ?>
    </div>

    <div class="creature-info">
        <div>
            <strong>⏰ Zeit:</strong>
            <span><?= htmlspecialchars($creature->time_active) ?></span>
        </div>
        <div>
            <strong>📅 Saison:</strong>
            <span><?= count($creature->months_northern) === 12 ? 'Ganzjährig' : count($creature->months_northern) . ' Monate' ?></span>
        </div>
    </div>

    <div class="catchphrase-box">
        "<?= htmlspecialchars($creature->catchphrase) ?>"
    </div>
</article>