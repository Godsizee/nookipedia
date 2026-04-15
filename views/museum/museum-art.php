<?php include __DIR__ . '/../partials/header.php'; ?>
<link rel="stylesheet" href="/assets/css/museum.css">

<div class="museum-hero art-hero">
    <div class="art-hero-icon">🖼️</div>
    <h1><?= htmlspecialchars($title) ?></h1>
    <p class="art-hero-subtitle">Hüte dich vor Reiners raffinierten Fälschungen! Hier lernst du den Unterschied.</p>
</div>

<div class="art-grid">
    <?php if (empty($artworks)): ?>
        <div class="museum-empty-state" style="grid-column: 1/-1;">
            <p>🎨 Die Galerie ist momentan leer...</p>
        </div>
    <?php else: ?>
        <?php foreach ($artworks as $art): ?>
            <a href="/museum/kunstwerke/<?= $art->id ?>" class="art-card">
                <div class="art-img-container">
                    <img src="<?= htmlspecialchars($art->getRealImageUrl()) ?>" alt="<?= htmlspecialchars($art->name) ?>" loading="lazy" onerror="this.src='/assets/img/acnh/placeholder.png'">
                </div>
                <div class="art-info">
                    <div class="art-title"><?= htmlspecialchars($art->name) ?></div>
                    <div class="art-artist"><?= htmlspecialchars($art->artist) ?></div>
                    
                    <?php if ($art->hasFake()): ?>
                        <span class="art-badge-fake">⚠️ Fälschung existiert</span>
                    <?php else: ?>
                        <span class="art-badge-real">✅ Immer echt</span>
                    <?php endif; ?>
                </div>
            </a>
        <?php endforeach; ?>
    <?php endif; ?>
</div>

<?php include __DIR__ . '/../partials/footer.php'; ?>
