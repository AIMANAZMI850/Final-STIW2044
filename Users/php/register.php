<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");

$name = addslashes($_POST['name']);
$email = addslashes($_POST['email']);
$password = $_POST['pass'];
$phone = $_POST['phone'];
$address = $_POST['address'];


$sqlinsert = "INSERT INTO tbl_users ( user_name, user_email, user_pass, user_phone, user_address) VALUES ('$name','$email','$password','$phone','$address')";
if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
