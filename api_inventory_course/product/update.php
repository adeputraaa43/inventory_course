<?php

include "../connection.php";

$old_code = $_POST['old_code'];
$code = $_POST['code']; // as new code
$name = $_POST['name'];
$stock = $_POST['stock'];
$unit = $_POST['unit'];
$price = $_POST['price'];

$date = new DateTime();
$updatedAt = $date->format('Y-m-d H:i:sP');
// (code == newCode) && (code != oldCode)
$sql_check_code = "SELECT * FROM tb_product WHERE code='$code' AND NOT code='$old_code'";
$result_check_code = $connect->query($sql_check_code);
if ($result_check_code->num_rows > 0) {
    echo json_encode(array(
        "success" => false,
        "message" => "code",
    ));
}else{
    $sql = "UPDATE tb_product SET
        code='$code',
        name='$name',
        stock='$stock',
        unit='$unit',
        price='$price',
        updated_at='$updatedAt'
        WHERE
        code='$old_code'
        ";
    $result = $connect->query($sql);
    if($result) {    
        echo json_encode(array("success"=>true));
    } else {
        echo json_encode(array("success"=>false));
    }
}

