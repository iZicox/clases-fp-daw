let nombre = "juanito";
let anime = "Naruto";
let edad = "16";

let personaje = {
    nombre: "juanito",
    anime: "naruto",
    edad: 16,
}

console.log(personaje); //te da todos los atributos del obj

console.log(personaje.nombre); //te da el atributo especifico que escojas

console.log(personaje['anime']);

personaje.edad = 13; //cambia la edad 

delete personaje.anime; // elimina el atributo del objeto

console.log(personaje);