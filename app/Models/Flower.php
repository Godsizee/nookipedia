<?php

namespace App\Models;

class Flower {
    public $id;
    public $name;
    public $description;
    public $image_path;
    public $colors;

    public function __construct($data = []) {
        $this->id = $data['id'] ?? null;
        $this->name = $data['name'] ?? '';
        $this->description = $data['description'] ?? '';
        $this->image_path = $data['image_path'] ?? 'placeholder.png';
        
        // Postgres Arrays in PHP-Arrays umwandeln
        $this->colors = $this->parsePostgresArray($data['colors'] ?? '{}');
    }

    /**
     * Hilfsmethode um PostgreSQL {"Rot","Blau"} in PHP ['Rot', 'Blau'] zu wandeln
     */
    private function parsePostgresArray($pgArray) {
        if (is_array($pgArray)) return $pgArray;
        
        // Entferne die geschweiften Klammern und Anführungszeichen
        $cleaned = trim($pgArray, '{}');
        if ($cleaned === '') return [];
        
        $cleaned = str_replace('"', '', $cleaned);
        return explode(',', $cleaned);
    }

    /**
     * Sexy Helper: Gibt den vollen Pfad zum Bild zurück
     */
    public function getImageUrl() {
        return "/assets/img/acnh/" . $this->image_path;
    }
}