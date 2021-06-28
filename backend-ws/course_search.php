<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
define("DB_HOST", "31.11.39.54");
define("DB_USER", "Sql1558195");
define("DB_PASSWORD", "ab12pozt12Q!!");
define("DB_NAME", "Sql1558195_1");
try {
	$query = "";
	$arrayResults = array();
	if(isset($_GET['query'])) $query = $_GET['query'];
	else {
		$connect = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
		if (mysqli_connect_errno($connect)){
			die("Unable to connect to MySQL Database: " . mysqli_connect_error());
		}
		
		$query = htmlspecialchars($query); 
		// changes characters used in html to their equivalents, for example: < to &gt;
		// var_dump($query);
				
				
		// $sql = "SELECT * FROM course order by course_name";
		$sql = "SELECT course.*
		FROM user 
		left join user_attribute on user.id = user_attribute.user_id
		left join degree on user_attribute.degree_id = degree.degree_id
		left join degree_path on user_attribute.degree_path_id = degree_path.degree_path_id
		left join course_path_degree on user_attribute.degree_path_id = course_path_degree.degree_path_id 
			AND user_attribute.degree_id = course_path_degree.degree_id
		left join course on course_path_degree.course_id = course.course_id
		where email = '" . $_GET['email'] ."' order by course.course_name ASC";
		
		// var_dump($sql);
		$results = $connect->query($sql);
		if($results){
			if ($results->num_rows > 0) {
				while($row = $results->fetch_assoc()) {
				if($row['course_id']) $arrayResults[] = $row;
				  }
			}
		}
		$connect->close();
	}

	$min_length = 3;
	
	if(strlen($query) >= $min_length){ // if query length is more or equal minimum length then

		$connect = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
		if (mysqli_connect_errno($connect)){
			die("Unable to connect to MySQL Database: " . mysqli_connect_error());
		}
		
		$query = htmlspecialchars($query); 
		// changes characters used in html to their equivalents, for example: < to &gt;
		// var_dump($query);
				
		// $sql = "SELECT * FROM course WHERE (`course_name` LIKE '%".$query."%') order by course_name";
		$sql = "SELECT course.* FROM user 
			left join user_attribute on user.id = user_attribute.user_id
			left join degree on user_attribute.degree_id = degree.degree_id
			left join degree_path on user_attribute.degree_path_id = degree_path.degree_path_id
			left join course_path_degree on user_attribute.degree_path_id = course_path_degree.degree_path_id 
				AND user_attribute.degree_id = course_path_degree.degree_id
			left join course on course_path_degree.course_id = course.course_id
			where email = '" . $_GET['email'] ."' AND `course_name` LIKE '%".$query."%' order by course.course_name ASC";
		// var_dump($sql);
		$results = $connect->query($sql);
		if($results){
			if ($results->num_rows > 0) {
				while($row = $results->fetch_assoc()) {
					$arrayResults[] = $row;
				  }
			}
		}
		$connect->close();
					
	} else{ // if query length is less than minimum
		// echo json_encode($arrayResults, JSON_INVALID_UTF8_IGNORE);
		// echo "Minimum length is ".$min_length;
	}
	
	echo json_encode($arrayResults, JSON_INVALID_UTF8_IGNORE);
}  catch (Exception $e) {
	echo json_encode("Unable to connect to MySQL Database: " . $e->getMessage());
}
?>