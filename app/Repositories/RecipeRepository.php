<?php

namespace App\Repositories;

use App\Core\Database;
use App\Models\Recipe;

class RecipeRepository {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Holt alle Bastelanleitungen, sortiert nach Kategorie und Name
     */
    public function getAllDiy() {
        // Wir injizieren hier den Typ 'diy', damit das Model Bescheid weiß
        $stmt = $this->db->query("SELECT *, 'diy' as type FROM diy_recipes ORDER BY category ASC, name ASC");
        $results = $stmt->fetchAll();
        
        $recipes = [];
        foreach ($results as $row) {
            $recipes[] = new Recipe($row);
        }
        
        return $recipes;
    }

    /**
     * Holt alle Kochrezepte, sortiert nach Kategorie und Name
     */
    public function getAllCooking() {
        // Wir injizieren hier den Typ 'cooking'
        $stmt = $this->db->query("SELECT *, 'cooking' as type FROM cooking_recipes ORDER BY category ASC, name ASC");
        $results = $stmt->fetchAll();
        
        $recipes = [];
        foreach ($results as $row) {
            $recipes[] = new Recipe($row);
        }
        
        return $recipes;
    }
}