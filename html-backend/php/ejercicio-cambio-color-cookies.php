<?php

	$paso;
	$color = $_POST['color'] ?? $_COOKIE['color'] ?? '';
	$revision = $_POST['revision'] ?? '';
	
	if(isset($_POST['color'])){
		setcookie('color',$color,time()+60*60*24*30);
	}
	
	
	if(empty($revision)){
		$paso = 1;
	} else {
		$paso = 2;
	}

	
	
	if($paso === 1){
		
?>

<html>
	<head>
	</head>
	<body>
		<h1>Seleccion de colores</h1>
		<p>Se ha elegido el color <?php echo $color; ?></p>
		<p>Cambio de color: </p>
		<form method='post'>
			<input type="submit" name="color" value="red">
			<input type="submit" name="color" value="blue">
			<input type="submit" name="color" value="yellow">
			<input type="submit" name="color" value="none">
			<br><br><br>
			<input type="submit" name="revision" value="revisarColor">
		</form>
	</body>
</html>

<?php 
	}
	
	if($paso === 2){
	
?>

<html>
	<head>
	</head>
	<style>
		* {color: <?php echo $color ?>;}
	</style>
	<body>
<?php
	switch($color){
		case 'red':
			echo 'El color seleccionado fue rojo';
			break;
		case 'blue':
			echo 'El color seleccionado fue azul';
			break;
		case 'yellow':
			echo 'El color seleccionado fue amarillo';
			break;
		case 'none':
			echo 'El color seleccionado fue ninguno';
			break;
		default:
			echo 'No haz seleccionado nada';
			break;
	}
?>

	<form method="post">
		<input type="submit" value="Volver al Paso 1" style="color: black;">
	</form>
	</body>
</html>

<?php 

}