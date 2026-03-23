<?php include 'partials/header.php'; ?>

<div class="hero">
    <h1><?= htmlspecialchars($title) ?></h1>
    <p>Lass deiner Kreativität freien Lauf an der Werkbank und am Herd!</p>
</div>

<nav class="tab-nav">
    <a href="/bastelanleitungen" class="tab-item <?= $category === 'diy' ? 'active' : '' ?>">🛠️ Bastelanleitungen</a>
    <a href="/kochrezepte" class="tab-item <?= $category === 'cooking' ? 'active' : '' ?>">🍳 Kochrezepte</a>
</nav>

<link rel="stylesheet" href="/assets/css/events.css"> <!-- Wir recyclen das Collapsible CSS -->
<link rel="stylesheet" href="/assets/css/recipes.css">

<div class="events-container" style="margin-top: 2rem;">
    <?php if (empty($groupedRecipes)): ?>
        <div style="text-align: center; padding: 50px;">
            <p style="font-size: 1.5rem;">📜 Hier ist es aktuell ziemlich leer...</p>
        </div>
    <?php else: ?>
        <?php foreach ($groupedRecipes as $catName => $recipes): ?>
            <!-- Collapsible für jede Rezept-Kategorie -->
            <details class="month-group recipe-group" open>
                <summary class="month-summary">
                    <span class="month-title">
                        <?= htmlspecialchars($catName) ?>
                    </span>
                    <span class="summary-chevron">▼</span>
                </summary>
                
                <div class="month-grid">
                    <div class="recipe-grid">
                        <?php foreach ($recipes as $recipe): ?>
                            <?php include 'partials/recipe-card.php'; ?>
                        <?php endforeach; ?>
                    </div>
                </div>
            </details>
        <?php endforeach; ?>
    <?php endif; ?>
</div>

<?php include 'partials/footer.php'; ?>