<?php
// 1. ZUERST SESSION STARTEN!
session_start();

// --- PERFORMANCE: .env zentral EINMALIG laden ---
// FIX: Nur ein Ordner-Level nach oben springen (von public/ ins nookipedia/ Root)
$envPath = __DIR__ . '/../.env';
if (file_exists($envPath)) {
    $lines = file($envPath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        $line = trim($line);
        // Ignoriere Kommentare
        if (strpos($line, '#') === 0 || strpos($line, ';') === 0) continue;
        
        // Schlüssel und Wert trennen und global im RAM speichern
        if (strpos($line, '=') !== false) {
            list($key, $value) = explode('=', $line, 2);
            $key = trim($key);
            $value = trim($value, " \t\n\r\0\x0B\"'"); 
            $_ENV[$key] = $value; 
        }
    }
}

// ACHTUNG: Die globale Login-Prüfung wurde hier entfernt! (Schritt 1.C)
// Sie liegt jetzt gekapselt und sauber im Basis-Controller (app/Core/Controller.php)

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
$router->add('login', 'AuthController', 'login');
$router->add('authenticate', 'AuthController', 'authenticate');
$router->add('logout', 'AuthController', 'logout');
$router->add('', 'HomeController', 'index');
$router->add('insekten', 'CreatureController', 'insects');
$router->add('fische', 'CreatureController', 'fish');
$router->add('meerestiere', 'CreatureController', 'sea');
$router->add('blumen', 'FlowerController', 'index'); 
$router->add('blume/{id}', 'FlowerController', 'show');    // CLEAN URL: Dynamischer Parameter {id}

// --- NEU: Das Museum ---
$router->add('museum', 'MuseumController', 'index');
$router->add('museum/npc/eugen', 'MuseumController', 'npcEugen');
$router->add('museum/npc/kofi', 'MuseumController', 'npcKofi');
$router->add('museum/npc/reiner', 'MuseumController', 'npcReiner');
$router->add('museum/fossilien', 'MuseumController', 'fossils');
$router->add('museum/kunstwerke', 'MuseumController', 'artworks');
$router->add('museum/kunstwerke/{id}', 'MuseumController', 'artDetail');
$router->add('museum/insekten', 'MuseumController', 'insects');
$router->add('museum/fische', 'MuseumController', 'fish');
$router->add('museum/meerestiere', 'MuseumController', 'sea');

$router->add('events', 'EventController', 'index');
$router->add('materialien', 'MaterialController', 'index'); 
$router->add('bastelanleitungen', 'RecipeController', 'diy');
$router->add('kochrezepte', 'RecipeController', 'cooking');

// --- NEU: Such-Routen ---
$router->add('api/search', 'SearchController', 'api'); // JSON-Endpunkt für Spotlight
$router->add('suche', 'SearchController', 'index');    // HTML-Ergebnisseite für Enter-Druck

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