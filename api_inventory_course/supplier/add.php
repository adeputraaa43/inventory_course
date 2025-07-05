<?php
header('Content-Type: application/json');
include "../connection.php";

// Ambil semua nilai dari Flutter
$nama_supplier  = $_POST['nama_supplier'];
$nama_produk    = $_POST['nama_produk'];
$no_telp        = $_POST['no_telp'];
$jumlah_produk  = $_POST['jumlah_produk'];
$harga          = $_POST['harga'];

$date     = new DateTime();
$createdAt = $date->format('Y-m-d H:i:s');

// Simpan ke database termasuk harga
$sql = "INSERT INTO tb_supplier 
          (nama_supplier, nama_produk, no_telp, jumlah_produk, harga, created_at)
        VALUES 
          ('$nama_supplier', '$nama_produk', '$no_telp', '$jumlah_produk', '$harga', '$createdAt')";

$result = $connect->query($sql);

if ($result) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode([
      "success" => false, 
      "error"   => $connect->error
    ]);
}
?>
