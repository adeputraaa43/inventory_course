<?php
include '../connection.php';

$name = $_POST['name'];

if (!empty($name)) {
    $query = mysqli_query($connect, "INSERT INTO tb_kategori (nama_kategori) VALUES ('$name')");
    
    if ($query) {
        echo json_encode([
            'success' => true,
            'message' => 'Category added successfully'
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Failed to add category'
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Category name is required'
    ]);
}
?>
