<?php
session_start();

$servername = "localhost";
$username = "nasa2024";
$password = "nasa2024";
$dbname = "nasa2024_db";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error){
	die("Connection failed: ".$conn->connect_error);
}

if( $_SERVER["REQUEST_METHOD"] == "POST" ){
	$user = $_POST["username"];
	$pass = $_POST["password"];

	if( empty($user) || empty($pass) ){
		$_SESSION["error"] = 1;
	} else {

		$sql = "SELECT id, username, password FROM users WHERE username = '$user'";
		$result = $conn->query($sql);
		if( $result->num_rows > 0 ){
			$row = $result->fetch_assoc();
			$id = $row['id'];
			$username = $row['username'];
			$hashed_password = $row['password'];
			if(password_verify($pass, $hashed_password)){
				$_SESSION['login'] = true;
				header('Location: home.php');
				exit();
			} else {
				$_SESSION["error"] = 3;
			}
		}
		else {
			$_SESSION["error"] = 2;
		}
	}

	$conn->close();
}

?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NASA 2024 Security Finals</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body class="bg-dark text-white">
    <div class="container" style="padding-top: 128px; display: flex; flex-direction: column; align-items: center;">
        <h1>NASA2024 Final Login System</h1>
        <br>
        <br>
        <form action="index.php" method="POST" style="width: 100%;">
            <div class="mb-3">
                <label for="username" class="form-label">Username</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <br>
            <button type="submit" class="btn btn-primary" style="width: 100%;">Login</button>
            <br>
            <br>
            <br>
            <br>
	    <?php
		if( isset($_SESSION['error']) ){
            		echo '<div class="alert alert-danger" role="alert">';
                	if( $_SESSION['error'] == 1 ){
				echo 'Please fill username and password before submit!';
			} else if ($_SESSION['error'] == 2 ){
				echo 'User not found!';
			} else if( $_SESSION['error'] == 3 ){
				echo 'Password Failed!';
			} else {
				echo 'A simple danger alert-check it out!';
            		}
			echo '</div>';
		}
	    ?>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
