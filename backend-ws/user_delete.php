<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

define("DB_HOST", "31.11.39.54");
define("DB_USER", "Sql1558195");
define("DB_PASSWORD", "ab12pozt12Q!!");
define("DB_NAME", "Sql1558195_1");
	
sleep(5);

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
	
	if($email){
		// get user id
		$sqlUser = "SELECT id FROM `user` WHERE email = '" . $email ."'";
		$result = $connect->query($sqlUser);
		$row = $result->fetch_assoc();
		$user_id = $row['id'];
		
		$sql = "DELETE FROM user WHERE email='" . $email ."'";

		if ($connect->query($sql) === TRUE) {
			$last_id = $connect->insert_id;
			$sql = "DELETE FROM user_attribute WHERE user_id='" . $user_id ."'";
			if ($connect->query($sql) === TRUE) {
				$SuccessMSG = json_encode("User deleted successfully");
				// Echo the message.
				echo $SuccessMSG ; 
			}
		} else {
			$InvalidMSG = "Error deleting User: " . $connect->error;
			$InvalidMSGJSon = json_encode($InvalidMSG, JSON_INVALID_UTF8_IGNORE);
			echo $InvalidMSGJSon;
		}
	} else {
			$InvalidMSG = "Error deleting User: No email param found";
			$InvalidMSGJSon = json_encode($InvalidMSG, JSON_INVALID_UTF8_IGNORE);
			echo $InvalidMSGJSon;
	}
		
	mysqli_close($connect);
} catch (Exception $e) {
	echo json_encode("Unable to connect to MySQL Database: " . $e->getMessage());
}
?>