-- 7. Por cada pais devuelve el nombre del pais, 
--nombre de la ciudad mas poblada de ese pais y el 
--lenguaje mas hablado en ese pais

SELECT
  c.NAME AS PAIS,
  ci.NAME AS CIUDAD_MAS_POBLADA,
  cl.LANGUAGE AS LENGUA_MAS_HABLADA
FROM WORLD.COUNTRY c
JOIN (
  SELECT COUNTRYCODE, NAME, POPULATION
  FROM WORLD.CITY ci1
  WHERE POPULATION = (
    SELECT MAX(POPULATION)
    FROM WORLD.CITY ci2
    WHERE ci2.COUNTRYCODE = ci1.COUNTRYCODE
  )
) ci ON c.CODE = ci.COUNTRYCODE
JOIN (
  SELECT COUNTRYCODE, LANGUAGE
  FROM WORLD.COUNTRYLANGUAGE cl1
  WHERE PERCENTAGE = (
    SELECT MAX(PERCENTAGE)
    FROM WORLD.COUNTRYLANGUAGE cl2
    WHERE cl2.COUNTRYCODE = cl1.COUNTRYCODE
  )
) cl ON c.CODE = cl.COUNTRYCODE
ORDER BY c.NAME;

select co.name as pais, ci.name as ciudad
from country co
join city ci on co.code = ci.COUNTRYCODE
join 
    (select countrycode, max(population) as mayor_pob
    from city
    group by COUNTRYCODE) 
poblacion_x_pais
on ci.COUNTRYCODE = poblacion_x_pais.countrycode 
and ci.POPULATION = pobacion_x_pais.mayor_pob
join
    (select COUNTRYCODE, max(PERCENTAGE) as mayor_len
    from countrylanguage 
    group by countrycode)
len_x_pais
on cl.countrycode = len_x_pais.COUNTRYCODE 
and cl.percentage = len_x_pais.mayor_len;

select countrycode, max(population) as mayor_pob
from city
group by COUNTRYCODE;

-- 2

select *
from city
where population = 
(
    select  max(population) from city
);

select co.name as pais, ci.name as ciudad, 
cl.language as idioma
from country co
join city ci on co.code = ci.COUNTRYCODE
join countrylanguage cl on cl.COUNTRYCODE = co.code
where ci.population = 
(
    select  max(population) from city ci2
    where ci.countrycode = ci2.countrycode
) and cl.percentage =
(
    select  max(cl2.percentage) from countrylanguage cl2
    where cl2.countrycode = cl.countrycode
) ;