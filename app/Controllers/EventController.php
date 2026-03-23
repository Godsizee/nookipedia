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
        
        $infoTemplate = 'partials/info_event.php';
        
        // Alle Events aus der DB holen
        $allEvents = $this->repo->getAllOrderedByMonth();
        
        // SRP & OCP: Wir gruppieren die Events hier im Controller logisch nach Monaten,
        // anstatt komplexe Logik in die View zu packen.
        $eventsByMonth = [];
        for ($i = 1; $i <= 12; $i++) {
            $eventsByMonth[$i] = [];
        }
        
        foreach ($allEvents as $event) {
            if ($event->month >= 1 && $event->month <= 12) {
                $eventsByMonth[$event->month][] = $event;
            }
        }

        require __DIR__ . '/../../views/event-list.php';
    }
}