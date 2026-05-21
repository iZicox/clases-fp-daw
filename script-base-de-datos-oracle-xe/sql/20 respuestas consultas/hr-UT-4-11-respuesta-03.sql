--
--1
--
--Automatic Zoom
--EJERCICIOS HR
--1. Devuelve el nombre del empleado que más gana

SELECT * 
FROM EMPLOYEES e 
where e.SALARY = (SELECT MAX(e1.salary) FROM EMPLOYEES e1);
--2. Devuelve el nombre del empleado que más gana de cada departamento. Añade al listado el
--nombre del departamento.
SELECT 
        (
            select d2.department_name
            from DEPARTMENTS d2
            where d2.DEPARTMENT_ID = stat.DEPARTMENT_id
        ) as departamento,
        e.FIRST_NAME as mvp
FROM (
    SELECT d1.DEPARTMENT_id, max(e1.salary) as max_sal
    FROM DEPARTMENTS d1
    JOIN EMPLOYEES e1 ON e1.DEPARTMENT_ID = d1.DEPARTMENT_ID
    group by d1.DEPARTMENT_id
) stat 
JOIN EMPLOYEES e ON e.DEPARTMENT_id = stat.DEPARTMENT_id and e.SALARY = stat.max_sal;
--3. Devuelve un listado con nombre del departamento, nombre del empleado y salario para
--todos los empleados que ganen más que la media de la empresa.
SELECT d.DEPARTMENT_NAME, e.FIRST_NAME, e.SALARY
FROM DEPARTMENTS d 
JOIN EMPLOYEES e ON e.DEPARTMENT_id = d.DEPARTMENT_id
where e.SALARY > (
    select avg(e2.salary)
    from EMPLOYEES e2
);
--4. Devuelve un listado con nombre del departamento, nombre del empleado y salario para
--todos los empleados que ganen más que la media de su departamento.
SELECT stat.DEPARTMENT_NAME, e.FIRST_NAME, e.SALARY
FROM (
    SELECT d2.DEPARTMENT_ID, d2.DEPARTMENT_NAME, avg(e2.SALARY) as sal_media
    FROM DEPARTMENTS d2 
    JOIN EMPLOYEES e2 ON e2.DEPARTMENT_ID = d2.DEPARTMENT_ID
    group by d2.DEPARTMENT_ID, d2.DEPARTMENT_NAME
) stat
JOIN EMPLOYEES e ON e.DEPARTMENT_ID = stat.DEPARTMENT_ID and e.SALARY > stat.sal_media
order by stat.DEPARTMENT_NAME, e.SALARY;

SELECT d.DEPARTMENT_NAME, e.FIRST_NAME, e.SALARY
FROM DEPARTMENTS d 
JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE e.SALARY > (
    SELECT AVG(e2.SALARY)
    FROM EMPLOYEES e2
    WHERE e2.DEPARTMENT_ID = d.DEPARTMENT_ID
) order by d.DEPARTMENT_NAME, e.SALARY
;
--5. Haz un listado con nombre del puesto, nombre del empleado y fecha de contratación para el
--empleado más antiguo por cada puesto de trabajo.
SELECT stat.JOB_TITLE, e.FIRST_NAME, e.HIRE_DATE
FROM (
    SELECT j1.JOB_ID, j1.JOB_TITLE, MIN(e1.HIRE_DATE) as antiguo
    FROM EMPLOYEES e1 
    JOIN JOBS j1 ON j1.JOB_ID = e1.JOB_ID
    GROUP BY j1.JOB_ID, j1.JOB_TITLE
) stat 
JOIN EMPLOYEES e ON e.HIRE_DATE = stat.antiguo and e.JOB_ID = stat.JOB_ID
order by stat.JOB_TITLE;

SELECT 
        j.JOB_TITLE, e.FIRST_NAME, e.HIRE_DATE
FROM EMPLOYEES e 
JOIN JOBS j ON j.JOB_ID = e.JOB_ID
WHERE e.HIRE_DATE = (
    SELECT MIN(e2.HIRE_DATE)
    FROM EMPLOYEES e2
    WHERE e2.JOB_ID = j.JOB_ID
);
--6. Haz un listado con nombre del departamento, nombre del empleado y salario para todos los
--empleados en cuyo departamento haya algún empleado que gane menos que ellos.
SELECT d.DEPARTMENT_NAME, e.FIRST_NAME, e.SALARY
FROM DEPARTMENTS d 
JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE EXISTS (
    SELECT 1
    FROM EMPLOYEES e2
    WHERE e2.DEPARTMENT_ID = d.DEPARTMENT_ID
    and e2.SALARY > e.SALARY
) order by d.DEPARTMENT_NAME;

