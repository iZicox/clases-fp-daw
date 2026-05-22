--
--3
--
--Automatic Zoom
--1.5.4 Consultas sobre una tabla 

--1.  Devuelve un listado con el primer apellido, segundo apellido y el nombre de 
--todos los alumnos. El listado deberá estar ordenado alfabéticamente de 
--menor a mayor por el primer apellido, segundo apellido y nombre. 
SELECT 
        p.APELLIDO1, p.APELLIDO2, p.NOMBRE
FROM PERSONA p
WHERE upper(p.TIPO) = 'ALUMNO'
order by p.APELLIDO1, p.APELLIDO2, p.NOMBRE;
--2.  Averigua el nombre y los dos apellidos de los alumnos que no han dado de 
--alta su número de teléfono en la base de datos. 
SELECT p.NOMBRE, p.APELLIDO1, p.APELLIDO2
FROM PERSONA p 
WHERE p.TELEFONO is null 
and lower(p.tipo) = 'alumno';
--3.  Devuelve el listado de los alumnos que nacieron en 1999. 
SELECT * 
FROM PERSONA p 
where EXTRACT(year from p.FECHA_NACIMIENTO) = '1999'
and p.TIPO = 'alumno';

SELECT * 
FROM PERSONA p 
where to_char(p.FECHA_NACIMIENTO, 'YYYY') = '1999'
and p.TIPO = 'alumno';
--4.  Devuelve el listado de profesores que no han dado de alta su número de 
--teléfono en la base de datos y además su nif termina en K. 
SELECT *
FROM PERSONA p 
WHERE p.TIPO = 'profesor'
AND p.TELEFONO is null
AND upper(p.NIF) like '%K';
--5.  Devuelve el listado de las asignaturas que se imparten en el primer 
--cuatrimestre, en el tercer curso del grado que tiene el identificador 7. 
SELECT * 
FROM ASIGNATURA a
WHERE a.CUATRIMESTRE = '1'
AND a.CURSO = '3'
AND a.ID_GRADO = '7';

--1.5.5 Consultas multitabla (Composición interna) 

--1.  Devuelve un listado con los datos de todas las alumnas que se han 
--matriculado alguna vez en el Grado en Ingeniería Informática (Plan 2015). 
SELECT * 
FROM grado;

SELECT distinct p.*
FROM PERSONA p 
JOIN ALUMNO_SE_MATRICULA_ASIGNATURA pivot ON pivot.id_alumno = p.ID
JOIN ASIGNATURA a ON a.ID = pivot.id_asignatura 
JOIN GRADO g ON g.ID = a.ID_GRADO
WHERE p.SEXO = 'M'
AND g.NOMBRE = 'Grado en Ingeniería Informática (Plan 2015)';
--2.  Devuelve un listado con todas las asignaturas ofertadas en el Grado en 
--Ingeniería Informática (Plan 2015). 
SELECT a.*
FROM ASIGNATURA a 
JOIN GRADO g ON g.ID = a.ID_GRADO
WHERE g.NOMBRE = 'Grado en Ingeniería Informática (Plan 2015)';
--3.  Devuelve un listado de los profesores junto con el nombre del departamento 
--al que están vinculados. El listado debe devolver cuatro columnas, primer 
--apellido, segundo apellido, nombre y nombre del departamento. El resultado 
--estará ordenado alfabéticamente de menor a mayor por los apellidos y el 
--nombre. 
SELECT p.NOMBRE, p.APELLIDO1, p.APELLIDO2, d.NOMBRE
FROM PERSONA p 
JOIN PROFESOR pf ON pf.ID_PROFESOR = p.ID 
JOIN DEPARTAMENTO d ON d.ID = pf.ID_DEPARTAMENTO
ORDER BY p.APELLIDO1, p.APELLIDO2, p.NOMBRE;
--4.  Devuelve un listado con el nombre de las asignaturas, año de inicio y año de 
--fin del curso escolar del alumno con nif 26902806M. 
SELECT a.NOMBRE, ce.ANYO_INICIO, ce.ANYO_FIN
FROM PERSONA p 
JOIN ALUMNO_SE_MATRICULA_ASIGNATURA pivot ON pivot.id_alumno = p.ID 
JOIN ASIGNATURA a ON a.ID = pivot.id_asignatura 
JOIN CURSO_ESCOLAR ce ON ce.ID = pivot.id_curso_escolar
WHERE p.NIF = '26902806M';
--5.  Devuelve un listado con el nombre de todos los departamentos que tienen 
--profesores que imparten alguna asignatura en el Grado en Ingeniería 
--Informática (Plan 2015). 
SELECT distinct d.NOMBRE
FROM PERSONA p
left join PROFESOR pf ON pf.ID_PROFESOR = p.id
left JOIN DEPARTAMENTO d ON d.ID = pf.ID_DEPARTAMENTO 
left JOIN ASIGNATURA a ON a.ID_PROFESOR = pf.ID_PROFESOR 
left JOIN GRADO g ON g.ID = a.ID_GRADO
WHERE g.NOMBRE = 'Grado en Ingeniería Informática (Plan 2015)';
--6.  Devuelve un listado con todos los alumnos que se han matriculado en alguna 
--asignatura durante el curso escolar 2018/2019. 
SELECT distinct p.*
FROM PERSONA p 
JOIN ALUMNO_SE_MATRICULA_ASIGNATURA ama ON ama.ID_ALUMNO = p.ID 
JOIN CURSO_ESCOLAR ce ON ce.ID = ama.ID_CURSO_ESCOLAR
WHERE ce.ANYO_INICIO = '2018' AND ce.ANYO_FIN = '2019';

