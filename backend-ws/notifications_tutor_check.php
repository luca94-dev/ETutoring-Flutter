<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

define("DB_HOST", "31.11.39.54");
define("DB_USER", "Sql1558195");
define("DB_PASSWORD", "ab12pozt12Q!!");
define("DB_NAME", "Sql1558195_1");

try {	
	$connect = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
	if (mysqli_connect_errno($connect)){
		die("Unable to connect to MySQL Database: " . mysqli_connect_error());
	}

	// Getting the received JSON into $json variable.
	$json = file_get_contents('php://input');
	 
	// Decoding the received JSON and store into $obj variable.
	$obj = json_decode($json,true);

	$id = $obj['notifications_tutor_id'];

	$sql = "UPDATE notifications_tutor SET `check` = 1 WHERE notifications_tutor_id = $id";
	// var_dump($sql);
	if($connect->query($sql)){
		$SuccessMSG = json_encode("Check updated successfully");
		echo $SuccessMSG ; 
	} else {
		$InvalidMSG = "Error updating notifications";
		$InvalidMSGJSon = json_encode($InvalidMSG);
		echo $InvalidMSGJSon ;
	}

	mysqli_close($connect);
} catch (Exception $e) {
	echo json_encode("Unable to connect to MySQL Database: " . $e->getMessage());
}
?>