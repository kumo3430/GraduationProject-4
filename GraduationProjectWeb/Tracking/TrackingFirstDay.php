<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

$todo_id = $data['id'];

$servername = "localhost"; // 資料庫伺服器名稱
$user = "kumo"; // 資料庫使用者名稱
$pass = "coco3430"; // 資料庫使用者密碼
$dbname = "spaced"; // 資料庫名稱

// 建立與 MySQL 資料庫的連接
$conn = new mysqli($servername, $user, $pass, $dbname);
// 檢查連接是否成功
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$TodoSELSql = "SELECT * FROM `RecurringInstance` WHERE todo_id = '$todo_id' ORDER by id DESC limit 1;";

$result = $conn->query($TodoSELSql);
if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $RecurringStartDate = $row['RecurringStartDate'];
    $id = $row['id'];
    $message = "User TrackingFirstDay successfully";
} else {
    $message = "No results found";
}

$userData = array(
    'id' => intval($id),
    'todo_id' => intval($todo_id),
    'RecurringStartDate' => $RecurringStartDate,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>