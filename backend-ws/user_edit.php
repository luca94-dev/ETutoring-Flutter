<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

define("DB_HOST", "31.11.39.54");
define("DB_USER", "Sql1558195");
define("DB_PASSWORD", "ab12pozt12Q!!");
define("DB_NAME", "Sql1558195_1");
	
sleep(2);

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
	$firstname = $obj['firstname'];
	$lastname = $obj['lastname'];
	$birth_date= $obj['birth_date'];
	$birth_city = $obj['birth_city'];
	$residence_city = $obj['residence_city'];
	$nationality = $obj['nationality'];
	$phone_number = $obj['phone_number'];
	$description = $obj['description'];

	$sql = "UPDATE user_attribute JOIN user ON user_attribute.user_id = user.id SET firstname = '$firstname', lastname = '$lastname', birth_date='$birth_date',
	birth_city ='$birth_city', residence_city = '$residence_city', 
	nationality = '$nationality', phone_number = '$phone_number', description = '$description'  WHERE email = '$email'";
	
	if($connect->query($sql)){
		$SuccessMSG = json_encode("User updated successfully");
		echo $SuccessMSG ; 
	} else {
		$InvalidMSG = "Error updating record";
		$InvalidMSGJSon = json_encode($InvalidMSG);
		echo $InvalidMSGJSon ;
	}

	mysqli_close($connect);
} catch (Exception $e) {
	echo json_encode("Unable to connect to MySQL Database: " . $e->getMessage());
}
?>