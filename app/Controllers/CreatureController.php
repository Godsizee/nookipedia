<?php

namespace App\Controllers;

use App\Repositories\CreatureRepository;

class CreatureController {
    
    private $creatureRepo;

    public function __construct() {
        // Repository initialisieren, damit wir auf die Datenbank zugreifen können
        $this->creatureRepo = new CreatureRepository();
    }

    /**
     * Übersicht: Insekten
     */
    public function insects() {
        $title = 'Insekten';
        $category = 'insect';
        // Definiere das spezifische Fluff-Text Partial (OCP & SRP)
        $infoTemplate = 'partials/info_insect.php';
        $creatures = $this->creatureRepo->getByCategory('insect');
        require __DIR__ . '/../../views/creature-list.php';
    }

    /**
     * Übersicht: Fische
     */
    public function fish() {
        $title = 'Fische';
        $category = 'fish';
        $infoTemplate = 'partials/info_fish.php';
        $creatures = $this->creatureRepo->getByCategory('fish');
        require __DIR__ . '/../../views/creature-list.php';
    }

    /**
     * Übersicht: Meerestiere
     */
    public function sea() {
        $title = 'Meerestiere';
        $category = 'sea';
        $infoTemplate = 'partials/info_sea.php';
        $creatures = $this->creatureRepo->getByCategory('sea');
        require __DIR__ . '/../../views/creature-list.php';
    }

    /**
     * NEU: Dynamische Detailseite für ein einzelnes Tier
     * Wird über die Route /tier/{id} aufgerufen
     */
    public function show($id) {
        // 1. Lade das Tier aus der Datenbank anhand der ID
        $creature = $this->creatureRepo->findById($id);
        
        // 2. Sicherheitscheck: Wenn die ID nicht existiert, zurück zur Startseite leiten
        if (!$creature) {
            header("Location: /");
            exit;
        }

        // 3. Titel setzen und die fabelhafte Detail-View laden
        $title = $creature->name . ' - Faunapädie';
        require __DIR__ . '/../../views/creature-detail.php';
    }
}