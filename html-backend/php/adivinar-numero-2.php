<?php 
/*
Paso 1: Un usuario escribe un numero secreto
Paso 2: Otro usuario debe ingresar un numero y le debe devolver si acerto o no
en caso de que no halla acertado debe mostrar la diferencia con X de maximo
10 numeros de diferencia

*/

$paso = 0;
$htmlSalida = "";
$secreto = $_POST['secreto'] ?? '';
$jugador = $_POST['usuario'] ?? '';


if($secreto === ''){
	$paso = 1;
} elseif ($jugador === '') {
	$paso = 2;
	$secreto = ctype_digit($secreto) ?? (int)$secreto;
	$jugador = ctype_digit($jugador) ?? (int)$jugador;
} elseif(ctype_digit($secreto) == ctype_digit($jugador)){
	
	$secreto = (int)$secreto;
	$jugador = (int)$jugador;
	
	if($secreto === $jugador){
		$paso = 3;
	} else {
		$paso = 2;
	}
	
}

if($paso === 1){

?>
		<html>
			<head></head>
			<body>
				<form method="post">
					Ingresa un numero secreto: 
					<input type="text" name="secreto">
					<input type="submit">
				</form>
			</body>
		</html>

<?php

}

if($paso === 2){

?>
<html>
	<head></head>
	<body>
		<form method="post">
			Ingresa un numero: 
			<input type="text" name="usuario">
			<input type="hidden" name="secreto" value="<?php echo $_POST['secreto']; ?>">
			<input type="submit">
		</form>
		
<?php
	if($jugador != ''){
	
		$diferencia = abs($secreto - $jugador);
		echo "<p>Numero incorecto ";
	
		if($diferencia < 10){
			echo str_repeat('X',$diferencia);
		} else {
			echo str_repeat('X',10);
		}
		
		echo "</p>";
	}

?>
	</body>
</html>

<?php
}

if($paso == 3){

?>
<html>
	<head></head>
	<body>
	
		<h1>Numero acertado</h1>
	
	</body>
</html>

<?php
}