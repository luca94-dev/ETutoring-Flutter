<?php
$servername = "31.11.39.54";
$username = "Sql1558195";
$password = "ab12pozt12Q!!";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully";
?>