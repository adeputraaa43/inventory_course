<?php
header('Content-Type: application/json');
include "../connection.php";

$id_supplier = $_POST['id_supplier'];
$nama_supplier = $_POST['nama_supplier'];
$nama_produk = $_POST['nama_produk'];
$no_telp = $_POST['no_telp'];
$jumlah_produk = $_POST['jumlah_produk'];
$produk_terjual = $_POST['produk_terjual'];

// Hitung sisa produk otomatis
$sisa_produk = intval($jumlah_produk) - intval($produk_terjual);

$sql = "UPDATE tb_supplier SET 
            nama_supplier = '$nama_supplier',
            nama_produk = '$nama_produk',
            no_telp = '$no_telp',
            jumlah_produk = '$jumlah_produk',
            produk_terjual = '$produk_terjual',
            sisa_produk = '$sisa_produk'
        WHERE id_supplier = $id_supplier";

$result = $connect->query($sql);

if ($result) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => $connect->error]);
}
?>
