<?php
require_once '../Database.php';

session_unset();
session_destroy();
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

$email = $data['email'];
$password = $data['password'];
$create_at = $data['create_at'];
$message = "";


$db = Database::getInstance();
$conn = $db->getConnection();

$emailExistSql = "SELECT * FROM `User` WHERE `email` = '$email'";

$result = $conn->query($emailExistSql);
if ($result->num_rows > 0) {
    $message = "email is registered";
} else {
    $sql = "INSERT INTO `User` (`userName`,`email`, `password`, `create_at`) VALUES ('$email','$email', '$password','$create_at')";
    if ($conn->query($sql) === TRUE) {
        // 註冊成功，回傳 JSON 格式的訊息
        $message = "User registered successfully";
    } else {
        // 註冊失敗，回傳 JSON 格式的錯誤訊息
        $message = 'Error: ' . $sql . '<br>' . $conn->error;
    }

    $sql2 = "SELECT * FROM `User` WHERE `email` = '$email'";
    $result = $conn->query($sql2);
    if ($result->num_rows <= 0) {
        $message = "no such account";
    } else {
        while ($row = $result->fetch_assoc()) {
            $_SESSION['uid'] = $row['id'];
            $uid = $row['id'];
        }
    }

}

$userData = array(
    // 'id' => strval($uid),
    'id' => $uid,
    'userName' => $email,
    'email' => $email,
    'create_at' => $create_at,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>