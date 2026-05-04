<?php

$ERRORES=array(); // declaracion e inicio limpio de errores

function main(){
// info:main controla el flujo de la pagina php
	if ($_REQUEST and !isset($_REQUEST['limpiar'])){ // info:si hay datos del formulario y no estoy limpiando
		if ( validar() ){
			// tratamiento de la informacion recibida	
			var_dump($_REQUEST); // datos del formulario, excepto file
			echo "<br/>";
			var_dump($_FILES); // datos del fichero adjunto		
		}
		else{
			form(); // reenvio del formulario no paso la validacion
		}	
	}else{		
		form(); // primer envio del formulario o pulso limpiar
	}
}

function getClases($a){
// info: detarminamos en un clase si el dato es valido o no
	global $ERRORES; // info:php uso de una variable global en esta funcion
	if ( isset($_REQUEST['limpiar']) ){
		return 'valido'; // limpio formulario, valores iniciales de todos los campos son validos
	}	
	if ( isset($ERRORES[$a]) ){	
		if ( $ERRORES[$a]!='' ){
			return 'invalido';
		}else{
			return 'valido';
		}	
	}
	else{
		return 'valido';
	}
}

function getValue($a){
// info:leemos los valores enviados por el formulario para imprimirlos de nuevo en el formulario
	if ( isset($_REQUEST['limpiar']) ){
		return ''; //info: si limpio values iniciales 
	}
	if (isset($_REQUEST[$a])){	
		return $_REQUEST[$a];
	}else{
		return '';
	}
}

function validar(){
// info:validamos el formulario
	global $ERRORES; // info:php uso de una variable global en esta funcion
	if ($_REQUEST['contraseña']=='hola'){ // info: se valida un input passwd
		$valido=true;
	}else{
		$valido=false;
		$ERRORES['contraseña']='mal clave'; // rellenamos errores de validación
	}
	return $valido;
}


function form(){
// dibujamos el formulario
	global $ERRORES; // info:php uso de una variable global en esta funcion
	$controles=array( // info:declaracion e inicializacion de un array de array
		array('type'=>'text','name'=>'nombre','value'=>getValue('nombre'),'class'=>'caja','size'=>20,'maxlength'=>30,'mens'=>'error'),
		array('type'=>'text','name'=>'apellidos','value'=>'','class'=>'caja','size'=>50,'maxlength'=>80,'mens'=>'error'),
		array('type'=>'password','name'=>'contraseña','value'=>'','class'=>getClases('contraseña').' caja','size'=>'','maxlength'=>10,'mens'=>'error')
);

// info:form action="index.php" , servidor
// info:form enctype="multipart/form-data" , para enviar ficheros
// info:form method="post" , datos ocultos
// The <input type="image"> es un submit, defines an image as a submit button.
// formenctype sobrescribe a enctype del form, pero puede aplicarse al boton de submit

?>
<h1>Rellena tu formulario</h1>

<form action="index.php" method="post">

	<div id='menu'>
		<div><input type="image" id='enviar' formenctype="multipart/form-data" name="enviar" src="img/submit.png" onclick="clickSubmit()"/></div>
		<div class='envio'><input type="submit" id='enviar2' name="enviar" value="enviar"/></div>
		<div class='envio'><input type="reset" id='limpiar' name="limpiar" value="limpiar" onclick="clickLimpiar()"/></div>
	</div>

	<fieldset id='caja1'>
	    <legend>un fieldset</legend>
		Generados desde php<br/>
		<?php
		foreach ($controles as $item){
			$mens='';
			if (isset($ERRORES[$item['name']])){
				$mens=$ERRORES[$item['name']];
			}
		 echo "$item[name] <input type='$item[type]' name='$item[name]' value='$item[value]' class='$item[class]' size='$item[size]' maxlength='$item[maxlength]'/><span>$mens</span><br/>";
		}	
		?>	
		
		<br/>Otras cajas de texto alineadas<br/>
		
		<label id="lblDni" for="dni">DNI</label> <!-- info: parametrizar html con php -->
		<input required class='<?php echo getClases("dni")?>' type="text" id="dni" name="dni" value='<?php echo getValue("dni")?>' size="10" maxlength="9" /><br/>
		
		<label id="lblPostal" for="postal">codigo postal</label>
		<input type="text" id="postal" name="postal" value="" size="5" maxlength="5" /><br/>
						
	</fieldset>

	<fieldset id='caja2'> 

		<legend>caja 2</legend>

		Sexo(selectores de boton) <br/>
		<input type="radio" name="sexo" value="hombre" checked="checked" /> Hombre <br/>
		<input type="radio" name="sexo" value="mujer" /> Mujer<br/><br/>
		
		<label for="foto">Incluir mi foto (adjuntar ficheros)</label>
		<input type="file" name="foto" id='foto'/><br/><br/>
		
		File tuneado con una imagen:<br/>
		<div class="upload">
			<input type="file" name="upload"/>
		</div><br/>
		
		CheckBox:<br/>	
		 <!-- info:[]  para enviar selecciones multiples -->
		<input name="suscribir[]" type="checkbox" value="1" checked="checked"/> te subscribes ?<br/>
		<input name="suscribir[]" type="checkbox" value="2" checked="checked"/> k te subscribas !<br/>
		<input name="suscribir[]" type="checkbox" value="3" checked="checked"/> tu ultima oportunidad de apuntarte !!<br/>
		nota:tas subscrito ?

	</fieldset>

	<fieldset id='caja3'> 
	    <legend>caja 3</legend>   
		Controles que incluyen limitaciones o chequeos de contenido <br/><br/>
	 	Number:<input type="number" name="points" min="0" max="100" step="10" value="30"/><br/>	
		Color:<input type="color" name="favcolor"/><br/>		
		<br/>Una forma de alinear label-input
		<div class='labelInput'><label for='points'>Range:</label><input type="range" id='points' name="points" min="0" max="10"/></div>
		<br/>email:<input type="email" name="email"/><br/>
		url:<input type="url" name="homepage"/><br/>	
	</fieldset>    

	<fieldset id='caja4'> 
	    <legend>caja 4</legend>
		<textarea id='cajatexto' cols='20' rows='4' maxlength='4' >caja de texto no redimensionable</textarea>	
		<textarea id='cajatexto2' cols='20' rows='4' maxlength='4' >caja de texto redimensionable</textarea>
	    <pre> <!-- info:tag pre imprime el texto tal cual esta en el editor -->
No funcionan en FireFox ?
( impreso con tag pre )
date
datetime
datetime-local
month
search
tel
time
week
		</pre>
	</fieldset>        
	  
	<fieldset id='caja5'> 
	    <legend>selectores</legend>

		<label for="so">select sencillo</label> 
		<select id="so" name="so">
		  <option value="" selected="selected">- selecciona -</option>
		  <option value="windows">Windows</option>
		  <option value="mac">Mac</option>
		  <option value="linux">Linux</option>
		  <option value="otro">Otro</option>
		</select>
		 
		 <br/><label for="so2">select en lista</label><br/>
		<select id="so2" name="so2" size="6">
		  <option value="windows" selected="selected">Windows</option>
		  <option value="mac">Mac</option>
		  <option value="linux">Linux</option>
		  <option value="otro">Otro</option>
		</select>
		
		<br/><label for="so3">select multiple</label><br/>
		<select id="so3" name="so3[]" size="6" multiple="multiple"> <!-- info:[]  para enviar selecciones multiples -->
		  <option value="windows" selected="selected">Windows</option>
		  <option value="mac" >Mac</option>
		  <option value="linux">Linux</option>
		  <option value="otro">Otro</option>
		</select>
			
		<br/><label for="programa">Select agrupados</label><br/>
		<select id="programa" name="programa">
		  <optgroup label="Sistemas Operativos">
		    <option value="Windows" selected="selected">Windows</option>
		    <option value="Mac">Mac</option>
		    <option value="Linux">Linux</option>
		    <option value="Other">Otro</option>
		  </optgroup>
		  <optgroup label="Navegadores">
		    <option value="Internet Explorer" selected="selected">Internet Explorer</option>
		    <option value="Firefox">Firefox</option>
		    <option value="Safari">Safari</option>
		    <option value="Opera">Opera</option>
		    <option value="Other">Otro</option>
		  </optgroup>
		</select><br/>	
		
		<label for="listado">selector con sugerencias (mete i)</label>
		<input id="listado" list="browsers">	
		<datalist id="browsers">
			<option value="Internet Explorer">
			<option value="Firefox">
			<option value="Chrome">
			<option value="Opera">
			<option value="Safari">
		</datalist> 	

	</fieldset>

</form>
<?php
}


