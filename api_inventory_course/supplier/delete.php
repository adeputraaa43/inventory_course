<?php

header('Content-Type: application/json'); // penting agar Flutter bisa parse JSON

include "../connection.php";

// Pastikan id_supplier dikirim
if (isset($_POST['id_supplier'])) {
    $id = $_POST['id_supplier'];

    $sql = "DELETE FROM tb_supplier WHERE id_supplier = '$id'";
    $result = $connect->query($sql);

    if ($result) {
        echo json_encode(array("success" => true));
    } else {
        echo json_encode(array("success" => false, "message" => "Query gagal"));
    }
} else {
    echo json_encode(array("success" => false, "message" => "ID tidak dikirim"));
}
