<?php 
class Database {
    private static $instance = null;
    private $conn;
    private $servername = "localhost";
    private $user = "kumo";
    private $pass = "coco3430";
    private $dbname = "spaced";

    private function __construct() {
        $this->conn = new mysqli($this->servername, $this->user, $this->pass, $this->dbname);
        if ($this->conn->connect_error) {
            die("連接失敗：" . $this->conn->connect_error);
        }
    }

    public static function getInstance() {
        if(!self::$instance) {
            self::$instance = new Database();
        }
        return self::$instance;
    }

    public function getConnection() {
        return $this->conn;
    }
}

?>