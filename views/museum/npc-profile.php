<?php include __DIR__ . '/../partials/header.php'; ?>
<link rel="stylesheet" href="/assets/css/museum.css">
<link rel="stylesheet" href="/assets/css/npc.css">

<div class="hero museum-hero npc-hero npc-<?= strtolower($npc->name) ?>">
    <div class="museum-hero-icon">
        <img src="<?= htmlspecialchars($npc->getImageUrl()) ?>" alt="<?= htmlspecialchars($npc->name) ?>">
    </div>
    <h1><?= htmlspecialchars($npc->name) ?></h1>
    <p style="color: #e0f2ea; font-size: 1.1rem; font-weight: 800; letter-spacing: 1px; text-transform: uppercase;">
        <?= htmlspecialchars($npc->role) ?>
    </p>
</div>

<div class="profile-content">
    <!-- Stammdaten-Leiste (Edel strukturiert) -->
    <div style="display: flex; gap: 2.5rem; border-bottom: 2px dashed var(--ac-border); padding-bottom: 1.5rem; margin-bottom: 2rem; justify-content: center; flex-wrap: wrap;">
        <div style="text-align: center;">
            <span style="opacity: 0.7; font-size: 0.8rem; display: block; text-transform: uppercase; font-weight: 900; letter-spacing: 1px;">Tierart</span>
            <strong style="font-size: 1.1rem;"><?= htmlspecialchars($npc->species) ?></strong>
        </div>
        <div style="text-align: center;">
            <span style="opacity: 0.7; font-size: 0.8rem; display: block; text-transform: uppercase; font-weight: 900; letter-spacing: 1px;">Geschlecht</span>
            <strong style="font-size: 1.1rem;"><?= htmlspecialchars($npc->gender) ?></strong>
        </div>
        <div style="text-align: center;">
            <span style="opacity: 0.7; font-size: 0.8rem; display: block; text-transform: uppercase; font-weight: 900; letter-spacing: 1px;">Geburtstag</span>
            <strong style="font-size: 1.1rem;">🎂 <?= htmlspecialchars($npc->birthday) ?></strong>
        </div>
        <?php if(!empty($npc->name_en)): ?>
        <div style="text-align: center;">
            <span style="opacity: 0.7; font-size: 0.8rem; display: block; text-transform: uppercase; font-weight: 900; letter-spacing: 1px;">Englisch</span>
            <strong style="font-size: 1.1rem;"><?= htmlspecialchars($npc->name_en) ?></strong>
        </div>
        <?php endif; ?>
    </div>

    <!-- Fluff-Text aus der Datenbank (wird unescaped ausgegeben, da HTML-Inhalt) -->
    <div class="fluff-text npc-story">
        <?= $npc->description ?>
    </div>
    
    <div style="text-align: center; margin-top: 3.5rem;">
        <a href="/museum" class="btn-museum-back">
            <span style="margin-right: 8px;">🏛️</span> Zurück zum Museum
        </a>
    </div>
</div>

<?php include __DIR__ . '/../partials/footer.php'; ?>