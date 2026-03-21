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
        $creatures = $this->repo->getByCategory('insect');
        require __DIR__ . '/../../views/creature-list.php';
    }

    public function fish() {
        $title = 'Fische';
        $category = 'fish';
        $creatures = $this->repo->getByCategory('fish');
        require __DIR__ . '/../../views/creature-list.php';
    }

    public function sea() {
        $title = 'Meerestiere';
        $category = 'sea';
        $creatures = $this->repo->getByCategory('sea');
        require __DIR__ . '/../../views/creature-list.php';
    }
}