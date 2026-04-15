<?php 
$title = "Willkommen auf Nookipedia";
include 'partials/header.php'; 
?>

<section class="hero">
    <div style="font-size: 4.5rem; margin-bottom: 10px; filter: drop-shadow(0 4px 8px rgba(0,0,0,0.1));">🏝️</div>
    <h1>Nookipedia Next</h1>
    <p>Dein ultimativer und fabelhafter Begleiter für Animal Crossing: New Horizons.</p>
</section>

<div class="category-selection">
    
    <a href="/museum" class="cat-card" style="border-color: rgba(212, 175, 55, 0.4); background: linear-gradient(135deg, var(--ac-surface), #fffdf5);">
        <i style="background: #fcf8e8; box-shadow: inset 0 2px 4px rgba(212, 175, 55, 0.2);">
            <span style="font-size: 2.2rem; line-height: 1; filter: drop-shadow(0 2px 2px rgba(0,0,0,0.1));">🏛️</span>
        </i>
        <span>Das Museum</span>
    </a>

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
        <span>Basteln & Kochen</span>
    </a>
</div>

<div style="margin-top: 40px; text-align: center;">
    <p style="color: var(--ac-text-muted); font-size: 0.95rem; font-weight: 600;">
        Wähle eine Kategorie aus, um zu sehen, was du gerade auf deiner Insel entdecken kannst!
    </p>
</div>

<?php include 'partials/footer.php'; ?>