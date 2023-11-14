<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

// 取得用戶名和密碼
// $userName = $data['userName'];
$uid = $_SESSION['uid'];

$communityName = $data['communityName'];
$communityDescription = $data['communityDescription'];
$communityCreateDate = date("Y-m-d");
$category = $data['communityCategory'];

$community_id = 0;
$message = "";
$message1 = "";
$message2 = "";

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

function insertCommunity($conn, $uid, $communityName, $communityDescription, $communityCreateDate, $category, $CommunitySELSql) {
    $CommunitySql = "INSERT INTO `Community` (`communityName`, `communityDescription`, `communityCreateDate`, `communityCategory`) VALUES ('$communityName', '$communityDescription','$communityCreateDate','$category')";
    
    if ($conn->query($CommunitySql) === TRUE) {
        $message = "User New Community successfully";

        $result = $conn->query($CommunitySELSql);
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $community_id = $row['id'];
                $memberSql = "INSERT INTO `community_members` (`community_id`, `user_id`, `memberRole`, `joinDate`) VALUES ('$community_id', '$uid','1','$communityCreateDate')";

                if ($conn->query($memberSql) === TRUE) {
                    $message1 = "User New memberSql successfully";
                } else {
                    $message1 = 'New memberSql - Error: ' . $memberSql . '<br>' . $conn->error;
                }
            }
        } else {
            $message = "no such CommunitySELSql" . '<br>';
        }
    } else {
        $message = 'New Community - Error: ' . $CommunitySql . '<br>' . $conn->error;
        if ($conn->connect_error) {
            $message =  die("Connection failed: " . $conn->connect_error);
        }
    }
    // return $message;
    return array('message' => $message,'message1' => $message1, 'community_id' => $community_id);
}

$CommunitySELSql = "SELECT * FROM `Community` WHERE `communityName` = '$communityName' ;";

$result = $conn->query($CommunitySELSql);
if ($result->num_rows == 0) {
    $result1 = insertCommunity($conn, $uid, $communityName, $communityDescription, $communityCreateDate, $category, $CommunitySELSql);
    $message = $result1['message'];
    $message1 = $result1['message1'];
    $community_id = $result1['community_id'];
} else {
    $message = "The Community is repeated";
}

$userData = array(
    'community_id' => intval($community_id),
    'communityName' => $communityName,
    'communityDescription' => $communityDescription,
    'communityCategory' => intval($communityCategory),
    'message' => $message . $message1 . $message2
);
echo json_encode($userData);

$conn->close();
?>