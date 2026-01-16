function iniciar ():void{
    var body = document.body;

    var contenedor = crearNodo('div');
    body.appendChild(contenedor);
    contenedor.classList = 'contenedor';
    contenedor.style.display='flex';

    var principal = crearNodo('div');
    contenedor.appendChild(principal);

    
    var parrafo = crearNodo('p');
    contenedor.appendChild(parrafo);
    parrafo.innerHTML = 'Texto de prueba';


    for(let i = 0; i < 20; i++){
        let ele = crearNodo('div');
        let contenido = 'menu ' + (i+1);

        ele.innerHTML = contenido;
        
        ele.style.display='flex';
        ele.style.justifyContent='center';
        ele.style.alignItems='center';
        
        ele.style.width='100px';
        ele.style.height='50px';
        ele.style.backgroundColor='red';
        ele.style.margin='5px';
        principal.appendChild(ele);
    }

}

function crearNodo(tipo: string ): HTMLElement{
    let ele = document.createElement(tipo);

    return ele;
}


window.onload = iniciar;