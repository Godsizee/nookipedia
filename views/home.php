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
    <a href="/insekten" class="cat-card faunapaedie">
        <i><img src="/assets/img/acnh/home/vogelfalter.png" alt="Faunapädie" style="max-width: 80%; max-height: 80%; object-fit: contain;"></i>
        <span>Faunapädie</span>
    </a>
    
    <a href="/blumen" class="cat-card flowers">
        <i><img src="/assets/img/acnh/home/Red_Cosmos_NL_Icon.png" alt="Pflanzenwelt" style="max-width: 80%; max-height: 80%; object-fit: contain;"></i>
        <span>Pflanzenwelt</span>
    </a>

    <a href="/events" class="cat-card events">
        <i><img src="/assets/img/acnh/home/64px-Red_Balloon_NH_Icon.png" alt="Feiertage & Events" style="max-width: 80%; max-height: 80%; object-fit: contain;"></i>
        <span>Feiertage & Events</span>
    </a>

    <a href="/materialien" class="cat-card" style="border-color: rgba(41, 182, 246, 0.4);">
        <i><img src="/assets/img/acnh/home/64px-Tree_Branch_NH_Inv_Icon.png" alt="Materialien & Zutaten" style="max-width: 80%; max-height: 80%; object-fit: contain;"></i>
        <span>Materialien & Zutaten</span>
    </a>

    <a href="/bastelanleitungen" class="cat-card" style="border-color: rgba(255, 152, 0, 0.4);">
        <i><img src="/assets/img/acnh/home/BastelnKochen.png" alt="Bastelanleitungen & Kochrezepte" style="max-width: 80%; max-height: 80%; object-fit: contain;"></i>
        <span>Bastelanleitungen & Kochrezepte</span>
    </a>
</div>

<div style="margin-top: 40px; text-align: center;">
    <p style="color: var(--ac-text-muted); font-size: 0.9rem;">
        Wähle eine Kategorie aus, um zu sehen, was du gerade auf deiner Insel entdecken kannst!
    </p>
</div>

<?php include 'partials/footer.php'; ?>