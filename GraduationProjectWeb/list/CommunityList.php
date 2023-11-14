<?php
session_start();

$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

$uid = $data['uid'];
$_SESSION['uid'] = $uid;
$community_id = array();
$communityName = array();
$communityDescription = array();
$communityCategory = array();
$message = "";


$servername = "localhost";
$user = "kumo";
$pass = "coco3430";
$dbname = "spaced";

$conn = new mysqli($servername, $user, $pass, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// $sql = "SELECT * FROM `tickers` INNER JOIN `voucher` ON tickers.voucher_id = voucher.id WHERE tickers.userID = '$uid';";
$sql = "SELECT * FROM community WHERE id IN (SELECT community_members.community_id FROM community_members WHERE user_id = 30);";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $community_id[] = $row['id'];
        $communityName[] = $row['communityName'];
        $communityDescription[] = $row['communityDescription'];
        $communityCategory[] = $row['communityCategory'];
    }
} else {
    $message = "no such Todo";
}

$userData = array(
    'community_id' => $community_id,
    'userId' => $uid,
    'communityName' => $communityName,
    'communityDescription' => $communityDescription,
    'communityCategory' => $communityCategory,
    'message' => $message
);
echo json_encode($userData);

?>