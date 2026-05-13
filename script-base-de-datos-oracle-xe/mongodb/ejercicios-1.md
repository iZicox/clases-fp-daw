# Ejercicios
1. Ejercicios de práctica: Colección companies 1. Búsqueda exacta: Mostrar toda la información sobre la empresa de nombre \"Facebook\"
```json
db.companies.find(
    {
        name: 'Facebook'
    }
)

```

2. Operador lógico OR: Obtener las empresas cuya categoría (category_code) sea \"web\" o \"social\

```json
db.companies.find(
  {
    $or: [
      {category_code: "web"},
      {category_code: "social"}
    ] 
  }
)
```



3. Rangos de fechas y AND: Se dice que el "boom" de las puntocom tuvo un pico
entre 1998 y 2000. Obtener el nombre de las empresas de la categoría "search" que
se fundaron en ese periodo.

```json
db.companies.find(
  {
    category_code: "search",
    founded_year: {$gte: 1998, $lte: 2000}
  }
)
```


4. Ampliación y ordenación: Modificar la consulta anterior para incluir también las
empresas de la categoría "messaging". Ordena los resultados por el año de
fundación de forma ascendente (las más antiguas primero).

```json
db.companies.find(
  {
    $or: [
      {category_code: "search"},
      {category_code: "messaging"}
    ],
    founded_year: {$gte: 1998, $lte: 2000}

  }
).sort({founded_year: 1})
```

5. Búsqueda en arrays: Obtener las empresas donde algún miembro del equipo
(etiqueta relationships.person.first_name) tenga vuestro nombre (o apellido en
last_name).

```json
db.companies.find(
  {
    $or: [
      {"relationships.person.first_name": "Francisco"},
      {"relationships.person.last_name": "Rosales"}
    ] 
  }
)
```

6. Proyección y ordenación descendente: Obtener el nombre (name), año de
fundación (founded_year) y categoría de las empresas donde ha trabajado "Mark
Zuckerberg". Ordena los resultados por año de forma descendente (las más
recientes primero).

```json
db.companies.find(
  {
    $and: [
      {"relationships.person.first_name": "Mark"},
      {"relationships.person.last_name": "Zuckerberg"}
    ]
  },
  {
    name: 1, founded_year: 1, category_code: 1
  }
).sort({founded_year: 1})
```


7. Operador IN y proyección: Obtener el nombre (ordenado de la A a la Z) de las
empresas que pertenezcan a las categorías "network_hosting" o "advertising".

```json

db.companies.find(
  {
    category_code: {$in: ["network_hosting", "advertising"]}
  },
  {
    name: 1
  }
).sort({nombre: 1})

```


8. Consulta combinada: Obtener una lista de empresas de la categoría "software"
fundadas en el año en que nacisteis, O empresas de "biotech" que tengan más de
5000 empleados (number_of_employees). Queremos ver solo nombre, año y
número de empleados, ordenados por empleados de forma descendente.


```json
db.companies.find(
  {
    $or: [
      {
        category_code: 'software',
        founded_year: 2000
      },
      {
        category_code: 'biotech',
        number_of_employees: {$gt: 5000}
      }
    ]
  },
  {
    name: 1, founded_year: 1, number_of_employees: 1
  }
).sort({number_of_employees: -1})
```
9. Inserta una nueva empresa tecnológica con la siguiente estructura básica (en name
cambia Javier por tu nombre):
"name": "Javier Tech Solutions",
"founded_year": 2026,
"category_code": "education",
"number_of_employees": 15,
"tags": ["mongodb", "learning", "pro"]

```json
db.companies.insertOne(
  {
    "name": "Javier Tech Solutions",
    "founded_year": 2026,
    "category_code": "education",
    "number_of_employees": 15,
    "tags": ["mongodb", "learning", "pro"]
  }
)
```

10. Busca la empresa con nombre "Facebook" y realiza lo siguiente:
a. Cambia su campo category_code a "social_media" usando $set.
b. Incrementa su número de empleados en 500 usando $inc.
```json
db.companies.updateOne(
  {
    name: "Facebook"
  },
  {
    $set: {category_code: "social_media"},
    $inc: {number_of_employees: 500}
  }
)
```

11. Elimina de la colección todas las empresas que tengan 0 empleados


```json
db.companies.deleteMany(
  {
    number_of_employees: 0
  }
)
```