--1.5.6 Consultas multitabla (Composición externa) 
--Resuelva todas las consultas utilizando las cláusulas LEFT JOIN y RIGHT JOIN. 

--1.  Devuelve un listado con los nombres de todos los profesores y los 
--departamentos que tienen vinculados. El listado también debe mostrar 
--aquellos profesores que no tienen ningún departamento asociado. El listado 
--debe devolver cuatro columnas, nombre del departamento, primer apellido, 
--segundo apellido y nombre del profesor. El resultado estará ordenado 
--alfabéticamente de menor a mayor por el nombre del departamento, apellidos 
--y el nombre. 
SELECT d.NOMBRE, p.APELLIDO1, p.APELLIDO2, p.NOMBRE
FROM PERSONA p 
LEFT JOIN PROFESOR pf ON pf.ID_PROFESOR = p.ID 
LEFT JOIN DEPARTAMENTO d ON d.ID = pf.ID_DEPARTAMENTO
WHERE p.TIPO = 'profesor'
ORDER BY d.nombre ASC, p.apellido1 ASC, p.apellido2 ASC, p.nombre ASC;

--2.  Devuelve un listado con los profesores que no están asociados a un 
--departamento. 
SELECT p.*
FROM PERSONA p 
LEFT JOIN PROFESOR pf ON pf.ID_PROFESOR = p.ID 
LEFT JOIN DEPARTAMENTO d ON d.ID = pf.ID_DEPARTAMENTO
WHERE p.TIPO = 'profesor'
AND d.ID is NULL;
--3.  Devuelve un listado con los departamentos que no tienen profesores 
--asociados. 
SELECT d.*
FROM DEPARTAMENTO d 
LEFT JOIN PROFESOR pf ON pf.ID_DEPARTAMENTO = d.ID
WHERE pf.ID_DEPARTAMENTO is null;
--4.  Devuelve un listado con los profesores que no imparten ninguna asignatura. 
SELECT p.*
FROM PERSONA p 
JOIN PROFESOR pf ON pf.ID_PROFESOR = p.ID 
LEFT JOIN ASIGNATURA a ON a.ID_PROFESOR = pf.ID_PROFESOR
WHERE a.ID_PROFESOR is null
and p.TIPO = 'profesor';
--5.  Devuelve un listado con las asignaturas que no tienen un profesor asignado. 
SELECT a.*
FROM ASIGNATURA a 
WHERE a.ID_PROFESOR is null;
--6.  Devuelve un listado con todos los departamentos que tienen alguna 
--asignatura que no se haya impartido en ningún curso escolar. El resultado 
--debe mostrar el nombre del departamento y el nombre de la asignatura que 
--no se haya impartido nunca. 
SELECT d.NOMBRE, a.NOMBRE
FROM DEPARTAMENTO d 
 JOIN PROFESOR pf ON pf.ID_DEPARTAMENTO = d.ID 
 JOIN ASIGNATURA a ON a.ID_PROFESOR = pf.ID_PROFESOR 
LEFT JOIN ALUMNO_SE_MATRICULA_ASIGNATURA ama ON ama.ID_ASIGNATURA = a.ID 
LEFT JOIN CURSO_ESCOLAR ce ON ce.ID = ama.ID_CURSO_ESCOLAR
WHERE ce.ID is null;

--1.5.7 Consultas resumen 

