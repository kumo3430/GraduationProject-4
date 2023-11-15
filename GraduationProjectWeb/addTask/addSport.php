<?php
// ini_set('display_errors', 1);
// error_reporting(E_ALL);
require_once '../Database.php';

session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

// 取得用戶名和密碼
$uid = $_SESSION['uid'];
// $uuid = $data['uuid'];
$category_id = 2;
$todoTitle = $data['todoTitle'];
$todoIntroduction = $data['todoIntroduction'];
$todoLabel= $data['label'];
$todoStatus= 0;
$startDateTime = $data['startDateTime'];

$sportType = $data['sportType'];
$sportValue = $data['sportValue'];
$sportUnit = $data['SportUnit'];

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
function insertSport($conn, $todo_id, $category_id, $sportType, $sportValue, $sportUnit)
{
    $SpacedSql = "INSERT INTO `Sport` (`todo_id`, `category_id`, `sportType`, `sportValue`, `sportUnit`) VALUES (?,?,?,?,?)";

    $stmt = $conn->prepare($SpacedSql);
    $stmt->bind_param("iisdi", $todo_id, $category_id, $sportType, $sportValue, $sportUnit);
    if($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        $message = "User New Sport successfully";
    } else {
        $message = 'New Sport - Error: '. $stmt->error;
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
        $result2 = insertSport($conn, $todo_id, $category_id, $sportType, $sportValue, $sportUnit);
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
    'sportType' => $sportType,
    'sportValue' => $sportValue,
    'sportUnit' => $sportUnit,
    'todoStatus' => $todoStatus,
    'frequency' => $frequency,
    'dueDateTime' => $dueDateTime,
    'reminderTime' => $reminderTime,
    'todoNote' => $todoNote,
    'message' => $message . $message1 . $message2
);
echo json_encode($userData);

$conn->close();
?>