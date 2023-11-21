<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據

$ticker_id = array();
$name = array();
$deadline = array();
$exchange = array();
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

// $sql = "SELECT * FROM `tickers` INNER JOIN `voucher` ON tickers.voucher_id = voucher.id WHERE tickers.userID = '$data['uid']';";
$sql = "SELECT tickers.id,tickers.exchange_time,voucher.name,voucher.deadline FROM `tickers` INNER JOIN `voucher` ON tickers.voucher_id = voucher.id WHERE tickers.userID = ? ;";


$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $data['uid']);
if ($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $_SESSION['uid'] = $data['uid'];

            $ticker_id[] = $row['id'];
            $name[] = $row['name'];
            $deadline[] = $row['deadline'];
            $exchange[] = $row['exchange_time'];
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
    'ticker_id' => $ticker_id,
    'userId' => $data['uid'],
    'name' => $name,
    'deadline' => $deadline,
    'exchange' => $exchange,
    'message' => $message
);
echo json_encode($userData);

?>