<?php

$contador = isset($_POST['numero']) ? (int) $_POST['numero'] + 1 : 0;



function fibonacci($n) {
    $penultimo = 0;
    $ultimo = 1;

    if ($n == 0) return 0;
    if ($n == 1) return 1;

    for ($i = 2; $i <= $n; $i++) {
        $actual = $ultimo + $penultimo;
        $penultimo = $ultimo;
        $ultimo = $actual;
    }

    return $ultimo;
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=, initial-scale=1.0">
    <title>Document</title>
    <style>
        * {
            padding: 0;
            margin: 0;
            box-sizing: border-box;
            font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }

        body {
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap; 1rem;
        }

        h2 {
            font-size: 2rem;
        }

        p {
            font-size: 1.5rem;
        }

        form {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap: 1rem;
        }
    </style>
</head>
<body>
    <h2>Numeros fibonacci</h2>

    <p>Valor fibonacci: <?php echo fibonacci($contador) ?></p>

    <form action="" method="post">

        <input type="hidden" name="numero" value="<?php echo $contador ?>">
        
        <input type="submit" value="sigueinte">
            
        
    </form>

    <br>

    <a href="">Reiniciar contador</a>
</body>
</html>