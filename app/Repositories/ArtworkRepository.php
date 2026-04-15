<?php

namespace App\Repositories;

use App\Core\Database;
use App\Models\Artwork;
use PDO;

class ArtworkRepository {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Holt alle Kunstwerke alphabetisch
     */
    public function getAll() {
        $sql = "SELECT * FROM artworks ORDER BY type ASC, name ASC";
        $stmt = $this->db->query($sql);
        $results = $stmt->fetchAll();
        
        $artworks = [];
        foreach ($results as $row) {
            $artworks[] = new Artwork($row);
        }
        
        return $artworks;
    }

    /**
     * Holt ein einzelnes Kunstwerk anhand der ID (für die Detailseite)
     */
    public function findById($id) {
        $sql = "SELECT * FROM artworks WHERE id = :id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        
        return $row ? new Artwork($row) : null;
    }
}