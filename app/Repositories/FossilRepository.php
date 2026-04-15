<?php

namespace App\Repositories;

use App\Core\Database;
use App\Models\Fossil;
use PDO;

class FossilRepository {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Holt alle Fossilien sortiert nach Gruppe und Typ
     */
    public function getAll() {
        // NULLS LAST sortiert Einzelfossilien nach den Dino-Gruppen ein
        $sql = "SELECT * FROM fossils ORDER BY dinosaur_group ASC NULLS LAST, name ASC";
        $stmt = $this->db->query($sql);
        $results = $stmt->fetchAll();
        
        $fossils = [];
        foreach ($results as $row) {
            $fossils[] = new Fossil($row);
        }
        
        return $fossils;
    }
}