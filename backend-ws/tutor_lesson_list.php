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

$email = $_GET['email'];

$query_select_id_user = "select id FROM user WHERE email = '$email'";
$result = $connect->query($query_select_id_user);
$row = $result->fetch_assoc();
$user_id = $row['id'];
	
$sql = "SELECT *, private_lesson.user_id as student_id FROM tutor_course 
JOIN private_lesson ON tutor_course.tutor_course_id = private_lesson.tutor_course_id
JOIN tutor_time_slot ON tutor_time_slot.tutor_time_slot_id = private_lesson.tutor_time_slot_id
JOIN course ON course.course_id = tutor_course.course_id
where tutor_course.user_id = '" . $user_id ."' ORDER BY tutor_time_slot.day";
	
$result = $connect->query($sql);

$emparray = array();

if ($result->num_rows > 0) {
  // output data of each row
  while($row = $result->fetch_assoc()) {
	  
    $sql = "SELECT * FROM user_attribute
	where user_id = '" . $row['student_id'] ."'";
	$result_user_student = $connect->query($sql);
	$row['student'] = [];
	$row_result_user_student = $result_user_student->fetch_assoc();
	array_push($row['student'], $row_result_user_student);
	
    $emparray[] = $row;
  }
} else {
  // echo "0 results";
}

$connect->close();

echo json_encode($emparray, JSON_INVALID_UTF8_IGNORE);
?>