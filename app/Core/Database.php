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
        // PERFORMANCE FIX: Datei wird nicht mehr gelesen! 
        // Wir nutzen direkt das zentral geladene $_ENV Array oder getenv() vom Server.
        $host = $_ENV['DB_HOST'] ?? getenv('DB_HOST') ?: '127.0.0.1';
        $port = $_ENV['DB_PORT'] ?? getenv('DB_PORT') ?: '5432';
        $db   = $_ENV['DB_NAME'] ?? getenv('DB_NAME') ?: 'nookipedia_db';
        $user = $_ENV['DB_USER'] ?? getenv('DB_USER') ?: 'n8n_user';
        $pass = $_ENV['DB_PASS'] ?? getenv('DB_PASS') ?: '';

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