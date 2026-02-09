<?php 
    //leer post si existe
    $opcion = $_POST['color'] ?? "";
    $color;
    $nombre = "color";
    
    //leer cookie si existe
    if(empty($opcion) && isset($_COOKIE['$nombre'])){
        $opcion = $_COOKIE[$nombre];
        }
        
        
    //leer si viene de post
    if(!empty($_POST[$nombre])){
        setcookie($nombre,$opcion,time() + 60 * 60*24*14);
    }
    
    switch ($opcion) {
        case "B":
            $color = "white";
            break;
        case "R":
            $color = "red";
            break;
        case "A":
            $color = "blue";
            break;
    }

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        div {
            display: block;
        }

        body {
            background-color: <?= $color ?>;
            
        }
    </style>
</head>
<body>
    <form action="" method="post">
        <label for=""><p>Selecciona un color de fondo:</p></label>

        <div>
            <input type="radio" name="color" value="B"> Blanco
            <input type="radio" name="color" value="R"> Rojo
            <input type="radio" name="color" value="A"> Azul
        </div>

        <input type="submit" value="seleccionar">

    </form>
</body>
</html>