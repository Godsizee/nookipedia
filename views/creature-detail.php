<?php 
// Bestimme Kategorie-Namen, Farbe und Zurück-Link
$catName = '';
$backLink = '/';
$icon = '';
$gradient = 'linear-gradient(to bottom, #2c4a3d 0%, #1a2e25 100%)';

if ($creature->category === 'fish') {
    $catName = 'Fisch';
    $backLink = '/fische';
    $icon = '🐟';
    $gradient = 'radial-gradient(circle at top, #0277bd 0%, #011d4a 100%)';
} elseif ($creature->category === 'insect') {
    $catName = 'Insekt';
    $backLink = '/insekten';
    $icon = '🦋';
    $gradient = 'radial-gradient(circle at top, #2e7d32 0%, #0d2112 100%)';
} elseif ($creature->category === 'sea') {
    $catName = 'Meerestier';
    $backLink = '/meerestiere';
    $icon = '🐙';
    $gradient = 'radial-gradient(circle at top, #6a1b9a 0%, #200542 100%)';
}

include 'partials/header.php'; 
?>
<link rel="stylesheet" href="/assets/css/creature-detail.css">

<!-- Hero Bereich -->
<div class="detail-hero" style="background: <?= $gradient ?>;">
    <div class="detail-icon-wrap">
        <img src="<?= htmlspecialchars($creature->getImageUrl()) ?>" alt="<?= htmlspecialchars($creature->name) ?>" onerror="this.src='/assets/img/acnh/koeder.png'">
    </div>
    <h1 class="detail-title"><?= htmlspecialchars($creature->name) ?></h1>
    <div class="detail-subtitle"><?= $icon ?> <?= $catName ?></div>
</div>

<!-- Hauptinhalt -->
<div class="detail-content-card">
    
    <!-- Floskel-Box (z.B. "Ein Schmetterling! Flatterhaft!") -->
    <?php if(!empty($creature->catchphrase)): ?>
        <div class="catchphrase-box" style="margin-top: 0; margin-bottom: 2rem; font-size: 1.1rem; padding: 1.5rem;">
            „<?= htmlspecialchars($creature->catchphrase) ?>“
        </div>
    <?php endif; ?>

    <div class="detail-grid">
        <!-- Linke Spalte: Basisdaten -->
        <div class="detail-info-box">
            <h3>📋 Basisdaten</h3>
            <div class="creature-info-list">
                <div class="info-row">
                    <span class="info-label">Verkaufspreis</span>
                    <span class="info-value price-tag" style="font-size: 1rem; padding: 4px 12px;">💰 <?= htmlspecialchars($creature->getFormattedPrice()) ?></span>
                </div>
                
                <!-- Nutzt location_name aus deinem JOIN -->
                <div class="info-row">
                    <span class="info-label">Fundort</span>
                    <span class="info-value">📍 <?= htmlspecialchars($creature->location_name ?? $creature->location ?? 'Unbekannt') ?></span>
                </div>
                
                <div class="info-row">
                    <span class="info-label">Uhrzeit</span>
                    <span class="info-value">⌚ <?= htmlspecialchars(implode(', ', $creature->time_array ?? [])) ?: 'Immer' ?></span>
                </div>
                
                <!-- Nutzt shadow_image aus deinem JOIN -->
                <?php if ($creature->category === 'fish' || $creature->category === 'sea'): ?>
                <div class="info-row">
                    <span class="info-label">Schatten</span>
                    <span class="info-value">
                        <?php 
                        $shadowVal = $creature->shadow_image ?? $creature->shadow ?? '';
                        if ($shadowVal): 
                        ?>
                            <span class="shadow-circle shadow-<?= strtolower(str_replace(' ', '-', $shadowVal)) ?>"></span>
                        <?php endif; ?>
                        <?= htmlspecialchars($shadowVal ?: 'N/A') ?>
                    </span>
                </div>
                <?php endif; ?>

                <!-- NEU: Nutzt speed aus deinem JOIN (Relevant für Meerestiere) -->
                <?php if (!empty($creature->speed)): ?>
                <div class="info-row">
                    <span class="info-label">Geschwindigkeit</span>
                    <span class="info-value">💨 <?= htmlspecialchars($creature->speed) ?></span>
                </div>
                <?php endif; ?>

                <!-- Nutzt weather aus deinem JOIN -->
                <?php if (!empty($creature->weather) && strtolower($creature->weather) !== 'beliebig'): ?>
                <div class="info-row">
                    <span class="info-label">Wetter</span>
                    <span class="info-value">🌧️ <?= htmlspecialchars($creature->weather) ?></span>
                </div>
                <?php endif; ?>
            </div>
        </div>

        <!-- Rechte Spalte: Saisonale Daten -->
        <div class="detail-info-box">
            <h3>📅 Aktivität (Nordhalbkugel)</h3>
            <?php
                $allMonths = ['Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'];
                // Stelle sicher, dass months_northern ein Array ist. Falls es als String aus der DB kommt (z.B. JSON), muss es im Model decodiert werden.
                $activeMonths = $creature->months_northern ?? []; 
            ?>
            <div class="month-grid-xl">
                <?php foreach($allMonths as $index => $monthName): 
                    $monthNum = $index + 1;
                    $isActive = is_array($activeMonths) && in_array($monthNum, $activeMonths);
                    $cssClass = $isActive ? 'active' : 'inactive';
                ?>
                    <div class="month-box-xl <?= $cssClass ?>"><?= $monthName ?></div>
                <?php endforeach; ?>
            </div>
            
            <?php if (is_array($activeMonths) && count($activeMonths) === 12): ?>
                <p style="text-align: center; margin-top: 1rem; color: var(--ac-green); font-weight: 800;">
                    ✅ Ist das ganze Jahr über fangbar!
                </p>
            <?php endif; ?>
        </div>
    </div>

    <!-- Zurück-Button -->
    <div style="text-align: center; margin-top: 3rem;">
        <a href="<?= $backLink ?>" class="btn-museum-back" style="border-color: var(--ac-green);">
            ← Zurück zur <?= $catName ?>-Übersicht
        </a>
    </div>
</div>

<?php include 'partials/footer.php'; ?>