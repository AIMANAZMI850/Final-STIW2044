<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['pass']);
$sqllogin = "SELECT * FROM tbl_users WHERE user_email = '$email' AND user_pass = '$password'";
$result = $conn->query($sqllogin);
$numrow = $result->num_rows;

if ($numrow > 0) {
    while ($row = $result->fetch_assoc()) {
        $user['user_id'] = $row['user_id'];
        $user['user_name'] = $row['user_name'];
        $user['user_email'] = $row['user_email'];
        $user['user_pass'] = $row['user_pass'];
        $user['user_phone'] = $row['user_phone'];
        $user['user_address'] = $row['user_address'];
    }
    $sqlgetqty = "SELECT * FROM tbl_cart WHERE user_email = '$email' AND cart_status IS NULL";
    $result = $conn->query($sqlgetqty);
    $number_of_result = $result->num_rows;
    $carttotal = 0;
    while($row = $result->fetch_assoc()) {
        $carttotal = $row['cart_qty'] + $carttotal;
    }
    $mycart = array();
    $customer['cart'] =$carttotal;

    $response = array('status' => 'success', 'data' => $customer);
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