<?php
include "../connection.php";

// Hanya JOIN ke tb_kategori karena tb_supplier sudah tidak dipakai
$sql = "SELECT 
            p.*, 
            k.nama_kategori AS kategori
        FROM tb_product p
        LEFT JOIN tb_kategori k ON p.id_kategori = k.id_kategori";

$result = $connect->query($sql);

if ($result && $result->num_rows > 0) {
    $products = array();
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }
    echo json_encode(array(
        "success" => true,
        "data" => $products,
    ));
} else {
    echo json_encode(array("success" => false));
}
