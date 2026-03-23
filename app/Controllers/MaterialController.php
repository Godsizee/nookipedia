<?php

namespace App\Controllers;

use App\Repositories\MaterialRepository;

class MaterialController {
    
    private $repo;

    public function __construct() {
        $this->repo = new MaterialRepository();
    }

    public function index() {
        $title = 'Materialien & Zutaten';
        $category = 'materials';
        
        $allMaterials = $this->repo->getAll();
        
        // SRP: Controller gruppiert die Daten für die View
        $groupedMaterials = [
            'normal' => [],
            'seasonal' => [],
            'other' => []
        ];
        
        foreach ($allMaterials as $material) {
            if (array_key_exists($material->category, $groupedMaterials)) {
                $groupedMaterials[$material->category][] = $material;
            }
        }

        require __DIR__ . '/../../views/material-list.php';
    }
}