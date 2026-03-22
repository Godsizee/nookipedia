<?php include 'partials/header.php'; ?>

<div class="hero">
    <h1><?= htmlspecialchars($title) ?></h1>
    <p>Verwandle deine Insel in ein florales Paradies.</p>
</div>

<!-- Modulares Einbinden der Info-Texte (SRP) -->
<?php if (isset($infoTemplate) && file_exists(__DIR__ . '/' . $infoTemplate)): ?>
    <div class="info-box">
        <?php include $infoTemplate; ?>
    </div>
<?php endif; ?>

<div class="creature-grid">
    <?php if (empty($flowers)): ?>
        <div style="grid-column: 1/-1; text-align: center; padding: 50px;">
            <p style="font-size: 1.5rem;">🥀 Hier blüht aktuell noch nichts...</p>
        </div>
    <?php else: ?>
        <?php foreach ($flowers as $flower): ?>
            <?php include 'partials/flower-card.php'; ?>
        <?php endforeach; ?>
    <?php endif; ?>
</div>

<?php include 'partials/footer.php'; ?>