<?php
header("Access-Control-Allow-Origin: *"); // running as crome app

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    if (!isset($_POST['email']) || !isset($_POST['password'])) {
        $response = array('status' => 'failed', 'message' => 'Bad Request');
        sendJsonResponse($response);
        exit();
    }
    
    $user_id = $_POST['email'];

    include 'dbconnect.php';


    $sqldonate = "SELECT * FROM `tbl_donation` WHERE user_id = '$user_id'";
    
    $result = $conn->query($sqldonate);
    if ($result->num_rows > 0) {
        $data = array();
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        $response = array('status' => 'success', 'data' => $data);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' =>null);
        sendJsonResponse($response);
    }

}else{
    $response = array('status' => 'failed', 'message' => 'Method Not Allowed');
    sendJsonResponse($response);
    exit();
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>