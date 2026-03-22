<?php include 'partials/header.php'; ?>

<link rel="stylesheet" href="/assets/css/faunapedia.css">
<link rel="stylesheet" href="/assets/css/flower-guide.css">

<div class="hero">
    <div class="hero-flower-icon">
        <img src="<?= htmlspecialchars($flower->getImageUrl()) ?>" alt="Icon">
    </div>
    <h1>Der ultimative <?= htmlspecialchars($flower->name) ?>n-Guide</h1>
    <p>Von der einfachen Samentüte zur seltenen Pracht.</p>
</div>

<section class="guide-section">
    <div class="guide-intro">
        <p>
            <?= htmlspecialchars($flower->name) ?>n gehören zu den vielseitigsten Blumen in Animal Crossing. 
            Besonders die seltenen Hybridvarianten sind bei Züchtern extrem heiß begehrt. 
            Dieser Guide erklärt dir Schritt für Schritt, wie du eine makellose Zucht aufbaust!
        </p>
    </div>

    <!-- Sektion: Samen -->
    <h2 class="guide-heading">🌱 1. Die Grundfarben (Samen)</h2>
    <div class="guide-card">
        <p style="margin-bottom: 1rem;">Um eine <strong>saubere Zucht</strong> zu garantieren, solltest du immer mit frischen Samentüten von Nooks Laden oder Gerd beginnen. Wild gewachsene Blumen haben oft eine unbekannte Genetik!</p>
        <p style="color: var(--ac-text-muted); font-size: 0.9rem;">Die standardmäßigen Grundfarben variieren je nach Blumenart. Arbeite ausschließlich mit diesen, wenn du gezielt kreuzen willst.</p>
    </div>

    <!-- Sektion: Kreuzungen -->
    <h2 class="guide-heading">🧬 2. Zuchtkombinationen & Hybride</h2>
    <p style="margin-bottom: 1.5rem; color: var(--ac-text-muted);">Kreuzungen sind der Schlüssel. Pflanze zwei Elternblumen schachbrettartig oder nebeneinander und gieße sie täglich.</p>

    <div class="breeding-list">
        <?php foreach ($combinations as $combo): ?>
            <div class="breeding-card">
                <div class="breeding-parents">
                    <div class="flower-entity">
                        <img src="<?= htmlspecialchars($combo->getImageUrl($combo->parent1_image)) ?>" alt="Elternteil 1">
                        <span><?= htmlspecialchars($combo->parent1_color) ?></span>
                    </div>
                    <div class="math-symbol">+</div>
                    <div class="flower-entity">
                        <img src="<?= htmlspecialchars($combo->getImageUrl($combo->parent2_image)) ?>" alt="Elternteil 2">
                        <span><?= htmlspecialchars($combo->parent2_color) ?></span>
                    </div>
                </div>
                
                <div class="math-symbol equals">=</div>
                
                <div class="breeding-result">
                    <div class="flower-entity result-entity">
                        <img src="<?= htmlspecialchars($combo->getImageUrl($combo->child_image)) ?>" alt="Ergebnis">
                        <span class="result-color"><?= htmlspecialchars($combo->child_color) ?></span>
                        <span class="probability-badge"><?= htmlspecialchars($combo->probability) ?></span>
                    </div>
                    <p class="breeding-notes"><?= htmlspecialchars($combo->notes) ?></p>
                </div>
            </div>
        <?php endforeach; ?>
    </div>

    <!-- Sektion: Profi-Tipps -->
    <h2 class="guide-heading">🎓 3. Profi-Tipps für die Zucht</h2>
    <div class="tips-grid">
        <div class="tip-card">
            <h3>💧 Der Besucher-Bonus</h3>
            <p>Das Gießen durch fremde Besucher erhöht die Chance auf neue Knospen massiv!</p>
            <ul>
                <li><strong>Du selbst:</strong> ~5% Chance</li>
                <li><strong>1 Besucher:</strong> ~25% Chance</li>
                <li><strong>5 Besucher:</strong> ~80% Chance (Blumen glitzern golden!)</li>
            </ul>
        </div>
        <div class="tip-card">
            <h3>👯 Das Klonen</h3>
            <p>Wenn du eine seltene Farbe hast und mehr willst, stelle die Blume <strong>alleine</strong> auf ein Feld (kein Kontakt zu anderen Blumen). Gießt du sie, klont sie sich exakt selbst.</p>
        </div>
        <div class="tip-card">
            <h3>📏 Layout & Sauberkeit</h3>
            <p>Ein Schachbrettmuster ist super für große Flächen. Willst du 100% reine Genetik, nutze <strong>Paarweise Isolierung</strong>. Entferne zudem "ungewollte" Blumenkinder sofort, damit sie den Genpool nicht ruinieren.</p>
        </div>
    </div>
</section>

<?php include 'partials/footer.php'; ?>