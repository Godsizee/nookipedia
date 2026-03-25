<?php include 'partials/header.php'; ?>

<link rel="stylesheet" href="/assets/css/faunapedia.css">
<link rel="stylesheet" href="/assets/css/flower-guide.css">

<div class="hero">
    <div class="hero-flower-icon">
        <img src="<?= htmlspecialchars($flower->getImageUrl()) ?>" alt="Icon">
    </div>
    
    <?php
    // Smartes Wörterbuch für die grammatikalisch korrekte Guide-Bezeichnung
    $pluralNames = [
        'Anemone' => 'Anemonen',
        'Alpenveilchen' => 'Alpenveilchen',
        'Chrysantheme' => 'Chrysanthemen',
        'Cosmea' => 'Cosmeen',
        'Hyazinthe' => 'Hyazinthen',
        'Lilie' => 'Lilien',
        'Rose' => 'Rosen',
        'Tulpe' => 'Tulpen',
        'Maiglöckchen' => 'Maiglöckchen'
    ];
    
    // Falls der Name im Array steht, nimm den Plural, sonst hänge zur Sicherheit einfach ein 'n' an.
    $guideName = $pluralNames[$flower->name] ?? $flower->name . 'n';
    ?>
    
    <h1>Der ultimative <?= htmlspecialchars($guideName) ?>-Guide</h1>
    <p>Von der einfachen Samentüte zur seltenen Pracht.</p>
</div>

<section class="guide-section">
    <!-- Modulares Laden des spezifischen Intro-Textes -->
    <div class="guide-intro">
        <?php 
            $introFile = __DIR__ . "/partials/guides/intro_{$flower->id}.php";
            if (file_exists($introFile)) {
                include $introFile;
            } else {
                echo "<p>Willkommen beim Zucht-Guide für die " . htmlspecialchars($flower->name) . ".</p>";
            }
        ?>
    </div>

    <!-- Sektion: Samen -->
    <h2 class="guide-heading">1. Die Grundfarben (Samen)</h2>
    <div class="guide-card">
        <p style="margin-bottom: 1.5rem;">Um eine <strong>saubere Zucht</strong> zu garantieren, solltest du immer mit frischen Samentüten von Nooks Laden oder Gerd beginnen. Wild gewachsene Blumen haben oft eine unbekannte Genetik!</p>
        
        <div class="seeds-grid">
            <?php if (!empty($seeds)): ?>
                <?php foreach ($seeds as $seed): ?>
                    <div class="seed-card">
                        <img src="/assets/img/acnh/<?= htmlspecialchars($seed->image_path) ?>" alt="<?= htmlspecialchars($seed->color) ?> Samentüte">
                        <div class="seed-info">
                            <span class="color-badge color-<?= strtolower(htmlspecialchars($seed->color)) ?>" style="display: inline-block; width: fit-content;">
                                <?= htmlspecialchars($seed->color) ?>
                            </span>
                            <span class="seed-source">🛒 <?= htmlspecialchars($seed->source) ?></span>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p>Keine Samendaten gefunden.</p>
            <?php endif; ?>
        </div>
    </div>

    <!-- Sektion: Kreuzungen -->
    <h2 class="guide-heading">2. Zuchtkombinationen & Hybride</h2>
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
    <h2 class="guide-heading">3. Profi-Tipps für die Zucht</h2>
    <div class="tips-grid">
        <!-- Modulares Laden der spezifischen Tipps -->
        <?php 
            $tipsFile = __DIR__ . "/partials/guides/tips_{$flower->id}.php";
            if (file_exists($tipsFile)) {
                include $tipsFile;
            } else {
                echo "<div class='tip-card'><p>Gieße deine Blumen jeden Tag für maximale Erfolge!</p></div>";
            }
        ?>
    </div>
</section>

<?php include 'partials/footer.php'; ?>