<?php include 'partials/header.php'; ?>

<div class="hero">
    <h1><?= htmlspecialchars($title) ?></h1>
    <p>Verpasse keine Partys, Turniere und besonderen Gäste mehr!</p>
</div>

<?php if (isset($infoTemplate) && file_exists(__DIR__ . '/' . $infoTemplate)): ?>
    <div class="info-box">
        <?php include $infoTemplate; ?>
    </div>
<?php endif; ?>

<?php
// Monats-Konfiguration für die visuelle Darstellung (Icons & Namen)
$monthNames = [
    1 => ['name' => 'Januar', 'icon' => '⛄'],
    2 => ['name' => 'Februar', 'icon' => '💝'],
    3 => ['name' => 'März', 'icon' => '☘️'],
    4 => ['name' => 'April', 'icon' => '🌸'],
    5 => ['name' => 'Mai', 'icon' => '🌿'],
    6 => ['name' => 'Juni', 'icon' => '☀️'],
    7 => ['name' => 'Juli', 'icon' => '🐚'],
    8 => ['name' => 'August', 'icon' => '🎇'],
    9 => ['name' => 'September', 'icon' => '🍇'],
    10 => ['name' => 'Oktober', 'icon' => '🎃'],
    11 => ['name' => 'November', 'icon' => '🍄'],
    12 => ['name' => 'Dezember', 'icon' => '🎄'],
];
?>

<div class="events-container">
    <?php 
    $hasEvents = false;
    for ($m = 1; $m <= 12; $m++): 
        if (!empty($eventsByMonth[$m])): 
            $hasEvents = true;
    ?>
        <!-- Native, Mobile-First Collapsible (Akkordeon) ohne extra JS-Klick-Listener -->
        <details class="month-group" id="month-group-<?= $m ?>" open>
            <summary class="month-summary">
                <span class="month-title">
                    <span class="month-icon"><?= $monthNames[$m]['icon'] ?></span>
                    <?= $monthNames[$m]['name'] ?>
                </span>
                <span class="summary-chevron">▼</span>
            </summary>
            
            <div class="creature-grid month-grid">
                <?php foreach ($eventsByMonth[$m] as $event): ?>
                    <?php include 'partials/event-card.php'; ?>
                <?php endforeach; ?>
            </div>
        </details>
    <?php 
        endif; 
    endfor; 
    ?>

    <?php if (!$hasEvents): ?>
        <div style="text-align: center; padding: 50px;">
            <p style="font-size: 1.5rem;">🎈 Aktuell sind keine Events geplant...</p>
        </div>
    <?php endif; ?>
</div>

<?php include 'partials/footer.php'; ?>