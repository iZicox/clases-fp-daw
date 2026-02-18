<?php 
    session_start();

    $operacion;
    $valor;
    $anterior = $_SESSION['anterior'] ?? 0;

    if(!isset($_POST['valor'])){
        //si post no existe se revisa la session
        $valor = $_SESSION['valor'] ?? 0;
    } else {
        //si post existe se le da ese valor a la variable y a la session
        $valor = $_POST['valor'];
        $_SESSION['valor'] = $_POST['valor'];
    }
            
    if(!isset($_POST['operacion'])){
        //si post no existe se revisa la session
        $operacion = $_SESSION['operacion'] ?? null;
    } else {
        //si post existe se le da ese valor a la variable y a la session
        $operacion = $_POST['operacion'];
        $_SESSION['operacion'] = $_POST['operacion'];
    }
    
    if($operacion == "+"){
        $valor += $anterior;
    }

    if($operacion == "-"){
        $valor -= $anterior;
    }


    $_SESSION['anterior'] = $valor;




?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <!--
    <style>
        * {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        main {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #faf;
        }

        form > :first-child {
            
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: textfield;
            border: none;
            outline: none;
            box-shadow: none;
            font-size: 3rem;
            width: 15rem;
            text-align: center;
        }
    </style>
-->
</head>
<body>
    <main>
        <h1><?php echo $valor ?></h1>
        <form action="" method="post">
            <input type="number" name="valor">
            <div>
                <input type="submit" name="operacion" value="+">
                <input type="submit" name="operacion" value="-">
            </div>
        </form>
    </main>
</body>
</html>
