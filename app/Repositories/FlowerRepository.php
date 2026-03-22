<?php

namespace App\Repositories;

use App\Core\Database;
use App\Models\Flower;
use PDO;

class FlowerRepository {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Holt alle Blumen alphabetisch sortiert
     */
    public function getAll() {
        $stmt = $this->db->query("SELECT * FROM flowers ORDER BY name ASC");
        $results = $stmt->fetchAll();
        
        $flowers = [];
        foreach ($results as $row) {
            $flowers[] = new Flower($row);
        }
        
        return $flowers;
    }
}