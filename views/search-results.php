<?php include 'partials/header.php'; ?>

<div class="hero">
    <div style="font-size: 4rem; margin-bottom: 10px; filter: drop-shadow(0 4px 10px rgba(89, 166, 131, 0.4));">🔍</div>
    <h1>Suchergebnisse</h1>
    
    <!-- UX-Boost: Direktes Suchfeld auf der Ergebnisseite -->
    <form action="/suche" method="GET" class="page-search-form">
        <div class="page-search-wrapper">
            <input type="text" name="q" value="<?= htmlspecialchars($_GET['q'] ?? '') ?>" placeholder="Suche anpassen..." autocomplete="off" spellcheck="false" required>
            <button type="submit" aria-label="Suchen">🔍</button>
        </div>
    </form>

    <?php if (mb_strlen($_GET['q'] ?? '') > 0): ?>
        <p style="font-size: 1.1rem;">Wir haben <strong><?= count($results) ?> passende Einträge</strong> für "<?= htmlspecialchars($_GET['q'] ?? '') ?>" gefunden.</p>
    <?php else: ?>
        <p style="font-size: 1.1rem;">Bitte gib einen Suchbegriff ein.</p>
    <?php endif; ?>
</div>

<section class="search-results-page">
    <?php if (empty($results)): ?>
        <div style="text-align: center; padding: 40px 20px; background: var(--ac-surface); border-radius: var(--radius-lg); box-shadow: var(--ac-shadow); border: 2px dashed var(--ac-border);">
            <div style="font-size: 4rem; margin-bottom: 1rem;">🦝</div>
            <p style="font-size: 1.3rem; color: var(--ac-text); font-weight: 800; margin-bottom: 0.5rem;">Oh weh! Resetti hat nichts gefunden.</p>
            <p style="color: var(--ac-text-muted); margin-bottom: 1.5rem;">Versuche es mit einem anderen Begriff oder überprüfe die Schreibweise.</p>
            <a href="/" class="btn-clear" style="display: inline-block; text-decoration: none; padding: 0.6rem 1.5rem;">Zurück zum Dorfplatz</a>
        </div>
    <?php else: ?>
        <!-- Mobile-First Grid Layout -->
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