<?php

namespace App\Repositories;

use App\Core\Database;
use App\Models\Material;

class MaterialRepository {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Holt alle Materialien, alphabetisch sortiert
     */
    public function getAll() {
        $stmt = $this->db->query("SELECT * FROM materials ORDER BY name ASC");
        $results = $stmt->fetchAll();
        
        $materials = [];
        foreach ($results as $row) {
            $materials[] = new Material($row);
        }
        
        return $materials;
    }
}