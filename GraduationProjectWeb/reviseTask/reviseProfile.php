<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID

$username = $data['username'];
$userDescription = $data['userDescription'];

$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

$UpSql = "UPDATE User SET `username` = ? , `userDescription` = ? WHERE `id` = ? ;";

$stmt = $conn->prepare($UpSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("sss", $username, $userDescription, $uid);
if($stmt->execute() === TRUE) {
    $message = "User revise Space successfully";
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "UpSqlError" . $stmt->error;
}
$stmt->close();

$userData = array(
    'id' => $uid,
    'userName' => $username,
    'userDescription' => $userDescription,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>