<?php

setcookie("nombre", "carlos", time() + 60 * 60*24*14);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <?php 
        if(isset($_COOKIE['nombre'])){
            $nombre = $_COOKIE['nombre'];
            echo "<p>Hola $nombre</p>";
        } else {
            echo "<p>Se ha definido la cookie <strong>'nombre'</strong> Recarga la pagina para que tenga efecto</p>";
        }
    ?>
</body>
</html>