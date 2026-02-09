<?php 

    $reseteo = $_POST['reset'] ?? "";
    $valor = $_COOKIE['visitas'] ?? "";
    $contador;

    if(isset($_COOKIE['contador']) == false){
        $contador = 1;
    } else {
        $contador = $_COOKIE['contador'];
        $contador++;
    }

    if($reseteo == "reseteo"){
        $contador = 0;
        setcookie("visitas","",time()+60*60*24*30);
        header("Location: contar-visitas.php");
    }

    setcookie('contador',$contador,time()+60*60*24*60);
    $mensaje = "<p>Numero de visitas: <b>$contador</b></p>";
    echo $mensaje;
?>


    <form method="post">
        
        
        <input type="submit" name="reset" value="reseteo">
    </form>
    

