<?php

namespace App\Controllers;

use App\Core\Controller;

// Durch "extends Controller" ist diese Seite automatisch passwortgeschützt!
class HomeController extends Controller {
    
    public function index() {
        // Lädt die Startseite (home.php) aus dem views-Ordner
        require __DIR__ . '/../../views/home.php';
    }
}