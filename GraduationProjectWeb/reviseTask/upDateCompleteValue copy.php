<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據

$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$todo_id = $data['id'];
$checkDate = date("Y-m-d");
$RecurringStartDate = $data['RecurringStartDate'];
$RecurringEndDate = $data['RecurringEndDate'];
$completeValue = $data['completeValue'];
$isComplete = $data['isComplete'];
$routineType = $data['routineType'];

$routineTime = date("H:i:s");
$startDate  = date("Y-m-d");
$endDate  = date("Y-m-d", strtotime($startDate . ' +1 day'));

$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

if ($routineType == 3) {
    // 區間起床
    $stmt = $conn->prepare("INSERT INTO `RecurringInstance` (`todo_id`, `RecurringStartDate`, `RecurringEndDate`) VALUES (?, ?, ?);");
    $stmt->bind_param("iss", $todo_id, $startDate, $endDate);
    if ($stmt->execute()) {
        $message = "User New first RecurringInstance successfully";
        $RecurringEndDate = $endDate;
        $RecurringStartDate = $startDate;
    } else {
        $message = "New first RecurringInstance successfully - Error: " . $stmt->error;
    }
    $stmt->close();
}

$stmtSEL = $conn->prepare("SELECT * FROM `RecurringInstance` WHERE todo_id = ? AND `RecurringEndDate` = ? AND `RecurringStartDate` = ?;");
$stmtSEL->bind_param("iss", $todo_id, $RecurringEndDate, $RecurringStartDate);
$stmtSEL->execute();
$result = $stmtSEL->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $Instance_id = $row['id'];
    $completeValueOld = $row['completeValue'];
    $completeValueNew = $completeValueOld + $completeValue;

    if ($isComplete) {
        $occurrenceStatus = 1;
    } else {
        $occurrenceStatus = 0;
    }
    $stmt = $conn->prepare("INSERT INTO `RecurringCheck` (`Instance_id`, `checkDate`, `completeValue`, `sleepTime`, `wakeUpTime`) VALUES (?, ?, ?, ?, ?);");

    if ($completeValue != 0 && $routineType != 3) {
        // 一般檢核 （ 記得要設定completeValue != 0 ）
        $sleepTime = null;
        $wakeUpTime = null;
        $stmt->bind_param("isiss", $Instance_id, $checkDate, $completeValue, $sleepTime, $wakeUpTime);
    } elseif ($routineType == 0 || $routineType == 2) {
        // 早睡、區間睡覺
        $completeValue = null;
        $wakeUpTime = null;
        $stmt->bind_param("isiss", $Instance_id, $checkDate, $completeValue, $routineTime, $wakeUpTime);
    } elseif ($routineType == 1) {
        // 早起
        $completeValue = null;
        $sleepTime = null;
        $stmt->bind_param("isiss", $Instance_id, $checkDate, $completeValue, $sleepTime, $routineTime);
    } elseif ($routineType == 3) {
        // 區間起床
        if ( $message == "User New first RecurringInstance successfully") {
            $sleepTime = null;
            $wakeUpTime = $routineTime;
            $stmt->bind_param("isiss", $Instance_id, $checkDate, $completeValue, $sleepTime, $wakeUpTime);
        }
    }
    if($stmt->execute()) {
        $message = "User New RecurringCheck successfully";
    
        // 使用預備語句更新 RecurringInstance
        $updateStmt = $conn->prepare("UPDATE RecurringInstance SET `completeValue` = ?, `occurrenceStatus` = ? WHERE `todo_id` = ? AND `RecurringEndDate` = ? AND `RecurringStartDate` = ?;");
        $updateStmt->bind_param("iiiss", $completeValueNew, $occurrenceStatus, $todo_id, $RecurringEndDate, $RecurringStartDate);
    
        if ($updateStmt->execute()) {
            $message = "User upDateCompleteValue successfully";
        } else {
            $message = $message . 'User upDateCompleteValue - Error: ' . $updateStmt->error;
        }
        $updateStmt->close();
    } else {
        $message = "New RecurringCheck - Error: " . $stmt->error;
    }
    $stmt->close();
} else {
    $message = "No results found";
}
$stmtSEL->close();
$userData = array(
    'todo_id' => $todo_id,
    'RecurringStartDate' => $RecurringStartDate,
    'RecurringEndDate' => $RecurringEndDate,
    'completeValue' => $completeValue,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>