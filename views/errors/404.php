<?php 
$title = "Huch! Verlaufen?";
include __DIR__ . '/../partials/header.php'; 
?>

<section class="hero" style="padding: 100px 0;">
    <div style="font-size: 5rem; margin-bottom: 20px;">😵‍💫</div>
    <h1>404 - Seite nicht gefunden</h1>
    <p>Uuups! Es sieht so aus, als hätte sich Resetti in deinen Pfaden vergraben.</p>
    
    <div style="margin-top: 40px;">
        <!-- Wir nutzen hier die Konstante BASE_PATH für korrekte Verlinkung -->
        <a href="<?= BASE_PATH ?>/" class="tab-item active" style="padding: 15px 30px; text-decoration: none; display: inline-block;">
            Zurück zum Dorfplatz
        </a>
    </div>
</section>

<?php include __DIR__ . '/../partials/footer.php'; ?>