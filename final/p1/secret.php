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
        <h1>NASA2024 Final Secret Panel</h1>
        <p>Welcome to Secret Panel...</p>
        <p>Please enter the ip that you want to test</p>
        <br>
        <form action="/v3ry53cr37p4n3lNaSa2024" method="post" style="width: 100%;">
            <div class="mb-3">
                <label for="ip" class="form-label">IP address</label>
                <input type="text" class="form-control" id="ip" name="ip" required>
            </div>
            <br>
            <button type="submit" class="btn btn-primary" style="width: 100%;">Execute</button>
            <br>
		<br>
            <?php
                if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['ip'])) {
                    $ip = $_POST['ip'];
		    $command = "ping -c 4 $ip";
                    $output = shell_exec($command);
			echo '<div class="alert alert-success" role="alert">';
			echo 'Good.. You should see the magic happend in terminal :D';
			echo '</div>';
		}
            ?>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
