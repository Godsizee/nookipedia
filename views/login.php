<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dodo Airlines Check-In - Nookipedia</title>
    <!-- Wir laden das Main-CSS für Variablen und das neue Login-CSS -->
    <link rel="stylesheet" href="/assets/css/main.css">
    <link rel="stylesheet" href="/assets/css/login.css">
</head>
<body class="login-body">
    
    <div class="login-container">
        <div class="nook-logo">🦝</div>
        
        <h1>Hast du das<br>"Reif-für-die-Insel-Paket"?</h1>
        
        <?php if (isset($error) && $error): ?>
            <div class="error-msg">
                🚫 Der Dodo-Airlines Flug wurde storniert! Die Zugangsdaten sind inkorrekt.
            </div>
        <?php endif; ?>

        <form action="/authenticate" method="POST" id="login-form">
            <!-- WICHTIG: Das unsichtbare Sicherheits-Token -->
            <input type="hidden" name="csrf_token" value="<?= htmlspecialchars($csrfToken) ?>">
            
            <div class="input-group">
                <label for="username">Flugticket (Nutzername)</label>
                <input type="text" id="username" name="username" required autocomplete="username" placeholder="Dein Nutzername">
            </div>
            
            <div class="input-group">
                <label for="password">Reisepass (Passwort)</label>
                <input type="password" id="password" name="password" required placeholder="••••••••">
            </div>
            
            <button type="submit" class="btn-login" id="login-btn">
                <span class="spinner" id="login-spinner"></span>
                <span class="btn-text" id="login-text">✈️ Abflug zur Insel</span>
            </button>
        </form>
    </div>

    <!-- Smartes Form-Handling -->
    <script>
        document.getElementById('login-form').addEventListener('submit', function() {
            const btn = document.getElementById('login-btn');
            const text = document.getElementById('login-text');
            
            // UI sofort auf "Laden" setzen
            btn.classList.add('is-loading');
            
            // Wir nutzen pointer-events: none statt btn.disabled = true.
            // Warum? Manche Browser brechen den Submit-Vorgang ab, wenn der Submit-Button im gleichen Event disabled wird.
            btn.style.pointerEvents = 'none'; 
            
            // Text austauschen
            text.textContent = 'Flug wird gebucht...';
        });
    </script>
</body>
</html>