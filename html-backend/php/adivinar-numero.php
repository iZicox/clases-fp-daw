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
        <input type="submit">
        <input type="reset">
    </form>
    EOT;
    echo $htmlSalida;

    if(!empty($num_jugador)){
        if($secreto < $num_jugador){
            echo "El numero es menor";

        }
    
        if($secreto > $num_jugador){
            echo "El numero es mayor";
        }
    
        if($secreto == $num_jugador) {
        echo "adivinado";

        } else {
            $proximidad = abs($secreto - $num_jugador);
            echo "<br>";
            if($proximidad < 10){
                echo str_repeat("*", $proximidad) . "<br>";
            }else{
                echo str_repeat("*", 10) . "<br>";
            }
        }
    }
}





?>

