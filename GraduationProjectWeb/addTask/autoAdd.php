<?php
session_start();
// 獲取用戶提交的表單數據
$input_data = file_get_contents("php://input");
$data = json_decode($input_data, true);

$uid = $_SESSION['uid'];

$today = date("Y/n/j");
// $tody = date('Y-m-d');

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

function insertRecurringInstance($conn, $todo_id, $startDateTime, $RecurringEndDate)
{
    $InstanceSql = "INSERT INTO `RecurringInstance` (`todo_id`, `RecurringStartDate`, `RecurringEndDate`) VALUES ('$todo_id', '$startDateTime', '$RecurringEndDate');";

    if ($conn->query($InstanceSql) === TRUE) {
        $message = "User New first RecurringInstance successfully";
    } else {
        $message = "New first RecurringInstance successfully - Error: " . $InstanceSql . '<br>' . $conn->error;
        if ($conn->connect_error) {
            $message = die("Connection failed: " . $conn->connect_error);
        }

    }
    return $message;
}

function updateRecurringInstanc($conn,$todo_id,$today,$uid)
{
    $update = "UPDATE `RecurringInstance` AS RI INNER JOIN `Todo` AS T ON RI.todo_id = T.id SET RI.`isOver` = '1' WHERE RI.`RecurringEndDate` <= '$today' AND T.`uid` = '$uid'; ";

    if ($conn->query($update) === TRUE) {
        $message = "User updateRecurringInstanc successfully";
    } else {
        $message = "updateRecurringInstanc - Error: " . $update . '<br>' . $conn->error;
        if ($conn->connect_error) {
            $message = die("Connection failed: " . $conn->connect_error);
        }

    }
    return $message;
}

$TodoSELSql = "SELECT `Todo`.frequency, `RecurringInstance`.RecurringEndDate, `Todo`.id FROM `Todo`,`RecurringInstance` WHERE `Todo`.dueDateTime > '$today' AND `Todo`.id = `RecurringInstance`.todo_id AND `RecurringEndDate` <= '$today' AND `RecurringInstance`.isOver = 0 AND`Todo`.uid = '$uid' AND `Todo`.id NOT IN (SELECT todo_id FROM `Routine` WHERE routineType = '睡眠時長');";

$result = $conn->query($TodoSELSql);
if ($result->num_rows > 0) {
    // $result->data_seek(0);
    // $result = $conn->query($TodoSELSql);
    while ($result->num_rows > 0) {
        $result = $conn->query($TodoSELSql);
        while ($row = $result->fetch_assoc()) {
            
            $RecurringEndDate_data = $row['RecurringEndDate'];
            $frequency = $row['frequency'];
            $todo_id = $row['id'];
            $update = "UPDATE `RecurringInstance` AS RI INNER JOIN `Todo` AS T ON RI.todo_id = T.id SET RI.`isOver` = '1' WHERE RI.`RecurringEndDate` <= '$today'  AND T.`id` = $todo_id; ";
            $conn->query($update); // 執行更新操作;
            // $message = updateRecurringInstanc($conn,$todo_id, $today, $uid);
            $RecurringStartDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +1 day"));

            if ($frequency == 1 || $frequency == 0) {
                // 每天重複
                $RecurringEndDate_new = $RecurringStartDate_new;
                $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
                // $conn->query($update); // 執行更新操作
            } else if ($frequency == 2) {
                // 每週重複
                $RecurringEndDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +6 day"));
                $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
                // $conn->query($update); // 執行更新操作
            } else if ($frequency == 3) {
                // 每月重複
                $RecurringEndDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +1 month"));
                $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
                // $conn->query($update); // 執行更新操作
            }
        }
        // $message = "yes";
    }
    // $message = "no";
} else {
    $message = "今日沒有要新增的";
}


$userData = array(
    'message' => $message
);
echo json_encode($userData);

$conn->close();
?>