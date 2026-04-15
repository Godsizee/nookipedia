<?php include __DIR__ . '/../partials/header.php'; ?>
<link rel="stylesheet" href="/assets/css/faunapedia.css">
<link rel="stylesheet" href="/assets/css/museum.css">

<div class="museum-hero hero-fish">
    <div class="museum-hero-icon">🐟</div>
    <h1><?= htmlspecialchars($title) ?></h1>
    <p class="hero-fish-subtitle">Tauche ein in die gigantischen Wassertanks und Flusstunnel.</p>
</div>

<div class="section-fish">
    <div class="creature-grid-mini grid-8-cols">
        <?php if(!empty($creatures)): ?>
            <?php foreach ($creatures as $c): ?>
                <a href="/fische#creature-<?= $c->id ?>" 
                   class="mini-card" data-id="<?= $c->id ?>" 
                   title="Details zu: <?= htmlspecialchars($c->name) ?>">
                    <div class="mini-card-inner">
                        <img src="/assets/img/acnh/<?= htmlspecialchars($c->image_path) ?>" alt="<?= htmlspecialchars($c->name) ?>" loading="lazy" onerror="this.src='/assets/img/acnh/koeder.png'">
                    </div>
                </a>
            <?php endforeach; ?>
        <?php endif; ?>
    </div>
</div>

<?php include __DIR__ . '/../partials/footer.php'; ?>