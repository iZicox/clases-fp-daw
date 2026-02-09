<?php

$paso;
$htmlSalida;

//reseteo cookies
$reset = $_POST['reset'] ?? "";
if(!empty($reset)){
    setcookie('nombre', '', time() - 3600);
    setcookie('sexo', '', time() - 3600);
    setcookie('usuario', '', time() - 3600);
    setcookie('password', '', time() - 3600);
    $nombre = "";
    $sexo =  "";
    $usuario =  "";
    $password = "";

    header("Location: pasos-cookie.php");

}

//revisar cookies
$nombre = $_COOKIE['nombre'] ?? "";
$sexo = $_COOKIE['sexo'] ?? "";
$usuario = $_COOKIE['usuario'] ?? "";
$password = $_COOKIE['password'] ?? "";

//leer si existe post y actualizar variables y cookies
if(!empty($_POST['nombre'])){
    $nombre = $_POST['nombre'];
    setcookie('nombre',$nombre, time()+86400);
}

if(!empty($_POST['sexo'])){
    $sexo = $_POST['sexo'];
    setcookie('sexo',$sexo, time()+86400);
}

if(!empty($_POST['usuario'])){
    $usuario = $_POST['usuario'];
    setcookie('usuario',$usuario, time()+86400);
}

if(!empty($_POST['password'])){
    $password = $_POST['password'];
    setcookie('password',$password, time()+86400);
}


//verificar pasos
if(
    (empty($nombre) || empty($sexo))
        && (empty($usuario) || empty($password))){
    $paso = 1;
} elseif(
    !(empty($nombre) && empty($sexo))
        && (empty($usuario) || empty($password))){
    $paso = 2;
} else {
    $paso = 3;
}


switch($paso){
    case 1:
        $htmlSalida = <<<EOT
            <form action="" method="post">
                <fieldset>
                    <legend>

                        <label for="">Ingresa un nombre: </label>
                    </legend>
                    <input type="text" name="nombre">
                </fieldset>
                <fieldset>
                    <legend>
                        <label for="">Sexo: </label>
                    </legend>
                    <input type="radio" name="sexo" value="M"> Masculino
                    <input type="radio" name="sexo" value="F"> Femenino
                </fieldset>
                <input type="submit" value="siguiente">
            </form>
        EOT;
        echo $htmlSalida;
        break;
    case 2:
        $htmlSalida = <<<EOT
        <form action="" method="post">
            <fieldset>
                <label for="">Usuario: </label>
                <input type="text" name="usuario">
            </fieldset>
            <fieldset>
                <label for="">Contraseña: </label>
                <input type="password" name="password" id="">
            </fieldset>
        
            <input type="submit" value="siguiente">
        </form>

        EOT;
        echo $htmlSalida;
        break;
    case 3:
        $htmlSalida = <<<EOT
        <div>
            <p>Nombre: $nombre </p>
            <p>Sexo: $sexo</p>
            <p>Usuario: $usuario</p>
            <p>Contraseña: $password</p>
        </div>
        <form method="post">
            <input type="hidden" name="reset" value="1">
            <input type="submit" value="finalizar">
        </form>
        EOT;
        echo $htmlSalida;
        break;
}

?>

