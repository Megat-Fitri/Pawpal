<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('error' => 'Method Not Allowed'));
    exit();
}

$user_id     = $_POST['user_id'];
$user_name = $_POST['user_name'];
$pet_name    = addslashes($_POST['pet_name']);
$pet_age     = $_POST['pet_age'];
$pet_gender  = $_POST['pet_gender'];
$pet_type    = $_POST['pet_type'];
$category    = $_POST['category'];
$description = addslashes($_POST['description']);
'';
$lat         = $_POST['lat'];
$lng         = $_POST['lng'];


if (!is_array($imagesArray) || count($imagesArray) == 0) {
    sendJsonResponse(array('status' => 'failed', 'message' => 'No images provided'));
    exit();
}

// Insert new pet into database without image first
$sqlinsertpets = "INSERT INTO tbl_pets(user_id, user_name, pet_name, pet_age, pet_gender, pet_type, category, description, image_paths, lat, lng) 
                  VALUES ('$user_id','$user_name','$pet_name','$pet_age','$pet_gender','$pet_type','$category','$description', ' ', '$lat', '$lng')";

try{
if ($conn->query($sqlinsertpet) === TRUE) {

    $last_id = $conn->insert_id;
	//get base64 images type from flutter and save them
    $images = json_decode($_POST['image'], true);
    $image_paths = [];

    if (is_array($images)) {

    for ($i = 0; $i < count($images); $i++) {

        // decode/convert string to image
        $decodedImage = base64_decode($images[$i]);

        // file name: pet_5_1.png, pet_5_2.png, pet_5_3.png
        $fileName = "pet_" . $last_id . "_" . ($i + 1) . ".png";

        // server storage path
        $filePath = "../file_put_contents/" . $fileName;

        // save image file to server
        file_put_contents($filePath, $decodedImage);

        // store file name in array
        $image_paths[] = $fileName;
    }

}

// convert path file to json and update database
    $image_paths_json = json_encode($image_paths);
    $conn->query("UPDATE tbl_pets SET image_paths = '$image_paths_json' WHERE pet_id = $last_id");

    sendJsonResponse(['status' => 'success', 'message' => 'Successfully added']);
} else {
    sendJsonResponse(['status' => 'failed', 'message' => 'Failed to add']);
}
}
catch(Exception $e){
    sendJsonResponse(['status' => 'failed', 'message' => $e->getMessage()]);
}
function sendJsonResponse($array)
{
    header('Content-Type: application/json');
    echo json_encode($array);
}
?>