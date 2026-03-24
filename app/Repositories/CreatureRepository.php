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

    public function getByCategory($category) {
        // NEU: LEFT JOIN auf creature_speeds für die Meerestier-Bewegung
        $sql = "
            SELECT c.*, cl.location_name, cs.shadow_image, csp.speed
            FROM creatures c
            LEFT JOIN creature_locations cl ON c.id = cl.creature_id
            LEFT JOIN creature_shadows cs ON c.id = cs.creature_id
            LEFT JOIN creature_speeds csp ON c.id = csp.creature_id
            WHERE c.category = :category 
            ORDER BY c.name ASC
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(['category' => $category]);
        
        $results = $stmt->fetchAll();
        $creatures = [];
        
        foreach ($results as $row) {
            $creatures[] = new Creature($row);
        }
        
        return $creatures;
    }

    public function findById($id) {
        $sql = "
            SELECT c.*, cl.location_name, cs.shadow_image, csp.speed
            FROM creatures c
            LEFT JOIN creature_locations cl ON c.id = cl.creature_id
            LEFT JOIN creature_shadows cs ON c.id = cs.creature_id
            LEFT JOIN creature_speeds csp ON c.id = csp.creature_id
            WHERE c.id = :id
        ";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        
        return $row ? new Creature($row) : null;
    }
}