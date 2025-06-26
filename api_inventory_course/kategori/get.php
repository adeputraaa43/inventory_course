<?php
include '../connection.php';

$query = mysqli_query($connect, "SELECT * FROM tb_kategori");

$result = array();

while ($row = mysqli_fetch_assoc($query)) {
    $result[] = $row;
}

header('Content-Type: application/json');
echo json_encode($result);
?>
