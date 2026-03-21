<?php

namespace App\Models;

class Creature {
    public $id;
    public $category;
    public $name;
    public $price;
    public $catchphrase;
    public $image_path;
    public $months_northern;
    public $months_southern;
    public $time_active;

    public function __construct($data = []) {
        $this->id = $data['id'] ?? null;
        $this->category = $data['category'] ?? '';
        $this->name = $data['name'] ?? '';
        $this->price = $data['price'] ?? 0;
        $this->catchphrase = $data['catchphrase'] ?? '';
        $this->image_path = $data['image_path'] ?? 'placeholder.png';
        
        // Postgres Arrays in PHP-Arrays umwandeln (falls sie als String kommen)
        $this->months_northern = $this->parsePostgresArray($data['months_northern'] ?? '{}');
        $this->months_southern = $this->parsePostgresArray($data['months_southern'] ?? '{}');
        
        $this->time_active = $data['time_active'] ?? '';
    }

    /**
     * Hilfsmethode um PostgreSQL {1,2,3} in PHP [1,2,3] zu wandeln
     */
    private function parsePostgresArray($pgArray) {
        if (is_array($pgArray)) return $pgArray;
        $cleaned = trim($pgArray, '{}');
        if ($cleaned === '') return [];
        return explode(',', $cleaned);
    }

    /**
     * Sexy Helper: Gibt den vollen Pfad zum Bild zurück
     */
    public function getImageUrl() {
        return "/assets/img/acnh/" . $this->image_path;
    }

    /**
     * Formatiert den Preis als "Sterni"-String
     */
    public function getFormattedPrice() {
        return number_format($this->price, 0, ',', '.') . ' Sternis';
    }

    /**
     * Gibt die formatierten Monate als String zurück (z.B. "Jul, Aug")
     */
    public function getFormattedMonths() {
        if (empty($this->months_northern)) return 'Keine Angabe';
        if (count($this->months_northern) === 12) return 'Ganzjährig';

        $monthNames = [
            1 => 'Jan', 2 => 'Feb', 3 => 'Mär', 4 => 'Apr',
            5 => 'Mai', 6 => 'Jun', 7 => 'Jul', 8 => 'Aug',
            9 => 'Sep', 10 => 'Okt', 11 => 'Nov', 12 => 'Dez'
        ];

        $names = array_map(function($m) use ($monthNames) {
            return $monthNames[(int)$m] ?? '';
        }, $this->months_northern);

        return implode(', ', $names);
    }
}