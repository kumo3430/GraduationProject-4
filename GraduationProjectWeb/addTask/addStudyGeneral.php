<?php
// ini_set('display_errors', 1);
// error_reporting(E_ALL);


require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據

$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$category_id = 0;
$todoTitle = $data['todoTitle'];
$todoIntroduction = $data['todoIntroduction'];
$todoLabel = $data['label'];
$todoStatus = 0;
$startDateTime = $data['startDateTime'];
$studyValue = $data['studyValue'];
$studyUnit = $data['studyUnit'];
$reminderTime = $data['reminderTime'];
$frequency = $data['frequency'];
$dueDateTime = $data['dueDateTime'];
$todoNote = $data['todoNote'];
$todo_id = 0;
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();

function insertTodo($conn, $uid, $category_id, $studyValue, $studyUnit, $todoTitle, $todoIntroduction, $todoLabel, $startDateTime, $frequency, $reminderTime, $dueDateTime, $todoNote, $todoStatus)
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
    return array('message' => $message, 'todo_id' => $todo_id);
}
function insertStudyGeneral($conn, $todo_id, $category_id, $studyValue, $studyUnit)
{
    $SpacedSql = "INSERT INTO StudyGeneral (`todo_id`, `category_id`, `studyValue`, `studyUnit`) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($SpacedSql);
    $stmt->bind_param("iidi", $todo_id, $category_id, $studyValue, $studyUnit);

    if($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        $message = "User New StudyGeneral successfully";
    } else {
        $message = 'New StudyGeneral - Error: '. $stmt->error;
    }
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
        // 不重複
        $result1 = insertTodo($conn, $uid, $category_id, $studyValue, $studyUnit, $todoTitle, $todoIntroduction, $todoLabel, $startDateTime, $frequency, $reminderTime, $dueDateTime, $todoNote, $todoStatus);
        $message = $message . $result1['message'];
        $todo_id = $result1['todo_id'];
        $result2 = insertStudyGeneral($conn, $todo_id, $category_id, $studyValue, $studyUnit);
        $message = $message . $result2;
        // 週期循環
        if ($frequency != 0) {
            if ($frequency == 1) {
                // 每天重複
                $RecurringEndDate = $startDateTime;
            } else if ($frequency == 2) {
                // 每週重複
                $RecurringEndDate = date('Y-m-d', strtotime("$startDateTime +6 day"));
            } else if ($frequency == 3) {
                // 每月重複
                $RecurringEndDate = date('Y-m-d', strtotime("$startDateTime +1 month"));
            }
            $message = $message . insertRecurringInstance($conn, $todo_id, $startDateTime, $RecurringEndDate);
        }
    }  else {
        $message = "The Todo is repeated";
    }
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "TodoIdSqlError" . $stmt->error;
}

$userData = array(
    'todo_id' => intval($todo_id),
    'userId' => $uid,
    'category_id' => $category_id,
    'todoLabel' => $todoLabel,
    'todoTitle' => $todoTitle,
    'todoIntroduction' => $todoIntroduction,
    'startDateTime' => $startDateTime,
    'studyValue' => $studyValue,
    'studyUnit' => $studyUnit,
    'frequency' => $frequency,
    'todoStatus' => $todoStatus,
    'dueDateTime' => $dueDateTime,
    'reminderTime' => $reminderTime,
    'todoNote' => $todoNote,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>