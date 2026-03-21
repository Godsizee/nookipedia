<?php include 'partials/header.php'; ?>

<div class="hero">
    <h1><?= $title ?></h1>
    <p>Hier findest du alle Details zu den Bewohnern deiner Insel.</p>
</div>

<nav class="tab-nav">
    <a href="/insekten" class="tab-item <?= $category === 'insect' ? 'active' : '' ?>">🦋 Insekten</a>
    <a href="/fische" class="tab-item <?= $category === 'fish' ? 'active' : '' ?>">🐟 Fische</a>
    <a href="/meerestiere" class="tab-item <?= $category === 'sea' ? 'active' : '' ?>">🐙 Meerestiere</a>
</nav>

<div class="creature-grid">
    <?php if (empty($creatures)): ?>
        <div style="grid-column: 1/-1; text-align: center; padding: 50px;">
            <p style="font-size: 1.5rem;">🏜️ Hier ist es aktuell ziemlich leer...</p>
        </div>
    <?php else: ?>
        <?php foreach ($creatures as $creature): ?>
            <?php include 'partials/creature-card.php'; ?>
        <?php endforeach; ?>
    <?php endif; ?>
</div>

<?php include 'partials/footer.php'; ?>