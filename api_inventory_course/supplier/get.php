<?php
header('Content-Type: application/json');
include "../connection.php";

$sql = "SELECT 
          id_supplier,
          nama_supplier,
          nama_produk,
          no_telp,
          jumlah_produk,
          produk_terjual,
          sisa_produk,
          harga,
          created_at
        FROM tb_supplier
        ORDER BY created_at DESC";  // urutkan terbaru dulu, opsional

$result = $connect->query($sql);

if ($result && $result->num_rows > 0) {
    $suppliers = [];
    while ($row = $result->fetch_assoc()) {
        $suppliers[] = $row;
    }
    echo json_encode([
        "success" => true,
        "data"    => $suppliers,
    ]);
} else {
    echo json_encode([
        "success" => false,
        "data"    => [],
    ]);
}
