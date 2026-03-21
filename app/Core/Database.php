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
            $env = parse_ini_file($envPath);
        }

        // Hole Variablen aus der .env ODER aus den Docker-Umgebungsvariablen (Portainer)
        $host = $env['DB_HOST'] ?? getenv('DB_HOST') ?: 'localhost';
        $port = $env['DB_PORT'] ?? getenv('DB_PORT') ?: '5432';
        $db   = $env['DB_NAME'] ?? getenv('DB_NAME') ?: 'nookipedia_db';
        $user = $env['DB_USER'] ?? getenv('DB_USER') ?: 'postgres';
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