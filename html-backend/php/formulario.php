<?php 

$nombre = isset($_POST['nombre']) ? $_POST['nombre'] : "";
$fecha = isset($_POST['fecha']) ? $_POST['fecha'] : "";
$intereses = isset($_POST['intereses']) ? $_POST['intereses'] : Array();

echo $nombre . "<br>";
echo $fecha . "<br>";

foreach($intereses as $item){
    echo $item . "<br>";
}
?>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <form action="" method="post">
        <label for="nombre">Nombre: </label>
        <input type="text" name="nombre">
        <br>

        <label for="fecha">Fecha nacimiento: </label>
        <input type="date" name="fecha" id="fecha">
        <br>

        <label for=""></label>
        <input type="checkbox" value="teatro" name="intereses[]"> Teatro
        <input type="checkbox" value="cine" name="intereses[]"> Cine
        <br>

        <input type="checkbox" value="musica" name="intereses[]"> Musica
        <input type="checkbox" value="deporte" name="intereses[]"> Deporte
        <br>

        <input type="submit" value="Enviar">
        <input type="reset" value="borrar"> 
    </form>
</body>
</html>

