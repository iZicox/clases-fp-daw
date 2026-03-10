	var h1,h2,h3;

	// pre-compilado de piezas etiquetadas	
	h1=ps1([
	// ejes
	'color #eee','ancho 6','relleno green',
	'linea 1 LI01 0,0,0 10,0,0','texto X',
	'0,0,0 0,10,0','texto Y',
	'0,0,0 0,0,10','texto Z', 
	]);
	h2=ps1([
	// pieza 3D con poligonos rellenos
	'color red','ancho 2','conlinea 1','conrelleno 1',
	'relleno #ff6961','0,0,6 2,0,6 2,6,6 0,6,6',	 //rojo
	'relleno #fdfd96','2,2,2 6,2,2 6,6,2 2,6,2',	//amarillo
	'relleno #fdcae1','2,0,4 6,0,4 6,2,4 2,2,4',	//morado
	'relleno #77dd77','6,0,4 6,0,0 6,6,0 6,6,2 6,2,2 6,2,4', 	//verde
	'relleno #84b6f4','0,6,6 2,6,6 2,6,2 6,6,2 6,6,0 0,6,0', 	//azul
	'relleno #77dd77','2,0,6 2,0,4 2,2,4 2,2,2 2,6,2 2,6,6', 	//verde
	]);	
	h3=ps1([ 
	// pieza creada con extruido
	'poligono 0 PO01 0,0,6 1,0,6 1,1,6 0,1,6',	
	'conrelleno 1','relleno #ddd','color blue',
	'extruido 1 EX01 0.5 PO01',	
	// mallas
	'color blue','relleno yellow','conrelleno 1',
	'malla 1 MA01 2,2,1 2,3,1 EX01',
	'color grey','conrelleno 0',
	'malla 1 MA02 1,1,1 6,6,1 PO01',
	//'malla 1 MA03 1,1,3 1,1,2 PO01',
	'conrelleno 0',
	// pieza con lineas
	'color red','ancho 1','relleno blue',	
	'conlinea 0','contexto 0',
	'0,0,6 0,6,6','texto 066',
	'0,6,6 2,6,6','texto 266',
	'2,6,6 2,0,6','texto 206',
	'2,0,6 0,0,6','texto 006',
	'2,0,6 2,0,4','texto 204',
	'2,0,4 2,2,4','texto 224',
	'2,2,4 6,2,4','texto 624',
	'6,2,4 6,0,4','texto 604',
	'6,0,4 2,0,4',
	'6,0,4 6,0,0','texto 600',
	'6,0,0 6,6,0','texto 660',
	'6,6,0 0,6,0','texto 060',
	'0,6,0 0,6,6',
	'2,6,6 2,6,2','texto 262',
	'2,6,2 6,6,2','texto 662',
	'6,6,2 6,2,2',
	'6,6,2 6,6,0',
	'6,2,2 6,2,4',
	'2,2,4 2,2,2','texto 222',	
	'2,2,2 2,6,2',
	'2,2,2 6,2,2','texto 622',
	]);

	console.log(hh); // comandos de dibujo

/*
COMANDOS
lineas [[xyz][xyz]] dos puntos. no crea sin referencias
poligonos [[xyz][xyz][xyz]] mas de dos puntos. no crea referencias
color: cambiar el color de las lineas
ancho: puntos del ancho de linea de dibujo
texto: posiciona texto despues del ultimo punto
relleno: cambiar el color relleno y el color de los textos
conlinea: pinta o no lineas, tb las de los poligonos 
contexto: pinta texto o no
conrelleno: pinta relleno de poligonos o no
linea a LI01 0,0,0 8,0,0 ; crea referencia 
poligono a PO01 6,0,4 6,0,0 6,6,0 6,6,2 6,2,2 6,2,4 ; crea referencia
extruido a EX01 14,0,0 PO01  ; crea referencia
* a=0 solo crea referencia
* a=1 crae referencia y tb dibuja
*/	