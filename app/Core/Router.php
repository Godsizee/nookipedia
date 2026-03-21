<?php

namespace App\Core;

class Router {
    protected $routes = [];

    public function add($url, $controller, $action) {
        $this->routes[trim($url, '/')] = [
            'controller' => $controller,
            'action' => $action
        ];
    }

    public function dispatch($url) {
        $url = trim($url, '/');

        if (array_key_exists($url, $this->routes)) {
            $controllerName = "App\\Controllers\\" . $this->routes[$url]['controller'];
            $action = $this->routes[$url]['action'];

            if (class_exists($controllerName)) {
                $controller = new $controllerName();
                if (method_exists($controller, $action)) {
                    $controller->$action();
                    return;
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