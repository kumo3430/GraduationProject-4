<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據

$community_id = array();
$communityName = array();
$communityDescription = array();
$communityCategory = array();
$image = array();
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

// $sql = "SELECT * FROM `tickers` INNER JOIN `voucher` ON tickers.voucher_id = voucher.id WHERE tickers.userID = '$uid';";
$TodoSELSql = "SELECT * FROM community WHERE id IN (SELECT community_members.community_id FROM community_members WHERE user_id = ? );";


$stmt = $conn->prepare($TodoSELSql);
$stmt->bind_param("s", $data['uid']);
if ($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $_SESSION['uid'] = $uid;

            $community_id[] = $row['id'];
            $communityName[] = $row['communityName'];
            $communityDescription[] = $row['communityDescription'];
            $communityCategory[] = $row['communityCategory'];
            $image[] = $row['image'];
        }
    } else {
        $message = "no such Todo";
    }
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "TodoIdSqlError" . $stmt->error;
}
$stmt->close();
$userData = array(
    'community_id' => $community_id,
    'userId' => $uid,
    'communityName' => $communityName,
    'communityDescription' => $communityDescription,
    'communityCategory' => $communityCategory,
    'image' => $image,
    'message' => $message
);
echo json_encode($userData);

?>