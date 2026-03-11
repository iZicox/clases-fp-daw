<?php
    if ($_REQUEST){
		// tengo parametros
        
		if (
            isset($_REQUEST["r"]) && 
            isset($_REQUEST["g"]) && 
            isset($_REQUEST["b"])){
			// analizo q=valor
            echo sprintf("#%02x%02x%02x", $_REQUEST["r"], $_REQUEST["g"], $_REQUEST["b"]);

			
		}
		exit;	
	}
?>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" xml:lang="es">
	<head>
		<script>
			function ajax1(str){
				var xmlhttp; // objeto de comunicaciones
				if (str.length==0){ 
					document.getElementById("colorHint").innerHTML=""; // vaciamos la caja
					return;
				}	
				xmlhttp=new XMLHttpRequest();
				xmlhttp.onreadystatechange=function(){ // declaracion callback
					if (xmlhttp.readyState==4 && xmlhttp.status==200){
							// respuesta de php no es la pagina completa, solo texto
							document.getElementById("colorHint").innerHTML=xmlhttp.responseText;
					}
				}
				// envio de la peticion al servidor
				xmlhttp.open("GET","hola.php?"+str,true);
				/*
					method: the type of request: GET or POST
					url: the server (file) location
					async: true (asynchronous) or false (synchronous)
				*/
				xmlhttp.send();
			}	
			function varios(){
                let cadena =    "r=" + document.getElementById('color1').value + "&" +
                                "g=" + document.getElementById('color2').value + "&" +
                                "b=" + document.getElementById('color3').value;
    
                console.log(this.value);     // Valor del slider actual
                ajax1(cadena);              // Enviar cadena completa
				//showHint(pulsado,true);
			}
			function iniciar(){
                document.getElementById('color1').onmouseup = varios;
                document.getElementById('color2').onmouseup = varios;
                document.getElementById('color3').onmouseup = varios;

				document.getElementById('color1').onchange = () => {
					let valor = document.getElementById('color1').value;
					document.querySelector('body .container.rojo').style.background = `rgb(${valor},0,0)`;
					colorResultado();
				}

				document.getElementById('color2').onchange = () => {
					let valor = document.getElementById('color2').value;
					document.querySelector('body .container.verde').style.background = `rgb(0,${valor},0)`;
					colorResultado();
				}

				document.getElementById('color3').onchange = () => {
					let valor = document.getElementById('color3').value;
					document.querySelector('body .container.azul').style.background = `rgb(0,0,${valor})`;
					colorResultado();
				}

				function colorResultado (){
					let color = document.getElementById('colorHint').innerText;
					document.getElementById('resultado').style.background = color;
				}

			}

			window.onload=iniciar;
		</script>
		<style>
			.container {
				width: 10rem;
				height: 10rem;
				border: 1px solid;
			}

			body > div {
				float: left;
			}

			p, #resultado {
				clear: both;

			}
			#resultado {
				width: 40rem;
				height: 3rem;
				border: 1px solid;
			}
		</style>
	</head>
	<body>
		<div>

			<div class="container rojo"></div>
			<input type="range" min="0" max="255" id="color1"  />
		</div>

		<div>

			<div class="container verde"></div>
			<input type="range" min="0" max="255" id="color2"  />
		</div>

		<div>

			<div class="container azul"></div>
			<input type="range" min="0" max="255" id="color3"  />
		</div>

		<div id="resultado"></div>

		<p>Color seleccionado: <span id="colorHint"></span></p> 

	</body>
</html>