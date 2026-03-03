<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Formulario de Votación</title>
    <style>
        /* Estilos CSS sencillos y básicos */
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7fc; /* Color de fondo claro y sutil */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .contenedor-votacion {
            text-align: center;
            padding: 40px;
            background-color: white; /* Contenedor blanco para destacar */
            border-radius: 8px; /* Bordes ligeramente redondeados */
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* Sombra suave para dar profundidad */
        }

        h1 {
            font-size: 2.5rem;
            margin-bottom: 20px;
            text-transform: uppercase; /* Texto en mayúsculas como en la imagen */
        }

        p {
            font-size: 1.1rem;
            margin-bottom: 40px;
            color: #333;
        }

        .opciones-votacion {
            display: flex;
            flex-direction: column;
            gap: 20px; /* Espaciado entre las opciones */
            align-items: center;
            margin-bottom: 40px;
        }

        /* Estilo para cada fila de opción */
        .opcion {
            display: flex;
            align-items: center;
            gap: 15px; /* Espaciado entre el check y el bloque de color */
        }

        /* Ocultar el checkbox real */
        .check-voto {
            display: none;
        }

        /* Estilo del label que funciona como check visible (el botón cuadrado) */
        .label-check {
            width: 80px;
            height: 80px;
            border: 2px solid #ccc; /* Borde gris como en la imagen */
            background-color: #f0f0f0; /* Fondo gris claro */
            cursor: pointer;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            box-sizing: border-box; /* Asegura que el borde no sume al tamaño */
        }

        /* El checkmark (la "v") dibujado con CSS */
        .label-check::after {
            content: '';
            position: absolute;
            width: 25px; /* Ancho de la v */
            height: 45px; /* Alto de la v */
            border: solid;
            border-width: 0 8px 8px 0; /* Solo bordes derecho e inferior */
            transform: rotate(45deg); /* Rota para formar la v */
            display: none; /* Oculto por defecto */
        }

        /* Estilo para el checkmark azul */
        .check-voto.azul + .label-check::after {
            border-color: #1e90ff; /* Color azul brillante */
            top: 10px; /* Ajuste de posición */
        }

        /* Estilo para el checkmark naranja */
        .check-voto.naranja + .label-check::after {
            border-color: #ff8c00; /* Color naranja brillante */
            top: 10px; /* Ajuste de posición */
        }

        /* Mostrar el checkmark cuando el checkbox está marcado */
        .check-voto:checked + .label-check::after {
            display: block;
        }

        /* Estilo del bloque de color asociado a la opción */
        .bloque-color {
            height: 80px;
        }

        /* Ancho y color específicos para el bloque azul */
        .bloque-azul {
            width: 200px;
            background-color: #1e90ff;
        }

        /* Ancho y color específicos para el bloque naranja */
        .bloque-naranja {
            width: 80px;
            background-color: #ff8c00;
        }

        /* Estilo del botón "Poner a cero" */
        .btn-reiniciar {
            padding: 10px 20px;
            font-size: 1rem;
            background-color: #f0f0f0; /* Fondo gris claro */
            border: 1px solid #ccc; /* Borde gris */
            cursor: pointer;
            text-transform: capitalize; /* Capitaliza la primera letra */
        }

        /* Efecto hover sencillo para el botón */
        .btn-reiniciar:hover {
            background-color: #e0e0e0;
        }
    </style>
</head>
<body>

    <div class="contenedor-votacion">
        <h1>VOTAR UNA OPCIÓN</h1>
        <p>Haga clic en los botones para votar por una opción:</p>

        <div class="opciones-votacion">
            <div class="opcion">
                <input type="checkbox" id="voto-azul" class="check-voto azul">
                <label for="voto-azul" class="label-check"></label>
                <div class="bloque-color bloque-azul"></div>
            </div>

            <div class="opcion">
                <input type="checkbox" id="voto-naranja" class="check-voto naranja">
                <label for="voto-naranja" class="label-check"></label>
                <div class="bloque-color bloque-naranja"></div>
            </div>
        </div>

        <button class="btn-reiniciar">Poner a cero</button>
    </div>

</body>
</html>