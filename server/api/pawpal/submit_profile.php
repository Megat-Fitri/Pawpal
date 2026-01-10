<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(['status' => 'failed', 'message' => 'Method Not Allowed']);
    exit();
}

// ---------- Get POST data ----------
$userid    = $_POST['user_id'];
$name      = addslashes($_POST['user_name']);
$phone     = addslashes($_POST['user_phone']);
$email     = addslashes($_POST['user_email']);

// ---------- SQL UPDATE ----------
$sqlupdateprofile = "
UPDATE tbl_users 
SET 
    user_name      = '$name',
    user_phone     = '$phone',
    user_email   = '$email',
WHERE user_id = '$userid'
";

try {
    $sqlupdateprofile = "UPDATE tbl_users SET 
        user_name = '$name', 
        user_phone = '$phone',
        user_email = '$email' 
        WHERE user_id = '$userid'";

    if ($conn->query($sqlupdateprofile) === TRUE) {
        if (!empty($_POST["user_image"])) {
            $imageData = $_POST["user_image"];
            $imageParts = explode(";base64,", $imageData);
            $imageTypeAux = explode("image/", $imageParts[0]);
            $imageType = $imageTypeAux[1];
            $imageBase64 = base64_decode($imageParts[1]);
            $fileName = "user_" . $userid . "." . $imageType;
            $filePath = "../user_images/" . $fileName;
            file_put_contents($filePath, $imageBase64);

            $sqlupdateimage = "UPDATE tbl_users SET user_image = '$fileName' WHERE user_id = '$userid'";
            $conn->query($sqlupdateimage);
        }
        sendJsonResponse([
            'status' => 'success',
            'message' => 'Profile updated successfully'
        ]);
    } else {
        sendJsonResponse([
            'status' => 'failed',
            'message' => 'Profile update failed'
        ]);
    }
} catch (Exception $e) {
    sendJsonResponse([
        'status' => 'failed',
        'message' => $e->getMessage()
    ]);
}

// ---------- JSON response ----------
function sendJsonResponse($sentArray)
{
    echo json_encode($sentArray);
}
?>