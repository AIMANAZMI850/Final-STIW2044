<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$cartid = addslashes($_POST['cart_id']);
$op = addslashes($_POST['operation']);

if ($op =="+"){
    $updatecart = "UPDATE `tbl_cart` SET `cart_qty`= (cart_qty+1) WHERE cart_id = '$cartid'";    
}

if ($op =="-"){
    $updatecart = "UPDATE `tbl_cart` SET `cart_qty` WHERE cart_id = '$cartid'";    
}

if ($conn->query($updatecart)){
    $response = array('status' => 'success', 'data' => null);    
}else{
    $response = array('status' => 'failed', 'data' => null);
}

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>