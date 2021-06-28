<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

define("DB_HOST", "31.11.39.54");
define("DB_USER", "Sql1558195");
define("DB_PASSWORD", "ab12pozt12Q!!");
define("DB_NAME", "Sql1558195_1");
	
$connect = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
if (mysqli_connect_errno($connect)){
	die("Unable to connect to MySQL Database: " . mysqli_connect_error());
}

$emparray = array();

if(isset($_GET['email'])) {
			$sql = "SELECT role.* FROM user left join user_attribute on user.id = user_attribute.user_id 
	left join role on user_attribute.role_id = role.role_id
	where email = '" . $_GET['email'] ."'";
	
	$result = $connect->query($sql);
    if($result->num_rows == 1) $emparray = $row = $result->fetch_assoc();
	 
} else { 
	// no results
}

$connect->close();

echo json_encode($emparray, JSON_INVALID_UTF8_IGNORE);


?>