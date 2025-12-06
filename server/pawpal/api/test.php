<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('status' => 'error', 'message' => 'Method Not Allowed'));
    exit();
}

// Validate required fields
$required_fields = ['userid', 'petName', 'petType', 'category', 'description', 'latitude', 'longitude', 'images'];
foreach ($required_fields as $field) {
    if (empty($_POST[$field])) {
        echo json_encode(array('status' => 'error', 'message' => "Missing required field: $field"));
        exit();
    }
}

$user_id = $_POST['userid'];
$pet_name = $_POST['petName'];
$pet_type = $_POST['petType'];
$category = $_POST['category'];
$description = $_POST['description'];
$lat = $_POST['latitude'];
$lng = $_POST['longitude'];

// Handle multiple images sent as ||| separated base64 strings
$images_data = $_POST['images'];
$image_array = explode('|||', $images_data);
$image_paths = array();

try {
    // Create uploads directory if it doesn't exist
    $upload_dir = "../pet/";
    if (!is_dir($upload_dir)) {
        if (!mkdir($upload_dir, 0755, true)) {
            echo json_encode(array('status' => 'error', 'message' => 'Failed to create upload directory'));
            exit();
        }
    }

    // Use prepared statement to insert pet record (without image paths first)
    $sqlinsertpet = "INSERT INTO `tbl_pets`(`user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`, `created_at`) 
                     VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
    
    $stmt = $conn->prepare($sqlinsertpet);
    if (!$stmt) {
        echo json_encode(array('status' => 'error', 'message' => 'Prepare failed: ' . $conn->error));
        exit();
    }

    $stmt->bind_param("issssss", $user_id, $pet_name, $pet_type, $category, $description, $lat, $lng);
    
    if (!$stmt->execute()) {
        echo json_encode(array('status' => 'error', 'message' => 'Execute failed: ' . $stmt->error));
        exit();
    }

    $pet_id = $stmt->insert_id;
    $stmt->close();

    // Save each image with a unique filename based on pet_id and index
    foreach ($image_array as $index => $base64_image) {
        $base64_image = trim($base64_image); // Remove whitespace
        
        if (empty($base64_image)) {
            continue; // Skip empty entries
        }

        $image_data = base64_decode($base64_image);
        if ($image_data === false) {
            echo json_encode(array('status' => 'error', 'message' => 'Invalid base64 image data at index ' . $index));
            exit();
        }

        // Generate filename: pet_<pet_id>_<number>.png
        $image_number = $index + 1;
        $filename = "pet_" . $pet_id . "_" . $image_number . ".png";
        $filepath = $upload_dir . $filename;
        
        if (!file_put_contents($filepath, $image_data)) {
            echo json_encode(array('status' => 'error', 'message' => 'Failed to save image ' . $image_number));
            exit();
        }

        $image_paths[] = $filename;
    }

    // Validate that at least 1 image was saved
    if (empty($image_paths)) {
        echo json_encode(array('status' => 'error', 'message' => 'No valid images were saved'));
        exit();
    }

    // Update the pet record with image paths (comma-separated)
    $image_paths_str = implode(",", $image_paths);
    
    $sqlUpdate = "UPDATE tbl_pets SET image_paths = ? WHERE pet_id = ?";
    $stmt = $conn->prepare($sqlUpdate);
    if (!$stmt) {
        echo json_encode(array('status' => 'error', 'message' => 'Prepare update failed: ' . $conn->error));
        exit();
    }

    $stmt->bind_param("si", $image_paths_str, $pet_id);
    if (!$stmt->execute()) {
        echo json_encode(array('status' => 'error', 'message' => 'Update failed: ' . $stmt->error));
        exit();
    }

    $stmt->close();

    // Return success response
    $response = array(
        'status' => 'success',
        'message' => 'Pet submitted successfully',
        'pet_id' => $pet_id,
        'image_count' => count($image_paths),
        'image_paths' => $image_paths
    );
    echo json_encode($response);

} catch (Exception $e) {
    echo json_encode(array('status' => 'error', 'message' => 'Exception: ' . $e->getMessage()));
}

?>