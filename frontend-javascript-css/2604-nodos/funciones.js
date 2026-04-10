function iniciar(){
    console.log('iniciar');
    
    let generarContenido = document.body;
    generarContenido.innerHTML += '<h1>Hola adadwdawd</h1><p>Este es un pvdvdvárrafo</p>';

    let arbol = document.documentElement.cloneNode(true);
    
    document.body.innerHTML = "";

    console.log(arbol.firstChild.childNodes);


}