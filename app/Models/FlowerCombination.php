<?php

namespace App\Models;

class FlowerCombination {
    public $id;
    public $flower_id;
    public $parent1_color;
    public $parent1_image;
    public $parent2_color;
    public $parent2_image;
    public $child_color;
    public $child_image;
    public $probability;
    public $notes;

    public function __construct($data = []) {
        $this->id = $data['id'] ?? null;
        $this->flower_id = $data['flower_id'] ?? null;
        $this->parent1_color = $data['parent1_color'] ?? '';
        $this->parent1_image = $data['parent1_image'] ?? '';
        $this->parent2_color = $data['parent2_color'] ?? '';
        $this->parent2_image = $data['parent2_image'] ?? '';
        $this->child_color = $data['child_color'] ?? '';
        $this->child_image = $data['child_image'] ?? '';
        $this->probability = $data['probability'] ?? '';
        $this->notes = $data['notes'] ?? '';
    }

    public function getImageUrl($image) {
        return "/assets/img/acnh/" . $image;
    }
}