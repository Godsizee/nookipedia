<?php

namespace App\Repositories;

use App\Core\Database;
use App\Models\Event;
use PDO;

class EventRepository {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Holt alle Events, sortiert nach Monat (Kalendarisch)
     */
    public function getAllOrderedByMonth() {
        // NULLs ans Ende, dann nach Monat aufsteigend
        $stmt = $this->db->query("SELECT * FROM events ORDER BY month ASC NULLS LAST, name ASC");
        $results = $stmt->fetchAll();
        
        $events = [];
        foreach ($results as $row) {
            $events[] = new Event($row);
        }
        
        return $events;
    }
}