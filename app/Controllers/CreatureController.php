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
     * Übersicht: Fische
     */
    public function fische() {
        $creatures = $this->creatureRepo->findByCategory('fish');
        $title = 'Fische';
        require __DIR__ . '/../../views/faunapedia-fish.php';
    }

    /**
     * Übersicht: Insekten
     */
    public function insekten() {
        $creatures = $this->creatureRepo->findByCategory('insect');
        $title = 'Insekten';
        require __DIR__ . '/../../views/faunapedia-insects.php';
    }

    /**
     * Übersicht: Meerestiere
     */
    public function meerestiere() {
        $creatures = $this->creatureRepo->findByCategory('sea');
        $title = 'Meerestiere';
        require __DIR__ . '/../../views/faunapedia-sea.php';
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