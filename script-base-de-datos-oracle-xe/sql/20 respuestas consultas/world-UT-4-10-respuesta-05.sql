--
--1
--
--Automatic Zoom
--EJERCICIOS WORLD
--Para estos ejercicios cuando hablamos de continente nos referimos al campo de la tabla, no a
--lo que entendemos por continentes.
--1. Devuelve las ciudades cuya población sea mayor que la ciudad más poblada de América.

SELECT c.*
FROM CITY c JOIN COUNTRY co ON co.CODE = c.COUNTRYCODE
where c.POPULATION > (
SELECT MAX(c2.population)
FROM city c2 
join COUNTRY co2 on co2.code = c2.COUNTRYCODE
where co2.CONTINENT in ('North America', 'South America')
)
;
--2. Devuelve país, esperanza de vida, superficie y población del país más pequeño.

SELECT co.NAME, co.LIFEEXPECTANCY, co.SURFACEAREA, co.POPULATION
FROM COUNTRY co
WHERE co.SURFACEAREA = (
SELECT MIN(co2.surfacearea)
FROM COUNTRY co2
where co2.LIFEEXPECTANCY is not null
) ;

SELECT co.NAME, co.LIFEEXPECTANCY, co.SURFACEAREA, co.POPULATION
FROM COUNTRY co
WHERE co.SURFACEAREA = (
SELECT MIN(co2.surfacearea)
FROM COUNTRY co2

) ;



--3. Devuelve país, esperanza de vida, superficie y población del país más pequeño por cada
--continente.

SELECT  co.CONTINENT,
        (
            SELECT co2.NAME 
            FROM COUNTRY co2 
            WHERE co2.CONTINENT = co.CONTINENT
            and co2.SURFACEAREA = (
                SELECT min(co3.SURFACEAREA)
                FROM COUNTRY co3
                WHERE co3.CONTINENT = co.CONTINENT
            )
        ) as pais,
        (
            SELECT nvl(co2.LIFEEXPECTANCY,0) 
            FROM COUNTRY co2 
            WHERE co2.CONTINENT = co.CONTINENT
            and co2.SURFACEAREA = (
                SELECT min(co3.SURFACEAREA)
                FROM COUNTRY co3
                WHERE co3.CONTINENT = co.CONTINENT
            )
        ) as esperanza_vida,
        (
            SELECT co2.SURFACEAREA
            FROM COUNTRY co2 
            WHERE co2.CONTINENT = co.CONTINENT
            and co2.SURFACEAREA = (
                SELECT min(co3.SURFACEAREA)
                FROM COUNTRY co3
                WHERE co3.CONTINENT = co.CONTINENT
            )
        ) as superficie,
        (
            SELECT co2.POPULATION
            FROM COUNTRY co2 
            WHERE co2.CONTINENT = co.CONTINENT
            and co2.SURFACEAREA = (
                SELECT min(co3.SURFACEAREA)
                FROM COUNTRY co3
                WHERE co3.CONTINENT = co.CONTINENT
            )
        ) as poblacion
FROM COUNTRY co 
GROUP BY co.CONTINENT;


SELECT  co.CONTINENT, co.NAME, co.LIFEEXPECTANCY, co.POPULATION, co.SURFACEAREA
FROM COUNTRY co 
WHERE (co.CONTINENT, co.SURFACEAREA) IN (
    SELECT co2.CONTINENT, MIN(co2.SURFACEAREA)
    FROM COUNTRY co2
    GROUP BY co2.CONTINENT
);

--4. Devuelve cuantas ciudades hay cuya población está por encima de la media de población de
--las ciudades.

SELECT COUNT(c.id)
FROM CITY c
WHERE c.POPULATION > (
    SELECT AVG(c2.POPULATION)
    FROM CITY c2 
);

--5. Devuelve los datos del país cuyo año de independencia sea el más alto.

