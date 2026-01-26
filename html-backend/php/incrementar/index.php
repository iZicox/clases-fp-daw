<?php

$entrada = $_POST["valor"]+1;





?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <form action="index2.php" method="post">
        <label for="">Incrementar: </label>
        <input type="number" value="<?= $entrada ?>" name="valor"></input>
        <input type="submit" value="enviar">
    </form>
     
</body>
</html>