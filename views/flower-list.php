<?php include 'partials/header.php'; ?>

<div class="hero">
    <h1><?= htmlspecialchars($title) ?></h1>
    <p>Verwandle deine Insel in ein florales Paradies.</p>
</div>

<!-- Modulares Einbinden der Info-Texte (SRP) -->
<?php if (isset($infoTemplate) && file_exists(__DIR__ . '/' . $infoTemplate)): ?>
    <div class="info-box">
        <?php include $infoTemplate; ?>
    </div>
<?php endif; ?>

<!-- ✨ TL;DR Cheat Sheet Accordion ✨ -->
<div style="max-width: 1000px; margin: 0 auto 3rem auto; padding: 0 1rem;">
    <details class="ac-details">
        <summary class="ac-summary">
            <span class="summary-icon">🗺️</span>
            <span class="summary-text">TL;DR: Der ultimative Zuchtleitfaden auf einen Blick</span>
            <span class="summary-chevron">▼</span>
        </summary>
        <div class="details-content">
            <p style="margin-bottom: 1rem; color: var(--ac-text-muted); font-size: 0.95rem;">
                Klicke auf das Bild oder zoome heran, um die platzsparendsten Layouts und Kreuzungen für alle Blumenarten zu sehen!
            </p>
            <a href="/assets/img/acnh/flowers/TLDR/BlumenZuchtleitfaden.png" target="_blank" title="Bild in voller Größe öffnen">
                <img src="/assets/img/acnh/flowers/TLDR/BlumenZuchtleitfaden.png" 
                     alt="ACNH Blumen Zuchtleitfaden Cheat Sheet" 
                     loading="lazy">
            </a>
        </div>
    </details>
</div>

<div class="creature-grid">
    <?php if (empty($flowers)): ?>
        <div style="grid-column: 1/-1; text-align: center; padding: 50px;">
            <p style="font-size: 1.5rem;">🥀 Hier blüht aktuell noch nichts...</p>
        </div>
    <?php else: ?>
        <?php foreach ($flowers as $flower): ?>
            <?php include 'partials/flower-card.php'; ?>
        <?php endforeach; ?>
    <?php endif; ?>
</div>

<?php include 'partials/footer.php'; ?>