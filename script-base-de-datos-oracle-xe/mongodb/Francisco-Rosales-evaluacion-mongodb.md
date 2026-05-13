Automatic Zoom
Actividad 1: Consultas sobre MongoDB 
 
Las consultas son: 
 
▪  Colección movies 
 
1.  Mostrar toda la información sobre la películas de nombre “Alice in 
Wonderland” 

```json
db.movies.find({title: "Alice in Wonderland"})
```

2.  Películas de género comedía (Comedy) o fantasía (Fantasy) 

```json
db.movies.find(
    {
        $or: [
            {genre: "Family"},{genre: "Fantasy"}
        ]
    }
)
```
3.  Algunos abogan que una de las edades de oro en la comedia fue el periodo 
entre el 1960 y el 1970. Obtener el título de las películas del género Science 
Fiction que se realizaron en ese periodo. 

```json
db.movies.find(
    {
        genre: "Science Fiction",
        $and: [
            {year: {$gte: 1960}},
            {year: {$lte: 1970}}
        ]
    },
    {
        title: 1
    }
)
```

4.  Modificar la consulta anterior para añadir también las películas del género 
Fantasy. Ordena los resultados por el año de la película (de forma 
ascendente). 

```json
db.movies.find(
    {
        $and: [
            {year: {$gte: 1960}},
            {year: {$lte: 1970}}
        ],
        genre: {$in: ["Science Fiction", "Fantasy"]}
    },
    {
        title: 1, genre: 1
    }
)
```

5.  Obtener las películas donde haya actuado algún actor (etiqueta cast) con 
vuestro nombre (lo podéis hacer alternativamente con vuestro apellido si 
queréis – pero sólo con el nombre o con el apellido, no con los dos a la vez). 

```json
db.movies.find(
    {
        actors: {$in: ["Francisco Rosales"]}
    }
)
```

6.  Obtener el título, año, y género de las películas donde Jude Law ha trabajado. 
Ordena los resultados por el año de la película de forma descendente (las 
más nuevas primero). 

```json
db.movies.find(
    {
        actors: "Jude Law"
    },
    {
        title: 1, year: 1, genre: 1
    }
).sort({year: -1})
```
7.  Título (ordenado ascendente) de películas en las que haya actuado Joaquin 
Phoenix o Al Pacino. 

```json
db.movies.find(
    {
        actors: {$in: ["Joaquin Phoenix", "Al Pacino"]}
    },
    {
        title: 1
    }
).sort({title: 1})
```
8.  Obtener una lista de películas de comedia (género Comedy) del año en que 
nacisteis o películas de guerra (género War) en las que actúa Sylvester 
Stallone. Queremos ver título, año y género. Ordenadas por año descendente 

```json
db.movies.find(
    {
        $or: [
            {
                genre: "Comedy", year: "2000"
            },
            {
                genre: "War", actors: "Sylvester Stallone"
            }
        ]
    },
    {
        title: 1, year: 1, genre: 1
    }
).sort({year: -1})
```

9.  Películas cuya puntuación (imdb.rating) es mayor que 9 o menor que 2 
```json
db.movies.find(
    {
        $or: [
            {score: {$gt: 9}},
            {score: {$lt: 2}}
        ]
    },
    {
        score: 1
    }
)
```
10. Devuelve las películas en las que haya sólo 2 actores 

```json
db.movies.find(
    {
        actors: {$size: 2}
    }
)
```
 