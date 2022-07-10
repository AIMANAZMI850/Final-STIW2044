<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$email = $_POST['user_email'];
$sqlloadcart = "SELECT tbl_cart.cart_id, tbl_cart.subject_id, tbl_cart.cart_qty, tbl_subjects.subject_name, 
tbl_subjects.subject_price, tbl_subjects.subject_sessions FROM tbl_cart INNER JOIN tbl_subjects 
ON tbl_cart.subject_id = tbl_subjects.subject_id 
WHERE tbl_cart.user_email = '$email' AND tbl_cart.cart_status IS NULL";
$result = $conn->query($sqlloadcart);
$number_of_result = $result->num_rows;
if ($result->num_rows > 0) {
    //do something
    $total_payable = 0;
    $carts["cart"] = array();
    while ($rows = $result->fetch_assoc()) {
        $subjectlist = array();
        $subjectlist['cartid'] = $rows['cart_id'];
        $subjectlist['subjectName'] = $rows['subject_name'];
        $subjectPrice= $rows['subject_price'];
        $subjectlist['subjectsessions'] = $rows['subject_sessions'];
        $subjectlist['subjectPrice'] = number_format((float)$subjectPrice, 2, '.', '');
        $subjectlist['cartqty'] = $rows['cart_qty'];
        $subjectlist['subjectId'] = $rows['subject_id'];
        $price = $rows['cart_qty'] * $subjectPrice;
        $total_payable = $total_payable + $price;
        $subjectlist['pricetotal'] = number_format((float)$price, 2, '.', ''); 
        array_push($carts["cart"],$subjectlist);
    }
    $response = array('status' => 'success', 'data' => $carts, 'total' => $total_payable);
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