<?php 

    $reseteo = $_POST['reset'] ?? "";
    $valor = $_COOKIE['visitas'] ?? "";

    if(!empty($_POST['visitas'])){
        $valor = $_POST['visitas'] + 1;
        setcookie("visitas",$valor,time()+60*60*24*30);
    } else {
        $valor = 1;
    }

    if($reseteo == "reseteo"){
        $valor = 1;
        setcookie("visitas",$valor,time()+60*60*24*30);
        header("Location: contar-visitas.php");
    }
    
?>
<p>Numero de visitar <?php echo $valor ?></p>
<form method="post">
    <input type="hidden" name="visitas" value="<?php echo $valor ?>">
    <input type="submit">
    <input type="submit" name="reset" value="reseteo">
</form>
