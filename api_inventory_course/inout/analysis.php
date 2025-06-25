<?php
include "../connection.php";

$type = $_POST['type'];
$today = new DateTime($_POST['today']);
$loc = (new DateTime())->getTimezone();
// change to local date in this server
$today->setTimezone($loc);
$day7 = $today->format('Y-m-d');
$day6 = date_sub($today,new DateInterval('P1D'))->format('Y-m-d');
$day5 = date_sub($today,new DateInterval('P1D'))->format('Y-m-d');
$day4 = date_sub($today,new DateInterval('P1D'))->format('Y-m-d');
$day3 = date_sub($today,new DateInterval('P1D'))->format('Y-m-d');
$day2 = date_sub($today,new DateInterval('P1D'))->format('Y-m-d');
$day1 = date_sub($today,new DateInterval('P1D'))->format('Y-m-d');
$week = array($day1,$day2,$day3,$day4,$day5,$day6,$day7);

$sql = "SELECT * FROM tb_history
        WHERE
        type='$type'
        ORDER BY created_at DESC
        ";
$result = $connect->query($sql);
if ($result->num_rows > 0) {
    $list_total = array(0,0,0,0,0,0,0);
    $history = array();    
    while ($row = $result->fetch_assoc()) {                
        $date = new DateTime($row['created_at']);
        $the_day = $date->format('Y-m-d');
        // break looping when limit 7 days available
        if ($the_day < $day1){
            break;
        }
        for ($i=0; $i < count($week); $i++) { 
            // count total_price in same day
            // example: day1 => In 1  + In 2 => get totalPrice from 2 data
            // example: day5 => In 1  + In 2 + In3 => get totalPrice from 3 data
            if ($the_day == $week[$i]){                
                $list_total[$i] += floatval($row['total_price']);
            }
        }
        
        $history[] = $row;     
    }

    echo json_encode(array(
        "success" => true,
        "list_total" => $list_total,
        "data" => $history,
    ));
} else {
    echo json_encode(array("success" => false));
}