<?php
try{
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
	
	if(isset($_GET['email'])) {
		$email = $_GET['email'];
		$query_select_id_user = "select id FROM user WHERE email = '$email'";
		$result = $connect->query($query_select_id_user);
		$row = $result->fetch_assoc();
		$user_id = $row['id'];
	
		$sql = "SELECT DISTINCT * FROM review
			left join user_attribute on review.user_tutor_id = user_attribute.user_id
			WHERE review.user_id = '$user_id'";
		$result_reviews = $connect->query($sql);
		
		$emparray = array();
		if ($result_reviews->num_rows > 0) {
		  // output data of each row
		  // $emparray = $row = $result->fetch_assoc();
			while($row = $result_reviews->fetch_assoc()) {
					$emparray[] = $row;
			}
		} else {
		  // echo "0 results";
		}
	}
	
	$connect->close();
	echo json_encode($emparray, JSON_INVALID_UTF8_IGNORE);
} catch (Exception $e) {
	print($e->getMessage());
}
?>