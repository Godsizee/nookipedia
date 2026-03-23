<?php

namespace App\Repositories;

use App\Core\Database;
use App\Models\Recipe;
use PDO;

class RecipeRepository {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Holt alle Bastelanleitungen, sortiert nach Kategorie und Name
     */
    public function getAllDiy() {
        $stmt = $this->db->query("SELECT *, 'diy' as type FROM diy_recipes ORDER BY category ASC, name ASC");
        $results = $stmt->fetchAll();
        
        $recipes = [];
        foreach ($results as $row) {
            $recipes[] = new Recipe($row);
        }
        
        // SRP: Auslagern des Material-Fetches in eine private Methode
        $this->attachMaterials($recipes, 'diy');
        
        return $recipes;
    }

    /**
     * Holt alle Kochrezepte, sortiert nach Kategorie und Name
     */
    public function getAllCooking() {
        $stmt = $this->db->query("SELECT *, 'cooking' as type FROM cooking_recipes ORDER BY category ASC, name ASC");
        $results = $stmt->fetchAll();
        
        $recipes = [];
        foreach ($results as $row) {
            $recipes[] = new Recipe($row);
        }
        
        $this->attachMaterials($recipes, 'cooking');
        
        return $recipes;
    }

    /**
     * Private Hilfsmethode (KISS), um in einem Rutsch alle Materialien für die übergebenen Rezepte zu laden.
     * Verhindert das langsame N+1 Query Problem.
     */
    private function attachMaterials(&$recipes, $type) {
        if (empty($recipes)) return;

        // IDs aller geladenen Rezepte extrahieren
        $recipeIds = array_map(function($r) { return $r->id; }, $recipes);
        
        // PDO Platzhalter generieren (?, ?, ?)
        $placeholders = implode(',', array_fill(0, count($recipeIds), '?'));
        
        // Welche Spalte müssen wir im JOIN ansprechen?
        $fkColumn = $type === 'diy' ? 'diy_recipe_id' : 'cooking_recipe_id';

        $sql = "SELECT im.$fkColumn AS recipe_id, m.id as material_id, m.name, m.image_path, im.amount 
                FROM item_materials im
                JOIN materials m ON im.material_id = m.id
                WHERE im.$fkColumn IN ($placeholders)";
                
        $stmt = $this->db->prepare($sql);
        $stmt->execute($recipeIds);
        $materialsData = $stmt->fetchAll();

        // Materialien nach recipe_id gruppieren
        $groupedMaterials = [];
        foreach ($materialsData as $row) {
            $groupedMaterials[$row['recipe_id']][] = (object) [
                'id'         => $row['material_id'],
                'name'       => $row['name'],
                'image_path' => $row['image_path'],
                'amount'     => $row['amount']
            ];
        }

        // Materialien den Rezept-Objekten zuweisen
        foreach ($recipes as $recipe) {
            if (isset($groupedMaterials[$recipe->id])) {
                $recipe->materials = $groupedMaterials[$recipe->id];
            }
        }
    }
}