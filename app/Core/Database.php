<?php

namespace App\Core;

use PDO;
use PDOException;

/**
 * Database Class (Singleton)
 * Verwaltet die Verbindung zum PostgreSQL Container.
 */
class Database {
    private static $instance = null;
    private $connection;

    private function __construct() {
        // Laden der .env Datei (falls vorhanden - z.B. für lokales XAMPP)
        $envPath = __DIR__ . '/../../.env';
        $env = [];
        
        if (file_exists($envPath)) {
            // Eigener, robuster Parser anstelle von parse_ini_file(), 
            // da .env Dateien oft nicht zu 100% INI-konform sind.
            $lines = file($envPath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
            foreach ($lines as $line) {
                $line = trim($line);
                
                // Ignoriere Kommentare
                if (strpos($line, '#') === 0 || strpos($line, ';') === 0) {
                    continue;
                }
                
                // Schlüssel und Wert am '=' trennen
                if (strpos($line, '=') !== false) {
                    list($key, $value) = explode('=', $line, 2);
                    $key = trim($key);
                    // Entfernt Leerzeichen und Anführungszeichen um den Wert
                    $value = trim($value, " \t\n\r\0\x0B\"'"); 
                    $env[$key] = $value;
                }
            }
        }

        // Hole Variablen aus der .env ODER aus den Docker-Umgebungsvariablen (Portainer)
        $host = $env['DB_HOST'] ?? getenv('DB_HOST') ?: '127.0.0.1';
        $port = $env['DB_PORT'] ?? getenv('DB_PORT') ?: '5432';
        $db   = $env['DB_NAME'] ?? getenv('DB_NAME') ?: 'nookipedia_db';
        $user = $env['DB_USER'] ?? getenv('DB_USER') ?: 'n8n_user';
        $pass = $env['DB_PASS'] ?? getenv('DB_PASS') ?: '';

        // DSN für PostgreSQL
        $dsn = "pgsql:host=$host;port=$port;dbname=$db";
        
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
            // PostgreSQL spezifische Optimierung
            PDO::ATTR_PERSISTENT         => true 
        ];

        try {
            $this->connection = new PDO($dsn, $user, $pass, $options);
        } catch (PDOException $e) {
            // Im Livebetrieb Fehlermeldung loggen, nicht direkt ausgeben
            error_log("DB Connection Error: " . $e->getMessage());
            die("Datenbankverbindung fehlgeschlagen. Bitte prüfe die Logs.");
        }
    }

    /**
     * Singleton Instanz holen
     */
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * PDO Verbindungsobjekt zurückgeben
     */
    public function getConnection() {
        return $this->connection;
    }
}