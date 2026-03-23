<?php

namespace App\Controllers;

use App\Repositories\RecipeRepository;

class RecipeController {
    
    private $repo;

    public function __construct() {
        $this->repo = new RecipeRepository();
    }

    public function diy() {
        $title = 'Bastelanleitungen';
        $category = 'diy';
        
        $allRecipes = $this->repo->getAllDiy();
        
        // SRP: Controller gruppiert die Daten für die View
        $groupedRecipes = [];
        foreach ($allRecipes as $recipe) {
            $groupedRecipes[$recipe->category][] = $recipe;
        }

        require __DIR__ . '/../../views/recipe-list.php';
    }

    public function cooking() {
        $title = 'Kochrezepte';
        $category = 'cooking';
        
        $allRecipes = $this->repo->getAllCooking();
        
        // SRP: Controller gruppiert die Daten für die View
        $groupedRecipes = [];
        foreach ($allRecipes as $recipe) {
            $groupedRecipes[$recipe->category][] = $recipe;
        }

        require __DIR__ . '/../../views/recipe-list.php';
    }
}