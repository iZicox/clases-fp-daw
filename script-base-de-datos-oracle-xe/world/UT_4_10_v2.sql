
-- 1

-- Automatic Zoom
-- EJERCICIOS WORLD
-- Para estos ejercicios cuando hablamos de continente nos referimos al campo de la tabla, no a
-- lo que entendemos por continentes.
-- 1. Devuelve las ciudades cuya población sea mayor que la ciudad más poblada de América.
SELECT CI.NAME
FROM CITY CI
WHERE CI.POPULATION > (
    SELECT MAX(CI2.POPULATION)
    FROM CITY CI2
    INNER JOIN COUNTRY CO2
        ON CO2.CODE = CI2.COUNTRYCODE
    WHERE UPPER(CO2.CONTINENT) IN ('NORTH AMERICA','SOUTH AMERICA')
);

SELECT DISTINCT CONTINENT, CODE FROM COUNTRY;
-- 2. Devuelve país, esperanza de vida, superficie y población del país más pequeño.
SELECT  
        CO.NAME,
        CO.LIFEEXPECTANCY,
        CO.SURFACEAREA,
        CO.POPULATION
FROM COUNTRY CO
WHERE CO.SURFACEAREA = (
    SELECT MIN(CO2.SURFACEAREA)
    FROM COUNTRY CO2
);

SELECT  
        CO.NAME,
        CO.LIFEEXPECTANCY,
        CO.SURFACEAREA,
        CO.POPULATION
FROM COUNTRY CO
WHERE CO.CODE = (
    SELECT CO2.CODE
    FROM COUNTRY CO2
    ORDER BY CO2.SURFACEAREA ASC
    FETCH FIRST 1 ROW ONLY
);
-- 3. Devuelve país, esperanza de vida, superficie y población del país más pequeño por cada
-- continente.
SELECT 
        C.NAME,
        C.LIFEEXPECTANCY,
        C.SURFACEAREA,
        C.POPULATION
FROM COUNTRY C
WHERE C.SURFACEAREA = (
    SELECT MIN(C2.SURFACEAREA)
    FROM COUNTRY C2
    GROUP BY C2.CONTINENT
    HAVING C2.CONTINENT = C.CONTINENT
);
        
SELECT 
        C.NAME,
        C.LIFEEXPECTANCY,
        C.SURFACEAREA,
        C.POPULATION
FROM COUNTRY C
WHERE C.SURFACEAREA = (
    SELECT MIN(C2.SURFACEAREA)
    FROM COUNTRY C2
    WHERE C2.CONTINENT = C.CONTINENT
);
-- 4. Devuelve cuantas ciudades hay cuya población está por encima de la media de población de
-- las ciudades.
SELECT 
        COUNT(*)
FROM CITY
WHERE POPULATION > (
    SELECT AVG(POPULATION)
    FROM CITY
);
-- 5. Devuelve los datos del país cuyo año de independencia sea el más alto.
SELECT  
        C.NAME,
        C.CONTINENT,
        C.INDEPYEAR
FROM COUNTRY C
WHERE C.INDEPYEAR = (SELECT MAX(C2.INDEPYEAR) 
                        FROM COUNTRY C2);

-- 6. Devuelve los datos del país cuyo año de independencia sea el más alto para cada forma de
-- gobierno.
SELECT 
        C.NAME,
        C.GOVERNMENTFORM,
        C.INDEPYEAR
FROM COUNTRY C
WHERE C.INDEPYEAR = (
    SELECT MAX(C2.INDEPYEAR)
    FROM COUNTRY C2
    WHERE C2.GOVERNMENTFORM = C.GOVERNMENTFORM
);
-- 7. Por cada país devuelve el nombre del país, nombre de la ciudad más poblada de ese país y el
-- lenguaje más hablado en ese país.
SELECT 
        C.NAME,
        CI.NAME AS CIUDAD_MAS_POBLADA,
        CL.LANGUAGE AS IDIOMA_MAS_HABLADO
FROM COUNTRY C
INNER JOIN CITY CI ON CI.COUNTRYCODE = C.CODE 
INNER JOIN COUNTRYLANGUAGE CL ON CL.COUNTRYCODE = C.CODE 
WHERE CI.POPULATION = (SELECT MAX(CI2.POPULATION)
                        FROM CITY CI2
                        WHERE CI2.COUNTRYCODE = C.CODE)
AND CL.PERCENTAGE = (SELECT MAX(CL2.PERCENTAGE)
                        FROM COUNTRYLANGUAGE CL2
                        WHERE CL2.COUNTRYCODE = C.CODE);
