<!-- Wir fügen hier die dynamische ID hinzu, damit der Link und der Filter ihr Ziel finden! -->
<article class="creature-card" id="creature-<?= $creature->id ?>">
    
    <div class="card-content-top">
        <div class="img-container">
            <img src="/assets/img/acnh/<?= htmlspecialchars($creature->image_path) ?>" 
                 alt="<?= htmlspecialchars($creature->name) ?>"
                 loading="lazy"
                 onerror="this.src='/assets/img/acnh/placeholder.png'">
        </div>
        
        <div class="details-container">
            <div class="card-header-flex">
                <span class="name"><?= htmlspecialchars($creature->name) ?></span>
                <div class="price-tag">
                    <span>💰</span> <?= number_format($creature->price, 0, ',', '.') ?> Sternis
                </div>
            </div>

            <div class="creature-info-list">
                <div class="info-row">
                    <span class="info-label">📍 Ort:</span>
                    <span class="info-value"><?= htmlspecialchars($creature->location) ?></span>
                </div>
                <div class="info-row">
                    <span class="info-label">⏰ Zeit:</span>
                    <span class="info-value"><?= htmlspecialchars($creature->time_active) ?></span>
                </div>
                
                <!-- NEU: Schatten-Anzeige (Wird nur ausgegeben, wenn Daten vorhanden sind) -->
                <?php if (!empty($creature->shadow_image)): ?>
                <div class="info-row">
                    <span class="info-label">👤 Schatten:</span>
                    <span class="info-value">
                        <img src="/assets/img/acnh/<?= htmlspecialchars($creature->shadow_image) ?>" 
                             alt="Schattengröße" 
                             class="shadow-icon"
                             loading="lazy">
                    </span>
                </div>
                <?php endif; ?>
            </div>
            
            <!-- Das Monats-Grid im fabelhaften Nook-Design -->
            <div class="month-grid-container">
                <?php 
                $months = [
                    1 => 'Jan', 2 => 'Feb', 3 => 'Mär', 4 => 'Apr', 
                    5 => 'Mai', 6 => 'Jun', 7 => 'Jul', 8 => 'Aug', 
                    9 => 'Sep', 10 => 'Okt', 11 => 'Nov', 12 => 'Dez'
                ];
                foreach ($months as $num => $mName): 
                    $isActive = $creature->isActiveInMonth($num);
                ?>
                    <div class="month-box <?= $isActive ? 'active' : 'inactive' ?>">
                        <?= $mName ?>
                    </div>
                <?php endforeach; ?>
            </div>
        </div>
    </div>

    <?php if (!empty($creature->catchphrase)): ?>
    <div class="catchphrase-box">
        "<?= htmlspecialchars($creature->catchphrase) ?>"
    </div>
    <?php endif; ?>

</article>