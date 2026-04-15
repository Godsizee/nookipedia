<?php

namespace App\Models;

class Artwork {
    public $id;
    public $name;
    public $type; // 'painting' oder 'statue'
    public $real_world_name;
    public $artist;
    public $image_real;
    public $image_fake;
    public $fake_description;

    public function __construct($data = []) {
        $this->id = $data['id'] ?? null;
        $this->name = $data['name'] ?? '';
        $this->type = $data['type'] ?? 'painting';
        $this->real_world_name = $data['real_world_name'] ?? '';
        $this->artist = $data['artist'] ?? '';
        $this->image_real = $data['image_real'] ?? 'placeholder.png';
        $this->image_fake = $data['image_fake'] ?? null;
        $this->fake_description = $data['fake_description'] ?? null;
    }

    public function getRealImageUrl() {
        // NEU: Setzt automatisch den museum/ Pfad davor
        return "/assets/img/acnh/museum/" . $this->image_real;
    }

    public function getFakeImageUrl() {
        if (!$this->image_fake) return null;
        // NEU: Setzt automatisch den museum/ Pfad davor
        return "/assets/img/acnh/museum/" . $this->image_fake;
    }

    public function hasFake() {
        return !empty($this->image_fake);
    }
}