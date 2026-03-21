<?php

/**
 * Nookipedia-Next 
 * Robuster Einstiegspunkt - Erkennt automatisch Live- vs. Lokal-Umgebung
 */

// --- Autoloading ---
spl_autoload_register(function ($class) {
    $prefix = 'App\\';
    $base_dir = __DIR__ . '/../app/';
    $len = strlen($prefix);
    if (strncmp($prefix, $class, $len) !== 0) return;
    $relative_class = substr($class, $len);
    $file = $base_dir . str_replace('\\', '/', $relative_class) . '.php';
    if (file_exists($file)) require $file;
});

// --- Intelligente Pfad-Logik ---
$scriptName = $_SERVER['SCRIPT_NAME']; // z.B. /index.php (Live) oder /files/nookipedia/public/index.php (Lokal)
$requestUri = $_SERVER['REQUEST_URI'];

// Wir ermitteln, ob wir in einem Unterordner laufen
// dirname($scriptName) gibt uns den Pfad zum public-Ordner
$publicUrlPath = rtrim(str_replace('\\', '/', dirname($scriptName)), '/');

// BASE_PATH ist alles VOR dem public-Ordner (für lokale Dev-Umgebungen)
// Wenn public der Root ist (Live), wird BASE_PATH leer sein.
$basePath = str_replace('/public', '', $publicUrlPath);
if ($basePath === '/') $basePath = '';

define('BASE_PATH', $basePath);
// ASSET_PATH ist der Pfad, den der Browser nutzen muss, um den public-Ordner zu erreichen
define('ASSET_PATH', $publicUrlPath);

use App\Core\Router;

$router = new Router();
$router->add('', 'HomeController', 'index');
$router->add('insekten', 'CreatureController', 'insects');
$router->add('fische', 'CreatureController', 'fish');
$router->add('meerestiere', 'CreatureController', 'sea');

// --- Route berechnen ---
$route = $requestUri;
// 1. Query String entfernen
$route = explode('?', $route)[0];
// 2. Den Pfad zum public-Ordner vorne wegschneiden
if ($publicUrlPath !== '' && strpos($route, $publicUrlPath) === 0) {
    $route = substr($route, strlen($publicUrlPath));
}
// 3. Trimmen
$route = trim($route, '/');

$router->dispatch($route);