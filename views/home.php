<?php 
$title = "Willkommen auf Nookipedia";
include 'partials/header.php'; 
?>

<section class="hero">
    <div style="font-size: 4rem; margin-bottom: 10px;">🏝️</div>
    <h1>Nookipedia Next</h1>
    <p>Dein ultimativer Begleiter für Animal Crossing: New Horizons.</p>
</section>

<div class="category-selection">
    <a href="/insekten" class="cat-card insects">
        <i>🦋</i>
        <span>Insekten</span>
    </a>
    <a href="/fische" class="cat-card fish">
        <i>🐟</i>
        <span>Fische</span>
    </a>
    <a href="/meerestiere" class="cat-card sea">
        <i>🐙</i>
        <span>Meerestiere</span>
    </a>
</div>

<div style="margin-top: 40px; text-align: center;">
    <p style="color: var(--text-muted); font-size: 0.9rem;">
        Wähle eine Kategorie aus, um zu sehen, was du gerade fangen kannst!
    </p>
</div>

<?php include 'partials/footer.php'; ?>