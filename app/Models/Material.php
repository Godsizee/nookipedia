<?php

namespace App\Models;

class Material {
    public $id;
    public $name;
    public $category;
    public $source;
    public $sell_price;
    public $image_path;

    public function __construct($data = []) {
        $this->id = $data['id'] ?? null;
        $this->name = $data['name'] ?? '';
        $this->category = $data['category'] ?? 'normal';
        $this->source = $data['source'] ?? '';
        $this->sell_price = $data['sell_price'] ?? '';
        $this->image_path = $data['image_path'] ?? 'material_placeholder.png';
    }

    /**
     * Gibt den korrekten Pfad für Material-Bilder zurück
     */
    public function getImageUrl() {
        return "/assets/img/acnh/materials/" . $this->image_path;
    }
}