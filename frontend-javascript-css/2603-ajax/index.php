<?php
	// ejemplo copiado de w3c
	//print_r($_REQUEST);

	if ($_REQUEST){
		// tengo parametros
		if (isset($_REQUEST["q"])){
			// analizo q=valor
			main();
		}else{
			// no entramos aqui
			echo "falta parametro q";
		}
		exit;	
	}
	// sino tengo parametros continuo con la carga de la página


	function main(){

		//sleep(1);

		// Fill up array with names
		$a[]="Anna";
		$a[]="Brittany";
		$a[]="Cinderella";
		$a[]="Diana";
		$a[]="Eva";
		$a[]="Fiona";
		$a[]="Gunda";
		$a[]="Hege";
		$a[]="Inga";
		$a[]="Johanna";
		$a[]="Kitty";
		$a[]="Linda";
		$a[]="Nina";
		$a[]="Ophelia";
		$a[]="Petunia";
		$a[]="Amanda";
		$a[]="Raquel";
		$a[]="Cindy";
		$a[]="Doris";
		$a[]="Eve";
		$a[]="Evita";
		$a[]="Sunniva";
		$a[]="Tove";
		$a[]="Unni";
		$a[]="Violet";
		$a[]="Liza";
		$a[]="Elizabeth";
		$a[]="Ellen";
		$a[]="Wenche";
		$a[]="Vicky";

		$q=$_REQUEST["q"]; 
		$hint="";
		if ($q !== ""){ 
			$q=strtolower($q); 
			$len=strlen($q);
			foreach($a as $name){ 
				if (stristr($q, substr($name,0,$len))){ 
					if ($hint===""){ 
						$hint=$name; 
					}else{ 
						$hint .= ", $name";
					}
				}
			}
		}
		echo $hint==="" ? "no suggestion" : $hint;

	}

?> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" xml:lang="es">
	<head>
		<script>
			function ajax1(str){
				var xmlhttp; // objeto de comunicaciones
				if (str.length==0){ 
					document.getElementById("txtHint").innerHTML=""; // vaciamos la caja
					return;
				}	
				xmlhttp=new XMLHttpRequest();
				xmlhttp.onreadystatechange=function(){ // declaracion callback
					if (xmlhttp.readyState==4 && xmlhttp.status==200){
							// respuesta de php no es la pagina completa, solo texto
							document.getElementById("txtHint").innerHTML=xmlhttp.responseText;
					}
				}
				// envio de la peticion al servidor
				xmlhttp.open("GET","index.php?q="+str,true);
				/*
					method: the type of request: GET or POST
					url: the server (file) location
					async: true (asynchronous) or false (synchronous)
				*/
				xmlhttp.send();
			}	
			function varios(){
				console.log(this.value);
				ajax1(this.value);
				//showHint(pulsado,true);
			}
			function iniciar(){
				document.getElementById('txt1').onkeyup=varios;
			}

			window.onload=iniciar;
		</script>
	</head>
	<body>

		<h3>Start typing a name in the input field below:</h3>

		First name: <input type="text" id="txt1"  />

		<p>Suggestions: <span id="txtHint"></span></p> 

	</body>
</html>