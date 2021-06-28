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

$email = $_GET['email'] ?? null;

if($email){
	$sql = "SELECT course.* FROM user 
	left join user_attribute on user.id = user_attribute.user_id
	left join degree on user_attribute.degree_id = degree.degree_id
	left join degree_path on user_attribute.degree_path_id = degree_path.degree_path_id
	left join course_path_degree on user_attribute.degree_path_id = course_path_degree.degree_path_id 
		AND user_attribute.degree_id = course_path_degree.degree_id
	left join course on course_path_degree.course_id = course.course_id
	where email = '" . $_GET['email'] ."' order by course.course_name ASC";
	// print_r($sql);
	$result = $connect->query($sql);
	
	$emparray = array();
	if ($result->num_rows > 0) {
	  // output data of each row
	  while($row = $result->fetch_assoc()) {
		$emparray[] = $row;
	  }
	} else {
	  echo "0 results";
	}
	$connect->close();

	echo json_encode($emparray, JSON_INVALID_UTF8_IGNORE);
}else {
	$connect->close();
	echo json_encode([]);
}
?>