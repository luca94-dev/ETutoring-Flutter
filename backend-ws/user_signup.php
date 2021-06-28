<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

define("DB_HOST", "31.11.39.54");
define("DB_USER", "Sql1558195");
define("DB_PASSWORD", "ab12pozt12Q!!");
define("DB_NAME", "Sql1558195_1");
	
sleep(2);

try {
	/*$degree_id = 0;
	$degree_path_id = 0;
	$role_id = 0;*/
	
	$connect = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
	if (mysqli_connect_errno($connect)){
		die("Unable to connect to MySQL Database: " . mysqli_connect_error());
	}

	// Getting the received JSON into $json variable.
	$json = file_get_contents('php://input');
	 
	// Decoding the received JSON and store into $obj variable.
	$obj = json_decode($json,true);


	$email = $obj['email'];
	$password = $obj['password'];
	$hashed_password = md5($password);
	$degree_name = $obj['degree_name'];
	$degree_type = $obj['degree_type'];
	$curriculum = $obj['curriculum'];
	$role = $obj['role'];
	
	if($email && $password){
		//Verify if User email exist.
		$query = "select * from user where email = '$email'";

		// Executing SQL Query.
		$check = mysqli_fetch_array(mysqli_query($connect,$query));
		if(isset($check)){
			// user already exist
			
			// Successfully Login Message.
			 $onSignInFailed = 'The user already exists. Registration failed';
			 
			 // Converting the message into JSON format.
			 $failedMSG = json_encode($onSignInFailed, JSON_INVALID_UTF8_IGNORE);
			 
			 // Echo the message.
			 echo $failedMSG; 
		 
		 }
		 
		 else{ // ok -> insert to db table: user, user_attribute 

			$sql = "INSERT INTO user (password, email) VALUES ('$hashed_password', '$email')";
			
			if($connect->query($sql)){
				
				// get degree type id
				$sqlDegreeType = "SELECT degree_type_id FROM `degree_type` WHERE degree_type_note = '" . $degree_type ."'";
				$result = $connect->query($sqlDegreeType);
				$row = $result->fetch_assoc();
				$degree_type_id = $row['degree_type_id'];
				
				// get degree id
				$sqlDegree = "SELECT degree_id FROM `degree` WHERE degree_name = '" . $degree_name ."' AND degree_type_id = '" . $degree_type_id ."'";
				$result = $connect->query($sqlDegree);
				$row = $result->fetch_assoc();
				$degree_id = $row['degree_id'];
				
				// get curriculum path id
				$sqlCurriculum = "SELECT degree_path_id FROM `degree_path` WHERE degree_path_name = '" . $curriculum ."'";
				$result = $connect->query($sqlCurriculum);
				$row = $result->fetch_assoc();
				$degree_path_id = $row['degree_path_id'];
				
				// get role id
				$sqlRole = "SELECT role_id FROM `role` WHERE role_name = '" . $role ."'";
				$result = $connect->query($sqlRole);
				$row = $result->fetch_assoc();
				$role_id = $row['role_id'];
				
				
				$sql = "INSERT INTO user_attribute (degree_id, degree_path_id, role_id, user_id) VALUES ($degree_id, $degree_path_id, $role_id, $last_id)";
				
				if($connect->query($sql)){
					
					$msg = 'New record created successfully';
				 
					// Converting the message into JSON format.
					$jsonMsg = json_encode($msg, JSON_INVALID_UTF8_IGNORE);
				 
					// Echo the message.
					echo $jsonMsg; 
					
				} else { // delete last_id

					$sql = "DELETE FROM MyGuests WHERE id=$last_id";
					$connect->query($sql);
					$InvalidMSG = 'Error: please Try Again' ;
					$InvalidMSGJSon = json_encode($InvalidMSG, JSON_INVALID_UTF8_IGNORE);
					echo $InvalidMSGJSon;
				}
			} else {
				echo json_encode('Error');
			}
		 
		 }
	}
	mysqli_close($connect);
} catch (Exception $e) {
	echo json_encode("Unable to connect to MySQL Database: " . $e->getMessage());
}
?>