SELECT * 
FROM COUNTRY co 
WHERE co.INDEPYEAR = (
    SELECT MAX(co2.INDEPYEAR)
    FROM COUNTRY co2
);

--6. Devuelve los datos del país cuyo año de independencia sea el más alto para cada forma de
--gobierno.

SELECT *
FROM COUNTRY co 
WHERE (co.GOVERNMENTFORM, co.INDEPYEAR) IN (
    SELECT co2.GOVERNMENTFORM, MAX(co2.INDEPYEAR)
    FROM COUNTRY co2
    GROUP BY co2.GOVERNMENTFORM
);

--7. Por cada país devuelve el nombre del país, nombre de la ciudad más poblada de ese país y el
--lenguaje más hablado en ese país.

SELECT  (
            SELECT co2.NAME
            FROM COUNTRY co2
            WHERE co2.CODE = co.CODE
        ) as pais,
        (
            SELECT c3.NAME 
            FROM COUNTRY co3 JOIN CITY c3 ON c3.COUNTRYCODE = co3.CODE
            WHERE c3.POPULATION = (
                SELECT MAX(c31.POPULATION)
                FROM CITY c31 JOIN COUNTRY co31 ON co31.CODE = c31.COUNTRYCODE
                WHERE co31.CODE = co.CODE
            )and co.code = co3.code and ROWNUM = 1
        ) as ciudad_mas_poblada,
        (
            SELECT cl4.LANGUAGE
            FROM COUNTRYLANGUAGE cl4 JOIN COUNTRY co4 ON co4.CODE = cl4.COUNTRYCODE
            WHERE cl4.PERCENTAGE = (
                SELECT MAX(cl41.PERCENTAGE)
                FROM COUNTRYLANGUAGE cl41 JOIN COUNTRY co41 ON co41.CODE = cl41.COUNTRYCODE
                WHERE co41.CODE = co.CODE
            ) and co.CODE = co4.code and rownum = 1
        ) as idioma
FROM COUNTRY co 
JOIN CITY c ON c.COUNTRYCODE = co.CODE
GROUP BY co.CODE;


SELECT 
    co.name AS pais, 
    mc.name AS ciudad_mas_poblada, 
    ml.language AS idioma
FROM country co
-- Join para obtener la ciudad con más población de cada país
LEFT JOIN (
    SELECT countrycode, name
    FROM city
    WHERE (countrycode, population) IN (
        SELECT countrycode, MAX(population)
        FROM city
        GROUP BY countrycode
    )
) mc ON co.code = mc.countrycode
-- Join para obtener el idioma más hablado de cada país
LEFT JOIN (
    SELECT countrycode, language
    FROM countrylanguage
    WHERE (countrycode, percentage) IN (
        SELECT countrycode, MAX(percentage)
        FROM countrylanguage
        GROUP BY countrycode
    )
) ml ON co.code = ml.countrycode;


--8. Saca un listado donde se vean los continentes, el número de países de cada continente, el
--número de ciudades de cada continente (de las que tenemos en las tablas), el número de
--países de cada continente cuya esperanza de vida es mayor a la media de la esperanza de vida
--del mundo y el número de países de cada continente cuya esperanza de vida es superior a la
--media del continente.
SELECT  co.CONTINENT, 
        COUNT(distinct co.CODE) as paises,    
        COUNT(distinct ci.id) as ciudades,
        le.paises, lec.paises
FROM COUNTRY co JOIN CITY ci ON ci.COUNTRYCODE = co.CODE
JOIN (
    SELECT co2.CONTINENT, COUNT(co2.CODE) as paises
    FROM COUNTRY co2 
    WHERE co2.LIFEEXPECTANCY > (
        SELECT AVG(co3.LIFEEXPECTANCY) FROM COUNTRY co3
    ) GROUP BY co2.CONTINENT
) le ON le.CONTINENT = co.CONTINENT
JOIN (
    SELECT co2.CONTINENT, COUNT(co2.CODE) as paises
    FROM COUNTRY co2 
    WHERE co2.LIFEEXPECTANCY > (
        SELECT AVG(co3.LIFEEXPECTANCY) FROM COUNTRY co3 WHERE co3.CONTINENT = co2.CONTINENT
    ) GROUP BY co2.CONTINENT
) lec ON lec.CONTINENT = co.CONTINENT
GROUP BY co.CONTINENT, le.paises, lec.paises;
--9. Saca por cada continente el nombre del continente, el nombre del país más grande y el
--nombre del país más pequeño.

