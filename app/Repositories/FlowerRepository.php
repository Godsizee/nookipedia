<?php

namespace App\Repositories;

use App\Core\Database;
use App\Models\Flower;
use App\Models\FlowerCombination;
use PDO;

class FlowerRepository {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Holt alle Blumen alphabetisch sortiert für die Übersichtsseite
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

    /**
     * Holt eine einzelne Blume anhand ihrer ID (für die Detailseite)
     */
    public function findById($id) {
        $stmt = $this->db->prepare("SELECT * FROM flowers WHERE id = :id");
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        
        return $row ? new Flower($row) : null;
    }

    /**
     * Holt alle Zuchtkombinationen einer bestimmten Blume
     */
    public function getCombinations($flowerId) {
        $stmt = $this->db->prepare("SELECT * FROM flower_combinations WHERE flower_id = :id ORDER BY id ASC");
        $stmt->execute(['id' => $flowerId]);
        
        $combinations = [];
        foreach ($stmt->fetchAll() as $row) {
            $combinations[] = new FlowerCombination($row);
        }
        
        return $combinations;
    }

    /**
     * Holt alle erhältlichen Samen (Grundfarben) für eine Blume
     */
    public function getSeeds($flowerId) {
        $stmt = $this->db->prepare("SELECT * FROM flower_seeds WHERE flower_id = :id ORDER BY id ASC");
        $stmt->execute(['id' => $flowerId]);
        
        // Wir nutzen hier direkt FETCH_OBJ für ein schlankes Datenobjekt (SRP & KISS)
        return $stmt->fetchAll(PDO::FETCH_OBJ);
    }
}