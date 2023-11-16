<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據

$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$todo_id = $data['id'];
$label = $data['label'];
$reminderTime = $data['reminderTime'];
$dueDateTime = $data['dueDateTime'];
$todoNote = $data['todoNote'];
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

$UpSql = "UPDATE Todo SET `label` = ? , `reminderTime` = ? , `dueDateTime` = ? , `todoNote` = ? WHERE `id` = ? ;";


$stmt = $conn->prepare($UpSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("ssssi", $label, $reminderTime, $dueDateTime, $todoNote, $todo_id);
if($stmt->execute() === TRUE) {
    $message = "User revise Study successfully";
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "UpSqlError" . $stmt->error;
}
$stmt->close();
$userData = array(
    'todo_id' => $todo_id,
    'label' => $label,
    'reminderTime' => $reminderTime,
    'dueDateTime' => $dueDateTime,
    'todoNote' => $todoNote,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>