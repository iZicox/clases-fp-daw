<?php

/* ============================================================
   PRIMERO: PROCESAR COOKIES (ANTES DE CUALQUIER ECHO)
   ============================================================ */

// COOKIE 1 — Último usuario (7 días)
if(isset($_POST['nombre'])){
    setcookie("usuario", $_POST['nombre'], time()+60*60*24*7);
}

// COOKIE 2 — Última instalación reservada (7 días)
if(isset($_POST['instalacion'])){
    setcookie("ultimaInstalacion", $_POST['instalacion'], time()+60*60*24*7);
}

// COOKIE 3 — Contador de reservas (30 días)
if(isset($_POST['instalacion'])){ 
    if(!isset($_COOKIE['contadorReservas'])){
        setcookie("contadorReservas", 1, time()+60*60*24*30);
    } else {
        $nuevoValor = $_COOKIE['contadorReservas'] + 1;
        setcookie("contadorReservas", $nuevoValor, time()+60*60*24*30);
    }
}


/* ============================================================
   VARIABLES Y VALIDACIONES
   ============================================================ */

$paso;
$htmlSalida;
$costeIluminacion = 15;
$costeInstalacion;
$descuento = 0;

$normas = $_POST['normas'] ?? '';
$tipoDocumento = $_POST['tipoDocumento'] ?? '';
$instalacion = $_POST['instalacion'] ?? '';
$cantHoras = $_POST['cantHoras'] ?? '';

if( isset($normas) &&
    isset($tipoDocumento) &&
    isset($instalacion) &&
    ($cantHoras >= 1 && $cantHoras <= 3 )){

    $paso = 2;
} else {
    $paso = 1;
}


/* ============================================================
   MOSTRAR MENSAJES DE COOKIES (YA SE PUEDE HACER ECHO)
   ============================================================ */

if(isset($_COOKIE["usuario"])){
    echo "BIENVENIDO DE NUEVO " . $_COOKIE['usuario'] . "<br>";
}

if(isset($_COOKIE["ultimaInstalacion"])){
    echo "Tu última instalación reservada fue: " . $_COOKIE['ultimaInstalacion'] . "<br>";
}

if(isset($_COOKIE['contadorReservas'])){
    echo "Has realizado " . $_COOKIE['contadorReservas'] . " reservas.<br>";
}


/* ============================================================
   FORMULARIO (PASO 1)
   ============================================================ */

if($paso === 1){
    $htmlSalida = <<<EOT
<html>
    <head>
        <title></title>
    </head>
    <body>
        <form method="post">
        
            <fieldset>
                <legend>Datos del usuario</legend>
                <p>
                    <label>Nombre completo: </label>
                    <input type="text" name="nombre" required>
                </p>
                <p>
                    <label>Domicilio: </label>
                    <input type="text" name="domicilio" required>
                </p>
                <p>
                    <label>Tipo de documento: </label>
                    <select name="tipoDocumento" required>
                        <option selected>--Selecciona un documento--</option>
                        <option value="dni">DNI</option>
                        <option value="tarjeta">Tarjeta de residencia</option>
                        <option value="pasaporte">Pasaporte</option>
                    </select>
                </p>
                <p>
                    <label>Numero de documento: </label>
                    <input type="text" name="numeroDocumento" required>
                </p>
                <p>
                    <label>Sexo: </label>
                    <input type="radio" name="sexo" value="hombre" required>Hombre
                    <input type="radio" name="sexo" value="mujer" required>Mujer
                </p>
                <p>
                    <label>Telefono: </label>
                    <input type="number" max="999999999" name="telefono">
                </p>
                <p>
                    <label>Correo electronico: </label>
                    <input type="email" name="email">
                </p>
            </fieldset>
            
            <fieldset>
                <legend>Datos de reserva</legend>
                <p>
                    <label>Instalación a reservar: </label>
                    <select name="instalacion" required>
                        <option>--Selecciona una instalación--</option>
                        <option value="exterior">Futbol sala exterior</option>
                        <option value="cubierta">Futbol sala cubierta</option>
                        <option value="baloncesto">Baloncesto</option>
                        <option value="multiuso">Sala multiproposito</option>
                    </select>
                </p>
                <p>
                    <label>Fecha de reserva: </label>
                    <input type="date" name="fechaReserva" required>
                </p>
                <p>
                    <label>Hora inicio: </label>
                    <input type="time" name="horaReserva" required>
                </p>
                <p>
                    <label>Numero de horas: </label>
                    <input type="number" max="3" min="1" name="cantHoras">
                </p>
                <p>
                    <label>Contratación de iluminación: </label>
                    <input type="radio" name="iluminacion" value="T">Si
                    <input type="radio" name="iluminacion" value="F">No
                </p>
                <p>
                    <input type="checkbox" name="normas" value="aceptado" required>
                    <label>Acepta normas y condiciones del completo </label>
                </p>
            </fieldset>
        
            <p>
                <input type="submit" value="enviar">
                <input type="reset" value="borrar formulario">
            </p>
            
        </form>
    </body>
</html>
EOT;

    echo $htmlSalida;
}


/* ============================================================
   RESULTADO DE LA RESERVA (PASO 2)
   ============================================================ */

if($paso === 2){

    echo "<br>Nombre: " . $_POST['nombre'] . "<br>Telefono: " . $_POST['telefono'] . "<br>";
    echo "Instalacion: ";

    switch ($_POST['instalacion']){
        case 'exterior':
            echo "Futbol sala exterior<br>";
            $costeInstalacion = 12;
            break;
        case 'cubierta':
            echo "Futbol sala cubierta<br>";
            $costeInstalacion = 24;
            break;
        case 'baloncesto':
            echo "Baloncesto<br>";
            $costeInstalacion = 15;
            break;
        case 'multiuso':
            echo "Sala multiproposito<br>";
            $costeInstalacion = 20;
            break;
    }

    echo "Fecha: " . $_POST['fechaReserva'] . ". Hora inicio: " . $_POST['horaReserva'] . "<br>";
    echo "Cantidad horas: " . $_POST['cantHoras'] . "<br>";
    echo "Iluminacion: " . ($_POST['iluminacion'] === "T" ? "Si" : "No") . "<br>";

    $costeTotal = $costeInstalacion * $_POST['cantHoras'];

    if($_POST['iluminacion'] === "T"){
        $costeTotal += $costeIluminacion * $_POST['cantHoras'];
    }

    if($costeTotal > 50){
        $descuento = 0.15;
    }

    if($_POST['sexo'] === "mujer"){
        $descuento += 0.3;
    }

    $totalConDescuento = $costeTotal - ($costeTotal * $descuento);

    echo "Coste total es de: " . $totalConDescuento;
}

?>