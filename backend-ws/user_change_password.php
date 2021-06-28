<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

define("DB_HOST", "31.11.39.54");
define("DB_USER", "Sql1558195");
define("DB_PASSWORD", "ab12pozt12Q!!");
define("DB_NAME", "Sql1558195_1");
	
sleep(2);

$connect = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
if (mysqli_connect_errno($connect)){
	die("Unable to connect to MySQL Database: " . mysqli_connect_error());
}

// Getting the received JSON into $json variable.
$json = file_get_contents('php://input');
 
// Decoding the received JSON and store into $obj variable.
$obj = json_decode($json,true);
// Getting User email from JSON $obj array and store into $email.
$email = $obj['email'];

// Getting Password from JSON $obj array and store into $password.
$password = $obj['password'];
$hashed_password = md5($password);

//Applying UPDATE user with new password
$sql = "UPDATE user SET password = '$hashed_password' WHERE email = '$email'";

if ($connect->query($sql) === TRUE) {
    // Converting the message into JSON format.
	$SuccessMSG = json_encode("Password updated successfully");
	 
	// Echo the message.
	echo $SuccessMSG ; 
} else {
	$InvalidMSG = "Error updating record: " . $conn->error;
	// Converting the message into JSON format.
	$InvalidMSGJSon = json_encode($InvalidMSG);
	 
	// Echo the message.
	 echo $InvalidMSGJSon ;
}

$connect->close();
?>