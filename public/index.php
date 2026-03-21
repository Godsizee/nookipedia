<?php

/**
 * Nookipedia-Next 
 * Robuster Einstiegspunkt mit automatischer Pfaderkennung (XAMPP-kompatibel)
 */

// --- Autoloading (KISS-Prinzip) ---
spl_autoload_register(function ($class) {
    $prefix = 'App\\';
    $base_dir = __DIR__ . '/../app/';

    $len = strlen($prefix);
    if (strncmp($prefix, $class, $len) !== 0) {
        return;
    }

    $relative_class = substr($class, $len);
    $file = $base_dir . str_replace('\\', '/', $relative_class) . '.php';

    if (file_exists($file)) {
        require $file;
    }
});

// --- Intelligente Basis-Pfad Erkennung ---
// Ermittelt den Pfad zum Projekt-Root (z.B. /files/nookipedia)
$scriptName = $_SERVER['SCRIPT_NAME']; // e.g. /files/nookipedia/public/index.php
$publicPath = str_replace('\\', '/', dirname($scriptName)); // e.g. /files/nookipedia/public
$basePath = str_replace('\\', '/', dirname($publicPath)); // e.g. /files/nookipedia

// Falls wir direkt im Root sind, setzen wir einen leeren String statt /
if ($basePath === '/') {
    $basePath = '';
}

define('BASE_PATH', $basePath);

use App\Core\Router;

// --- Router Setup ---
$router = new Router();

// Definition der Routen
$router->add('', 'HomeController', 'index');
$router->add('insekten', 'CreatureController', 'insects');
$router->add('fische', 'CreatureController', 'fish');
$router->add('meerestiere', 'CreatureController', 'sea');

// --- Request URI verarbeiten ---
$requestUri = str_replace('\\', '/', $_SERVER['REQUEST_URI']);

// 1. BASE_PATH entfernen
if (BASE_PATH !== '' && strpos($requestUri, BASE_PATH) === 0) {
    $requestUri = substr($requestUri, strlen(BASE_PATH));
}

// 2. /public Pfad entfernen, falls er in der URL steht
if (strpos($requestUri, '/public') === 0) {
    $requestUri = substr($requestUri, 7);
}

// 3. Query Strings (Sonderzeichen nach ?) entfernen und Trimming
$route = trim(explode('?', $requestUri)[0], '/');

// Dispatcher starten
$router->dispatch($route);