<?php

    if($_REQUEST){
        $imagenes = glob('./img/*');
        echo(json_encode($imagenes));
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
       

        function ajax(){
            return new Promise(resolve => {
                let peticion = new XMLHttpRequest();
                peticion.open('GET','index.php?ajax=1',true);
                peticion.onreadystatechange = () => {
                    if(peticion.readyState === 4 && peticion.status === 200){
                        resolve(JSON.parse(peticion.responseText));
                        
                    }
                }
                peticion.send();
            })
        }

        async function iniciar(){

            let contenedorPadre = document.createElement('div');
            contenedorPadre.style.display = 'grid';
            contenedorPadre.style.gridTemplateColumns = 'repeat(10,1fr)';
            contenedorPadre.style.gridTemplateRows = 'repeat(10,1fr)';
            contenedorPadre.style.width = '400px';

            document.body.appendChild(contenedorPadre);

            const data = await ajax();

            for(let i = 0; i < data.length; i++){
                let ele = document.createElement('img');
                ele.setAttribute('src',data[i]);
                contenedorPadre.appendChild(ele);
            }

            


        }

        window.onload = iniciar;
    </script>
</head>
<body>
    
</body>
</html>