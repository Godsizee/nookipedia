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
                <span class="meta-badge recipe-source">
                    <img src="/assets/img/acnh/erhalten_von.png" alt="Quelle" class="meta-icon">
                    <?= htmlspecialchars($recipe->source) ?>
                </span>
            <?php endif; ?>
            
            <?php if($recipe->sell_price): ?>
                <span class="meta-badge recipe-price">
                    <img src="/assets/img/acnh/64px-99k_Bells_NH_Inv_Icon.png" alt="Preis" class="meta-icon">
                    <?= htmlspecialchars($recipe->sell_price) ?>
                </span>
            <?php endif; ?>
            
            <?php if($recipe->durability): ?>
                <span class="meta-badge recipe-durability">
                    <img src="/assets/img/acnh/haltbarkeoit.png" alt="Haltbarkeit" class="meta-icon">
                    Haltbarkeit: <?= htmlspecialchars($recipe->durability) ?>
                </span>
            <?php endif; ?>
        </div>
        
        <?php if(!empty($recipe->materials)): ?>
            <div class="recipe-materials-interactive">
                <strong style="font-size: 0.85rem; color: var(--ac-text-muted); text-transform: uppercase; letter-spacing: 0.5px;">Zutaten:</strong>
                <div class="material-links-wrapper">
                    <?php foreach($recipe->materials as $mat): ?>
                        <a href="/materialien#mat-<?= $mat->id ?>" class="material-link-badge" title="Gehe zu <?= htmlspecialchars($mat->name) ?>">
                            <img src="/assets/img/acnh/materials/<?= htmlspecialchars($mat->image_path) ?>" alt="<?= htmlspecialchars($mat->name) ?>">
                            <span><?= htmlspecialchars($mat->amount) ?>x <?= htmlspecialchars($mat->name) ?></span>
                        </a>
                    <?php endforeach; ?>
                </div>
            </div>
        <?php elseif($recipe->materials_desc): ?>
            <div class="recipe-materials">
                <strong>Zutaten:</strong> <?= htmlspecialchars($recipe->materials_desc) ?>
            </div>
        <?php endif; ?>
    </div>
</div>