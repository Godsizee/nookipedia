<?php

namespace App\Controllers;

use App\Repositories\EventRepository;

class EventController {
    
    private $repo;

    public function __construct() {
        $this->repo = new EventRepository();
    }

    public function index() {
        $title = 'Feiertage & Events';
        $category = 'events';
        
        // Fluff-Text Partial
        $infoTemplate = 'partials/info_event.php';
        
        // Events aus der DB holen
        $events = $this->repo->getAllOrderedByMonth();

        // View laden
        require __DIR__ . '/../../views/event-list.php';
    }
}