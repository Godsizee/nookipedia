<?php include 'partials/header.php'; ?>

<div class="hero">
    <h1><?= htmlspecialchars($title) ?></h1>
    <p>Alles, was du zum Basteln und Kochen auf deiner Insel benötigst!</p>
</div>

<link rel="stylesheet" href="/assets/css/faunapedia.css">
<link rel="stylesheet" href="/assets/css/events.css">
<link rel="stylesheet" href="/assets/css/materials.css">

<?php
// Konfiguration für die Kategorien (Collapsibles)
$categoryConfig = [
    'normal' => ['name' => '🪵 Basis-Materialien & Zutaten', 'desc' => 'Diese Ressourcen kannst du fast das ganze Jahr über auf deiner Insel sammeln oder anbauen.'],
    'seasonal' => ['name' => '❄️ Saisonale Materialien', 'desc' => 'Nur zu bestimmten Jahreszeiten oder an speziellen Feiertagen verfügbar.'],
    'other' => ['name' => '🧸 Möbel & Sonstiges', 'desc' => 'Möbelstücke oder Ausrüstungen, die als Basis für erweiterte Bastelanleitungen dienen.']
];
?>

<div class="events-container">
    <?php foreach ($categoryConfig as $catKey => $config): ?>
        <?php if (!empty($groupedMaterials[$catKey])): ?>
            
            <!-- Collapsible für jede Material-Kategorie -->
            <details class="month-group material-group" open>
                <summary class="month-summary">
                    <span class="month-title">
                        <?= $config['name'] ?>
                    </span>
                    <span class="summary-chevron">▼</span>
                </summary>
                
                <div class="month-grid">
                    <p style="margin-bottom: 1.5rem; color: var(--ac-text-muted); text-align: center;">
                        <i><?= $config['desc'] ?></i>
                    </p>
                    
                    <!-- Dichtes Grid für Materialien -->
                    <div class="material-grid">
                        <?php foreach ($groupedMaterials[$catKey] as $material): ?>
                            <?php include 'partials/material-card.php'; ?>
                        <?php endforeach; ?>
                    </div>
                </div>
            </details>

        <?php endif; ?>
    <?php endforeach; ?>
</div>

<?php include 'partials/footer.php'; ?>