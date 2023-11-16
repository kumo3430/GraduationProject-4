<?php
require_once '../Database.php';

// 獲取用戶提交的表單數據
session_unset();
session_destroy();
session_start();

$postData = file_get_contents("php://input");
$requestData = json_decode($postData, true);

$uid = "";
$userName = $requestData['email'];
$email = $requestData['email'];
$password = $requestData['password'];
$create_at = "";
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

$sql = "SELECT * FROM User WHERE email='$email' AND password='$password'";

$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $_SESSION['uid'] = $row['id'];
        $uid = $row['id'];
        $userName = $row['userName'];
        $userDescription = $row['userDescription'];
        $create_at = $row['create_at'];
        $message = "User login successfully";
    }
} else {
    $message = "no such account";
}

$userData = array(
    'id' => $uid,
    'userName' => $userName,
    'email' => $email,
    'userDescription' => $userDescription,
    'create_at' => $create_at,
    'message' => $message
);
$jsonData = json_encode($userData);
echo $jsonData;

// 關閉與 MySQL 的連接
$conn->close();
?>