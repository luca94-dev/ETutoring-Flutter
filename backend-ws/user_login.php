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

//Applying User Login query with email and password.
$loginQuery = "select * from user where email = '$email' and password = '$hashed_password' ";

// Executing SQL Query.
$check = mysqli_fetch_array(mysqli_query($connect,$loginQuery));

if(isset($check)){
	
	 // Successfully Login Message.
	 $onLoginSuccess = 'Login Matched';
	 
	 // Converting the message into JSON format.
	 $SuccessMSG = json_encode($onLoginSuccess);
	 
	 // Echo the message.
	 echo $SuccessMSG ; 
 
 }
 
 else{
 
	 // If Email and Password did not Matched.
	$InvalidMSG = 'Invalid Username or Password Please Try Again' ;
	 
	// Converting the message into JSON format.
	$InvalidMSGJSon = json_encode($InvalidMSG);
	 
	// Echo the message.
	 echo $InvalidMSGJSon ;
 
 }
mysqli_close($connect);
?>