--1.  Devuelve el número total de alumnas que hay. 
SELECT COUNT(p.ID)
FROM PERSONA p 
WHERE p.TIPO = 'alumno';
--2.  Calcula cuántos alumnos nacieron en 1999. 
SELECT COUNT(p.ID)
FROM PERSONA p 
WHERE p.TIPO = 'alumno'
AND to_char(p.FECHA_NACIMIENTO,'YYYY') = '1999';
--3.  Calcula cuántos profesores hay en cada departamento. El resultado sólo 
--debe mostrar dos columnas, una con el nombre del departamento y otra con 
--el número de profesores que hay en ese departamento. El resultado sólo 
--debe incluir los departamentos que tienen profesores asociados y deberá 
--estar ordenado de mayor a menor por el número de profesores. 
SELECT d.NOMBRE, count(pf.ID_PROFESOR)
FROM DEPARTAMENTO d 
JOIN PROFESOR pf ON pf.ID_DEPARTAMENTO = d.ID
GROUP BY d.NOMBRE;
--4.  Devuelve un listado con todos los departamentos y el número de profesores 
--que hay en cada uno de ellos. Tenga en cuenta que pueden existir 
--departamentos que no tienen profesores asociados. Estos departamentos 
--también tienen que aparecer en el listado. 
SELECT d.NOMBRE, count(pf.ID_PROFESOR)
FROM DEPARTAMENTO d 
left JOIN PROFESOR pf ON pf.ID_DEPARTAMENTO = d.ID
GROUP BY d.NOMBRE;
--5.  Devuelve un listado con el nombre de todos los grados existentes en la base 
--de datos y el número de asignaturas que tiene cada uno. Tenga en cuenta 
--que pueden existir grados que no tienen asignaturas asociadas. Estos grados 
--también tienen que aparecer en el listado. El resultado deberá estar ordenado 
--de mayor a menor por el número de asignaturas. 
SELECT g.NOMBRE, COUNT(a.ID) 
FROM GRADO g 
left JOIN ASIGNATURA a ON a.ID_GRADO = g.ID
GROUP BY g.NOMBRE;
--6.  Devuelve un listado con el nombre de todos los grados existentes en la base 
--de datos y el número de asignaturas que tiene cada uno, de los grados que 
--tengan más de 40 asignaturas asociadas. 
SELECT g.NOMBRE, COUNT(a.ID) 
FROM GRADO g 
left JOIN ASIGNATURA a ON a.ID_GRADO = g.ID
GROUP BY g.NOMBRE HAVING COUNT(a.ID) > 40;
--7.  Devuelve un listado que muestre el nombre de los grados y la suma del 
--número total de créditos que hay para cada tipo de asignatura. El resultado 
--debe tener tres columnas: nombre del grado, tipo de asignatura y la suma de 
--los créditos de todas las asignaturas que hay de ese tipo. Ordene el resultado 
--de mayor a menor por el número total de crédidos. 
SELECT g.NOMBRE, a.TIPO, nvl(SUM(a.CREDITOS),0) as creditos
FROM GRADO g 
left JOIN ASIGNATURA a ON a.ID_GRADO = g.ID
GROUP BY g.NOMBRE, a.TIPO
ORDER BY creditos desc;
--8.  Devuelve un listado que muestre cuántos alumnos se han matriculado de 
--alguna asignatura en cada uno de los cursos escolares. El resultado deberá 
--mostrar dos columnas, una columna con el año de inicio del curso escolar y 
--otra con el número de alumnos matriculados. 
SELECT ce.ANYO_INICIO, COUNT(distinct p.ID)
FROM PERSONA p 
JOIN ALUMNO_SE_MATRICULA_ASIGNATURA ama ON ama.ID_ALUMNO = p.ID 
JOIN CURSO_ESCOLAR ce ON ce.ID = ama.ID_CURSO_ESCOLAR
WHERE p.TIPO = 'alumno'
GROUP BY ce.ANYO_INICIO;
--9.  Devuelve un listado con el número de asignaturas que imparte cada profesor. 
--El listado debe tener en cuenta aquellos profesores que no imparten ninguna 
--asignatura. El resultado mostrará cinco columnas: id, nombre, primer apellido, 
--segundo apellido y número de asignaturas. El resultado estará ordenado de 
--mayor a menor por el número de asignaturas. 

