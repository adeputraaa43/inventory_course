<?php
include "../connection.php";

// Join tb_product dengan tb_kategori dan tb_supplier agar bisa ambil nama kategori dan nama supplier
$sql = "SELECT 
            p.*, 
            k.nama_kategori AS kategori,
            s.nama_supplier AS supplier
        FROM tb_product p
        LEFT JOIN tb_kategori k ON p.id_kategori = k.id_kategori
        LEFT JOIN tb_supplier s ON p.id_supplier = s.id_supplier";

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