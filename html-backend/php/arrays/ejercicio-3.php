<?php

/*
Recorrer la siguiente lista con un bucle imprimiendo el doble de cada número:

$numbers = [1,9,3,8,5,7]
*/

$numbers = [1,9,3,8,5,7];

for($i = 0; $i < count($numbers); $i++){
	print($numbers[$i] * 2);
	echo "<br>";
}