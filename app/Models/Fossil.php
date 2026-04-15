<?php

namespace App\Models;

class Fossil {
    public $id;
    public $name;
    public $dinosaur_group;
    public $price;
    public $image_path;
    public $type; // 'skull', 'torso', 'tail', 'standalone', 'track'

    public function __construct($data = []) {
        $this->id = $data['id'] ?? null;
        $this->name = $data['name'] ?? '';
        $this->dinosaur_group = $data['dinosaur_group'] ?? null;
        $this->price = $data['price'] ?? 0;
        $this->image_path = $data['image_path'] ?? 'placeholder.png';
        $this->type = $data['type'] ?? 'standalone';
    }

    public function getImageUrl() {
        // NEU: Setzt automatisch den museum/ Pfad davor
        return "/assets/img/acnh/museum/" . $this->image_path;
    }

    public function getFormattedPrice() {
        return number_format($this->price, 0, ',', '.') . ' Sternis';
    }
}