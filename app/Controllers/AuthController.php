<?php

namespace App\Controllers;

class AuthController {
    // Hardcodierte Credentials für den Single-User-Modus
    private const ADMIN_USER = 'BundB';
    private const ADMIN_PASS = '1arschmusik!'; 
    
    public function login() {
        // Wenn bereits eingeloggt, direkt zur Startseite umleiten
        if (isset($_SESSION['user_logged_in']) && $_SESSION['user_logged_in'] === true) {
            header('Location: /');
            exit;
        }
        
        // CSRF-Token generieren (Best Practice)
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
        $csrfToken = $_SESSION['csrf_token'];
        
        $error = isset($_SESSION['login_error']) ? $_SESSION['login_error'] : null;
        unset($_SESSION['login_error']); // Fehler nach dem Anzeigen löschen
        
        require __DIR__ . '/../../views/login.php';
    }

    public function authenticate() {
        // Künstliche Verzögerung gegen Brute-Force-Attacken (0.3 Sekunden)
        usleep(300000); 

        // CSRF-Prüfung
        if (!hash_equals($_SESSION['csrf_token'] ?? '', $_POST['csrf_token'] ?? '')) {
            die("Sicherheitsfehler: CSRF Token ungültig. Bitte lade die Seite neu.");
        }

        $username = $_POST['username'] ?? '';
        $password = $_POST['password'] ?? '';

        // Strikter Vergleich der Credentials
        if ($username === self::ADMIN_USER && $password === self::ADMIN_PASS) {
            
            // Best Practice: Session-Fixation-Schutz durch neue ID!
            session_regenerate_id(true);
            
            $_SESSION['user_logged_in'] = true;
            $_SESSION['username'] = $username;
            
            header('Location: /');
            exit;
        } else {
            $_SESSION['login_error'] = true;
            header('Location: /login');
            exit;
        }
    }

    public function logout() {
        // Session sicher und komplett zerstören
        $_SESSION = [];
        if (ini_get("session.use_cookies")) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000,
                $params["path"], $params["domain"],
                $params["secure"], $params["httponly"]
            );
        }
        session_destroy();
        header('Location: /login');
        exit;
    }
}