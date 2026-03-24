<article class="recipe-card-premium">
    <div class="recipe-visual">
        <div class="visual-glow"></div>
        <img src="<?= htmlspecialchars($recipe->getImageUrl()) ?>" 
             alt="<?= htmlspecialchars($recipe->name) ?>"
             loading="lazy"
             onerror="this.src='/assets/img/acnh/koeder.png'"
             class="recipe-main-img">
    </div>
    
    <div class="recipe-content">
        <div class="recipe-header">
            <h3 class="recipe-title"><?= htmlspecialchars($recipe->name) ?></h3>
            <?php if($recipe->is_customizable): ?>
                <div class="badge-customizable" title="Dieses Item kann umgestaltet (und so repariert) werden!">
                    <span class="custom-icon">🎨</span>
                    <span class="custom-text">Umgestaltbar</span>
                </div>
            <?php endif; ?>
        </div>
        
        <div class="recipe-meta-tags">
            <?php if($recipe->source): ?>
                <div class="meta-tag tag-source">
                    <img src="/assets/img/acnh/erhalten_von.png" alt="Quelle" class="meta-icon">
                    <span class="meta-text">
                        <?php 
                            // Sucht nach Text in Klammern und wandelt ihn in einen Link um
                            $sourceHtml = htmlspecialchars($recipe->source);
                            echo preg_replace('/\((.*?)\)/', '(<a href="/nachbarn?perso=$1" class="personality-link">$1</a>)', $sourceHtml);
                        ?>
                    </span>
                </div>
            <?php endif; ?>
            
            <?php if($recipe->sell_price): ?>
                <div class="meta-tag tag-price">
                    <img src="/assets/img/acnh/64px-99k_Bells_NH_Inv_Icon.png" alt="Preis" class="meta-icon">
                    <span class="meta-text"><?= htmlspecialchars($recipe->sell_price) ?></span>
                </div>
            <?php endif; ?>
            
            <?php if($recipe->durability): ?>
                <div class="meta-tag tag-durability">
                    <img src="/assets/img/acnh/haltbarkeoit.png" alt="Haltbarkeit" class="meta-icon">
                    <span class="meta-text">Haltbarkeit: <?= htmlspecialchars($recipe->durability) ?></span>
                </div>
            <?php endif; ?>
        </div>
        
        <?php if(!empty($recipe->materials)): ?>
            <div class="recipe-materials-box">
                <div class="materials-header">Benötigte Zutaten</div>
                <div class="materials-list">
                    <?php foreach($recipe->materials as $mat): ?>
                        <a href="/materialien#mat-<?= $mat->id ?>" class="material-pill" title="Gehe zu <?= htmlspecialchars($mat->name) ?>">
                            <div class="material-pill-img">
                                <img src="/assets/img/acnh/materials/<?= htmlspecialchars($mat->image_path) ?>" alt="<?= htmlspecialchars($mat->name) ?>">
                            </div>
                            <span class="material-pill-text">
                                <strong><?= htmlspecialchars($mat->amount) ?>x</strong> <?= htmlspecialchars($mat->name) ?>
                            </span>
                        </a>
                    <?php endforeach; ?>
                </div>
            </div>
        <?php elseif($recipe->materials_desc): ?>
            <div class="recipe-materials-box fallback-desc">
                <div class="materials-header">Zutaten</div>
                <p><?= htmlspecialchars($recipe->materials_desc) ?></p>
            </div>
        <?php endif; ?>
    </div>
</article>