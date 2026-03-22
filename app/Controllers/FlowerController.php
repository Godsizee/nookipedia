<?php

namespace App\Controllers;

use App\Repositories\FlowerRepository;

class FlowerController {
    
    private $repo;

    public function __construct() {
        // Initialisiert das Repository für die Datenbankzugriffe
        $this->repo = new FlowerRepository();
    }

    public function index() {
        // Setzt die Basis-Variablen für die View
        $title = 'Pflanzenwelt';
        $category = 'flowers';
        
        // Definiert das Partial für den Fluff-Text und das Grid
        $infoTemplate = 'partials/info_flower.php';
        
        // Holt alle Blumen dynamisch aus der Datenbank
        $flowers = $this->repo->getAll();

        // Lädt die aufgerufene View und übergibt implizit die Variablen
        require __DIR__ . '/../../views/flower-list.php';
    }
}