select 
        st.continente, pg.name, pp.name
FROM (
    SELECT co.CONTINENT as continente, max(co.surfacearea) as p_mas_grande, min(co.surfacearea) as p_mas_pequeno
    FROM COUNTRY co group by co.continent
) st 
join country pg on pg.continent = st.continente and pg.surfacearea = st.p_mas_grande
join country pp on pp.continent = st.continente and pp.surfacearea = st.p_mas_pequeno;

select 
        st.continente,
        (
            select co2.name
            from country co2 
            where co2.surfacearea = st.p_mas_grande
            and rownum = 1
        ) as grande,
        (
            select co2.name
            from country co2 
            where co2.surfacearea = st.p_mas_pequeno
            and rownum = 1
        ) as pequeno
FROM (
    SELECT co.CONTINENT as continente, max(co.surfacearea) as p_mas_grande, min(co.surfacearea) as p_mas_pequeno
    FROM COUNTRY co group by co.continent
) st;


SELECT co.CONTINENT,
        (
            SELECT co2.NAME 
            FROM COUNTRY co2
            WHERE co2.SURFACEAREA = (
                SELECT max(co21.SURFACEAREA)
                FROM COUNTRY co21
                WHERE co21.CONTINENT = co.CONTINENT
            )
        ) as grande,
        (
            SELECT co2.NAME 
            FROM COUNTRY co2
            WHERE co2.SURFACEAREA = (
                SELECT min(co21.SURFACEAREA)
                FROM COUNTRY co21
                WHERE co21.CONTINENT = co.CONTINENT
            )
        ) as pequeno
FROM COUNTRY co 
group by co.CONTINENT;


--10. A la consulta anterior añade un campo con la población de la ciudad más poblada del país
--más grande.

SELECT co.CONTINENT,
        (
            SELECT co2.NAME 
            FROM COUNTRY co2
            WHERE co2.SURFACEAREA = (
                SELECT max(co21.SURFACEAREA)
                FROM COUNTRY co21
                WHERE co21.CONTINENT = co.CONTINENT
            )
        ) as grande,
        (
            SELECT co2.NAME 
            FROM COUNTRY co2
            WHERE co2.SURFACEAREA = (
                SELECT min(co21.SURFACEAREA)
                FROM COUNTRY co21
                WHERE co21.CONTINENT = co.CONTINENT
            )
        ) as pequeno,
        (
            SELECT ci3.POPULATION 
            FROM COUNTRY co3
            JOIN CITY ci3 ON ci3.COUNTRYCODE = co3.CODE
            WHERE ci3.POPULATION = (
                SELECT max(ci31.POPULATION)
                FROM COUNTRY co31
                JOIN CITY ci31 ON ci31.COUNTRYCODE = co31.CODE
                WHERE co31.CONTINENT = co.CONTINENT 
            ) 
        ) as poblacion_ciudad_mas_grande
FROM COUNTRY co 
group by co.CONTINENT;

select co.name, ci.name, ci.population
from city ci
join country co on co.code = ci.countrycode
where co.NAME like 'Rus%'
order by co.name, ci.population desc 
fetch first 1 rows only;
--BONUS TRACK
--11. A la consulta anterior añade un campo con el nombre de la ciudad más poblada del país
--más grande.
--1

