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
        return explode(',', trim($pgArray, '{}'));
    }

    /**
     * Sexy Helper: Gibt den vollen Pfad zum Bild zurück
     */
    public function getImageUrl() {
        return "/assets/img/creatures/" . $this->image_path;
    }

    /**
     * Formatiert den Preis als "Sterni"-String
     */
    public function getFormattedPrice() {
        return number_format($this->price, 0, ',', '.') . ' Sternis';
    }
}