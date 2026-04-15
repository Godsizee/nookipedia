<?php include __DIR__ . '/../partials/header.php'; ?>
<link rel="stylesheet" href="/assets/css/events.css"> 
<link rel="stylesheet" href="/assets/css/museum.css">

<div class="museum-hero fossil-hero">
    <div class="fossil-hero-icon">🦴</div>
    <h1><?= htmlspecialchars($title) ?></h1>
    <p class="fossil-hero-subtitle">Entdecke die faszinierenden Überreste vergangener Zeitalter.</p>
</div>

<div class="events-container">
    <?php if (empty($groupedFossils) && empty($standaloneFossils)): ?>
        <div class="museum-empty-state">
            <p>🏜️ Noch keine Fossilien ausgegraben...</p>
        </div>
    <?php else: ?>
        
        <?php foreach ($groupedFossils as $groupName => $fossils): ?>
            <details class="month-group fossil-group">
                <summary class="month-summary fossil-summary">
                    <span class="month-title">🦕 <?= htmlspecialchars($groupName) ?></span>
                    <span class="summary-chevron">▼</span>
                </summary>
                
                <div class="month-grid fossil-grid">
                    <div class="fossil-card-grid">
                        <?php foreach ($fossils as $fossil): ?>
                            <div class="fossil-card">
                                <div class="fossil-img-wrap">
                                    <img src="<?= htmlspecialchars($fossil->getImageUrl()) ?>" alt="<?= htmlspecialchars($fossil->name) ?>" loading="lazy" onerror="this.src='/assets/img/acnh/koeder.png'">
                                </div>
                                <strong class="fossil-name"><?= htmlspecialchars($fossil->name) ?></strong>
                                <span class="price-tag fossil-price">💰 <?= htmlspecialchars($fossil->getFormattedPrice()) ?></span>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>
            </details>
        <?php endforeach; ?>

        <?php if (!empty($standaloneFossils)): ?>
            <details class="month-group fossil-group">
                <summary class="month-summary fossil-summary">
                    <span class="month-title">🪨 Einzelne Fossilien & Spuren</span>
                    <span class="summary-chevron">▼</span>
                </summary>
                <div class="month-grid fossil-grid">
                    <div class="fossil-card-grid">
                        <?php foreach ($standaloneFossils as $fossil): ?>
                            <div class="fossil-card">
                                <div class="fossil-img-wrap">
                                    <img src="<?= htmlspecialchars($fossil->getImageUrl()) ?>" alt="<?= htmlspecialchars($fossil->name) ?>" loading="lazy" onerror="this.src='/assets/img/acnh/koeder.png'">
                                </div>
                                <strong class="fossil-name"><?= htmlspecialchars($fossil->name) ?></strong>
                                <span class="price-tag fossil-price">💰 <?= htmlspecialchars($fossil->getFormattedPrice()) ?></span>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>
            </details>
        <?php endif; ?>

    <?php endif; ?>
</div>

<?php include __DIR__ . '/../partials/footer.php'; ?>
