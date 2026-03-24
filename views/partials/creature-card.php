<!-- Wir fügen hier die dynamische ID hinzu, damit der Link und der Filter ihr Ziel finden! -->
<article class="creature-card" id="creature-<?= $creature->id ?>">
    
    <div class="card-content-top">
        <!-- Image: Immer fest oben links verankert -->
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
                    <span>💰</span> <?= htmlspecialchars($creature->getFormattedPrice()) ?>
                </div>
            </div>

            <div class="creature-info-list">
                <!-- ORT -->
                <?php if (!empty($creature->location)): ?>
                <div class="info-row">
                    <span class="info-label">📍 Ort:</span>
                    <span class="info-value"><?= htmlspecialchars($creature->location) ?></span>
                </div>
                <?php endif; ?>

                <!-- ZEIT -->
                <div class="info-row">
                    <span class="info-label">⏰ Zeit:</span>
                    <span class="info-value"><?= htmlspecialchars($creature->time_active) ?></span>
                </div>
                
                <!-- SCHATTEN (Flexibel für Fischbild oder CSS-Kreis bei Meerestieren) -->
                <?php if (!empty($creature->shadow_image)): ?>
                <div class="info-row">
                    <span class="info-label">👤 Schatten:</span>
                    <span class="info-value">
                        <?php if ($creature->category === 'sea'): ?>
                            <!-- Schwarzer Kreis & Text für Meerestiere -->
                            <?php 
                                $shadowClass = str_replace(' ', '-', strtolower(htmlspecialchars($creature->shadow_image))); 
                                $shadowClass = str_replace('ß', 'ss', $shadowClass); 
                            ?>
                            <div class="shadow-circle shadow-<?= $shadowClass ?>"></div>
                            <span style="text-transform: capitalize;"><?= htmlspecialchars($creature->shadow_image) ?></span>
                        <?php else: ?>
                            <!-- Fisch-Schatten-Grafik -->
                            <img src="/assets/img/acnh/<?= htmlspecialchars($creature->shadow_image) ?>" 
                                 alt="Schattengröße" 
                                 class="shadow-icon"
                                 loading="lazy">
                        <?php endif; ?>
                    </span>
                </div>
                <?php endif; ?>

                <!-- BEWEGUNG / GESCHWINDIGKEIT (Nur für Meerestiere) -->
                <?php if (!empty($creature->speed)): ?>
                <div class="info-row">
                    <span class="info-label">💨 Tempo:</span>
                    <span class="info-value" style="text-transform: capitalize;">
                        <?= htmlspecialchars($creature->speed) ?>
                    </span>
                </div>
                <?php endif; ?>

                <!-- WETTER (Für Insekten) -->
                <?php if (!empty($creature->weather)): ?>
                <div class="info-row">
                    <span class="info-label">⛅ Wetter:</span>
                    <span class="info-value">
                        <?php if ($creature->weather === 'Sonne' || $creature->weather === 'Jedes'): ?>
                            <img src="/assets/img/acnh/sun.png" alt="Sonne" class="weather-icon" title="Bei Sonnenschein">
                        <?php endif; ?>
                        <?php if ($creature->weather === 'Regen' || $creature->weather === 'Jedes'): ?>
                            <img src="/assets/img/acnh/rain.png" alt="Regen" class="weather-icon" title="Bei Regen">
                        <?php endif; ?>
                    </span>
                </div>
                <?php endif; ?>
            </div>
            
        </div>
    </div>

    <!-- Catchphrase (Blathers' Style) -->
    <?php if (!empty($creature->catchphrase)): ?>
    <div class="catchphrase-box">
        "<?= htmlspecialchars($creature->catchphrase) ?>"
    </div>
    <?php endif; ?>

    <!-- Monats-Grid (Immer fest am unteren Rand der Karte verankert durch margin-top: auto) -->
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

</article>