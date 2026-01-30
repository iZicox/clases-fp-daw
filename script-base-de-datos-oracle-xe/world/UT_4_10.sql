
--EJERCICIOS WORLD
--Para estos ejercicios cuando hablamos de continente nos referimos al campo de la tabla, no a
--lo que entendemos por continentes.
--1. Devuelve las ciudades cuya población sea mayor que la ciudad más poblada de América.
SELECT CITY.NAME, CITY.POPULATION FROM CITY
WHERE POPULATION > (
    SELECT MAX(CI.POPULATION)
    FROM COUNTRY C 
    INNER JOIN CITY CI
        ON C.CODE = CI.COUNTRYCODE
    WHERE UPPER(C.CONTINENT) IN ('NORTH AMERICA','SOUTH AMERICA')
);


--2. Devuelve país, esperanza de vida, superficie y población del país más pequeño.
SELECT NAME, LIFEEXPECTANCY, SURFACEAREA, POPULATION
FROM COUNTRY
WHERE SURFACEAREA = (
    SELECT MIN(SURFACEAREA)
    FROM COUNTRY C
);

--3. Devuelve país, esperanza de vida, superficie y población del país más pequeño por cada
--continente.

--4. Devuelve cuantas ciudades hay cuya población está por encima de la media de población de
--las ciudades.
--5. Devuelve los datos del país cuyo año de independencia sea el más alto.
--6. Devuelve los datos del país cuyo año de independencia sea el más alto para cada forma de
--gobierno.
--7. Por cada país devuelve el nombre del país, nombre de la ciudad más poblada de ese país y el
--lenguaje más hablado en ese país.
--8. Saca un listado donde se vean los continentes, el número de países de cada continente, el
--número de ciudades de cada continente (de las que tenemos en las tablas), el número de
--países de cada continente cuya esperanza de vida es mayor a la media de la esperanza de vida
--del mundo y el número de países de cada continente cuya esperanza de vida es superior a la
--media del continente.
--9. Saca por cada continente el nombre del continente, el nombre del país más grande y el
--nombre del país más pequeño.
--10. A la consulta anterior añade un campo con la población de la ciudad más poblada del país
--más grande.
--BONUS TRACK
--11. A la consulta anterior añade un campo con el nombre de la ciudad más poblada del país
--más grande.




--EJERCICIOS WORLD
--Para estos ejercicios cuando hablamos de continente nos referimos al campo de la tabla, no a
--lo que entendemos por continentes.
--1. Devuelve las ciudades cuya población sea mayor que la ciudad más poblada de América.
SELECT c.Name, c.Population
FROM City c
WHERE c.Population > (
    SELECT MAX(ca.Population)
    FROM City ca
    JOIN Country co ON ca.CountryCode = co.Code
    WHERE co.Continent IN ('North America', 'South America')
)
ORDER BY c.Population DESC;

--2. Devuelve país, esperanza de vida, superficie y población del país más pequeño.
SELECT co.Name AS pais,
       co.LifeExpectancy AS esperanza_vida,
       co.SurfaceArea AS superficie,
       co.Population AS poblacion
FROM Country co
WHERE co.SurfaceArea = (
    SELECT MIN(SurfaceArea)
    FROM Country
);

--3. Devuelve país, esperanza de vida, superficie y población del país más pequeño por cada continente.
SELECT co.Continent,
       co.Name AS pais,
       co.LifeExpectancy AS esperanza_vida,
       co.SurfaceArea AS superficie,
       co.Population AS poblacion
FROM Country co
JOIN (
    SELECT Continent, MIN(SurfaceArea) AS min_surface
    FROM Country
    GROUP BY Continent
) mins ON co.Continent = mins.Continent AND co.SurfaceArea = mins.min_surface
ORDER BY co.Continent, co.Name;

--4. Devuelve cuantas ciudades hay cuya población está por encima de la media de población de las ciudades.
SELECT COUNT(*) AS ciudades_sobre_media
FROM City
WHERE Population > (
    SELECT AVG(Population)
    FROM City
);

--5. Devuelve los datos del país cuyo año de independencia sea el más alto.
SELECT *
FROM Country
WHERE IndepYear = (
    SELECT MAX(IndepYear)
    FROM Country
);

--6. Devuelve los datos del país cuyo año de independencia sea el más alto para cada forma de gobierno.
SELECT co.*
FROM Country co
JOIN (
    SELECT GovernmentForm, MAX(IndepYear) AS max_indep
    FROM Country
    GROUP BY GovernmentForm
) mx ON co.GovernmentForm = mx.GovernmentForm AND co.IndepYear = mx.max_indep
ORDER BY co.GovernmentForm, co.Name;

--7. Por cada país devuelve el nombre del país, nombre de la ciudad más poblada de ese país y el lenguaje más hablado en ese país.
SELECT
  c.Name AS pais,
  ci.Name AS ciudad_mas_poblada,
  cl.Language AS lengua_mas_hablada
