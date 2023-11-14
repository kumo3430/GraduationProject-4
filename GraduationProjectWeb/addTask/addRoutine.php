<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

// 取得用戶名和密碼
// $userName = $data['userName'];
$uid = $_SESSION['uid'];
// $uuid = $data['uuid'];
$category_id = 4;
$todoTitle = $data['todoTitle'];
$todoIntroduction = $data['todoIntroduction'];


// if ( $data['label'] == "") {
//     $todoLabel = "notSet";
// } else {
//     $todoLabel= $data['label'];
// }
$todoLabel= $data['label'];
$todoStatus= 0;
$startDateTime = $data['startDateTime'];

$routineType = $data['routineType'];
$routineValue = $data['routineValue'];
$routineTime = $data['routineTime'];
$reminderTime = $data['reminderTime'];
// $frequency = $data['frequency'];
$dueDateTime = $data['dueDateTime'];
$todoNote = $data['todoNote'];
$todo_id = 0;
$message = "";
$message1 = "";
$message2 = "";

$servername = "localhost"; // 資料庫伺服器名稱
$user = "kumo"; // 資料庫使用者名稱
$pass = "coco3430"; // 資料庫使用者密碼
$dbname = "spaced"; // 資料庫名稱

// 建立與 MySQL 資料庫的連接
$conn = new mysqli($servername, $user, $pass, $dbname);
// 檢查連接是否成功
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$TodoSELSql = "SELECT * FROM `Todo` WHERE `uid` = '$uid' && `category_id` = '$category_id' && `todoTitle` = '$todoTitle' && `todoIntroduction` = '$todoIntroduction' && `label` = '$todoLabel'&& `todoNote` = '$todoNote';";

function insertTodoAndRoutine($conn, $uid, $category_id, $todoTitle, $todoIntroduction, $todoLabel, $startDateTime,$routineType, $routineValue, $routineTime , $reminderTime, $dueDateTime, $todoNote) {
    $TodoSql = "INSERT INTO `Todo` (`uid`, `category_id`, `todoTitle`, `todoIntroduction`, `label`, `startDateTime`, `reminderTime`, `todoStatus`, `dueDateTime`, `todoNote`) VALUES ('$uid', '$category_id','$todoTitle','$todoIntroduction','$todoLabel','$startDateTime','$reminderTime','0','$dueDateTime','$todoNote')";
    
    if ($conn->query($TodoSql) === TRUE) {
        $message = "User New Todo category_id = 0 successfully" . '<br>';

        $TodoIdSql = "SELECT * FROM `Todo` WHERE `uid` = '$uid' && `category_id` = '$category_id' && `todoTitle` = '$todoTitle' && `todoIntroduction` = '$todoIntroduction' && `label` = '$todoLabel' && `todoNote` = '$todoNote';";

        $result = $conn->query($TodoIdSql);
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $todo_id = $row['id'];
                $SpacedSql = "INSERT INTO `Routine` (`todo_id`, `category_id`, `routineType`, `routineValue`, `routineTime`) VALUES ('$todo_id', '$category_id','$routineType','$routineValue','$routineTime')";

                if ($conn->query($SpacedSql) === TRUE) {
                    $message = "User New routine successfully";
                } else {
                    $message = 'New routine - Error: ' . $SpacedSql . '<br>' . $conn->error;
                }
            }
        } else {
            $message = "no such StudyGeneralTodo" . '<br>';
        }
    } else {
        $message = 'New StudyGeneral Todo - Error: ' . $TodoSql . '<br>' . $conn->error;
        if ($conn->connect_error) {
            $message =  die("Connection failed: " . $conn->connect_error);
        }
    }
    
    // return $message;
    return array('message' => $message, 'todo_id' => $todo_id);
}

function insertRecurringInstance($conn, $todo_id, $startDateTime, $RecurringEndDate) {
    $InstanceSql = "INSERT INTO `RecurringInstance` (`todo_id`, `RecurringStartDate`, `RecurringEndDate`) VALUES ('$todo_id', '$startDateTime', '$RecurringEndDate');";

    if($conn->query($InstanceSql) === TRUE) {
        $message = "User New first RecurringInstance successfully";
    } else {
        $message = "New first RecurringInstance successfully - Error: " . $InstanceSql . '<br>' . $conn->error; 
        if ($conn->connect_error) {
            $message =  die("Connection failed: " . $conn->connect_error);
        }
        
    }
    return $message;
}


$result = $conn->query($TodoSELSql);
if ($result->num_rows == 0) {
    $result1 = insertTodoAndRoutine($conn, $uid, $category_id, $todoTitle, $todoIntroduction, $todoLabel, $startDateTime, $routineType, $routineValue, $routineTime, $reminderTime, $dueDateTime, $todoNote);
    $message1 = $result1['message'];
    $todo_id = $result1['todo_id'];

    $RecurringEndDate = $startDateTime;
    $message2 = insertRecurringInstance($conn, $todo_id, $startDateTime, $RecurringEndDate);
} else {
    $message = "The Todo is repeated";
}

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