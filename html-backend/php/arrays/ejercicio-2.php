<?php

/*
rea una función toArray que reciba dos valores y devuelva un array con estos dos valores.

Por ejemplo, la llamada:

toArray(5,9);

debería devolver el array [5, 9]

*/

function toArray($n1,$n2){
	$array = [];
	
	array_push($array,$n1,$n2);
	
	return $array;
}

print_r(toArray(5,9));