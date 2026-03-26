<?php include 'partials/header.php'; ?>

<div class="hero">
    <div style="font-size: 4rem; margin-bottom: 10px; filter: drop-shadow(0 4px 10px rgba(89, 166, 131, 0.4));">🔍</div>
    <h1><?= $title ?></h1>
    <p>Wir haben <?= count($results) ?> passende Einträge in der Nook-Datenbank gefunden.</p>
</div>

<section class="search-results-page">
    <?php if (empty($results)): ?>
        <div style="text-align: center; padding: 50px;">
            <p style="font-size: 1.5rem; color: var(--ac-text-muted);">Leider konnten wir dazu nichts finden... 🦝</p>
            <a href="/" class="btn-clear" style="display: inline-block; margin-top: 20px; text-decoration: none;">Zurück zum Dorfplatz</a>
        </div>
    <?php else: ?>
        <div class="search-page-grid">
            <?php foreach ($results as $res): ?>
                <a href="<?= htmlspecialchars($res['url']) ?>" class="search-page-card">
                    <div class="search-page-img">
                        <img src="<?= htmlspecialchars($res['image']) ?>" 
                             alt="<?= htmlspecialchars($res['title']) ?>"
                             loading="lazy"
                             onerror="this.src='/assets/img/acnh/koeder.png'">
                    </div>
                    <div class="search-page-info">
                        <h3 class="search-page-title"><?= htmlspecialchars($res['title']) ?></h3>
                        <span class="search-page-subtitle"><?= htmlspecialchars($res['subtitle']) ?></span>
                    </div>
                    <div class="search-page-badge">
                        <?= htmlspecialchars($res['type']) ?>
                    </div>
                </a>
            <?php endforeach; ?>
        </div>
    <?php endif; ?>
</section>

<?php include 'partials/footer.php'; ?>