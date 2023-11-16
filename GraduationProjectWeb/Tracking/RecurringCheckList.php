<?php
require_once '../common.php'; // 引用共通設定

$data = getFormData(); // 使用 common.php 中的函數獲取表單數據
$id = $data['id'];
$targetvalue = $data['targetvalue'];
$checkDate = array();
$completeValue = array();

$db = Database::getInstance();
$conn = $db->getConnection();

// $TodoSELSql = "SELECT * FROM `RecurringCheck` WHERE Instance_id = '$id';";
$TodoSELSql = "SELECT * FROM RecurringInstance AS RI, RecurringCheck AS RC WHERE RI.todo_id = ? && RC.instance_id = RI.id;";

$stmt = $conn->prepare($TodoSELSql);
if ($stmt === false) {
    die("Error preparing statement: " . $conn->error);
}
$stmt->bind_param("i", $todo_id);
if($stmt->execute() === TRUE) {
    $result = $stmt->get_result();
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $checkDate[] = $row['checkDate'];
            $completeValue[] = $row['completeValue'];
            $message = "User RecurringCheckList successfully";
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
    'checkDate' => $checkDate,
    'completeValue' => $completeValue,
    'targetvalue' => $targetvalue,
    'message' => $message
);
echo json_encode($userData);
$conn->close();
?>