<?php

namespace App\Controllers;

use App\Repositories\CreatureRepository;

class CreatureController {
    private $repo;

    public function __construct() {
        $this->repo = new CreatureRepository();
    }

    public function insects() {
        $title = 'Insekten';
        $category = 'insect';
        // Definiere das spezifische Fluff-Text Partial (OCP & SRP)
        $infoTemplate = 'partials/info_insect.php';
        $creatures = $this->repo->getByCategory('insect');
        require __DIR__ . '/../../views/creature-list.php';
    }

    public function fish() {
        $title = 'Fische';
        $category = 'fish';
        $infoTemplate = 'partials/info_fish.php';
        $creatures = $this->repo->getByCategory('fish');
        require __DIR__ . '/../../views/creature-list.php';
    }

    public function sea() {
        $title = 'Meerestiere';
        $category = 'sea';
        $infoTemplate = 'partials/info_sea.php';
        $creatures = $this->repo->getByCategory('sea');
        require __DIR__ . '/../../views/creature-list.php';
    }
}