<?php
// 1. ZUERST SESSION STARTEN!
session_start();

// --- PERFORMANCE: .env zentral EINMALIG laden ---
$envPath = __DIR__ . '/../../.env';
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

// 2. GLOBALE LOGIN-PRÜFUNG (Türsteher)
$route = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

// Diese Routen dürfen ohne Login betreten werden (und natürlich CSS/Bilder)
$publicRoutes = ['/login', '/authenticate'];

// Prüfe, ob es sich um eine statische Datei (CSS/IMG/JS) handelt
$isAsset = preg_match('/\.(?:png|jpg|jpeg|gif|css|js)$/', $route);

// Wenn der Nutzer nicht eingeloggt ist, es keine public Route und kein Asset ist -> Kick!
if (!isset($_SESSION['user_logged_in']) || $_SESSION['user_logged_in'] !== true) {
    if (!$isAsset && !in_array($route, $publicRoutes)) {
        header('Location: /login');
        exit;
    }
}

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
$router->add('blumen', 'FlowerController', 'index'); // Für die Übersicht
$router->add('blume', 'FlowerController', 'show');   // WICHTIG: Für die Detailseite!
$router->add('events', 'EventController', 'index');
$router->add('materialien', 'MaterialController', 'index'); // NEU: Route für Materialien & Zutaten
$router->add('bastelanleitungen', 'RecipeController', 'diy');
$router->add('kochrezepte', 'RecipeController', 'cooking');

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