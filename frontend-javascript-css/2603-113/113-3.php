<?php
if($_REQUEST){

    $array = array("r" => $_REQUEST['r'], "b" => $_REQUEST['g'], "b" => $_REQUEST['b']);
    $json = json_encode($array);
    echo $json;

    // VERSION DE ARRAY
    /*
    $result = "[";
    $i = 0;
    foreach($_REQUEST as $color){
        if($i !== (count($_REQUEST)-1)){
            $result .= hexdec($color) . ",";
        } else {
            $result .= hexdec($color);
        }
        $i++;
    }
    $result .= "]";
    print_r($result);
    */

    
    exit;

}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script>
        function ajax(datos){
            let peticion = new XMLHttpRequest();

            peticion.onreadystatechange = () => {
                if (peticion.readyState === 4 && peticion.status === 200) {
                   document.getElementById('codColor').innerHTML = peticion.responseText;
                }
            }

            peticion.open('GET','113-3.php?'+
                                            'r='+ parseInt(datos[0]).toString(16) +
                                            '&g='+ parseInt(datos[1]).toString(16) +
                                            '&b='+ parseInt(datos[2]).toString(16)
                            ,true);
            peticion.send();
        }
        function colores(){
            
            let valores = document.querySelectorAll('body div input[type="range"]');
            let copia = [...valores].map((ele) => ele.value);
            console.log("array:", copia);
            ajax(copia);

            document.getElementById('color').style.background = `rgb(${copia[0]},${copia[1]},${copia[2]})`;

            let color = document.getElementById('r').value;
            document.querySelector('.container.red').style.backgroundColor = `rgb(${color},0,0)`;

            color = document.getElementById('g').value;
            document.querySelector('.container.green').style.backgroundColor = `rgb(0,${color},0)`;

            color = document.getElementById('b').value;
            document.querySelector('.container.blue').style.backgroundColor = `rgb(0,0,${color})`;
        }

        function iniciar() {
            document.querySelectorAll('body div input[type="range"]').forEach((ele) => {
                ele.oninput = colores;
            }); 

            let color = document.getElementById('r').value;
            document.querySelector('.container.red').style.backgroundColor = `rgb(${color},0,0)`;

            color = document.getElementById('g').value;
            document.querySelector('.container.green').style.backgroundColor = `rgb(0,${color},0)`;

            color = document.getElementById('b').value;
            document.querySelector('.container.blue').style.backgroundColor = `rgb(0,0,${color})`;
            
          
        }

        window.onload = iniciar;
    </script>
    <style>
        .container {
            width: 10rem;
            height: 10rem;
            border: 1px solid;
        }

        #color {
            width: 40rem;
            height: 5rem;
            border: 1px solid;
        }

        body > div {
            float: left;
        }

        #color, p {
            clear: both;
        }
    </style>
</head>
<body>
    <div>
        <div class="container red"></div>
        <input type="range" min="0" max="255" id="r" >
    </div>
    
    <div>
        <div class="container green"></div>
        <input type="range" min="0" max="255" id="g" >
    </div>

    <div>
        <div class="container blue"></div>
        <input type="range" min="0" max="255" id="b" >
    </div>

    <div id="color"></div>

    <p>Color: <span id="codColor"></span></p>
</body>
</html>