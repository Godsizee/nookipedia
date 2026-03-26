<?php

namespace App\Controllers;

use App\Repositories\SearchRepository;

class SearchController {
    
    private $searchRepo;

    public function __construct() {
        $this->searchRepo = new SearchRepository();
    }

    /**
     * API-Endpunkt für die Live-Suche
     * Route: /api/search?q=...
     */
    public function api() {
        // Ausgabe als JSON deklarieren (Trennung von Logik und Darstellung)
        header('Content-Type: application/json; charset=utf-8');

        // Eingabe säubern (KISS & Security)
        $query = trim($_GET['q'] ?? '');

        if (mb_strlen($query) < 2) {
            // Erst ab 2 Zeichen suchen, um die DB zu schonen
            echo json_encode(['results' => [], 'message' => 'Bitte mindestens 2 Zeichen eingeben.']);
            exit;
        }

        // Repository aufrufen (SRP)
        $results = $this->searchRepo->searchAll($query);

        // Intelligente Rückgabe
        echo json_encode([
            'results' => $results,
            'count' => count($results)
        ]);
        exit;
    }
}