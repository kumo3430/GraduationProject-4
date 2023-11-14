<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

$id = $data['id'];
$targetvalue = $data['targetvalue'];
$checkDate = array();
$completeValue = array();

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

// $TodoSELSql = "SELECT * FROM `RecurringCheck` WHERE Instance_id = '$id';";
$TodoSELSql = "SELECT * FROM RecurringInstance AS RI, RecurringCheck AS RC WHERE RI.todo_id = '67' && RC.instance_id = RI.id;";

$result = $conn->query($TodoSELSql);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $checkDate[] = $row['checkDate'];
        $completeValue[] = $row['completeValue'];
        $message = "User RecurringCheckList successfully";
    }
} else {
    $message = "no such Todo";
}
$userData = array(
    'checkDate' => $checkDate,
    'completeValue' => $completeValue,
    'targetvalue' => $targetvalue,
    'message' => $message
);
echo json_encode($userData);
$conn->close();
?>