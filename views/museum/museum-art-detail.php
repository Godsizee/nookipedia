<?php include __DIR__ . '/../partials/header.php'; ?>
<link rel="stylesheet" href="/assets/css/museum.css">

<div class="hero">
    <h1><?= htmlspecialchars($artwork->name) ?></h1>
    <p><?= htmlspecialchars($artwork->real_world_name) ?> <br> <span class="art-author-subtitle">von <?= htmlspecialchars($artwork->artist) ?></span></p>
</div>

<div class="art-detail-wrapper" id="art-container">
    
    <div class="compare-container">
        <img src="<?= htmlspecialchars($artwork->getRealImageUrl()) ?>" class="compare-img img-real" alt="Original <?= htmlspecialchars($artwork->name) ?>">
        <?php if ($artwork->hasFake()): ?>
            <img src="<?= htmlspecialchars($artwork->getFakeImageUrl()) ?>" class="compare-img img-fake" alt="Fälschung <?= htmlspecialchars($artwork->name) ?>">
        <?php endif; ?>
    </div>

    <?php if ($artwork->hasFake()): ?>
        <div class="toggle-btn-wrap">
            <button class="btn-toggle-art" id="toggle-fake-btn">
                <span id="toggle-icon">✅</span> 
                <span id="toggle-text">Original-Ansicht</span>
            </button>
        </div>

        <div class="fake-warning">
            <h4>🚨 Worauf musst du achten?</h4>
            <p><?= nl2br(htmlspecialchars($artwork->fake_description)) ?></p>
        </div>
        
        <script>
            document.getElementById('toggle-fake-btn').addEventListener('click', function() {
                const container = document.getElementById('art-container');
                const btnText = document.getElementById('toggle-text');
                const btnIcon = document.getElementById('toggle-icon');
                
                container.classList.toggle('is-showing-fake');
                
                if (container.classList.contains('is-showing-fake')) {
                    btnText.textContent = 'Fälschung wird angezeigt';
                    btnIcon.textContent = '❌';
                } else {
                    btnText.textContent = 'Original-Ansicht';
                    btnIcon.textContent = '✅';
                }
            });
        </script>

    <?php else: ?>
        <div class="always-real-msg">
            ✨ Von diesem Kunstwerk existiert keine Fälschung im Spiel. Es ist immer ein Original!
        </div>
    <?php endif; ?>

    <div class="art-back-link">
        <a href="/museum/kunstwerke" class="btn-clear">← Zurück zur Galerie</a>
    </div>
</div>

<?php include __DIR__ . '/../partials/footer.php'; ?>