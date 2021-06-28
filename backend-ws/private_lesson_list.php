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

$sql = "SELECT * FROM private_lesson 
join user on user.id=private_lesson.user_id
join tutor_course on tutor_course.tutor_course_id=private_lesson.tutor_course_id
join tutor_time_slot on tutor_time_slot.tutor_time_slot_id=private_lesson.tutor_time_slot_id
join course on course.course_id=tutor_course.course_id
where user.email = '" . $_GET['email'] ."' order by tutor_time_slot.day ASC";

$result = $connect->query($sql);

$emparray = array();
if ($result->num_rows > 0) {
  // output data of each row
  while($row = $result->fetch_assoc()) {
    $sql = "SELECT * FROM user_attribute
	where user_id = '" . $row['user_id'] ."'";
	$result_tutor_time_slot = $connect->query($sql);
	$row['tutor'] = [];
	while($row_tutor_time_slot = $result_tutor_time_slot->fetch_assoc()) {
		array_push($row['tutor'], $row_tutor_time_slot);
	};
    $emparray[] = $row;
  }
} else {
  // echo "0 results";
}
$connect->close();

echo json_encode($emparray, JSON_INVALID_UTF8_IGNORE);
?>