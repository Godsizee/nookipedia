<?php

namespace App\Controllers;

use App\Repositories\SearchRepository;

class SearchController {
    
    private $searchRepo;

    public function __construct() {
        $this->searchRepo = new SearchRepository();
    }

    /**
     * API-Endpunkt für die Live-Suche (Spotlight)
     * Route: /api/search?q=...
     */
    public function api() {
        // Ausgabe als JSON deklarieren (Trennung von Logik und Darstellung)
        header('Content-Type: application/json; charset=utf-8');

        // Eingabe säubern (KISS & Security)
        $query = trim($_GET['q'] ?? '');

        if (mb_strlen($query) < 2) {
            echo json_encode(['results' => [], 'message' => 'Bitte mindestens 2 Zeichen eingeben.']);
            exit;
        }

        // Repository aufrufen (SRP) - true = limitierte Live-Suche
        $results = $this->searchRepo->searchAll($query, true);

        // Intelligente Rückgabe
        echo json_encode([
            'results' => $results,
            'count' => count($results)
        ]);
        exit;
    }

    /**
     * HTML-Endpunkt für die volle Suchergebnisseite
     * Route: /suche?q=...
     */
    public function index() {
        $query = trim($_GET['q'] ?? '');
        $title = "Suche";
        
        $results = [];
        if (mb_strlen($query) >= 2) {
            // false = kein Limit für die volle Suchergebnisseite (OCP)
            $results = $this->searchRepo->searchAll($query, false);
        }
        
        // Render View (Trennung Logik/View)
        require __DIR__ . '/../../views/search-results.php';
    }
}