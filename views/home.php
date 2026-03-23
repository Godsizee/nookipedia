<?php 
$title = "Willkommen auf Nookipedia";
include 'partials/header.php'; 
?>

<section class="hero">
    <div style="font-size: 4rem; margin-bottom: 10px;">🏝️</div>
    <h1>Nookipedia Next</h1>
    <p>Dein ultimativer und fabelhafter Begleiter für Animal Crossing: New Horizons.</p>
</section>

<div class="category-selection">
    <!-- Verzweigt zur Insekten-Seite, von wo aus auf Fische & Meerestiere navigiert werden kann -->
    <a href="/insekten" class="cat-card faunapaedie">
        <i>🦉</i>
        <span>Faunapädie</span>
    </a>
    
    <!-- Link für Blumen (aktuell noch ohne Route, bereitet aber den Ausbau vor) -->
    <a href="/blumen" class="cat-card flowers">
        <i>🌷</i>
        <span>Pflanzenwelt</span>
    </a>


    <!-- NEU: Link für Feiertage & Events -->
    <a href="/events" class="cat-card events">
        <i>🎈</i>
        <span>Feiertage & Events</span>
    </a>

        <a href="/materialien" class="cat-card" style="border-color: rgba(41, 182, 246, 0.4);">
        <i>🪓</i>
        <span>Materialien & Zutaten</span>
    </a>

        <a href="/bastelanleitungen" class="cat-card" style="border-color: rgba(255, 152, 0, 0.4);">
        <i>🛠️🍳</i>
        <span>Bastelanleitungen & Kochrezepte</span>
    </a>
    
</div>

<div style="margin-top: 40px; text-align: center;">
    <p style="color: var(--ac-text-muted); font-size: 0.9rem;">
        Wähle eine Kategorie aus, um zu sehen, was du gerade auf deiner Insel entdecken kannst!
    </p>
</div>

<?php include 'partials/footer.php'; ?>