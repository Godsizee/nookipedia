<?php

namespace App\Repositories;

use App\Core\Database;
use App\Models\Npc;
use PDO;

class NpcRepository {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    public function getMuseumNpcs() {
        // Wir holen Eugen, Kofi und Reiner anhand ihrer Namen oder Rollen
        $sql = "SELECT * FROM npcs WHERE name IN ('Eugen', 'Kofi', 'Reiner') ORDER BY id ASC";
        $stmt = $this->db->query($sql);
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $npcs = [];
        foreach ($results as $row) {
            $npcs[] = new Npc($row);
        }
        return $npcs;
    }

    public function findByName($name) {
        $sql = "SELECT * FROM npcs WHERE LOWER(name) = LOWER(:name) LIMIT 1";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(['name' => $name]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        
        return $row ? new Npc($row) : null;
    }
}