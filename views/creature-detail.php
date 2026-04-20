<?php 
// Bestimme Kategorie-Details und grammatikalisch korrekte Button-Label
$catName = '';
$backLink = '/';
$icon = '';
$gradient = 'linear-gradient(to bottom, #2c4a3d 0%, #1a2e25 100%)';
$btnLabel = 'Übersicht';

if ($creature->category === 'fish') {
    $catName = 'Fisch';
    $backLink = '/fische';
    $icon = '🐟';
    $gradient = 'linear-gradient(135deg, #0277bd 0%, #011d4a 100%)';
    $btnLabel = 'Fische-Übersicht';
} elseif ($creature->category === 'insect') {
    $catName = 'Insekt';
    $backLink = '/insekten';
    $icon = '🦋';
    $gradient = 'linear-gradient(135deg, #2e7d32 0%, #0d2112 100%)';
    $btnLabel = 'Insekten-Übersicht';
} elseif ($creature->category === 'sea') {
    $catName = 'Meerestier';
    $backLink = '/meerestiere';
    $icon = '🐙';
    $gradient = 'linear-gradient(135deg, #6a1b9a 0%, #200542 100%)';
    $btnLabel = 'Meerestiere-Übersicht';
}

include 'partials/header.php'; 
?>
<link rel="stylesheet" href="/assets/css/creature-detail.css">

<div class="detail-hero" style="background: <?= $gradient ?>;">
    <div class="detail-icon-wrap">
        <img src="<?= htmlspecialchars($creature->getImageUrl()) ?>" alt="<?= htmlspecialchars($creature->name) ?>" onerror="this.src='/assets/img/acnh/koeder.png'">
    </div>
    <h1 class="detail-title"><?= htmlspecialchars($creature->name) ?></h1>
    <div class="detail-subtitle"><?= $icon ?> <?= $catName ?></div>
</div>

<div class="detail-content-card">
    
    <?php if(!empty($creature->catchphrase)): ?>
        <div class="detail-quote">
            <?= htmlspecialchars($creature->catchphrase) ?>
        </div>
    <?php endif; ?>

    <div class="detail-grid">
        
        <div>
            <h3 class="section-heading">📋 Insel-Akte</h3>
            <div class="data-list">
                
                <div class="data-row">
                    <div class="data-icon icon-price">💰</div>
                    <div class="data-content">
                        <span class="data-label">Verkaufspreis</span>
                        <span class="data-value"><?= htmlspecialchars($creature->getFormattedPrice()) ?></span>
                    </div>
                </div>
                
                <div class="data-row">
                    <div class="data-icon icon-location">📍</div>
                    <div class="data-content">
                        <span class="data-label">Fundort</span>
                        <span class="data-value"><?= htmlspecialchars($creature->location_name ?? $creature->location ?? 'Unbekannt') ?></span>
                    </div>
                </div>
                
                <div class="data-row">
                    <div class="data-icon icon-time">⌚</div>
                    <div class="data-content">
                        <span class="data-label">Uhrzeit</span>
                        <span class="data-value">
                            <?= htmlspecialchars(implode(', ', $creature->time_array ?? [$creature->time_active])) ?: 'Ganzjährig' ?>
                        </span>
                    </div>
                </div>
                
                <?php if ($creature->category === 'fish' || $creature->category === 'sea'): ?>
                <div class="data-row">
                    <div class="data-icon icon-shadow">👤</div>
                    <div class="data-content">
                        <span class="data-label">Schatten</span>
                        <span class="data-value" style="display: flex; align-items: center; gap: 8px;">
                            <?php 
                            $shadowVal = $creature->shadow_image ?? $creature->shadow ?? '';
                            if ($shadowVal): 
                            ?>
                                <span class="shadow-circle shadow-<?= strtolower(str_replace(' ', '-', $shadowVal)) ?>"></span>
                            <?php endif; ?>
                            <?= htmlspecialchars($shadowVal ?: 'N/A') ?>
                        </span>
                    </div>
                </div>
                <?php endif; ?>

                <?php if (!empty($creature->speed)): ?>
                <div class="data-row">
                    <div class="data-icon icon-speed">💨</div>
                    <div class="data-content">
                        <span class="data-label">Geschwindigkeit</span>
                        <span class="data-value"><?= htmlspecialchars($creature->speed) ?></span>
                    </div>
                </div>
                <?php endif; ?>

                <?php if (!empty($creature->weather) && strtolower($creature->weather) !== 'beliebig'): ?>
                <div class="data-row">
                    <div class="data-icon icon-weather">
                        <?= (strpos(strtolower($creature->weather), 'regen') !== false) ? '🌧️' : '☀️' ?>
                    </div>
                    <div class="data-content">
                        <span class="data-label">Wetter-Bedingung</span>
                        <span class="data-value"><?= htmlspecialchars($creature->weather) ?></span>
                    </div>
                </div>
                <?php endif; ?>

            </div>
        </div>

        <div>
            <h3 class="section-heading">📅 Saison-Planer <span style="font-size:0.8rem; color:var(--ac-text-muted); font-weight:700;">(Nord)</span></h3>
            <?php
                $allMonths = ['Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'];
                $activeMonths = $creature->months_northern ?? []; 
            ?>
            <div class="month-grid-premium">
                <?php foreach($allMonths as $index => $monthName): 
                    $monthNum = $index + 1;
                    $isActive = is_array($activeMonths) && in_array($monthNum, $activeMonths);
                    $cssClass = $isActive ? 'active' : 'inactive';
                ?>
                    <div class="month-pill <?= $cssClass ?>"><?= $monthName ?></div>
                <?php endforeach; ?>
            </div>
            
            <?php if (is_array($activeMonths) && count($activeMonths) === 12): ?>
                <div style="margin-top: 1.5rem; padding: 1rem; background: var(--ac-green-light); color: var(--ac-green); border-radius: var(--radius-sm); text-align: center; font-weight: 800;">
                    ✅ Ganzjährig fangbar!
                </div>
            <?php endif; ?>
        </div>
        
    </div>

    <div class="detail-actions">
        <a href="<?= $backLink ?>" class="btn-detail-back">
            <span class="btn-icon">←</span>
            <span class="btn-text">Zurück zur <?= $btnLabel ?></span>
        </a>
    </div>
</div>

<?php include 'partials/footer.php'; ?>