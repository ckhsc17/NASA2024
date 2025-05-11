<?php
session_start();

if( !isset($_SESSION['login']) ){
	header("Location: index.php");
	exit();
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
        <h1>Under Construction....</h1>
        <p>You can come back after final and we will update our server from nginx 16.04 to nginx 18.04! :D</p>
	<img src="http://ws1.csie.ntu.edu.tw:51190/img/capoo.gif" alt="Under Construction" style="width: 50%; height: auto;">
	<?php
		if( isset($_SESSION['login']) && $_SESSION['login'] === true ){
			echo '<p>NASA{5ql_1nj3c710n_w17h_p455w0rd_cr4ck1n6}</p>';
		}
	?>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
