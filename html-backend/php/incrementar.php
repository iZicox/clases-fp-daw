<?php

$contador = isset($_POST['numero']) ? (int) $_POST['numero'] + 1 : 0;

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
    <h2>Contador automatico</h2>

    <p>El valor actual es: <?php echo $contador ?></p>

    <form action="" method="post">

        <input type="hidden" name="numero" value="<?php echo $contador ?>">
        
        <input type="submit">
            
        
    </form>

    <br>

    <a href="">Reiniciar contador</a>
</body>
</html>