<?php

namespace App\Models;

class Event {
    public $id;
    public $name;
    public $event_type;
    public $month;
    public $date_description;
    public $description;
    public $image_path;

    public function __construct($data = []) {
        $this->id = $data['id'] ?? null;
        $this->name = $data['name'] ?? '';
        $this->event_type = $data['event_type'] ?? 'event';
        $this->month = $data['month'] ?? 0;
        $this->date_description = $data['date_description'] ?? '';
        $this->description = $data['description'] ?? '';
        $this->image_path = $data['image_path'] ?? 'placeholder.png';
    }

    /**
     * Gibt den vollen Pfad zum Bild zurück
     */
    public function getImageUrl() {
        return "/assets/img/acnh/events/" . $this->image_path;
    }

    /**
     * Übersetzt den Datenbank-Typ in einen lesbaren Badge-Namen
     */
    public function getFormattedType() {
        $types = [
            'holiday' => 'Feiertag',
            'tournament' => 'Turnier',
            'season' => 'Saison',
            'event' => 'Event'
        ];
        return $types[$this->event_type] ?? 'Event';
    }
    
    /**
     * Gibt die CSS-Klasse für das Badge basierend auf dem Typ zurück
     */
    public function getTypeCssClass() {
        return "badge-" . strtolower($this->event_type);
    }
}