<?php
    function factorial($numero){

        if($numero < 0) {
            return "Error: Numero negativo";
        }
        if($numero == 0 || $numero == 1){
            return 1;
        }

        $resultado = 1;
        for($i = 2; $i <= $numero; $i++){
            
            $resultado *= $i; 
        }

        return $resultado;
    }

    function factorial2($numero){

        if($numero < 0) {
            return "Error: Numero negativo";
        }
        if($numero == 0 || $numero == 1){
            return 1;
        }

        $resultado = $numero;
        for($i = $numero-1; $i > 0; $i--){
            
            $resultado *= $i; 
        }

        return $resultado;
    }


    for($i = 0; $i < 100; $i++){
        echo ($i+1) . " - "; 
        echo factorial2($i+1);
        echo "<br>";
    }

    