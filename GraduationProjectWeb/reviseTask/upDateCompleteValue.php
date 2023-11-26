<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID

$checkDate = date("Y-m-d");
$routineTime = date("H:i:s");
$startDate  = date("Y-m-d");
$endDate  = date("Y-m-d", strtotime($startDate . ' +1 day'));
$isOver = 1 ;
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

if ($data['isComplete']) {
    $occurrenceStatus = 1;
} else {
    $occurrenceStatus = 0;
}

if ($data['routineType'] == 3) {
    // 區間起床

        // 使用預備語句更新 RecurringInstance
        $updateStmt = $conn->prepare("UPDATE RecurringInstance SET `isOver` = ?, `occurrenceStatus` = ? WHERE `todo_id` = ? AND `RecurringEndDate` = ? AND `RecurringStartDate` = ?;");
        $updateStmt->bind_param("iiiss", $isOver, $occurrenceStatus, $data['id'], $data['RecurringEndDate'], $data['RecurringStartDate']);
    
        if ($updateStmt->execute()) {
            $message = "User upDateCompleteValue successfully";
        } else {
            $message = $message . 'User upDateCompleteValue - Error: ' . $updateStmt->error;
        }
        $updateStmt->close();


    $stmt = $conn->prepare("INSERT INTO `RecurringInstance` (`todo_id`, `RecurringStartDate`, `RecurringEndDate`) VALUES (?, ?, ?);");
    $stmt->bind_param("iss", $data['id'], $startDate, $endDate);
    if ($stmt->execute()) {
        $message = "User New first RecurringInstance successfully";
        $data['RecurringEndDate'] = $endDate;
        $data['RecurringStartDate'] = $startDate;
    } else {
        $message = "New first RecurringInstance successfully - Error: " . $stmt->error;
    }
    $stmt->close();
}

$stmtSEL = $conn->prepare("SELECT * FROM `RecurringInstance` WHERE todo_id = ? AND `RecurringEndDate` = ? AND `RecurringStartDate` = ?;");
$stmtSEL->bind_param("iss", $data['id'], $data['RecurringEndDate'], $data['RecurringStartDate']);
$stmtSEL->execute();
$result = $stmtSEL->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $Instance_id = $row['id'];
    $completeValueOld = $row['completeValue'];
    $completeValueNew = $completeValueOld + $data['completeValue'];

    $stmt = $conn->prepare("INSERT INTO `RecurringCheck` (`Instance_id`, `checkDate`, `completeValue`, `sleepTime`, `wakeUpTime`) VALUES (?, ?, ?, ?, ?);");

    if ($data['completeValue'] != 0 && $data['routineType'] != 3) {
        // 一般檢核 （ 記得要設定completeValue != 0 ）
        $sleepTime = null;
        $wakeUpTime = null;
        $stmt->bind_param("isiss", $Instance_id, $checkDate, $data['completeValue'], $sleepTime, $wakeUpTime);
    } elseif ($data['routineType'] == 0 || $data['routineType'] == 2) {
        // 早睡、區間睡覺
        $data['completeValue'] = null;
        $wakeUpTime = null;
        $stmt->bind_param("isiss", $Instance_id, $checkDate, $data['completeValue'], $routineTime, $wakeUpTime);
    } elseif ($data['routineType'] == 1) {
        // 早起
        $data['completeValue'] = null;
        $sleepTime = null;
        $stmt->bind_param("isiss", $Instance_id, $checkDate, $data['completeValue'], $sleepTime, $routineTime);
    } elseif ($data['routineType'] == 3) {
        // 區間起床
        if ( $message == "User New first RecurringInstance successfully") {
            $sleepTime = null;
            $wakeUpTime = $routineTime;
            $stmt->bind_param("isiss", $Instance_id, $checkDate, $data['completeValue'], $sleepTime, $wakeUpTime);
        }
    }
    if($stmt->execute()) {
        $message = "User New RecurringCheck successfully";
    
        // 使用預備語句更新 RecurringInstance
        $updateStmt = $conn->prepare("UPDATE RecurringInstance SET `completeValue` = ?, `occurrenceStatus` = ? WHERE `todo_id` = ? AND `RecurringEndDate` = ? AND `RecurringStartDate` = ?;");
        $updateStmt->bind_param("iiiss", $completeValueNew, $occurrenceStatus, $data['id'], $data['RecurringEndDate'], $data['RecurringStartDate']);
    
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
    'todo_id' => $data['id'],
    'RecurringStartDate' => $data['RecurringStartDate'],
    'RecurringEndDate' => $data['RecurringEndDate'],
    'completeValue' => $data['completeValue'],
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>