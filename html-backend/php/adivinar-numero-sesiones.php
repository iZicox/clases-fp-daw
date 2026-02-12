<?php

session_start();

$secreto;
$numUsuario;
$htmlSalida;
$paso;

//si hay un post guardarlo en la sesion de secreto
if(isset($_POST['secreto'])){
    $_SESSION['secreto'] = $_POST['secreto'];
}

//si hay un post guardarlo en la sesion de numero usuario
if(isset($_POST['numUsuario'])){
    $_SESSION['numUsuario'] = $_POST['numUsuario'];
}



//validar numero secreto
if(isset($_SESSION['secreto'])){
    $secreto = $_SESSION['secreto'];
} else {
    $secreto = null;
}

//validar numero usuario
if(isset($_SESSION['numUsuario'])){
    $numUsuario = $_SESSION['numUsuario'];
} else {
    $numUsuario = null;
}

//dando el valor al paso
if (!isset($_SESSION['secreto']) || $_SESSION['secreto'] === "") {
    $paso = 1;
} else {
    $paso = 2;
}


if ($paso === 1) {
    $htmlSalida = <<<EOF
<form method="post">
    <label for="">Numero secreto: </label>
    <input type="number" min="1" name="secreto">
    <input type="submit">
</form>
EOF;

echo $htmlSalida;
}

    
if($paso === 2){
    $htmlSalida = <<<EOF
    <form method="post">
        <label for="">Numero usuario: </label>
        <input type="number" min="1" name="numUsuario" placeholder="0">
        <input type="submit">
    </form>
    EOF;
    echo $htmlSalida;

    if(isset($_SESSION['numUsuario'])){
        $proximidad = abs($secreto - $numUsuario);
        $resultado = $secreto === $numUsuario ? "Acertado!!!" : "Veuvle a intentar.";
        echo $resultado . "<br>";
        if(($proximidad != 0 && $proximidad < 10)){
            echo str_repeat(" X ",$proximidad);
        }
        
        if($proximidad > 10){
            echo str_repeat(" X ",10);
        }

      

    }
}

?>
