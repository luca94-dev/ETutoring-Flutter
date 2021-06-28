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
	$course_id = $obj['course_id'];
	$day = $obj['day'];
	$hour_from = $obj['hour_from'];
	$hour_to = $obj['hour_to'];
	
	$query_select_id_user = "select id FROM user WHERE email = '$email'";
	$result = $connect->query($query_select_id_user);
	$row = $result->fetch_assoc();
	$user_id = $row['id'];
		
	$sql = "INSERT INTO tutor_time_slot (course_id, day, hour_from, hour_to, user_id) VALUES ('$course_id', '$day', '$hour_from', '$hour_to', $user_id)";
	if($connect->query($sql)){
		$SuccessMSG = json_encode("Add availability successfully");
		echo $SuccessMSG ; 
	} else {
		$InvalidMSG = "Error adding availability";
		$InvalidMSGJSon = json_encode($InvalidMSG, JSON_INVALID_UTF8_IGNORE);
		echo $InvalidMSGJSon;
	}

	$connect->close();
} catch (Exception $e) {
	echo json_encode("Unable to connect to MySQL Database: " . $e->getMessage());
}
?>