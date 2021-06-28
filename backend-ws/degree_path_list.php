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

if(isset($_GET['degree_id'])) {
    $sql = $sql = "SELECT * FROM degree_path join degree on degree.degree_id = degree_path.degree_id
	where degree.degree_id =". $_GET['degree_id'];
} else {
	$sql = "SELECT * FROM degree_path join degree on degree.degree_id = degree_path.degree_id";
}

$result = $connect->query($sql);

$emparray = array();
if ($result->num_rows > 0) {
  // output data of each row
  while($row = $result->fetch_assoc()) {
    $emparray[] = $row;
  }
} else {
  // echo "0 results";
}
$connect->close();

echo json_encode($emparray, JSON_INVALID_UTF8_IGNORE);
?>