<?php

/*
Crea un array con cinco nombres de persona y recórrelo con 
un bucle for mostrando el texto «Conozco a alguien llamado «.

*/

$nombres = ['juan', 'pedro', 'mario', 'maria', 'laura'];

foreach($nombres as $n){
	echo "Conozco a alguien llamado " . $n . "<br>";
}