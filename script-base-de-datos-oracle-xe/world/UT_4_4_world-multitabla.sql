/*

1\. Devuelve el listado con el nombre del continente, 

nombre del pais, nombre de la

ciudad y población de la ciudad.

*/

SELECT c.CONTINENT AS continente, c.NAME AS pais, c2.NAME AS ciudad,

c2.POPULATION AS poblacion_ciudad 

FROM COUNTRY c 

INNER JOIN CITY c2 ON c.CODE = c2.COUNTRYCODE ;

/*

2\. Misma select que en el ejercicio 1 y añade una ordenación 

por nombre del pais de

forma ascendente y luego por población de la ciudad de forma descendente.

*/

SELECT c.CONTINENT AS continente, c.NAME AS pais, c2.NAME AS ciudad,

c2.POPULATION AS poblacion_ciudad 

FROM COUNTRY c 

INNER JOIN CITY c2 ON c.CODE = c2.COUNTRYCODE 

ORDER BY c.NAME ASC, c2.POPULATION DESC ;

/*

3\. Devuelve un listado de todos los países (código y nombre del país) 

y los lenguajes que

se hablan en el país con su % de personas que los hablan.

*/

SELECT c.CODE , c.NAME , l."LANGUAGE", l.PERCENTAGE || '%'    

FROM COUNTRY c INNER JOIN COUNTRYLANGUAGE l 

ON c.CODE = l.COUNTRYCODE ;

/*

4\. Misma consulta que en el ejercicio 3 pero sólo para los 

lenguajes que sean oficiales en

el pais (valor de T de isoficial).

*/

SELECT c.CODE , c.NAME , l."LANGUAGE", l.PERCENTAGE , l.ISOFFICIAL || '%'    

FROM COUNTRY c INNER JOIN COUNTRYLANGUAGE l 

ON c.CODE = l.COUNTRYCODE WHERE l.ISOFFICIAL = 'T';

/*

5\. Misma consulta que en el ejercicio 2 pero sólo para ciudades 

de más de 1.000.000 de

habitantes.

*/

SELECT c.CONTINENT AS continente, c.NAME AS pais, c2.NAME AS ciudad,

c2.POPULATION AS poblacion_ciudad 

FROM COUNTRY c 

INNER JOIN CITY c2 ON c.CODE = c2.COUNTRYCODE

WHERE c2.POPULATION > 1000000

ORDER BY c.NAME ASC, c2.POPULATION DESC ;

/*

6\. Misma consulta que en el ejercicio 2 pero sólo para ciudades de 

más de 1.000.000 de

habitantes y cuyo nombre empiece por M.

*/

SELECT c.CONTINENT AS continente, c.NAME AS pais, c2.NAME AS ciudad,

c2.POPULATION AS poblacion_ciudad 

FROM COUNTRY c 

INNER JOIN CITY c2 ON c.CODE = c2.COUNTRYCODE

WHERE c2.POPULATION > 1000000 AND c2.NAME LIKE 'M%'

ORDER BY c.NAME ASC, c2.POPULATION DESC ;

/*
7\. Misma consulta que en el ejercicio 2 pero sólo para ciudades entre 500.000 y

1.000.000 de habitantes, cuyo nombre empiece por M y cuyo país contenga la letra i

en cualquier posición.

*/
SELECT c.CONTINENT AS continente, c.NAME AS pais, c2.NAME AS ciudad,
c2.POPULATION AS poblacion_ciudad 
FROM COUNTRY c 
INNER JOIN CITY c2 ON c.CODE = c2.COUNTRYCODE 
WHERE c2.POPULATION BETWEEN 500000 AND 1000000
ORDER BY c.NAME ASC, c2.POPULATION DESC ;
/*
8\. Devuelve un listado de las ciudades de Asia de más de 
2.000.000 y las ciudades de
América de más de 1.000.000. Ordena la consulta por población 
de la ciudad
descendente
*/
SELECT c.name, c2.CONTINENT, c.POPULATION   FROM CITY c 
INNER JOIN COUNTRY c2 ON c2.CODE = c.COUNTRYCODE 
WHERE (c2.CONTINENT IN ('Asia') AND c.POPULATION > 2000000) 
OR (c2.CONTINENT IN ('North America') AND c.population > 1000000)
ORDER BY c.POPULATION DESC ;
/*
9\. Devuelve un listado de las ciudades de Asia de más de 2.000.000 y las ciudades de
América de más de 1.000.000, y en ambos casos que estén en países de más
50.000.000 de personas. Ordena la consulta por población de la ciudad descendente
*/
SELECT c.name, c2.CONTINENT, c.POPULATION, c2.population   FROM CITY c 
INNER JOIN COUNTRY c2 ON c2.CODE = c.COUNTRYCODE 
WHERE (c2.population > 50000000) AND ((c2.CONTINENT IN ('Asia') AND c.POPULATION > 2000000) 
OR (c2.CONTINENT IN ('North America') AND c.population > 1000000))
ORDER BY c.POPULATION DESC ;
/*
10\. Devuelve un listado de las ciudades cuyo nombre empieza por la misma letra que la
forma de gobierno de su país.
*/
SELECT c.name, t.GOVERNMENTFORM  FROM city c 
INNER JOIN country t 
ON t.code = c.countrycode 
WHERE SUBSTR(C.name,1,1) = substr(t.governmentform,1,1);
/*
11\. Devuelve un listado con los distintos países (el nombre, esperanza de vida y población)
en los que haya una ciudad cuyo nombre contenga ‘YORK’.
*/
SELECT co.name, co.LIFEEXPECTANCY , co.POPULATION  FROM country co 
INNER JOIN city ci ON ci.countrycode = co.code 
WHERE lower(ci.name) LIKE '%york%';
/*
12\. Devuelve un listado de las ciudades en las que la población del país es divisible
exactamente por la población de la ciudad (el resto de esa división es 0). En el listado
queremos ver el nombre del país, población del país, nombre de la ciudad y población
de la ciudad.
*/
SELECT country.name, country.population FROM city INNER JOIN country
ON city.countrycode = country.code 
WHERE  MOD(country.population,city.population)  = 0;
/*
13\. Devuelve un listado con nombre de la ciudad, nombre del país y esperanza de vida
para aquellos países cuya esperanza de vida es mayor de 80 años y donde los
caracteres 2 y 3 del nombre del país coinciden con los caracteres 2 y 3 del nombre de
la ciudad.
*/
SELECT c.name, c2.name, c2.lifeexpectancy FROM city c 
INNER JOIN country c2 
ON c.COUNTRYCODE  = c2.code 
WHERE c2.LIFEEXPECTANCY > 80 
AND SUBSTR(c2.NAME ,2,3)=SUBSTR(c.NAME ,2,3);

/*
14\. Devuelve un listado de los países donde se habla inglés,
no como lengua oficial, por al
menos un 40% de la población.
*/
SELECT c.NAME from COUNTRY c inner join COUNTRYLANGUAGE l
on c.CODE = l.COUNTRYCODE
where l.PERCENTAGE > 40
AND l.ISOFFICIAL IN ('F');
/*
15\. Devuelve un listado de las ciudades cuya población es la
menos la mitad de la
población del país en el que están.*/
SELECT c.NAME , c.POPULATION ,c2.POPULATION  FROM CITY c INNER JOIN COUNTRY c2 
ON c2.CODE = c.COUNTRYCODE 
WHERE (c2.POPULATION * 0.5) <= c.POPULATION ;