---

# Ejercicios deepseek


1. Obtener el nombre, año de fundación y categoría de las empresas fundadas en 1999.

```json
db.companies.find(
  {
    founded_year: 1999
  },
  {
    name: 1, founded_year: 1, category_code: 1
  }
)
```

2. Encontrar el nombre y número de empleados de las empresas que tienen más de 500 empleados.

```json
db.companies.find(
  {
    number_of_employees: {$gt: 500}
  },
  {
    name: 1, number_of_employees: 1
  }
)
```

3. Listar el nombre y año de fundación de las empresas que **no han sido adquiridas** (campo `acquisition` es null).

```json
db.companies.find(
  {
    acquisition: null
  },
  {
    name: 1, founded_year: 1
  }
)
```

4. Mostrar nombre y número de rondas de financiación de las empresas que tienen al menos 3 rondas.

```json
db.companies.find(
  {
    $expr: { $gte: [ { $size: "$funding_rounds" }, 3 ] }
  },
  {
    name:1, funding_rounds: 1
  }
)
```

5. Obtener nombre, ciudad y país de las empresas que tienen una oficina en Estados Unidos (código `"USA"`).

```json
db.companies.find(
  {
    "offices.country_code": "USA"
  },
  {
    name: 1, "offices.country_code": 1, "offices.city": 1
  }
)
```

6. Listar nombre y categoría de las empresas cuya categoría sea `"web"` o `"ecommerce"`.

```json
db.companies.find(
  {
    $or: [
      {category_code: "web"}, {category_code: "ecommerce"}
    ]
  },
  {
    name: 1, category_code: 1
  }
)
```

```json
db.companies.find(
  {
    category_code: {$in: ["web", "ecommerce"]}
  },
  {
    name: 1, category_code: 1
  }
)
```

7. Mostrar nombre y usuario de Twitter de las empresas que tienen cuenta de Twitter (campo no nulo y no vacío).

```json
db.companies.find(
  {
    twitter_username: {$nin: ["", null]}
  },
  {
    name: 1, twitter_username: 1
  }
)
```

8. Encontrar nombre y año de fundación de las empresas fundadas antes del año 2000 y que aún no han muerto (`deadpooled_year` es null).

```json
db.companies.find(
  {
    deadpooled_year: null,
    founded_year: {$lt: 2000}
  },
  {
    name: 1, founded_year: 1
  }
)
```

9. Buscar empresas que hayan recaudado **más de 10 millones de dólares** según el campo `total_money_raised` (string con formato `"$10M"`, `"$50k"`, etc.). Escribe una expresión regular que detecte montos desde 10M hacia arriba.

```json

db.companies.find(
  {
    total_money_raised: {
      $regex: /^(\$|\€)(([1-9][0-9]{2,})M|(1[1-9]|[2-9][0-9])M)$/
    }
  },
  {
    name:1, total_money_raised: 1
  }
)

```

10. Calcular la media de rondas de financiación por empresa (usando agregación).

```json

```

11. Obtener el **top 5** de empresas con más rondas de inversión (nombre y número de rondas).

12. Encontrar las empresas que compiten con `"Google"` (campo `competitions[].competitor.name`).

13. Listar las empresas que recibieron inversión de `"Sequoia Capital"` (dentro de `funding_rounds.investments.financial_org.name`).

14. Mostrar nombre, valor de valuación y año de salida a bolsa de las empresas que hicieron IPO (campo `ipo` no nulo). Ordenar por valuación descendente.

15. Encontrar empresas que tienen algún hito (`milestones`) en el año 2005.

16. Calcular el número de empresas por cada categoría (`category_code`), excluyendo nulos, y ordenar de mayor a menor.

17. Listar nombre, año de fundación y total recaudado de empresas fundadas después del año 2000 que recaudaron más de 20 millones.

18. Mostrar solo el nombre de la empresa y **la primera ronda de financiación** de cada una (usando proyección con `$slice`).

19. Encontrar empresas que hayan adquirido a otra compañía (campo `acquisitions` no vacío) y mostrar el nombre de la empresa adquirida.

20. Convertir el campo `total_money_raised` (string con sufijos M/k) a un valor numérico (ej. `"$10M"` → `10000000`) y proyectarlo junto con el nombre de la empresa. (Puedes usar agregación con `$regexMatch` y operaciones aritméticas).
