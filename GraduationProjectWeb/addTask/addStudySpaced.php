<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據

$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$category_id = 1;
$todoTitle = $data['title'];
$todoIntroduction = $data['description'];
$todoLabel = $data['label'];
$startDateTime = $data['nextReviewDate'];
$reminderTime = $data['nextReviewTime'];
$todo_id = 0;
$repetition1Count = $data['First'];
$repetition2Count = $data['third'];
$repetition3Count = $data['seventh'];
$repetition4Count = $data['fourteenth'];
$frequency = 0;
$todoStatus = 0;
$todoNote = "";
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
    $stmt->close();
    return array('message' => $message, 'todo_id' => $todo_id);
}
function insertStudySpacedRepetition($conn, $todo_id, $repetition1Count, $repetition2Count, $repetition3Count, $repetition4Count)
{
    $SpacedSql = "INSERT INTO `StudySpacedRepetition` (`todo_id`, `repetition1Count`, `repetition2Count`, `repetition3Count`, `repetition4Count`, `repetition1Status`, `repetition2Status`, `repetition3Status`, `repetition4Status`) VALUES (?, ?,?,?,?, 0, 0, 0, 0)";

    $stmt = $conn->prepare($SpacedSql);
    $stmt->bind_param("issss", $todo_id, $repetition1Count, $repetition2Count, $repetition3Count, $repetition4Count);

    if($stmt->execute() === TRUE) {
        $result = $stmt->get_result();
        $message = "User New StudySpacedRepetition successfully";
    } else {
        $message = 'New StudyGeneral - Error: '. $stmt->error;
    }
    $stmt->close();
    return $message;
}

$TodoSELSql = "SELECT * FROM `Todo` WHERE `uid` = ? AND `category_id` = ? AND `todoTitle` = ? AND `todoIntroduction` = ? AND `label` = ? ;";

$stmt = $conn->prepare($TodoSELSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("sisss", $uid, $category_id, $todoTitle, $todoIntroduction, $todoLabel);

if ($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows == 0) {

        $result1 = insertTodo($conn, $uid, $category_id, $studyValue, $studyUnit, $todoTitle, $todoIntroduction, $todoLabel, $startDateTime, $frequency, $reminderTime, $dueDateTime, $todoNote, $todoStatus);
        $message = $message . $result1['message'];
        $todo_id = $result1['todo_id'];

        $result2 = insertStudySpacedRepetition($conn, $todo_id, $repetition1Count, $repetition2Count, $repetition3Count, $repetition4Count);
        $message = $message . $result2;
    }  else {
        $message = "The Todo is repeated";
    }
} else {
    echo "TodoSELSqlError" . $stmt->error;
    $message = "TodoSELSqlError" . $stmt->error;
}
$stmt->close();
$userData = array(
    'userId' => $uid,
    'category_id' => $category_id,
    'todoTitle' => $todoTitle,
    'todoIntroduction' => $todoIntroduction,
    'todoLabel' => $todoLabel,
    'startDateTime' => $startDateTime,
    'reminderTime' => $reminderTime,
    'todo_id' =>  intval($todo_id),
    'repetition1Count' => $repetition1Count,
    'repetition2Count' => $repetition2Count,
    'repetition3Count' => $repetition3Count,
    'repetition4Count' => $repetition4Count,
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>