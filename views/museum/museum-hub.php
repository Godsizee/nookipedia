<?php include __DIR__ . '/../partials/header.php'; ?>
<link rel="stylesheet" href="/assets/css/museum.css">

<div class="museum-hero">
    <div class="museum-hero-icon">🏛️</div>
    <h1>Das Museum</h1>
    
    <div class="museum-intro-box">
        <p>
            Das Museum ist ein Gebäude, das in allen Animal Crossing-Spielen (außer Animal Forest) zu finden ist. Es ist eine faszinierende Einrichtung zur Sammlung und Ausstellung von <strong>Insekten, Fischen, Meerestieren, Fossilien, Gemälden und Skulpturen</strong>.
        </p>
        <p>
            Kuratiert wird das Museum von Eugen (Blathers), einer Eule, die stets treu in der Eingangshalle wacht.
        </p>
    </div>

<div class="museum-npc-grid">
    <?php foreach ($museumNpcs as $npc): ?>
        <a href="/museum/npc/<?= strtolower($npc->name) ?>" class="npc-card">
            <img src="<?= $npc->getImageUrl() ?>" alt="<?= $npc->name ?>">
            <strong class="npc-name"><?= $npc->name ?></strong>
            <span class="npc-role"><?= $npc->role ?></span>
        </a>
    <?php endforeach; ?>
</div>

<?php include __DIR__ . '/../partials/info_museum.php'; ?>

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