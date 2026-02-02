<?php
$min = isset($_POST['min']) ? $_POST['min'] : "";
$max = isset($_POST['max']) ? $_POST['max'] : "";
$htmlSalida = "";
$paso;


$menu = array(
    array("Sopa de cocido", 250),
    array("Crema de espinacas", 250),
    array("Verduras a la plancha", 200)
);


$segundo_plato = array(
    "Filete con patatas" => 400,
    "Lubina a la plancha" => 300,
    "Pechuga de pollo" => 250
);

//crear tabla
echo '<table border="1">';

echo "<tr>";
foreach($primer_plato as $clave => $valor){
    echo "<td>";
        echo $clave;
    echo "</td>";
}
echo "/<tr>";

echo "</table>";

if(empty($min) && empty($max)){
    $paso = 1;
}

if($paso == 1){
    $htmlSalida = <<< EOT
    <p>Mostrar menu en el siguiente rango calorico</p>

    <form action="" method="post">
        
        <label for="">Calorias entre: </label>
        <input type="number" name="min">

        <label for=""> y </label>
        <input type="number" name="max">

    </form>
    EOT;
    
    echo $htmlSalida;
}

?>