--7 Haz un listado de las ciudades en las que no está ubicado ningún departamento
SELECT l.city
FROM LOCATIONS l 
LEFT JOIN DEPARTMENTS d ON d.LOCATION_ID = l.LOCATION_ID
WHERE d.DEPARTMENT_ID is NULL;

SELECT l.CITY
FROM LOCATIONS l 
WHERE not EXISTS (
    SELECT 1 
    FROM DEPARTMENTS d1
    WHERE d1.LOCATION_ID = l.LOCATION_ID
);
--8 Haz un listado con el puesto de trabajo, nombre del puesto, y todos los empleados
--pertenecientes a este puesto menos el último que se ha contratado.
SELECT j1.JOB_ID, MIN(e1.HIRE_DATE)
FROM EMPLOYEES e1 
JOIN JOBS j1 ON j1.JOB_ID = e1.JOB_ID
GROUP BY j1.JOB_ID;

SELECT j.JOB_ID, j.JOB_TITLE, e.*
FROM EMPLOYEES e 
JOIN JOBS j ON j.JOB_ID = e.JOB_ID
WHERE (j.JOB_ID, e.HIRE_DATE) not in (
    SELECT j1.JOB_ID, MIN(e1.HIRE_DATE)
    FROM EMPLOYEES e1 
    JOIN JOBS j1 ON j1.JOB_ID = e1.JOB_ID
    GROUP BY j1.JOB_ID
);
--9 Haz un listado con las ciudades, el empleado que más gana de cada ciudad (nombre, apellido
--y salario) y la diferencia de salario que hay entre el empleado que más gana y la media de
--salarios de su ciudad.
SELECT stat.city, emp.FIRST_NAME, emp.last_name, emp.salary, trunc(stat.mas_gana - stat.media,2) as diferencia
FROM (
    SELECT l2.city, MAX(e2.SALARY) as mas_gana, AVG(e2.SALARY) as media
    FROM LOCATIONS l2
    JOIN DEPARTMENTS d2 ON d2.LOCATION_ID = l2.LOCATION_ID 
    JOIN EMPLOYEES e2 ON e2.DEPARTMENT_ID = d2.DEPARTMENT_ID
    GROUP BY l2.city
) stat 
JOIN (
    SELECT e3.FIRST_NAME, e3.last_name ,e3.salary, l3.CITY
    FROM EMPLOYEES e3
    JOIN DEPARTMENTS d3 ON d3.DEPARTMENT_ID = e3.DEPARTMENT_ID 
    JOIN LOCATIONS l3 ON l3.LOCATION_ID = d3.LOCATION_ID
) emp ON emp.CITY = stat.city and emp.salary = stat.mas_gana;
--10 (difícil) Haz un listado con los departamentos cuya media de salarios está por encima de la
--media de salarios de la empresa. Incluye entre las columnas del listado dos que indiquen
--● Cuantos empleados del departamento tienen un salario por encima de la media de la
--empresa
--● Cuantos empleados del departamento tienen un salario por encima de la media del
--departamento.

SELECT stat.department_name, 
FROM (
    SELECT d2.DEPARTMENT_ID, d2.DEPARTMENT_NAME, AVG(e2.SALARY) as media_dep
    FROM DEPARTMENTS d2 
    JOIN EMPLOYEES e2 ON e2.DEPARTMENT_ID = d2.DEPARTMENT_ID
    GROUP BY d2.DEPARTMENT_ID, d2.DEPARTMENT_NAME
) stat
where stat.media_dep > (select avg(e3.salary) from employees e3);



SELECT d.DEPARTMENT_NAME,
        COUNT(e.EMPLOYEE_ID) as encima_media_empresa,
        (
            SELECT count(e3.EMPLOYEE_ID)
            FROM EMPLOYEES e3
            WHERE e3.SALARY > (
                SELECT AVG(e4.SALARY)
                FROM EMPLOYEES e4
                WHERE e4.DEPARTMENT_ID = d.DEPARTMENT_ID
            )
        )
FROM DEPARTMENTS d 
JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME, d.DEPARTMENT_NAME
HAVING AVG(e.SALARY) > (
    SELECT AVG(e2.SALARY)
    FROM EMPLOYEES e2
);
--11 Haz un listado que me de los trabajos que cumplan que la suma de los sueldos de los
--empleados de ese trabajo es superior a la suma de salario de los empleados que trabajan de
--IT_PROG. En el listado quiero ver descripción del trabajo, suma de salario de los trabajadores y
--fecha de contratación del empleado más antiguo que desempeña ese trabajo.
--12 (difícil) Haz un listado que me de el nombre y salario de un empleado y la diferencia salarial
--que tiene con la media del salario de los empleados que son jefes, pero sin considerar a su
--propio jefe.
--1