<?php

namespace App\Controllers;

class HomeController {
    public function index() {
        // Lädt die Startseite (home.php) aus dem views-Ordner
        require __DIR__ . '/../../views/home.php';
    }
}