SELECT co.CONTINENT,
        (
            SELECT co2.NAME 
            FROM COUNTRY co2
            WHERE co2.SURFACEAREA = (
                SELECT max(co21.SURFACEAREA)
                FROM COUNTRY co21
                WHERE co21.CONTINENT = co.CONTINENT
            )
        ) as grande,
        (
            SELECT co2.NAME 
            FROM COUNTRY co2
            WHERE co2.SURFACEAREA = (
                SELECT min(co21.SURFACEAREA)
                FROM COUNTRY co21
                WHERE co21.CONTINENT = co.CONTINENT
            )
        ) as pequeno,
        (
            SELECT ci3.POPULATION 
            FROM COUNTRY co3
            JOIN CITY ci3 ON ci3.COUNTRYCODE = co3.CODE
            WHERE ci3.POPULATION = (
                SELECT max(ci31.POPULATION)
                FROM COUNTRY co31
                JOIN CITY ci31 ON ci31.COUNTRYCODE = co31.CODE
                WHERE co31.CONTINENT = co.CONTINENT 
            ) 
        ) as poblacion_ciudad_mas_grande,
        (
            SELECT ci3.name 
            FROM COUNTRY co3
            JOIN CITY ci3 ON ci3.COUNTRYCODE = co3.CODE
            WHERE ci3.POPULATION = (
                SELECT max(ci31.POPULATION)
                FROM COUNTRY co31
                JOIN CITY ci31 ON ci31.COUNTRYCODE = co31.CODE
                WHERE co31.CONTINENT = co.CONTINENT 
            ) 
        ) as nombre_ciudad_mas_grande
FROM COUNTRY co 
group by co.CONTINENT;


SELECT 

    stats.continent, 
    c_max.name AS grande, 
    c_min.name AS pequeno, 
    ct_max.population AS poblacion_ciudad_mas_grande,
    ct_max.name AS nombre_ciudad_mas_grande

FROM (
    -- 1. Calculamos los valores de referencia por continente una sola vez
    SELECT 
        co.continent,
        MAX(co.surfacearea) AS max_surf,
        MIN(co.surfacearea) AS min_surf,
        MAX(ci.population) AS max_city_pop
    FROM country co
    LEFT JOIN city ci ON co.code = ci.countrycode
    GROUP BY co.continent
) stats
-- 2. "Pescamos" el nombre del país más grande
JOIN country c_max ON stats.continent = c_max.continent AND stats.max_surf = c_max.surfacearea
-- 3. "Pescamos" el nombre del país más pequeño
JOIN country c_min ON stats.continent = c_min.continent AND stats.min_surf = c_min.surfacearea
-- 4. "Pescamos" los datos de la ciudad más poblada del continente
JOIN city ct_max ON stats.max_city_pop = ct_max.population
JOIN country co_city ON ct_max.countrycode = co_city.code AND stats.continent = co_city.continent;

-- PARA PREVEENIR EMPATES
-- ADEMAS PODEMOS USAR LOS DATOS DE STATS PARA HACER CORRELATIVAS EN CADA CAMPO
SELECT 
    stats.continent, 
    -- Seleccionamos solo el primer nombre encontrado tras ordenar
    (SELECT name FROM country c2 
     WHERE c2.continent = stats.continent AND c2.surfacearea = stats.min_surf
     ORDER BY name ASC -- Criterio de desempate por orden alfabético
     FETCH FIRST 1 ROWS ONLY) AS pequeno,
    c_max.name AS grande, 
    ct_max.population AS poblacion_ciudad_mas_grande
FROM (
    SELECT co.continent, MAX(co.surfacearea) AS max_surf,
           MIN(co.surfacearea) AS min_surf, MAX(ci.population) AS max_city_pop
    FROM country co
    LEFT JOIN city ci ON co.code = ci.countrycode
    GROUP BY co.continent
) stats
JOIN country c_max ON stats.continent = c_max.continent AND stats.max_surf = c_max.surfacearea
JOIN city ct_max ON stats.max_city_pop = ct_max.population;