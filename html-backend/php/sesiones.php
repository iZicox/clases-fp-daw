<?php 
    //se abre sesion
    session_start();
    //los valores a recuperar
    $nombre = $_SESSION['nombre'] = 'Pepito';
    $edad = $_SESSION['edad'] = 89;

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <p>Se ha definido los siguientes valores de sesion</p>
    <ul>
        <li>
            Nombre: <?php echo $nombre ?> 
        </li>
        <li>
            Edad: <?php echo $edad ?> 
        </li>
    </ul>
</body>
</html>