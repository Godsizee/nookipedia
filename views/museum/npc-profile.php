<?php include __DIR__ . '/../partials/header.php'; ?>
<link rel="stylesheet" href="/assets/css/museum.css">
<link rel="stylesheet" href="/assets/css/npc.css">

<div class="hero museum-hero npc-hero npc-<?= strtolower($npc->name) ?>">
    <div class="museum-hero-icon">
        <img src="<?= htmlspecialchars($npc->getImageUrl()) ?>" alt="<?= htmlspecialchars($npc->name) ?>">
    </div>
    <h1><?= htmlspecialchars($npc->name) ?></h1>
    <p style="color: #e0f2ea; font-size: 1.1rem;"><?= htmlspecialchars($npc->role) ?></p>
</div>

<div class="profile-content">
    <div style="display: flex; gap: 2rem; border-bottom: 2px dashed var(--ac-border); padding-bottom: 1.5rem; margin-bottom: 2rem; justify-content: center; flex-wrap: wrap;">
        <div><strong>Tierart:</strong> <?= htmlspecialchars($npc->species) ?></div>
        <div><strong>Geschlecht:</strong> <?= htmlspecialchars($npc->gender) ?></div>
        <div><strong>Geburtstag:</strong> 🎂 <?= htmlspecialchars($npc->birthday) ?></div>
    </div>

    <div class="fluff-text">
        <?= $npc->description ?>
    </div>
    
    <div style="text-align: center; margin-top: 3rem;">
        <a href="/museum" class="btn-clear" style="text-decoration: none; padding: 12px 24px;">← Zurück zum Museum</a>
    </div>
</div>
<div style="text-align: center; margin-top: 3rem;">
        <a href="/museum" class="btn-museum-back">← Zurück zum Museum</a>
    </div>


<?php include __DIR__ . '/../partials/footer.php'; ?>