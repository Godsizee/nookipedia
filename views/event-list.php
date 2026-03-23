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

<div class="creature-grid">
    <?php if (empty($events)): ?>
        <div style="grid-column: 1/-1; text-align: center; padding: 50px;">
            <p style="font-size: 1.5rem;">🎈 Aktuell sind keine Events geplant...</p>
        </div>
    <?php else: ?>
        <?php foreach ($events as $event): ?>
            <?php include 'partials/event-card.php'; ?>
        <?php endforeach; ?>
    <?php endif; ?>
</div>

<?php include 'partials/footer.php'; ?>