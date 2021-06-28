<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

define("DB_HOST", "31.11.39.54");
define("DB_USER", "Sql1558195");
define("DB_PASSWORD", "ab12pozt12Q!!");
define("DB_NAME", "Sql1558195_1");
	
try {
	$arrayResults = array();
	$degree_name = $_GET['degree_name'];
	$degree_type_note = $_GET['degree_type_note'];
	$connect = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
	if (mysqli_connect_errno($connect)){
		die("Unable to connect to MySQL Database: " . mysqli_connect_error());
	}
				
	$sql = "SELECT degree_path.degree_path_name FROM degree_path 
	LEFT JOIN degree ON degree.degree_id = degree_path.degree_id
	LEFT JOIN degree_type ON degree.degree_type_id = degree_type.degree_type_id
	WHERE degree.degree_name = '" . $degree_name ."'
	AND degree_type.degree_type_note = '" . $degree_type_note ."'
	ORDER BY degree_path.degree_path_name;";
	// print($sql);
	
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
	echo json_encode($arrayResults, JSON_INVALID_UTF8_IGNORE);
}  catch (Exception $e) {
	echo json_encode("Unable to connect to MySQL Database: " . $e->getMessage());
}
?>