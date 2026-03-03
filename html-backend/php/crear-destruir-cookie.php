<?php
	
		$mensaje = "";
		$duracion = $_POST['duracion'] ?? ''; 
		if(isset($_POST['duracion']) && ctype_digit($duracion)){
			
			$duracion = (int) $duracion;
			
			if($duracion > 0 && $duracion < 61){
				$expira = time() + $duracion;
				setcookie('duracion',$duracion,$expira);
				setcookie('duracionExpira',$expira,$expira);
				$mensaje = "Duracion de la cookie establecida en " . $duracion . " segundos";

			}else {
				$mensaje = "La duracion debe ser entre 1 y 60";
			}
		} else {
			$mensaje = "El valor debe ser un numero.";
		}
		
		
		$comprobar = $_POST['estado'] ?? '';
		if(isset($comprobar) && $comprobar === "comprobar"){
			if(isset($_COOKIE['duracionExpira'])){
				$tiempoRestante = $_COOKIE['duracionExpira'] - time();
				
				if($tiempoRestante > 0){
					$mensaje = "La cookie se destruira en $tiempoRestante segundos";
					
				} else {
					$mensaje = "La cookie ya ha expirado";
				
				}
			
			} else {
				$mensaje = "La cookie no existe";
			}
		
		}
		
		//Destruir
		if(isset($_POST['destruir'])){
			setcookie('duracion','',time()-3600);
			setcookie('duracionExpira','',time()-3600);
			
			$mensaje = "Cookie destruida";
		}
		
		
	
?>
	
<html>
<head></head>
<body>
	<p><?php echo $mensaje ?></p>
	Elige una opcion
	<ul>
	
		<li>
			
			<form method="post">
				Crea una cookie de una duración de 
				<input type="text" name="duracion" maxlength="2">
				segundos (entre 1 y 60 segundos)
				<input type="submit" value="crear">
			</form>
			
		</li>
		<li>
		
		<form method="post">
			Comprobar cookie
			<input type="submit" name="estado" value="comprobar">
		</form>
		
		</li>
		<li>
		
		<form method="post">
			Destruir cookie
			<input type="submit" name="destruir" value="destruir">
		</form>
		
		</li>
	
	</ul>
	
</body>
</html>