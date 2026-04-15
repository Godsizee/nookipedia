<?php

namespace App\Models;

class Npc {
    public $id;
    public $name;
    public $name_en;
    public $type;
    public $role;
    public $species;
    public $gender;
    public $birthday;
    public $image_path;
    public $description;

    public function __construct($data = []) {
        $this->id = $data['id'] ?? null;
        $this->name = $data['name'] ?? '';
        $this->name_en = $data['name_en'] ?? '';
        $this->type = $data['type'] ?? 'special';
        $this->role = $data['role'] ?? '';
        $this->species = $data['species'] ?? '';
        $this->gender = $data['gender'] ?? '';
        $this->birthday = $data['birthday'] ?? '';
        $this->image_path = $data['image_path'] ?? '';
        $this->description = $data['description'] ?? '';
    }

    public function getImageUrl() {
        return "/assets/img/acnh/" . $this->image_path;
    }
}