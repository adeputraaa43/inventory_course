<?php
include "../connection.php";

$sql = "SELECT * FROM tb_supplier";
$result = $connect->query($sql);
if ($result->num_rows > 0) {
    $supplier = array();
    while ($row = $result->fetch_assoc()) {
        $supplier[] = $row;
    }
    echo json_encode(array(
        "success" => true,
        "data" => $supplier,
    ));
} else {
    echo json_encode(array("success" => false));
}