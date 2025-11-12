/*

- ver eventoTeclado.html
- posicionamiento del div con float y clear
- usar className para poner clases , agrupar los estilos
- dos hojas de estilos estilos1.css y estilos2.css
- modificar con ele.setAttribute('href','estilo1.css');
- evento pasar con el raton ele.onmouseover=raton; 
lenguaje: getElementsByTagName,Math.floor
*/

window.onload = function(){
	window.onkeypress=tecla; // pulsacion de la tecla en window sera detectada en cualquier parte de la pagina
	var padre=document.body; 
	creaNodo(padre,'','caja1','div','tipo0'); // primera caja mostrar el texto del mouseover
	var contenedor=creaNodo(padre,'','contenedor','div',''); // contenedor de los cajas de colores
	for (let j=0;j<81;j++){ // 81 cajas	
		let clase='tipo2';
		if ( j % 2 == 0 ){ clase='tipo1' }
		// al estar dentro de un contenedor, float se encarga del salto de linea				
		var ele=creaNodo(contenedor,j+(Math.floor(j/9)),'D'+j,'div',clase);// crear nodo
		if ( j % 2 == 0 ){ ele.onmouseover=raton }	
	}
	var ele=document.getElementsByTagName('link')[0]; // primero, el unico que hay
	ele.setAttribute('href','estilo1.css'); // modificar un atributo de un elemento
}
function raton(){
	// muestra el texto de la caja con el evento mourover
	var ele=document.getElementById('caja1');
	ele.innerHTML=this.innerHTML;
}
function tecla(e){
	// cambiar hoja de estilos al pulsar tecla 1 o 2
	// en el parametro e tenemos la informacion del evento
	console.log(e);
	var estilo='estilo1.css';
	if (e.key=='2'){estilo='estilo2.css'}
	if (e.key=='1'){estilo='estilo1.css'}
	var ele=document.getElementsByTagName('link')[0]; // primero pero solo hay uno
	ele.setAttribute('href',estilo); // modificar un atributo de un elemento
}
function creaNodo(ancestro,texto,id,tipo,clase){
	// ancestro: elemento padre
	// t: texto que crearemos dentro de un nodo text equivamente al innerHTML
	// m: id del nodo 
	// tipo: tipo de nodo
	// clase: clase que ponermos al elemento
	// crea un texto dentro del nodo createElement
	// alternativa .innerHTML que no es estandar pero esta aceptado 
	var p = document.createElement(tipo);
	var contenido = document.createTextNode(texto);	
	p.n=id
	p.id=id;
	p.className=clase;
	p.appendChild(contenido);	 
	ancestro.appendChild(p);
	return p; // por si queremos trabajar con la referencia al elemento
}