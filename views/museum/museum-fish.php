<?php include __DIR__ . '/../partials/header.php'; ?>
<link rel="stylesheet" href="/assets/css/faunapedia.css">
<link rel="stylesheet" href="/assets/css/museum.css">

<div class="museum-hero hero-fish">
    <div class="museum-hero-icon">🐟</div>
    <h1><?= htmlspecialchars($title) ?></h1>
    <p class="hero-fish-subtitle">Tauche ein in die gigantischen Wassertanks und Flusstunnel.</p>
</div>

<div class="faunapedia-section section-fish" data-category="fish">
    <div class="filter-controls">
        <label class="ac-checkbox">
            <input type="checkbox" id="filter-month">
            <span class="checkmark"></span>
            <span class="label-text">📅 Aktuell im Museum zu sehen</span>
        </label>
        <button id="clear-filters" class="btn-clear">🧹 Filter löschen</button>
    </div>

    <div class="creature-grid-mini grid-8-cols">
        <?php if(!empty($creatures)): ?>
            <?php foreach ($creatures as $c): ?>
                <?php $months = implode(',', $c->months_northern ?? []); ?>
                <a href="/fische#creature-<?= $c->id ?>" 
                   class="mini-card" data-id="<?= $c->id ?>" data-months="<?= htmlspecialchars($months) ?>" 
                   title="Details zu: <?= htmlspecialchars($c->name) ?>">
                    <div class="mini-card-inner">
                        <img src="/assets/img/acnh/<?= htmlspecialchars($c->image_path) ?>" alt="<?= htmlspecialchars($c->name) ?>" loading="lazy" onerror="this.src='/assets/img/acnh/koeder.png'">
                    </div>
                </a>
            <?php endforeach; ?>
        <?php endif; ?>
    </div>
</div>

<script type="module" src="/assets/js/faunapedia.js"></script>
<?php include __DIR__ . '/../partials/footer.php'; ?>