-- 8. Saca un listado donde se vean los continentes, el número de países de cada continente, el
-- número de ciudades de cada continente (de las que tenemos en las tablas), el número de
-- países de cada continente cuya esperanza de vida es mayor a la media de la esperanza de vida
-- del mundo y el número de países de cada continente cuya esperanza de vida es superior a la
-- media del continente.
SELECT
        C.CONTINENT,
        COUNT(DISTINCT C.CODE) AS NUM_CO_CONT,
        (SELECT COUNT(*) FROM CITY CI2
                            INNER JOIN COUNTRY C3 
                                ON C3.CODE = CI2.COUNTRYCODE 
                            WHERE C3.CONTINENT = C.CONTINENT ) AS NUM_CI_CONT,
        SUM(
            CASE
                WHEN C.LIFEEXPECTANCY > (SELECT AVG(C2.LIFEEXPECTANCY)
                                            FROM COUNTRY C2)
                    THEN 1 ELSE 0
                END) AS PAISES_ENCIMA_MEDIA_MUNDIAL,
        SUM(
            CASE
                WHEN C.LIFEEXPECTANCY > (SELECT AVG(C2.LIFEEXPECTANCY)
                                            FROM COUNTRY C2
                                            WHERE C2.CONTINENT = C.CONTINENT)
                    THEN 1 ELSE 0
                END
        )AS PAISES_ENCIMA_MEDIA_CONT
FROM COUNTRY C 
GROUP BY C.CONTINENT;

-- 9. Saca por cada continente el nombre del continente, el nombre del país más grande y el
-- nombre del país más pequeño.
SELECT
        C.CONTINENT,
        (SELECT C2.NAME
        FROM COUNTRY C2
        WHERE C2.CONTINENT = C.CONTINENT
        ORDER BY C2.SURFACEAREA DESC
        FETCH FIRST 1 ROW ONLY) AS MAS_GRANDE_DEL_CONTIENENTE,
        (SELECT C2.NAME
        FROM COUNTRY C2
        WHERE C2.CONTINENT = C.CONTINENT
        ORDER BY C2.SURFACEAREA ASC
        FETCH FIRST 1 ROW ONLY) AS MAS_PEQUENO_DEL_CONTIENENTE
FROM COUNTRY C 
GROUP BY C.CONTINENT;
-- 10. A la consulta anterior añade un campo con la población de la ciudad más poblada del país
-- más grande.

SELECT
        C.CONTINENT,
        (SELECT C2.NAME
        FROM COUNTRY C2
        WHERE C2.CONTINENT = C.CONTINENT
        ORDER BY C2.SURFACEAREA DESC
        FETCH FIRST 1 ROW ONLY) AS MAS_GRANDE_DEL_CONTIENENTE,

        (SELECT C2.NAME
        FROM COUNTRY C2
        WHERE C2.CONTINENT = C.CONTINENT
        ORDER BY C2.SURFACEAREA ASC
        FETCH FIRST 1 ROW ONLY) AS MAS_PEQUENO_DEL_CONTIENENTE,

        (SELECT MAX(CI.POPULATION)
        FROM CITY CI 
        WHERE CI.COUNTRYCODE = (SELECT C3.CODE
                                FROM COUNTRY C3
                                WHERE C3.CONTINENT = C.CONTINENT
                                ORDER BY C3.SURFACEAREA DESC
                                FETCH FIRST 1 ROW ONLY)
                                ) AS POLACION_CIUDAD_MAS_GRANDE

FROM COUNTRY C 
GROUP BY C.CONTINENT;
-- BONUS TRACK
-- -- 11. A la consulta anterior añade un campo con el nombre de la ciudad más poblada del país
-- -- más grande.
SELECT
        C.CONTINENT,
        (SELECT C2.NAME
        FROM COUNTRY C2
        WHERE C2.CONTINENT = C.CONTINENT
        ORDER BY C2.SURFACEAREA DESC
        FETCH FIRST 1 ROW ONLY) AS MAS_GRANDE_DEL_CONTIENENTE,

        (SELECT C2.NAME
        FROM COUNTRY C2
        WHERE C2.CONTINENT = C.CONTINENT
        ORDER BY C2.SURFACEAREA ASC
        FETCH FIRST 1 ROW ONLY) AS MAS_PEQUENO_DEL_CONTIENENTE,

        (SELECT MAX(CI.POPULATION)
        FROM CITY CI 
        WHERE CI.COUNTRYCODE = (SELECT C3.CODE
                                FROM COUNTRY C3
                                WHERE C3.CONTINENT = C.CONTINENT
                                ORDER BY C3.SURFACEAREA DESC
                                FETCH FIRST 1 ROW ONLY)
                                ) AS POLACION_CIUDAD_MAS_GRANDE,
            
        (SELECT CI.NAME
        FROM CITY CI
        WHERE CI.POPULATION = (SELECT MAX(CI.POPULATION)
                                FROM CITY CI 
                                WHERE CI.COUNTRYCODE = (SELECT C3.CODE
                                                        FROM COUNTRY C3
                                                        WHERE C3.CONTINENT = C.CONTINENT
                                                        ORDER BY C3.SURFACEAREA DESC
                                                        FETCH FIRST 1 ROW ONLY)
                                                        ))

FROM COUNTRY C 
GROUP BY C.CONTINENT;