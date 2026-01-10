<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('error' => 'Method Not Allowed'));
    exit();
}

$user_id = $_POST['user_id'];
$pet_id = $_POST['pet_id'];
$msg = $_POST['msg'];
$status = 'Pending';

try {

    $sqlowner = "SELECT user_id FROM tbl_pets WHERE pet_id = '$pet_id'";
    $result = $conn->query($sqlowner);
    $row = $result->fetch_assoc();
    $owner_id = $row['user_id'];

    $sqladopt = "INSERT INTO tbl_adoption (pet_id, user_id, owner_id, messages, status) VALUES ('$pet_id', '$user_id', '$owner_id', '$msg', '$status')";
    if ($conn->query($sqladopt) === TRUE) {


        sendJsonResponse(['status' => 'success', 'message' => 'Successfully request adoption']);
    } else {
        sendJsonResponse(['status' => 'failed', 'message' => 'Failed to request adoption']);
    }
} catch (Exception $e) {
    sendJsonResponse(['status' => 'failed', 'message' => $e->getMessage()]);
}
function sendJsonResponse($array)
{
    header('Content-Type: application/json');
    echo json_encode($array);
}