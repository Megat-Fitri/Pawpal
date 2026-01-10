<?php
header("Access-Control-Allow-Origin: *"); // running as crome app
header("Content-Type: application/json");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'failed', 'message' => 'Method Not Allowed']);
    exit();
}

$petid = $_POST['pet_id'];
$userid = $_POST['user_id']; // user donate
$type = $_POST['donation_type'];
$amount = $_POST['donation_amount'];
$desc = $_POST['description'];




try {

        // get pet id owner
        $sqlowner = "SELECT user_id FROM tbl_pets WHERE pet_id = '$petid'";
        $result = $conn->query($sqlowner);
        $row = $result->fetch_assoc();
        $owner_id = $row['user_id'];

        $donation_type = "food/medical";
        // insert into tbl donations
        $sqlinsertdonation = "INSERT INTO `tbl_donation`(`pet_id`, `user_id`, `donation_type`, `donation_amount`, `description`, `owner_id`) 
        VALUES ('$petid', '$userid', '$type', '$amount', '$desc', '$owner_id')";

        if ($conn->query($sqlinsertdonation) === TRUE) {
            sendJsonResponse([
                'status' => 'success',
                'message' => 'Donation updated successfully'
            ]);
        } else {
            sendJsonResponse([
                'status' => 'failed',
                'message' => 'Failed to update donation'
            ]);
        }
    
} catch (Exception $e) {
    sendJsonResponse([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}


function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}