// PAGINA HTML
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="es" xml:lang="es">
 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Rellena tu formulario</title>
<script>
function clickSubmit(){
// info:esta funcion se llama antes del submit en el click del boton
	var ele=document.getElementById('postal');
	ele.required='required'; // info:marcar un control como requerido, al submitir se tendra en cuenta en la validacion html tb se puede gestionar en php

}
function clickLimpiar(){
	alert('Pulsaste Limpiar, no esta bien poner PopUps');
}
</script>
<style>
<?php 
// tambien podemos usar php para trabajar con los estilos
$fondo='#FAEBD7';
// textarea :podemos evitar el resize con max
?>
.envio{
	margin:4px 4px 4px 12px;
}
/* menu */
#menu{
	margin-left:20px;
	width:240px;
	height:60px;		
	display:flex;
}
#menu div{
	flex:1;
}
#enviar{
    width:100px;
	top:-2px;
	position:relative;
}

legend {
	font:oblique 120% sans-serif bold; 
}
/* estilar el boton upload */
div.upload {
    width:157px; 
    height:50px;
    background-image:url("https://lh6.googleusercontent.com/-dqTIJRTqEAQ/UJaofTQm3hI/AAAAAAAABHo/w7ruR1SOIsA/s157/upload.png");
    overflow:hidden;
}
div.upload input {
    display:block;
    width:157px;
    height:57px;
    opacity:0;
    overflow:hidden;
}
label {
	font:oblique bold 80% cursive;
}

#lblPostal,#lblDni {
	width:120px;
	display: inline-block;
	margin:10px;
}

/* alinear label y input */
.labelInput {
    display: table-cell;
    vertical-align: middle;
    height: 100px;
    border: 1px solid red;
}


fieldset[id*="caja"]{ /* info:selecciona todos los fieldset con id que empiezen por caja */
	float:left;
	width:280px;
	height:440px;
}
.caja {
	margin:10px;
	width:100px;
	height:30px;	
}

#cajatexto{
	width:184px;
	height:73px;
	max-height:30px;
	max-width:200px;
	resize:none;
}

#so3{
   -moz-appearance:none; /* info:css explicito para mozilla , por desgracia no todos los navegadores implementar los standar al completo */ 
    text-indent:0.01px;
    text-overflow:'';
}

#pie{
	clear:left;
}

.invalido{
	background-color:red;
}

.valido{
	background-color:<?echo $fondo?>;/* info:escribir estilos con php */
}

</style>
</head>
 
 
 
<body>
<?php
main();
?>
<div id='pie'></div>
<br/>
</body>
 
 
 
</html>