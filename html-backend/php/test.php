<?php

// 1️⃣ Crear variables vacías
$errores = [];

if(isset($_POST["enviar"])){

    // 2️⃣ Guardar datos del formulario
    $nombre = $_POST["nombre"];
    $edad = $_POST["edad"];
    $ciudad = $_POST["ciudad"];

    // 3️⃣ Validaciones simples
    if($nombre == ""){
        $errores[] = "El nombre es obligatorio";
    }

    if($edad == ""){
        $errores[] = "La edad es obligatoria";
    }

    if($ciudad == ""){
        $errores[] = "La ciudad es obligatoria";
    }

    // 4️⃣ Si no hay errores
    if(empty($errores)){

        // 5️⃣ Guardamos todo en un array
        $persona = [
            "nombre" => $nombre,
            "edad" => $edad,
            "ciudad" => $ciudad
        ];

        echo "<h3>Datos guardados correctamente</h3>";

        echo "<pre>";
        print_r($persona);
        echo "</pre>";

        exit;
    }
}

?>

<!DOCTYPE html>
<html>
<head>
    <title>Formulario Simple</title>
</head>
<body>

<h2>Registro de Persona</h2>

<?php
// Mostrar errores si existen
if(!empty($errores)){
    foreach($errores as $error){
        echo "<p style='color:red;'>$error</p>";
    }
}
?>

<form method="post">

    Nombre:<br>
    <input type="text" name="nombre">
    <br><br>

    Edad:<br>
    <input type="number" name="edad">
    <br><br>

    Ciudad:<br>
    <input type="text" name="ciudad">
    <br><br>

    <input type="submit" name="enviar" value="Guardar">

</form>

</body>
</html>