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
     * Performance-Update: Nutzt eine einzige UNION ALL Abfrage.
     */
    public function searchAll($term, $isLive = true) {
        $results = [];
        
        // ILIKE = Case-insensitive Suche in PostgreSQL
        $searchTerm = '%' . $term . '%';
        
        // Limits nur setzen, wenn es ein Live-Search API-Call ist
        $limit5 = $isLive ? " LIMIT 5" : "";
        $limit4 = $isLive ? " LIMIT 4" : "";
        $limit3 = $isLive ? " LIMIT 3" : "";
        
        // PERFORMANCE BOOST: 6 Queries zu 1 UNION ALL zusammengefasst!
        // WICHTIG: Die Spaltenanzahl und Datentypen (z.B. CAST zu TEXT) müssen in allen SELECTs exakt übereinstimmen.
        $sql = "
            (SELECT CAST(id AS TEXT) as id, name, image_path, CAST(price AS TEXT) as subtitle, 'creature' as source, category FROM creatures WHERE name ILIKE :term $limit5)
            UNION ALL
            (SELECT CAST(id AS TEXT) as id, name, image_path, 'Pflanzenwelt' as subtitle, 'flower' as source, '' as category FROM flowers WHERE name ILIKE :term $limit3)
            UNION ALL
            (SELECT CAST(id AS TEXT) as id, name, image_path, CAST(sell_price AS TEXT) as subtitle, 'material' as source, '' as category FROM materials WHERE name ILIKE :term $limit4)
            UNION ALL
            (SELECT CAST(id AS TEXT) as id, name, image_path, category as subtitle, 'diy' as source, '' as category FROM diy_recipes WHERE name ILIKE :term $limit3)
            UNION ALL
            (SELECT CAST(id AS TEXT) as id, name, image_path, category as subtitle, 'cooking' as source, '' as category FROM cooking_recipes WHERE name ILIKE :term $limit3)
            UNION ALL
            (SELECT CAST(id AS TEXT) as id, name, image_path, date_description as subtitle, 'event' as source, '' as category FROM events WHERE name ILIKE :term $limit3)
        ";

        $stmt = $this->db->prepare($sql);
        // Wir übergeben das Token nur 1x. Moderne PDO/Postgres Versionen lösen den Platzhalter in allen Sub-Queries auf.
        $stmt->execute(['term' => $searchTerm]);
        $rows = $stmt->fetchAll();

        // 1 einziger Durchlauf für alle gemischten Ergebnisse
        foreach ($rows as $row) {
            $url = '';
            $badge = '';
            $subtitle = $row['subtitle'];
            $imagePath = 'acnh/' . $row['image_path']; // Basis-Pfad

            // URL und Badge je nach Quelle (Source) zuweisen
            switch ($row['source']) {
                case 'creature':
                    $subtitle .= ' Sternis'; // Nur bei Kreaturen hängen wir "Sternis" an den numerischen Preis an
                    $url = '/tier/'.$row['id']; // Sauberer Link auf die Detailseite (KISS)
                    if ($row['category'] === 'insect') { $badge = '🦋 Insekt'; }
                    elseif ($row['category'] === 'fish') { $badge = '🐟 Fisch'; }
                    elseif ($row['category'] === 'sea') { $badge = '🐙 Meerestier'; }
                    break;
                case 'flower':
                    $url = '/blume/'.$row['id']; // Clean URL aus Schritt 1.A!
                    $badge = '🌷 Blume';
                    break;
                case 'material':
                    $url = '/materialien#mat-'.$row['id'];
                    $imagePath = 'acnh/materials/' . $row['image_path']; // Eigener Ordner
                    $badge = '🪵 Material';
                    break;
                case 'diy':
                    $url = '/bastelanleitungen';
                    $badge = '🔨 DIY';
                    break;
                case 'cooking':
                    $url = '/kochrezepte';
                    $badge = '🍳 Kochen';
                    break;
                case 'event':
                    $url = '/events#event-'.$row['id'];
                    $imagePath = 'acnh/events/' . $row['image_path']; // Eigener Ordner
                    $badge = '🎉 Event';
                    break;
            }

            $results[] = $this->formatResult($row['name'], $subtitle, $url, $imagePath, $badge);
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