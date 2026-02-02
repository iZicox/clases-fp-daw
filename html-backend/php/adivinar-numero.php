<?php

$secreto = isset($_POST['secreto']) ? $_POST['secreto'] : "";
$num_jugador = isset($_POST['num_jugador']) ? $_POST['num_jugador'] : "";

$htmlSalida = "";
$paso;

if(empty($num_jugador) && empty($secreto)){
    $paso = 1;
} else {
    $paso = 2;
}



if($paso == 1){
    //primer numero a adivinar
    $htmlSalida = <<<EOT
    <form action="" method="post">
        <label for="">Ingresa un numero secreto: </label>
        <input type="number" name="secreto">
        <input type="submit">
    </form>
    EOT;
    echo $htmlSalida;
}

if($paso == 2){
    //ingresar un numero del usuario para comprobar si es el correcto
    $htmlSalida = <<<EOT
    <form action="" method="post">
        <label for="">Ingresa un numero: </label>
        <input type="hidden" name="secreto" value="$secreto">
        <input type="number" name="num_jugador">
    </form>
    EOT;
    echo $htmlSalida;
    if($secreto == $num_jugador) {
    echo "adivinado";
}
}





?>

