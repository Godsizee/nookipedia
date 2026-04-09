<?php

namespace App\Core;

class Router {
    // Wir nutzen jetzt ein numerisches Array, um die Reihenfolge und Regex-Pattern zu speichern
    protected $routes = [];

    public function add($url, $controller, $action) {
        $url = trim($url, '/');
        
        // Wandle dynamische Parameter wie {id} in Regex-Gruppen um: (?P<id>[a-zA-Z0-9_-]+)
        $routeRegex = preg_replace('/\{([a-zA-Z0-9_-]+)\}/', '(?P<\1>[a-zA-Z0-9_-]+)', $url);
        
        // Füge Start- und Endanker hinzu für exaktes Matching
        $routeRegex = '/^' . str_replace('/', '\/', $routeRegex) . '$/';

        $this->routes[] = [
            'pattern' => $routeRegex,
            'controller' => $controller,
            'action' => $action
        ];
    }

    public function dispatch($url) {
        $url = trim($url, '/');

        foreach ($this->routes as $routeData) {
            // Prüfe, ob die aufgerufene URL zum Regex-Pattern der Route passt
            if (preg_match($routeData['pattern'], $url, $matches)) {
                $controllerName = "App\\Controllers\\" . $routeData['controller'];
                $action = $routeData['action'];

                if (class_exists($controllerName)) {
                    $controller = new $controllerName();
                    
                    if (method_exists($controller, $action)) {
                        // Filtere nur die benannten Parameter aus den Regex-Matches heraus
                        $params = array_filter($matches, 'is_string', ARRAY_FILTER_USE_KEY);
                        
                        // Rufe den Controller auf und übergebe die Parameter sauber an die Methode
                        call_user_func_array([$controller, $action], $params);
                        return;
                    }
                }
            }
        }
        
        $this->abort(404);
    }

    public function abort($code = 404) {
        http_response_code($code);
        
        // Wir nutzen den absoluten Pfad vom Projekt-Root aus
        $viewPath = __DIR__ . "/../../views/errors/$code.php";
        
        if (file_exists($viewPath)) {
            require $viewPath;
        } else {
            echo "<h1>$code - Not Found</h1><p>Zusätzlich wurde die Error-View nicht gefunden.</p>";
        }
        die();
    }
}