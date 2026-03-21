<?php

namespace App\Repositories;

use App\Core\Database;
use App\Models\Creature;
use PDO;

class CreatureRepository {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Holt alle Tiere einer bestimmten Kategorie
     * @param string $category ('insect', 'fish', 'sea')
     */
    public function getByCategory($category) {
        $stmt = $this->db->prepare("SELECT * FROM creatures WHERE category = :category ORDER BY name ASC");
        $stmt->execute(['category' => $category]);
        
        $results = $stmt->fetchAll();
        $creatures = [];
        
        foreach ($results as $row) {
            $creatures[] = new Creature($row);
        }
        
        return $creatures;
    }

    /**
     * Holt ein einzelnes Tier anhand der ID
     */
    public function findById($id) {
        $stmt = $this->db->prepare("SELECT * FROM creatures WHERE id = :id");
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        
        return $row ? new Creature($row) : null;
    }
}