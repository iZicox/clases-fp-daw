/*
1. Calcula el número total de países que hay en la tabla Paises
*/
SELECT COUNT (c.NAME ) total_paises FROM COUNTRY c ;
/*
2. Calcula el número total de ciudades que hay en la tabla Ciudades
*/
SELECT COUNT(c.NAME ) total_ciudades FROM CITY c ;
/*
3. Calcula la media de población de los Países
*/
SELECT MEDIAN(c.POPULATION ) FROM COUNTRY c ;  
/*
4. Saca el número de habitantes del país más poblado.
*/
SELECT MAX(c.POPULATION ) FROM COUNTRY c ;
/*
5. Saca el número de habitantes del país menos poblado.
*/
SELECT MIN(c.POPULATION ) FROM COUNTRY c ;
/*
6. Calcula la suma de la población de todos los países.
*/
SELECT SUM(c.POPULATION ) FROM COUNTRY c ;
/*
7. Calcula el número de habitantes del país más poblado, del menos poblado, la media de
población y la suma de población para los países de Europa.
*/
SELECT 
		MAX(c.POPULATION ),
		MIN(c.POPULATION ),
		MEDIAN(c.POPULATION ),
		SUM(c.POPULATION )
FROM COUNTRY c 
WHERE c.CONTINENT IN ('Europe');
/*
8. Calcula el número de habitantes del país más poblado, del menos poblado, la media de
población y la suma de población para las ciudades que estén en países de América.
*/
SELECT 
		MAX(c.POPULATION ),
		MIN(c.POPULATION ),
		MEDIAN(c.POPULATION ),
		SUM(c.POPULATION )
FROM CITY c 
WHERE c.CONTINENT IN ('Europe');
/*
9. Muestra el número total de personas que tiene cada continente. Se mostrará en dos
columnas, una con el nombre del continente y otra con el número total de personas. Debe
estar ordenado por el número total de personas descendente
10. Muestra la esperanza de vida más alta y más baja que tiene cada continente.
11. Calcula el número total de ciudades que tienen más de 1.000.000 de habitantes..
12. Calcula el número de países que tienen una ciudad de más de 1.000.000 de habitantes.
13. Lista todos los países para los que haya en la tabla de ciudades más 100 ciudades.
14. ¿Cuántas personas del mundo viven en un país en el que el español es un idioma oficial?
15. ¿Cuál es la esperanza de vida media de los países con más de 50 millones de habitantes?
(redondeando a 2 decimales)
16. Agrupando por continente saca la media de esperanza de vida (redondeando a 2
decimales).
17. Agrupando por continente saca la media de esperanza de vida (redondeando a 2 decimales)
de los paises cuya esperanza de vida es mayor que 70 años.
17. Agrupando por continente saca la media de esperanza de vida (redondeando a 2
decimales). Solo para continentes cuya esperanza de vida sea mayor que 70 años.
*/