<?php
include "../connection.php";

$sql = "SELECT code FROM tb_supplier";
$result = $connect->query($sql);
echo json_encode(array(
    "data" => $result->num_rows,
));