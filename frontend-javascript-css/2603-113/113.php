<?php
if($_REQUEST){
    print_r($_REQUEST);
    echo "hola";
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

            peticion.open('GET','113.php?'+'r='+datos[0]+'&g='+datos[1]+'&b='+datos[2],true);
            peticion.send();
        }
        function colores(){
            let valores = document.querySelectorAll('body div input[type="range"]');
            let copia = [...valores].map((ele) => ele.value);
            console.log(copia);
            ajax(copia);
        }

        function iniciar() {
            document.querySelectorAll('body div input[type="range"]').forEach((ele) => {
                ele.onchange = colores;    
            }); 
                
            /*
            document.getElementById('r').onchange = colores;
            document.getElementById('g').onchange = colores;
            document.getElementById('b').onchange = colores;    
            */
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