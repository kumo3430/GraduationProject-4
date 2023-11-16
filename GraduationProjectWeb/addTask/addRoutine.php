<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據

$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$category_id = 4;
$todoTitle = $data['todoTitle'];
$todoIntroduction = $data['todoIntroduction'];
$frequency = 0;
$todoLabel= $data['label'];
$todoStatus= 0;
$startDateTime = $data['startDateTime'];
$routineType = $data['routineType'];
$routineValue = $data['routineValue'];
$routineTime = $data['routineTime'];
$reminderTime = $data['reminderTime'];
$dueDateTime = $data['dueDateTime'];
$todoNote = $data['todoNote'];
$todo_id = 0;
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

function insertTodo($conn, $uid, $category_id, $todoTitle, $todoIntroduction, $todoLabel, $startDateTime, $frequency, $reminderTime, $dueDateTime, $todoNote, $todoStatus)
{
    $TodoSql = "INSERT INTO `Todo` (`uid`, `category_id`, `todoTitle`, `todoIntroduction`, `label`, `startDateTime`, `frequency`, `reminderTime`, `todoStatus`, `dueDateTime`, `todoNote`) VALUES (?,?,?,?,?,?,?,?,?,?,?)";

    $stmt = $conn->prepare($TodoSql);
    $stmt->bind_param("sissssisiss", $uid, $category_id, $todoTitle, $todoIntroduction, $todoLabel, $startDateTime, $frequency, $reminderTime, $todoStatus, $dueDateTime, $todoNote);

    if ($stmt->execute() === TRUE) {
        $todo_id = $conn->insert_id;
        $message = "User New Todo successfully";

    } else {
        $message = "TodoSqlError: " . $stmt->error;
    }
    // return $message;
    $stmt->close();
    return array('message' => $message, 'todo_id' => $todo_id);
}
function insertRoutine($conn, $todo_id, $category_id, $routineType, $routineValue, $routineTime)
{
    $SpacedSql = "INSERT INTO `Routine` (`todo_id`, `category_id`, `routineType`, `routineValue`, `routineTime`) VALUES (?, ?,?,?,?)";

    $stmt = $conn->prepare($SpacedSql);
    $stmt->bind_param("iisdi", $todo_id, $category_id, $routineType, $routineValue, $routineTime);
    if($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        $message = "User New Sport successfully";
    } else {
        $message = 'New Sport - Error: '. $stmt->error;
    }
    $stmt->close();
    return $message;
}
function insertRecurringInstance($conn, $todo_id, $startDateTime, $RecurringEndDate)
{
    $InstanceSql = "INSERT INTO `RecurringInstance` (`todo_id`, `RecurringStartDate`, `RecurringEndDate`) VALUES (?, ?, ?);";

    $stmt = $conn->prepare($InstanceSql);
    $stmt->bind_param("iss", $todo_id, $startDateTime, $RecurringEndDate);

    if($stmt->execute() === TRUE) {
        $message = "User New first RecurringInstance successfully";
    } else {
        $message = "InstanceSqlError" . $stmt->error;
    }
    $stmt->close();
    return $message;
}

$TodoIdSql = "SELECT * FROM `Todo` WHERE `uid` = ? AND `category_id` = ? AND `todoTitle` = ? AND `todoIntroduction` = ? AND `label` = ? AND `todoNote` = ? ";

$stmt = $conn->prepare($TodoIdSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("sissss", $uid, $category_id, $todoTitle, $todoIntroduction, $todoLabel, $todoNote);
if($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows == 0) {
        $result1 = insertTodo($conn, $uid, $category_id, $todoTitle, $todoIntroduction, $todoLabel, $startDateTime, $frequency, $reminderTime, $dueDateTime, $todoNote, $todoStatus);
        $message = $message . $result1['message'];
        $todo_id = $result1['todo_id'];
        $result2 = insertRoutine($conn, $todo_id, $category_id, $routineType, $routineValue, $routineTime);
        $message = $message . $result2;
    
        $RecurringEndDate = $startDateTime;
        $message = $message .  insertRecurringInstance($conn, $todo_id, $startDateTime, $RecurringEndDate);
    }  else {
        $message = "The Todo is repeated";
    }
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "TodoIdSqlError" . $stmt->error;
}

$stmt->close();
$userData = array(
    'todo_id' => intval($todo_id),
    'userId' => $uid,
    'category_id' => $category_id,
    'label' => $todoLabel,
    'todoTitle' => $todoTitle,
    'todoIntroduction' => $todoIntroduction,
    'startDateTime' => $startDateTime,
    'routineType' => $routineType,
    'routineValue' => intval($routineValue),
    'routineTime' => $routineTime,
    'todoStatus' => $todoStatus,
    'dueDateTime' => $dueDateTime,
    'reminderTime' => $reminderTime,
    'message' => $message . $message1 . $message2
);
echo json_encode($userData);

$conn->close();
?>