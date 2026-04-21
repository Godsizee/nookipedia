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
        // Wir holen Eugen, Kofi und Reiner anhand ihrer Namen aus der neuen Tabelle
        $sql = "SELECT * FROM special_npcs WHERE name_de IN ('Eugen', 'Kofi', 'Reiner') ORDER BY id ASC";
        $stmt = $this->db->query($sql);
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $npcs = [];
        foreach ($results as $row) {
            $npcs[] = new Npc($row);
        }
        return $npcs;
    }

    public function findByName($name) {
        $sql = "SELECT * FROM special_npcs WHERE LOWER(name_de) = LOWER(:name) LIMIT 1";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(['name' => $name]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        
        return $row ? new Npc($row) : null;
    }