<?php

require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$uid = getUserId(); // 使用 common.php 中的函數獲取用戶ID
$todo_id = 0;
$message = "";

$db = Database::getInstance();
$conn = $db->getConnection();


// session_start();
// // 獲取用戶提交的表單數據
// $input_data = file_get_contents("php://input");
// $data = json_decode($input_data, true);

// $uid = $_SESSION['uid'];

$today = date("Y-n-j");
// $tody = date('Y-m-d');
$duration = "睡眠時長";


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

function updateRecurringInstance($conn, $todo_id, $RecurringEndDate_data, $frequency, $today) {
    $RecurringEndDate_new = $RecurringEndDate_data;

    // 更新 RecurringEndDate，直到它大於或等於今天
    while ($RecurringEndDate_new < $today) {
        $RecurringEndDate_new = getNextRecurringDate($RecurringEndDate_new, $frequency);
    }

    $RecurringStartDate_new = getPreviousRecurringDate($RecurringEndDate_new, $frequency);

    // 插入新的實例
    return insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
}

// 根據頻率計算下一個重複日期
function getNextRecurringDate($date, $frequency) {
    switch ($frequency) {
        case 1:
        case 0:
            return date('Y-m-d', strtotime("$date +1 day"));
        case 2:
            return date('Y-m-d', strtotime("$date +7 day"));
        case 3:
            return date('Y-m-d', strtotime("$date +1 month"));
        // 可以添加更多的 case
    }
}

// 根據頻率計算上一個重複日期
function getPreviousRecurringDate($date, $frequency) {
    switch ($frequency) {
        case 1:
        case 0:
            return date('Y-m-d', strtotime("$date -0 day"));
        case 2:
            return date('Y-m-d', strtotime("$date -7 day"));
        case 3:
            return date('Y-m-d', strtotime("$date -1 month"));
        // 可以添加更多的 case
    }
}

// $TodoSELSql = "SELECT `Todo`.frequency, `RecurringInstance`.RecurringEndDate, `Todo`.id FROM `Todo`,`RecurringInstance` WHERE `Todo`.dueDateTime > '$today' AND `Todo`.id = `RecurringInstance`.todo_id AND `RecurringEndDate` <= '$today' AND `RecurringInstance`.isOver = 0 AND`Todo`.uid = '$uid' AND `Todo`.id NOT IN (SELECT todo_id FROM `Routine` WHERE routineType = '睡眠時長');";


$TodoSELSql = "SELECT `Todo`.frequency, `RecurringInstance`.RecurringEndDate, `Todo`.id FROM `Todo` JOIN `RecurringInstance` ON `Todo`.id = `RecurringInstance`.todo_id WHERE `Todo`.dueDateTime > ? AND `Todo`.id = `RecurringInstance`.todo_id AND `RecurringInstance`.RecurringEndDate < ? AND `RecurringInstance`.isOver = 0 AND `Todo`.uid = ? AND `Todo`.id NOT IN (SELECT todo_id FROM `Routine` WHERE routineValue != 0 );";

$stmt = $conn->prepare($TodoSELSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("sss", $today, $today, $uid);
if($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            
            $RecurringEndDate_data = $row['RecurringEndDate'];
            $frequency = $row['frequency'];
            $todo_id = $row['id'];
            $update = "UPDATE `RecurringInstance` AS RI INNER JOIN `Todo` AS T ON RI.todo_id = T.id SET RI.`isOver` = '1' WHERE RI.`RecurringEndDate` <= '$today'  AND T.`id` = $todo_id; ";
            $conn->query($update); // 執行更新操作;
            // $message = updateRecurringInstanc($conn,$todo_id, $today, $uid);
            // $RecurringStartDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +1 day"));

            // if ($frequency == 1 || $frequency == 0) {
            //     // 每天重複
            //     $RecurringEndDate_new = $RecurringStartDate_new;
            //     $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
            //     // $conn->query($update); // 執行更新操作
            // } else if ($frequency == 2) {
            //     // 每週重複
            //     $RecurringEndDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +6 day"));
            //     $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
            //     // $conn->query($update); // 執行更新操作
            // } else if ($frequency == 3) {
            //     // 每月重複
            //     $RecurringEndDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +1 month"));
            //     $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
            //     // $conn->query($update); // 執行更新操作
            // }
            $message = updateRecurringInstance($conn, $todo_id, $RecurringEndDate_data, $frequency,$today);
        }
    }  else {
        $message = "今日沒有要新增的";
    }
} else {
    error_log("SQL Error: " . $stmt->error);
    $message = "TodoIdSqlError" . $stmt->error;
}
$stmt->close();


// $TodoSELSql = "SELECT `Todo`.frequency, `RecurringInstance`.RecurringEndDate, `Todo`.id FROM `Todo` JOIN `RecurringInstance` ON `Todo`.id = `RecurringInstance`.todo_id WHERE `Todo`.dueDateTime > '$today' AND `Todo`.id = `RecurringInstance`.todo_id AND `RecurringInstance`.RecurringEndDate <= '$today' AND `RecurringInstance`.isOver = 0 AND `Todo`.uid = '$uid' AND `Todo`.id NOT IN (SELECT todo_id FROM `Routine` WHERE routineValue != 0 );";
// $result = $conn->query($TodoSELSql);
// while ($result->num_rows > 0) {
//         while ($row = $result->fetch_assoc()) {
            
//             $RecurringEndDate_data = $row['RecurringEndDate'];
//             $frequency = $row['frequency'];
//             $todo_id = $row['id'];
//             $update = "UPDATE `RecurringInstance` AS RI INNER JOIN `Todo` AS T ON RI.todo_id = T.id SET RI.`isOver` = '1' WHERE RI.`RecurringEndDate` <= '$today'  AND T.`id` = $todo_id; ";
//             $conn->query($update); // 執行更新操作;
//             // $message = updateRecurringInstanc($conn,$todo_id, $today, $uid);
//             $RecurringStartDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +1 day"));

//             if ($frequency == 1 || $frequency == 0) {
//                 // 每天重複
//                 $RecurringEndDate_new = $RecurringStartDate_new;
//                 $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
//                 // $conn->query($update); // 執行更新操作
//             } else if ($frequency == 2) {
//                 // 每週重複
//                 $RecurringEndDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +6 day"));
//                 $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
//                 // $conn->query($update); // 執行更新操作
//             } else if ($frequency == 3) {
//                 // 每月重複
//                 $RecurringEndDate_new = date('Y-m-d', strtotime("$RecurringEndDate_data +1 month"));
//                 $message = insertRecurringInstance($conn, $todo_id, $RecurringStartDate_new, $RecurringEndDate_new);
//                 // $conn->query($update); // 執行更新操作
//             }
//         }
//         // $message = "yes";

// } 
//     $message = "今日沒有要新增的";


$userData = array(
    'uid'=>$uid,
    'TodoSELSql'=>$TodoSELSql,
    'result'=>$result,
    'row'=>$row,
    'message' => $message,
);
echo json_encode($userData);

$conn->close();
?>