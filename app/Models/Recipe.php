<?php

namespace App\Models;

class Recipe {
    public $id;
    public $type; // 'diy' oder 'cooking'
    public $category;
    public $name;
    public $materials_desc;
    public $durability;
    public $is_customizable;
    public $source;
    public $sell_price;
    public $image_path;

    public function __construct($data = []) {
        $this->id = $data['id'] ?? null;
        $this->type = $data['type'] ?? 'diy';
        $this->category = $data['category'] ?? '';
        $this->name = $data['name'] ?? '';
        $this->materials_desc = $data['materials_desc'] ?? '';
        $this->durability = $data['durability'] ?? null;
        // Wichtig: PostgreSQL gibt Boolean oft als 't'/'f' oder true/false zurück
        $this->is_customizable = isset($data['is_customizable']) ? (bool)$data['is_customizable'] : false;
        $this->source = $data['source'] ?? '';
        $this->sell_price = $data['sell_price'] ?? '';
        $this->image_path = $data['image_path'] ?? 'diy/96px-DIY_Recipe_NH_Icon.png';
    }

    /**
     * Gibt den korrekten Pfad für die Rezept-Bilder zurück
     */
    public function getImageUrl() {
        return "/assets/img/acnh/" . $this->image_path;
    }
}