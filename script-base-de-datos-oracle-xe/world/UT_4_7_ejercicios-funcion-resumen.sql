--1. Calcula el número total de países que hay en la tabla Paises
SELECT COUNT(*) FROM COUNTRY C;
--2. Calcula el número total de ciudades que hay en la tabla Ciudades
SELECT COUNT(*) FROM CITY X;
--3. Calcula la media de población de los Países
SELECT ROUND(SUM(POPULATION) / COUNT(*),2) FROM COUNTRY;
--4. Saca el número de habitantes del país más poblado.
SELECT NAME, POPULATION FROM COUNTRY
WHERE POPULATION = (SELECT MAX(POPULATION) FROM COUNTRY);

SELECT MAX(POPULATION) FROM COUNTRY;
--5. Saca el número de habitantes del país menos poblado.
SELECT NAME, POPULATION FROM COUNTRY 
WHERE POPULATION = (SELECT MIN(POPULATION) FROM COUNTRY);

SELECT MIN(POPULATION) FROM COUNTRY;
--6. Calcula la suma de la población de todos los países.
SELECT SUM(POPULATION) FROM COUNTRY;
--7. Calcula el número de habitantes del país más poblado, del menos poblado, la media de
--población y la suma de población para los países de Europa.
SELECT MAX(POPULATION), MIN(POPULATION), AVG(POPULATION), SUM(POPULATION) FROM COUNTRY
WHERE CONTINENT IN ('Europe');
--8. Calcula el número de habitantes del país más poblado, del menos poblado, la media de
--población y la suma de población para las ciudades que estén en países de América.

SELECT 
    MAX(ci.population),
    MIN(ci.population),
    AVG(ci.population),
    SUM(ci.population)
FROM city ci
JOIN country co ON ci.countrycode = co.code
WHERE co.continent IN ('South America', 'North America');


--9. Muestra el número total de personas que tiene cada continente. Se mostrará en dos
--columnas, una con el nombre del continente y otra con el número total de personas. Debe
--estar ordenado por el número total de personas descendente
SELECT CONTINENT, SUM(POPULATION) AS TOTAL FROM COUNTRY
GROUP BY CONTINENT 
ORDER BY TOTAL DESC;
--10. Muestra la esperanza de vida más alta y más baja que tiene cada continente.
SELECT CONTINENT, 
        MAX(LIFEEXPECTANCY) AS ALTA,
        MIN(LIFEEXPECTANCY) AS BAJA
FROM COUNTRY
GROUP BY CONTINENT;
--11. Calcula el número total de ciudades que tienen más de 1.000.000 de habitantes..
SELECT COUNT(*) FROM CITY
WHERE POPULATION > 1000000;
--12. Calcula el número de países que tienen una ciudad de más de 1.000.000 de habitantes.
SELECT COUNT(DISTINCT COUNTRYCODE) FROM CITY
WHERE POPULATION > 1000000;

--13. Lista todos los países para los que haya en la tabla de ciudades más 100 ciudades.
SELECT countrycode, COUNT(*) AS num_ciudades
FROM city
GROUP BY countrycode
HAVING COUNT(*) > 100;

--CON NOMBRES
SELECT co.name, COUNT(*) AS num_ciudades
FROM city ci
JOIN country co ON ci.countrycode = co.code
GROUP BY co.name
HAVING COUNT(*) > 100;

--14. ¿Cuántas personas del mundo viven en un país en el que el español es un idioma oficial?
SELECT SUM(POPULATION) FROM COUNTRY
INNER JOIN COUNTRYLANGUAGE 
    ON COUNTRYLANGUAGE.COUNTRYCODE = COUNTRY.CODE
WHERE COUNTRYLANGUAGE.ISOFFICIAL IN ('T')
    AND COUNTRYLANGUAGE.LANGUAGE IN ('Spanish');

-- LA BUENA
SELECT SUM(POPULATION) FROM COUNTRY
WHERE CODE IN (
    SELECT COUNTRYCODE 
    FROM COUNTRYLANGUAGE
    WHERE ISOFFICIAL = 'T' 
        AND LANGUAGE = 'Spanish'
);

--15. ¿Cuál es la esperanza de vida media de los países con más de 50 millones de habitantes?
--(redondeando a 2 decimales)
SELECT ROUND(AVG(LIFEEXPECTANCY),2) FROM COUNTRY
WHERE POPULATION > 50000000;
--16. Agrupando por continente saca la media de esperanza de vida (redondeando a 2
--decimales).
SELECT CONTINENT, ROUND(AVG(LIFEEXPECTANCY),2) FROM COUNTRY
GROUP BY CONTINENT;
--17. Agrupando por continente saca la media de esperanza de vida (redondeando a 2 decimales)
--de los paises cuya esperanza de vida es mayor que 70 años.
SELECT CONTINENT, ROUND(AVG(LIFEEXPECTANCY),2) FROM COUNTRY
WHERE LIFEEXPECTANCY > 70
GROUP BY CONTINENT;
--18. Agrupando por continente saca la media de esperanza de vida (redondeando a 2
--decimales). Solo para continentes cuya esperanza de vida sea mayor que 70 años..
SELECT ROUND(AVG(LIFEEXPECTANCY),2) FROM COUNTRY
GROUP BY CONTINENT
HAVING AVG(LIFEEXPECTANCY) > 70;