SELECT p.ID, p.NOMBRE, p.APELLIDO1, p.APELLIDO2, nvl(stat.materias,0)
FROM PERSONA p 
JOIN PROFESOR pf ON pf.ID_PROFESOR = p.ID
LEFT JOIN (
    SELECT a.ID_PROFESOR, COUNT(a.ID) as materias
    FROM ASIGNATURA a
    GROUP BY a.ID_PROFESOR
) stat ON stat.ID_PROFESOR = p.ID;

--1.5.8 Subconsultas 
--1.  Devuelve todos los datos del alumno más joven. 
SELECT *
FROM PERSONA
WHERE FECHA_NACIMIENTO = (
    SELECT MAX(p.FECHA_NACIMIENTO) 
    FROM PERSONA p 
    WHERE p.TIPO = 'alumno'
) AND TIPO = 'alumno' ;
--2.  Devuelve un listado con los profesores que no están asociados a un 
--departamento. 
SELECT p.*
FROM PERSONA p 
where p.id not in (
    SELECT pf.id_profesor FROM PROFESOR pf
)
and p.tipo = 'profesor';


insert into persona (id, nif,nombre, apellido1, apellido2, ciudad, direccion, telefono, fecha_nacimiento, sexo, tipo)
select  '25','123', 
        p.nombre,
        'Perez',
        'Sanchez',
        p.ciudad,
        p.direccion,
        '123456789',
        p.FECHA_NACIMIENTO,
        p.sexo,
        'profesor' 
from PERSONA p
where p.id = '2'


;

SELECT pf.id_profesor FROM PROFESOR pf;

SELECT pf.ID_PROFESOR FROM DEPARTAMENTO d
left JOIN PROFESOR pf  ON d.ID = pf.ID_DEPARTAMENTO
where pf.ID_PROFESOR is null;
--3.  Devuelve un listado con los departamentos que no tienen profesores 
--asociados. 
SELECT d.*
FROM DEPARTAMENTO d
WHERE d.ID NOT IN (
    SELECT pf.id_departamento
    FROM PROFESOR pf
);

SELECT d.* 
FROM DEPARTAMENTO d 
LEFT JOIN PROFESOR pf ON pf.ID_DEPARTAMENTO = d.ID
WHERE pf.ID_DEPARTAMENTO is null;
--4.  Devuelve un listado con los profesores que tienen un departamento asociado 
--y que no imparten ninguna asignatura. 
SELECT p.*
FROM PERSONA p 
JOIN PROFESOR pf ON pf.ID_PROFESOR = p.ID 
LEFT JOIN ASIGNATURA a ON a.ID_PROFESOR = pf.ID_PROFESOR
WHERE a.id is null;
--5.  Devuelve un listado con las asignaturas que no tienen un profesor asignado. 
SELECT *
FROM ASIGNATURA a 
WHERE a.ID_PROFESOR is null;

SELECT *
FROM ASIGNATURA a 
where not EXISTS (
    select 1 
    from PROFESOR pf
    where pf.ID_PROFESOR = a.ID_PROFESOR
);
--6.  Devuelve un listado con todos los departamentos que no han impartido 
--asignaturas en ningún curso escolar. 
SELECT distinct d.*
FROM DEPARTAMENTO d 
JOIN PROFESOR pf ON pf.ID_DEPARTAMENTO = d.ID 
LEFT JOIN ASIGNATURA a ON a.ID_PROFESOR = pf.ID_PROFESOR
WHERE a.ID is null;

SELECT distinct d.*
FROM DEPARTAMENTO d 
JOIN PROFESOR pf ON pf.ID_DEPARTAMENTO = d.ID 
LEFT JOIN ASIGNATURA a ON a.ID_PROFESOR = pf.ID_PROFESOR
WHERE NOT EXISTS (
    SELECT 1
    FROM ASIGNATURA a2
    WHERE a2.ID = a.ID
);
--7.  Devuelve el nombre y apellidos de los profesores cuya fecha de nacimiento 
--es anterior a la fecha de nacimiento media de los profesores de su propio 
--departamento. 


