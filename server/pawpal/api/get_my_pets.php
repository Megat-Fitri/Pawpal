<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'GET') {
    http_response_code(405);
    echo json_encode(array('status' => 'error', 'message' => 'Method Not Allowed'));
    exit();
}

try {
    // Support two modes: fetch by userid or by petid
    if (!empty($_GET['userid'])) {
        // Fetch all pets by user_id (for MainScreen listing)
        $userid = $conn->real_escape_string($_GET['userid']);
        
        $query = "
            SELECT 
                pet_id,
                user_id,
                pet_name,
                pet_type,
                category,
                description,
                images_paths,
                lat,
                lng,
                created_at
            FROM tbl_pets
            WHERE user_id = '$userid'
            ORDER BY created_at DESC
        ";
        
    } elseif (!empty($_GET['petid'])) {
        // Fetch single pet by pet_id
        $petid = $conn->real_escape_string($_GET['petid']);
        
        $query = "
            SELECT 
                pet_id,
                user_id,
                pet_name,
                pet_type,
                category,
                description,
                images_paths,
                lat,
                lng,
                created_at
            FROM tbl_pets
            WHERE pet_id = '$petid'
        ";
    } elseif (!empty($_GET['search'])) {
        // Search pets (public listing)
        $search = $conn->real_escape_string($_GET['search']);
        
        $query = "
            SELECT 
                pet_id,
                user_id,
                pet_name,
                pet_type,
                category,
                description,
                images_paths,
                lat,
                lng,
                created_at
            FROM tbl_pets
            WHERE pet_name LIKE '%$search%'
               OR pet_type LIKE '%$search%'
               OR category LIKE '%$search%'
               OR description LIKE '%$search%'
            ORDER BY pet_id DESC
        ";
    } else {
        // Default: get all pets (public listing)
        $query = "
            SELECT 
                pet_id,
                user_id,
                pet_name,
                pet_type,
                category,
                description,
                images_paths,
                lat,
                lng,
                created_at
            FROM tbl_pets
            ORDER BY created_at DESC
        ";
    }

    $result = $conn->query($query);

    if ($result === false) {
        // SQL error occurred
        http_response_code(400);
        echo json_encode(array(
            'status' => 'error',
            'message' => 'Database query failed: ' . $conn->error
        ));
        exit();
    }

    if ($result->num_rows > 0) {
        $data = [];
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        echo json_encode(array('status' => 'success', 'message' => 'Data retrieved', 'data' => $data));
    } else {
        echo json_encode(array('status' => 'success', 'message' => 'No records found', 'data' => []));
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(array(
        'status' => 'error',
        'message' => 'Exception: ' . $e->getMessage()
    ));
}
?>