<?php
session_start();



$centro = 300;
$nuevaPosicion;

if(isset($_POST['resetear'])){
	session_destroy();
}

if(isset($_POST['movimiento'])){
	if($_POST['movimiento'] === 'IZQ'){
		
		if(isset($_SESSION['nuevaPosicion'])){
			$nuevaPosicion = $_SESSION['nuevaPosicion'] - 10;	
		} else {
			$nuevaPosicion = $centro - 10;
		}
		
		$_SESSION['nuevaPosicion'] = $nuevaPosicion;
	
	} elseif ($_POST['movimiento'] === 'DER'){
	
		if(isset($_SESSION['nuevaPosicion'])){
			$nuevaPosicion = $_SESSION['nuevaPosicion'] + 10;	
		} else {
			$nuevaPosicion = $centro + 10;
		}
		
		$_SESSION['nuevaPosicion'] = $nuevaPosicion;
	}
} else {
	$nuevaPosicion = $centro;
}




?>


<html>
	<head>
		<style>
			.linea {
				background-color: black;
				height: 5px;
				width: 600px;
			}
			
			.punto {
				border-radius: 10px;
				width: 30px;
				height: 30px;
				background-color: red;
				margin-left: <?php echo $nuevaPosicion ?>px; //el que se modifica
			}
		</style>
	</head>
	<body>
		<h1>Mover punto de izquierda a derecha.</h1>
		<p>Haz clic en alguno de los botones.</p>
		<form method="post">
			<input type="submit" name="movimiento" value="IZQ">
			<input type="submit" name="movimiento" value="DER">
		</form>
		
		<div class="linea"><div class="punto"></div></div>
		<br><br>
		
		<form method="post">
			<input type="submit" name="resetear" value="resetear">
		</form>
	</body>
</html>