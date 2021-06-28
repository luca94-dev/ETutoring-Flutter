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

if(isset($_GET['id'])) {
    $sql = "SELECT * FROM user left join user_attribute on user.id = user_attribute.user_id 
left join role on user_attribute.role_id = role.role_id
left join degree on user_attribute.degree_id = degree.degree_id
left join degree_path on user_attribute.degree_path_id = degree_path.degree_path_id
left join degree_type on degree.degree_type_id = degree_type.degree_type_id
where id = " . $_GET['id'];
} else {
			if(isset($_GET['email'])) {
				$sql = "SELECT * FROM user left join user_attribute on user.id = user_attribute.user_id 
		left join role on user_attribute.role_id = role.role_id
		left join degree on user_attribute.degree_id = degree.degree_id
		left join degree_path on user_attribute.degree_path_id = degree_path.degree_path_id
		left join degree_type on degree.degree_type_id = degree_type.degree_type_id
		where email = '" . $_GET['email'] ."'";
	} else {
			$sql = "SELECT * FROM user left join user_attribute on user.id = user_attribute.user_id 
		left join role on user_attribute.role_id = role.role_id
		left join degree on user_attribute.degree_id = degree.degree_id
		left join degree_path on user_attribute.degree_path_id = degree_path.degree_path_id
		left join degree_type on degree.degree_type_id = degree_type.degree_type_id";
}
}
$result = $connect->query($sql);

$emparray = array();
if ($result->num_rows > 0) {
  if($result->num_rows == 1) {
	  $emparray = $row = $result->fetch_assoc();
	  $role_id = $row['role_id'];
	  // print($role_id);
	  if($role_id == 2) {
		  
		  $sql = "SELECT * FROM tutor_time_slot where user_id = '" . $row['id'] ."'";
			$result_tutor_time_slot = $connect->query($sql);
			$row['time_slot'] = [];
			while($row_tutor_time_slot = $result_tutor_time_slot->fetch_assoc()) {
				array_push($row['time_slot'], $row_tutor_time_slot);
			}
			
			$sql = "SELECT * FROM tutor_course  
				left join course on tutor_course.course_id = course.course_id 
				where user_id = '" . $row['id'] ."'";
			$result_courses = $connect->query($sql);
			$row['courses'] = [];
			while($row_courses = $result_courses->fetch_assoc()) {
				array_push($row['courses'], $row_courses);
			}
			
			$sql = "SELECT * FROM review where user_tutor_id = '" . $row['id'] ."'";
			$result_reviews = $connect->query($sql);
			$row['reviews'] = [];
			while($row_reviews = $result_reviews->fetch_assoc()) {
				array_push($row['reviews'], $row_reviews);
			}
			
			$sql = "SELECT AVG(review_star) as avg FROM review where user_tutor_id = '" . $row['id'] ."'";
			$result_avg = $connect->query($sql);
			if($result_avg) {
				$avg = $result_avg->fetch_assoc()['avg'];
				if($avg) $row['avg_reviews'] = doubleval($avg);
				else $row['avg_reviews'] = -1;
			}
			
			$emparray = $row;
	  }
  }
  // output data of each row
  else {
	  while($row = $result->fetch_assoc()) {
		$emparray[] = $row;
		$role_id = $row['role_id'];
		// print($role_id);
		if($role_id == 2) {
			$row['time_slot'] = [];
			while($row = $result->fetch_assoc()) {
			  
				$sql = "SELECT * FROM tutor_time_slot where user_id = '" . $row['id'] ."'";
				$result_tutor_time_slot = $connect->query($sql);
				$row['time_slot'] = [];
				while($row_tutor_time_slot = $result_tutor_time_slot->fetch_assoc()) {
					array_push($row['time_slot'], $row_tutor_time_slot);
				}
			
				$sql = "SELECT * FROM tutor_course  
					left join course on tutor_course.course_id = course.course_id 
					where user_id = '" . $row['id'] ."'";
				$result_courses = $connect->query($sql);
				$row['courses'] = [];
				while($row_courses = $result_courses->fetch_assoc()) {
					array_push($row['courses'], $row_courses);
				}
				
				$sql = "SELECT * FROM review where user_tutor_id = '" . $row['id'] ."'";
				$result_reviews = $connect->query($sql);
				$row['reviews'] = [];
				while($row_reviews = $result_reviews->fetch_assoc()) {
					array_push($row['reviews'], $row_reviews);
				}
				
				$sql = "SELECT AVG(review_star) as avg FROM review where user_tutor_id = '" . $row['id'] ."'";
				$result_avg = $connect->query($sql);
				if($result_avg) {
					$avg = $result_avg->fetch_assoc()['avg'];
					if($avg) $row['avg_reviews'] = doubleval($avg);
					else $row['avg_reviews'] = -1;
				}
			
			$emparray[] = $row;
			}
		}
	}
  }
} else { 
	// no results
}
$connect->close();

echo json_encode($emparray, JSON_INVALID_UTF8_IGNORE);


?>