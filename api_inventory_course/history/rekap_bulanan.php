<?php
include "../connection.php";

$sql = "SELECT 
            MONTH(created_at) AS bulan,
            SUM(total_price) AS total_penjualan
        FROM tb_history
        WHERE type = 'masuk'
        GROUP BY MONTH(created_at)
        ORDER BY bulan ASC";

$result = $connect->query($sql);

if ($result && $result->num_rows > 0) {
    $rekap = array();
    while ($row = $result->fetch_assoc()) {
        $rekap[] = $row;
    }
    echo json_encode([
        "success" => true,
        "data" => $rekap
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Tidak ada data"
    ]);
}
?>
