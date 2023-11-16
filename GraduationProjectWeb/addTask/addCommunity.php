<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據

$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$communityName = $data['communityName'];
$communityDescription = $data['communityDescription'];
$communityCreateDate = date("Y-m-d");
$category = $data['communityCategory'];

$community_id = 0;
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

function insertCommunity($conn, $uid, $communityName, $communityDescription, $communityCreateDate, $category, $CommunitySELSql) {
    $CommunitySql = "INSERT INTO `Community` (`communityName`, `communityDescription`, `communityCreateDate`, `communityCategory`) VALUES (?, ?,?,?)";
    
    $stmt = $conn->prepare($CommunitySql);
    $stmt->bind_param("sssi", $communityName, $communityDescription, $communityCreateDate, $category);

    if ($stmt->execute() === TRUE) {
        $community_id = $conn->insert_id;
        $message = "User New Community successfully";
    } else {
        $message = "TodoSqlError: " . $stmt->error;
    }
    // return $message;
    $stmt->close();
    return array('message' => $message, 'community_id' => $community_id);
}
function insertMemberSql($conn, $community_id, $uid, $communityCreateDate)
{
    $memberSql = "INSERT INTO `community_members` (`community_id`, `user_id`, `memberRole`, `joinDate`) VALUES (?, ?,'1',?)";

    $stmt = $conn->prepare($memberSql);
    $stmt->bind_param("iss", $community_id, $uid, $communityCreateDate);
    if($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        $message = "User New memberSql successfully";
    } else {
        $message = 'New memberSql - Error: '. $stmt->error;
    }
    $stmt->close();
    return $message;
}


$CommunitySELSql = "SELECT * FROM `Community` WHERE `communityName` = ? ;";

$stmt = $conn->prepare($CommunitySELSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("s", $communityName);
if($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows == 0) {
        $result1 = insertCommunity($conn, $uid, $communityName, $communityDescription, $communityCreateDate, $category, $CommunitySELSql);
        $message = $result1['message'];
        if ($result1['message'] ==  "User New Community successfully") {
            $message = insertMemberSql($conn, $community_id, $uid, $communityCreateDate);
        }
    }  else {
        $message = "The Community is repeated";
    }
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "TodoIdSqlError" . $stmt->error;
}
$stmt->close();
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