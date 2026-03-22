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

        <form action="/authenticate" method="POST">
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
            
            <button type="submit" class="btn-login">✈️ Abflug zur Insel</button>
        </form>
    </div>

</body>
</html>