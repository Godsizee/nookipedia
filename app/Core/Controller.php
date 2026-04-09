<?php

namespace App\Core;

/**
 * Basis Controller
 * Handhabt globale Logik wie die Authentifizierungsprüfung für alle erbenden Controller.
 */
class Controller {
    
    // Standardmäßig erfordern alle Controller einen Login
    protected $requireAuth = true;

    public function __construct() {
        // Session sicherstellen, falls noch nicht geschehen
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        // Türsteher-Prüfung
        if ($this->requireAuth) {
            $this->checkAuth();
        }
    }

    /**
     * Zentrale Methode zur Überprüfung des Login-Status.
     */
    protected function checkAuth() {
        if (!isset($_SESSION['user_logged_in']) || $_SESSION['user_logged_in'] !== true) {
            header('Location: /login');
            exit;
        }
    }
}