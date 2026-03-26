<?php

namespace App\Repositories;

use App\Core\Database;
use PDO;

class SearchRepository {
    private $db;

    public function __construct() {
        $this->db = Database::getInstance()->getConnection();
    }

    /**
     * Durchsucht alle relevanten Entitäten und normalisiert die Ausgabe für die UI.
     * Zukunftssicher (OCP): Leicht erweiterbar um neue Tabellen.
     */
    public function searchAll($term) {
        $results = [];
        
        // ILIKE = Case-insensitive Suche in PostgreSQL
        $searchTerm = '%' . $term . '%';
        
        // 1. KREATUREN (Insekten, Fische, Meerestiere)
        $stmt = $this->db->prepare("SELECT id, name, category, image_path, price FROM creatures WHERE name ILIKE :term LIMIT 5");
        $stmt->execute(['term' => $searchTerm]);
        foreach ($stmt->fetchAll() as $row) {
            $url = '';
            $badge = '';
            if ($row['category'] === 'insect') { $url = '/insekten#creature-'.$row['id']; $badge = '🦋 Insekt'; }
            if ($row['category'] === 'fish') { $url = '/fische#creature-'.$row['id']; $badge = '🐟 Fisch'; }
            if ($row['category'] === 'sea') { $url = '/meerestiere#creature-'.$row['id']; $badge = '🐙 Meerestier'; }
            
            $results[] = $this->formatResult($row['name'], $row['price'] . ' Sternis', $url, 'acnh/' . $row['image_path'], $badge);
        }

        // 2. BLUMEN
        $stmt = $this->db->prepare("SELECT id, name, image_path FROM flowers WHERE name ILIKE :term LIMIT 3");
        $stmt->execute(['term' => $searchTerm]);
        foreach ($stmt->fetchAll() as $row) {
            $results[] = $this->formatResult($row['name'], 'Pflanzenwelt', '/blume?id='.$row['id'], 'acnh/' . $row['image_path'], '🌷 Blume');
        }

        // 3. MATERIALIEN
        $stmt = $this->db->prepare("SELECT id, name, image_path, sell_price FROM materials WHERE name ILIKE :term LIMIT 4");
        $stmt->execute(['term' => $searchTerm]);
        foreach ($stmt->fetchAll() as $row) {
            $results[] = $this->formatResult($row['name'], $row['sell_price'], '/materialien#mat-'.$row['id'], 'acnh/materials/' . $row['image_path'], '🪵 Material');
        }

        // 4. REZEPTE (DIY)
        $stmt = $this->db->prepare("SELECT id, name, image_path, category FROM diy_recipes WHERE name ILIKE :term LIMIT 3");
        $stmt->execute(['term' => $searchTerm]);
        foreach ($stmt->fetchAll() as $row) {
            $results[] = $this->formatResult($row['name'], $row['category'], '/bastelanleitungen', 'acnh/' . $row['image_path'], '🔨 DIY');
        }

        // 5. REZEPTE (Kochen)
        $stmt = $this->db->prepare("SELECT id, name, image_path, category FROM cooking_recipes WHERE name ILIKE :term LIMIT 3");
        $stmt->execute(['term' => $searchTerm]);
        foreach ($stmt->fetchAll() as $row) {
            $results[] = $this->formatResult($row['name'], $row['category'], '/kochrezepte', 'acnh/' . $row['image_path'], '🍳 Kochen');
        }

        // 6. EVENTS
        $stmt = $this->db->prepare("SELECT id, name, image_path, date_description FROM events WHERE name ILIKE :term LIMIT 3");
        $stmt->execute(['term' => $searchTerm]);
        foreach ($stmt->fetchAll() as $row) {
            $results[] = $this->formatResult($row['name'], $row['date_description'], '/events#event-'.$row['id'], 'acnh/events/' . $row['image_path'], '🎉 Event');
        }

        return $results;
    }

    /**
     * Standardisiert das Array-Format für die JSON API (KISS)
     */
    private function formatResult($title, $subtitle, $url, $imagePath, $typeBadge) {
        return [
            'title' => $title,
            'subtitle' => $subtitle,
            'url' => $url,
            // Fallback auf Platzhalter direkt im Backend sichern
            'image' => $imagePath ? '/assets/img/' . $imagePath : '/assets/img/acnh/placeholder.png',
            'type' => $typeBadge
        ];
    }
}