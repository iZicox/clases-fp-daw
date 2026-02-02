<?php
$min = isset($_POST['min']) ? $_POST['min'] : "";
$max = isset($_POST['max']) ? $_POST['max'] : "";
$htmlSalida = "";
$paso;


$primer_plato = array(
    "Sopa de cocido" => 250,
    "Crema de espinacas" => 250,
    "Verduras a la plancha" => 200);


$segundo_plato = array(
    "Filete con patatas" => 400,
    "Lubina a la plancha" => 300,
    "Pechuga de pollo" => 250
);

if(empty($min) && empty($max)){
    $paso = 1;
} else {
    $paso = 2;
}

if($paso == 1){
    $htmlSalida = <<< EOT
    <p>Mostrar menu en el siguiente rango calorico</p>

    <form action="" method="post">
        
        <label for="">Calorias entre: </label>
        <input type="number" name="min">

        <label for=""> y </label>
        <input type="number" name="max">

        <input type="submit">

    </form>
    EOT;
    
    echo $htmlSalida;
}



if($paso == 2){
    echo '<table border="1"><tr><th>Primer plato</th><th>Segundo plato</th><th>Calorias</th></tr>';
    foreach($primer_plato as $primer => $calorias_primer){
        foreach($segundo_plato as $segundo => $calorias_segundo){
            
            $total_calorias = $calorias_primer + $calorias_segundo;

            if($total_calorias >= $min && $total_calorias <= $max ){
                echo "<tr><td>{$primer}</td><td>{$segundo}</td><td>{$total_calorias}</td></tr>";
            }

        }
    }
    echo "</table>";
}
?>

