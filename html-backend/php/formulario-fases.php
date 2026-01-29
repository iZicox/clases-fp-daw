<?php

$nombre = isset($_POST['nombre']) ? $_POST['nombre'] : "";
$fecha = isset($_POST['fecha']) ? $_POST['fecha'] : "";
$usuario = isset($_POST['usuario']) ? $_POST['usuario'] : "";
$password = isset($_POST['password']) ? $_POST['password'] : "";

$htmlSalida = "";

if(empty($nombre) && empty($usuario)){
    $paso = 1;
} elseif (!empty($nombre) && empty($usuario)){
    $paso = 2;
} else {
    $paso = 3;
}



if($paso == 1){
    $htmlSalida = <<<EOT
    <form action="" method="post">
        <label for="nombre">Nombre: </label>
        <input type="text" name="nombre">
        <br>
    
        <label for="fecha">Fecha: </label>
        <input type="date" name="fecha" id="fecha">
        <br>
    
        <input type="submit" value="Siguiente">
    </form>
    
EOT;
} elseif ($paso == 2) {
    $htmlSalida = <<<EOT
    <form action="" method="post">
    <label for="">Usuario: </label>
    <input type="text" name="usuario" value="">
    <br>

    <label for="">Contraseña: </label>
    <input type="password" name="password" value="">
    <br>

    <input type="submit" value="Siguiente">
</form>
EOT;
} else {
    $htmlSalida = <<<EOT
    <ul>
    <li>Nombre: {$nombre}</li>
    <li>Fecha: {$fecha}</li>
    <li>Usuario: {$usuario}</li>
    <li>Contraseña: {$password}</li>
    </ul>
EOT;
}

$inicio = <<<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
EOF;

$fin = <<<EOF
</body>
</html>
EOF;


echo $inicio . $htmlSalida . $fin;
?>