SELECT prof.nombre, prof.apellido1, prof.apellido2, stat.nombre_departamento
FROM (
    SELECT  d.ID as id_departamento, 
            d.NOMBRE as nombre_departamento, 
            AVG(
                MONTHS_BETWEEN(
                    p.FECHA_NACIMIENTO, TO_DATE('01/01/1900', 'DD/MM/YYYY')
                    )
                ) as media_fecha
    FROM PERSONA p 
    JOIN PROFESOR pf ON pf.ID_PROFESOR = p.ID 
    JOIN DEPARTAMENTO d ON d.ID = pf.ID_DEPARTAMENTO
    GROUP BY d.ID, d.NOMBRE
) stat 
JOIN (
    SELECT d2.ID as id_departamento, p2.fecha_nacimiento, p2.nombre,
            p2.apellido1, p2.apellido2
    FROM PERSONA p2
    JOIN PROFESOR pf2 ON pf2.ID_PROFESOR = p2.ID 
    JOIN DEPARTAMENTO d2 ON d2.ID = pf2.ID_DEPARTAMENTO
) prof ON prof.id_departamento = stat.id_departamento 
                AND  MONTHS_BETWEEN(
                            prof.fecha_nacimiento, TO_DATE('01/01/1900', 'DD/MM/YYYY')
                        ) < stat.media_fecha
;

--8.  Devuelve el nombre de la asignatura y su número de créditos, siempre que 
--dicho número de créditos sea mayor que el número de créditos medio de las 
--asignaturas que pertenecen al mismo grado que esa asignatura. 

SELECT a.NOMBRE, a.CREDITOS, stat.NOMBRE as grado, stat.media as media_creditos
FROM (
    SELECT g.ID, g.NOMBRE, AVG(nvl(a.CREDITOS,0)) as media
    FROM GRADO g 
    JOIN ASIGNATURA a ON a.ID_GRADO = g.ID
    GROUP BY g.ID, g.NOMBRE
) stat
JOIN ASIGNATURA a ON a.ID_GRADO = stat.ID AND a.CREDITOS > stat.media

;

select * from ASIGNATURA;
--9.  Devuelve el nombre de los alumnos que se han matriculado en el mismo 
--curso escolar en al menos 3 asignaturas diferentes.  
SELECT p.nombre, p.apellido1, p.apellido2
FROM persona p
JOIN (
    -- Subconsulta que identifica a los alumnos con al menos 3 matrículas en un mismo curso
    SELECT id_alumno
    FROM alumno_se_matricula_asignatura
    GROUP BY id_alumno, id_curso_escolar
    HAVING COUNT(id_asignatura) >= 3
) matriculados ON p.id = matriculados.id_alumno;
--10. Devuelve el nombre y apellidos de los alumnos que se han matriculado en 
--asignaturas de, al menos, 3 grados distintos a lo largo de toda su trayectoria. 
SELECT p.nombre, p.apellido1, p.apellido2
FROM persona p
JOIN (
    -- Subconsulta: identifica IDs de alumnos con 3 o más grados distintos
    SELECT m.id_alumno
    FROM alumno_se_matricula_asignatura m
    JOIN asignatura a ON m.id_asignatura = a.id
    GROUP BY m.id_alumno
    HAVING COUNT(DISTINCT a.id_grado) >= 3
) filtrados ON p.id = filtrados.id_alumno;
--11. Devuelve el nombre del departamento que tenga la mayor cantidad de 
--alumnos matriculados en asignaturas impartidas por profesores de dicho 
--departamento. 

--12. Devuelve el nombre de aquellos profesores que imparten asignaturas en 
--todos los grados que tienen asignaturas de tipo 'básica'. 
select p.* 
from persona p
where p.id in (
    select a.id_profesor
    from asignatura a 
    where a.tipo = 'básica'
);
--13. Devuelve el nombre del grado cuya media de edad de los alumnos 
--matriculados (considerando la fecha de nacimiento de la tabla persona) sea 
--la menor de toda la universidad. 

select g.nombre
from persona p 
join ALUMNO_SE_MATRICULA_ASIGNATURA ama on ama.id_alumno = p.id
join asignatura a on a.id = ama.id_asignatura 
join grado g on g.id = a.id_grado
group by g.nombre
having avg(
    MONTHS_BETWEEN(
        p.fecha_nacimiento, TO_DATE('01/01/1900', 'DD/MM/YYYY')
        )
    ) < (
        select avg(MONTHS_BETWEEN(
        p2.fecha_nacimiento, TO_DATE('01/01/1900', 'DD/MM/YYYY')
        )) from persona p2
    );

    

--14. Devuelve el nombre de todas las asignaturas que nunca han tenido ningún 
--alumno matriculado en ninguno de los cursos escolares registrados. 



select a.nombre 
from asignatura a 
left join ALUMNO_SE_MATRICULA_ASIGNATURA ama on ama.id_asignatura = a.id
where ama.ID_ALUMNO is null;

select a.nombre 
from asignatura a 
where not exists (
    select 1 
    from ALUMNO_SE_MATRICULA_ASIGNATURA ama
    where ama.ID_ASIGNATURA = a.id
);