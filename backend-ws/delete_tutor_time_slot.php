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

	$email = $obj['email'];
	$time_slot_id = $obj['time_slot_id'];
	
	$query_select_id_user = "select id FROM user WHERE email = '$email'";
	$result = $connect->query($query_select_id_user);
	$row = $result->fetch_assoc();
	$user_id = $row['id'];
		
	$sql = "DELETE FROM tutor_time_slot WHERE user_id = '$user_id' AND tutor_time_slot_id =' $time_slot_id'";
	if($connect->query($sql)){
		$SuccessMSG = json_encode("Time slot successfully deleted");
		echo $SuccessMSG ; 
	} else {
		$InvalidMSG = "Error deleting time slot";
		$InvalidMSGJSon = json_encode($InvalidMSG, JSON_INVALID_UTF8_IGNORE);
		echo $InvalidMSGJSon;
	}
	$connect->close();
} catch (Exception $e) {
	echo json_encode("Unable to connect to MySQL Database: " . $e->getMessage());
}
?>