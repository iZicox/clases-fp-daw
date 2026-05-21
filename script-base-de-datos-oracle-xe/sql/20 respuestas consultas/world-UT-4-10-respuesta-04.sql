--
--1
--
--Automatic Zoom
--EJERCICIOS WORLD
--Para estos ejercicios cuando hablamos de continente nos referimos al campo de la tabla, no a
--lo que entendemos por continentes.
--1. Devuelve las ciudades cuya población sea mayor que la ciudad más poblada de América.

select *
  from city c
 where c.population > (
   select max(c.population)
     from city c
     join country co
   on co.code = c.countrycode
    where co.continent in ( 'North America',
                            'South America' )
);



--2. Devuelve país, esperanza de vida, superficie y población del país más pequeño.

select co.name,
       co.lifeexpectancy,
       co.surfacearea,
       co.population
  from country co
 where co.surfacearea = (
   select min(co2.surfacearea)
     from country co2
);

--3. Devuelve país, esperanza de vida, superficie y población del país más pequeño por cada
--continente.

select co.name,
       co.lifeexpectancy,
       co.surfacearea,
       co.population,
       co.continent
  from country co
 where co.surfacearea in (
   select min(co2.surfacearea)
     from country co2
    where co.continent = co2.continent
 --   GROUP BY co2.CONTINENT
)
 order by co.continent;


--4. Devuelve cuantas ciudades hay cuya población está por encima de la media de población de
--las ciudades.

select count(*)
  from city c2
 where c2.population > (
   select avg(c.population)
     from city c
);

--5. Devuelve los datos del país cuyo año de independencia sea el más alto.

select *
  from country co
 where co.indepyear = (
   select max(co2.indepyear)
     from country co2
);

--6. Devuelve los datos del país cuyo año de independencia sea el más alto para cada forma de
--gobierno.

select *
  from country
 where ( governmentform,
         indepyear ) in (
   select governmentform,
          max(indepyear)
     from country
    group by governmentform
)
 order by code;

select *
  from country co2
 where co2.indepyear in (
   select max(co.indepyear)
     from country co
    where co.governmentform = co2.governmentform
)
 order by co2.code;


--7. Por cada país devuelve el nombre del país, nombre de la ciudad más poblada de ese país y el
--lenguaje más hablado en ese país.

select co.name,
       ci.name,
       cl.language
  from city ci
  join country co
on co.code = ci.countrycode
  join countrylanguage cl
on cl.countrycode = co.code
 where ci.population = (
      select max(ci2.population)
        from city ci2
       where ci2.countrycode = co.code
   )
   and cl.percentage = (
   select max(cl2.percentage)
     from countrylanguage cl2
    where cl2.countrycode = co.code
);

--8. Saca un listado donde se vean los continentes, el número de países de cada continente, el
--número de ciudades de cada continente (de las que tenemos en las tablas), el número de
--países de cada continente cuya esperanza de vida es mayor a la media de la esperanza de vida
--del mundo y el número de países de cada continente cuya esperanza de vida es superior a la
--media del continente.



SELECT co.CONTINENT,
        count(distinct co.code) paises, count(distinct c.id) ciudades,
        (
          select count(distinct co2.code)
          from COUNTRY co2
          where co2.LIFEEXPECTANCY > (select avg(co3.LIFEEXPECTANCY) from COUNTRY co3)
          and co2.CONTINENT = co.CONTINENT
        ) as paises_esperanza_mayor_media_mundial,
        (
          select count(distinct co2.code)
          from COUNTRY co2
          where co2.LIFEEXPECTANCY > (
            select avg(co3.LIFEEXPECTANCY)
            from COUNTRY co3
            where co3.CONTINENT = co.CONTINENT
          )
          and co2.CONTINENT = co.CONTINENT
        ) as paises_esperanza_mayor_media_continente
FROM CITY c 
JOIN COUNTRY co ON c.COUNTRYCODE = co.CODE
GROUP BY co.CONTINENT;


--9. Saca por cada continente el nombre del continente, el nombre del país más grande y el
--nombre del país más pequeño.

select distinct co.continent,
       (
          select co2.name
            from country co2
           where co2.surfacearea = (
                select max(co3.surfacearea)
                  from country co3
                 where co3.continent = co.continent
             )
             and co2.continent = co.continent
             AND ROWNUM = 1
       ) as ciudad_mas_grande,
       (
          select co2.name
            from country co2
           where co2.surfacearea = (
                select min(co3.surfacearea)
                  from country co3
                 where co3.continent = co.continent
             )
             and co2.continent = co.continent
             AND ROWNUM = 1
       ) as ciudad_mas_pequena
  from country co;


--10. A la consulta anterior añade un campo con la población de la ciudad más poblada del país
--más grande.

select distinct co.continent,
       (
            select ci2.population 
            from CITY ci2 
            JOIN COUNTRY co2 on co2.CODE = ci2.COUNTRYCODE
            where co2.SURFACEAREA = (
                SELECT max(co3.surfacearea)
                from COUNTRY co3
                WHERE co3.CONTINENT = co.CONTINENT
            ) and ci2.POPULATION = (
                select max(ci3.population)
                from CITY ci3
                join COUNTRY co4 on co4.CODE = ci3.COUNTRYCODE
                where co4.CONTINENT = co.CONTINENT
            ) and co2.CONTINENT = co.CONTINENT
       ) as pob_ciudad_mas_grande
  from country co;

--BONUS TRACK
--11. A la consulta anterior añade un campo con el nombre de la ciudad más poblada del país
--más grande.
--1
select distinct co.continent,
       (
            select ci2.population 
            from CITY ci2 
            JOIN COUNTRY co2 on co2.CODE = ci2.COUNTRYCODE
            where co2.SURFACEAREA = (
                SELECT max(co3.surfacearea)
                from COUNTRY co3
                WHERE co3.CONTINENT = co.CONTINENT
            ) and ci2.POPULATION = (
                select max(ci3.population)
                from CITY ci3
                join COUNTRY co4 on co4.CODE = ci3.COUNTRYCODE
                where co4.CONTINENT = co.CONTINENT
            ) and co2.CONTINENT = co.CONTINENT
       )
  from country co;