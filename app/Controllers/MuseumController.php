<?php

namespace App\Controllers;

use App\Core\Controller;
use App\Repositories\FossilRepository;
use App\Repositories\ArtworkRepository;
use App\Repositories\CreatureRepository;

class MuseumController extends Controller {
    
    private $fossilRepo;
    private $artworkRepo;
    private $creatureRepo;

    public function __construct() {
        parent::__construct(); // Wichtig für den Passwort-Schutz!
        $this->fossilRepo = new FossilRepository();
        $this->artworkRepo = new ArtworkRepository();
        $this->creatureRepo = new CreatureRepository();
    }

    /**
     * Die Museums-Eingangshalle (Hub)
     */
    public function index() {
        $title = 'Eugen\'s Museum';
        require __DIR__ . '/../../views/museum/museum-hub.php';
    }

    /**
     * Fossilien-Abteilung
     */
    public function fossils() {
        $title = 'Fossilienausstellung';
        $allFossils = $this->fossilRepo->getAll();
        
        $groupedFossils = [];
        $standaloneFossils = [];

        foreach ($allFossils as $fossil) {
            if (!empty($fossil->dinosaur_group)) {
                $groupedFossils[$fossil->dinosaur_group][] = $fossil;
            } else {
                $standaloneFossils[] = $fossil;
            }
        }

        require __DIR__ . '/../../views/museum/museum-fossils.php';
    }

    /**
     * Kunstgalerie (Reiners Schatzkiste)
     */
    public function artworks() {
        $title = 'Kunstgalerie';
        $artworks = $this->artworkRepo->getAll();
        
        require __DIR__ . '/../../views/museum/museum-art.php';
    }

    /**
     * "Echt vs. Fälschung" Detailseite
     */
    public function artDetail($id) {
        $artwork = $this->artworkRepo->findById($id);
        
        if (!$artwork) {
            header("Location: /museum/kunstwerke");
            exit;
        }

        $title = $artwork->name . ' - Fälschungscheck';
        require __DIR__ . '/../../views/museum/museum-art-detail.php';
    }

    /**
     * Insektenausstellung im Museum
     */
    public function insects() {
        $title = 'Insektenabteilung';
        $creatures = $this->creatureRepo->getByCategory('insect');
        require __DIR__ . '/../../views/museum/museum-insects.php';
    }

    /**
     * Aquarium: Fische im Museum
     */
    public function fish() {
        $title = 'Aquarium (Fische)';
        $creatures = $this->creatureRepo->getByCategory('fish');
        require __DIR__ . '/../../views/museum/museum-fish.php';
    }

    /**
     * Aquarium: Meerestiere im Museum
     */
    public function sea() {
        $title = 'Aquarium (Meerestiere)';
        $creatures = $this->creatureRepo->getByCategory('sea');
        require __DIR__ . '/../../views/museum/museum-sea.php';
    }
}