<?php include __DIR__ . '/../partials/header.php'; ?>
<link rel="stylesheet" href="/assets/css/museum.css">

<div class="museum-hero">
    <div class="museum-hero-icon">🏛️</div>
    <h1>Das Museum</h1>
    
    <?php include __DIR__ . '/../partials/info_museum.php'; ?>

    <div class="museum-npc-grid">
        <div class="npc-card">
            <img src="/assets/img/acnh/museum/Eugen.png" alt="Eugen" onerror="this.src='/assets/img/acnh/placeholder.png'">
            <strong class="npc-name">Eugen</strong>
            <span class="npc-role">Museumsdirektor</span>
        </div>
        <div class="npc-card">
            <img src="/assets/img/acnh/museum/Kofi.png" alt="Kofi" onerror="this.src='/assets/img/acnh/placeholder.png'">
            <strong class="npc-name">Kofi</strong>
            <span class="npc-role">Barista im Taubenschlag</span>
        </div>
    </div>
</div>

<div class="museum-section-header">
    <h2>Die Ausstellungsräume</h2>
    <p>Wähle einen Museumsflügel aus, um ihn zu betreten.</p>
</div>

<div class="museum-categories">
    <a href="/museum/kunstwerke" class="cat-card cat-card-art">
        <i>🖼️</i>
        <div class="cat-card-text">
            <span class="cat-card-title">Kunstgalerie</span>
            <span class="cat-card-subtitle">⬆️ Obergeschoss</span>
        </div>
    </a>
    
    <a href="/museum/fossilien" class="cat-card cat-card-fossil">
        <i>🦴</i>
        <div class="cat-card-text">
            <span class="cat-card-title">Fossilienausstellung</span>
            <span class="cat-card-subtitle">⬇️ Untergeschoss</span>
        </div>
    </a>

    <a href="/museum/insekten" class="cat-card cat-card-insect">
        <i>🦋</i>
        <div class="cat-card-text">
            <span class="cat-card-title">Insektenabteilung</span>
            <span class="cat-card-subtitle">⬅️ Westflügel</span>
        </div>
    </a>

    <a href="/museum/fische" class="cat-card cat-card-fish">
        <i>🐟</i>
        <div class="cat-card-text">
            <span class="cat-card-title">Aquarium: Fische</span>
            <span class="cat-card-subtitle">➡️ Ostflügel</span>
        </div>
    </a>

    <a href="/museum/meerestiere" class="cat-card cat-card-sea">
        <i>🐙</i>
        <div class="cat-card-text">
            <span class="cat-card-title">Aquarium: Meerestiere</span>
            <span class="cat-card-subtitle">➡️ Ostflügel</span>
        </div>
    </a>
</div>

<?php include __DIR__ . '/../partials/footer.php'; ?>