FROM Country c
JOIN (
  SELECT ci1.CountryCode, ci1.Name, ci1.Population
  FROM City ci1
  WHERE ci1.Population = (
    SELECT MAX(ci2.Population)
    FROM City ci2
    WHERE ci2.CountryCode = ci1.CountryCode
  )
) ci ON c.Code = ci.CountryCode
JOIN (
  SELECT cl1.CountryCode, cl1.Language
  FROM CountryLanguage cl1
  WHERE cl1.Percentage = (
    SELECT MAX(cl2.Percentage)
    FROM CountryLanguage cl2
    WHERE cl2.CountryCode = cl1.CountryCode
  )
) cl ON c.Code = cl.CountryCode
ORDER BY c.Name;

--8. Saca un listado donde se vean los continentes, el número de países de cada continente, el número de ciudades de cada continente (de las que tenemos en las tablas),
--   el número de países de cada continente cuya esperanza de vida es mayor a la media de la esperanza de vida del mundo
--   y el número de países de cada continente cuya esperanza de vida es superior a la media del continente.
WITH media_mundo AS (
    SELECT AVG(LifeExpectancy) AS avg_life_world
    FROM Country
    WHERE LifeExpectancy IS NOT NULL
), media_continente AS (
    SELECT Continent, AVG(LifeExpectancy) AS avg_life_continent
    FROM Country
    WHERE LifeExpectancy IS NOT NULL
    GROUP BY Continent
)
SELECT co.Continent,
       COUNT(DISTINCT co.Code) AS num_paises,
       COUNT(DISTINCT ci.ID) AS num_ciudades,
       SUM(CASE WHEN co.LifeExpectancy > (SELECT avg_life_world FROM media_mundo) THEN 1 ELSE 0 END) AS paises_sobre_media_mundo,
       SUM(CASE WHEN co.LifeExpectancy > mc.avg_life_continent THEN 1 ELSE 0 END) AS paises_sobre_media_continente
FROM Country co
LEFT JOIN City ci ON ci.CountryCode = co.Code
JOIN media_continente mc ON mc.Continent = co.Continent
GROUP BY co.Continent, mc.avg_life_continent
ORDER BY co.Continent;

--9. Saca por cada continente el nombre del continente, el nombre del país más grande y el nombre del país más pequeño.
WITH max_min AS (
    SELECT Continent,
           MAX(SurfaceArea) AS max_surface,
           MIN(SurfaceArea) AS min_surface
    FROM Country
    GROUP BY Continent
)
SELECT mm.Continent,
       co_max.Name AS pais_mas_grande,
       co_min.Name AS pais_mas_pequeno
FROM max_min mm
JOIN Country co_max ON co_max.Continent = mm.Continent AND co_max.SurfaceArea = mm.max_surface
JOIN Country co_min ON co_min.Continent = mm.Continent AND co_min.SurfaceArea = mm.min_surface
ORDER BY mm.Continent;

--10. A la consulta anterior añade un campo con la población de la ciudad más poblada del país más grande.
WITH max_min AS (
    SELECT Continent,
           MAX(SurfaceArea) AS max_surface,
           MIN(SurfaceArea) AS min_surface
    FROM Country
    GROUP BY Continent
), paises AS (
    SELECT mm.Continent,
           co_max.Code AS code_grande,
           co_max.Name AS pais_mas_grande,
           co_min.Name AS pais_mas_pequeno
    FROM max_min mm
    JOIN Country co_max ON co_max.Continent = mm.Continent AND co_max.SurfaceArea = mm.max_surface
    JOIN Country co_min ON co_min.Continent = mm.Continent AND co_min.SurfaceArea = mm.min_surface
)
SELECT p.Continent,
       p.pais_mas_grande,
       p.pais_mas_pequeno,
       (
           SELECT MAX(ci.Population)
           FROM City ci
           WHERE ci.CountryCode = p.code_grande
       ) AS poblacion_ciudad_mas_poblada_pais_grande
FROM paises p
ORDER BY p.Continent;

--BONUSTRACK
--11. A la consulta anterior añade un campo con el nombre de la ciudad más poblada del país más grande.
WITH max_min AS (
    SELECT Continent,
           MAX(SurfaceArea) AS max_surface,
           MIN(SurfaceArea) AS min_surface
    FROM Country
    GROUP BY Continent
), paises AS (
    SELECT mm.Continent,
           co_max.Code AS code_grande,
           co_max.Name AS pais_mas_grande,
           co_min.Name AS pais_mas_pequeno
    FROM max_min mm
    JOIN Country co_max ON co_max.Continent = mm.Continent AND co_max.SurfaceArea = mm.max_surface
    JOIN Country co_min ON co_min.Continent = mm.Continent AND co_min.SurfaceArea = mm.min_surface
)
SELECT p.Continent,
       p.pais_mas_grande,
       p.pais_mas_pequeno,
       (
           SELECT MAX(ci.Population)
           FROM City ci
           WHERE ci.CountryCode = p.code_grande
       ) AS poblacion_ciudad_mas_poblada_pais_grande,
       (
           SELECT ci.Name
           FROM City ci
           WHERE ci.CountryCode = p.code_grande
             AND ci.Population = (
                 SELECT MAX(ci2.Population)
                 FROM City ci2
                 WHERE ci2.CountryCode = p.code_grande
             )
       ) AS ciudad_mas_poblada_pais_grande
FROM paises p
ORDER BY p.Continent;