<?php 
$title = "Huch! Verlaufen?";
include __DIR__ . '/../partials/header.php'; 
?>

<section class="hero error-hero">
    <div class="error-icon">😵‍💫</div>
    <h1>404 - Seite nicht gefunden</h1>
    <p>Uuups! Es sieht so aus, als hätte sich Resetti in deinen Pfaden vergraben.</p>
    
    <div class="error-actions">
        <!-- Wir nutzen hier die Konstante BASE_PATH für korrekte Verlinkung -->
        <a href="<?= BASE_PATH ?>/" class="tab-item active btn-back">
            Zurück zum Dorfplatz
        </a>
    </div>
</section>

<?php include __DIR__ . '/../partials/footer.php'; ?>