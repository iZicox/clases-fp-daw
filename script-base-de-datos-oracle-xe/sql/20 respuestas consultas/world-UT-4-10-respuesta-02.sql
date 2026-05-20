--
--1
--
--Automatic Zoom
--EJERCICIOS HR
--1. Devuelve el nombre del empleado que más gana

select e.first_name
  from employees e
 where e.salary = (
      select max(e2.salary)
        from employees e2
   )
   and rownum = 1;

--2. Devuelve el nombre del empleado que más gana de cada departamento. Añade al listado el
--nombre del departamento.

select d.department_name,
       e.first_name as empleado_mas_gana
  from employees e
  join departments d
on e.department_id = d.department_id
 where ( e.department_id,
         e.salary ) in (
   select department_id,
          max(salary)
     from employees
    group by department_id
)
 order by d.department_name;

---

select d.department_name,
       (
          select e2.first_name
            from employees e2
            join departments d2
          on d2.department_id = e2.department_id
           where e2.salary = (
                select max(e3.salary)
                  from employees e3
                  join departments d3
                on d3.department_id = e3.department_id
                 where d3.department_name = d.department_name
             )
             and d2.department_name = d.department_name
             and rownum = 1
       ) as empleado_mas_gana
  from employees e
  join departments d
on e.department_id = d.department_id
 group by d.department_name;

--3. Devuelve un listado con nombre del departamento, nombre del empleado y salario para
--todos los empleados que ganen más que la media de la empresa.

select d.department_name,
       e.first_name,
       e.salary
  from employees e
  join departments d
on e.department_id = d.department_id
 where e.salary > (
   select avg(e2.salary)
     from employees e2
)
 order by d.department_name;

--4. Devuelve un listado con nombre del departamento, nombre del empleado y salario para
--todos los empleados que ganen más que la media de su departamento.

select d.department_name,
       e.first_name,
       e.salary
  from employees e
  join departments d
on e.department_id = d.department_id
 where e.salary > (
   select avg(e2.salary)
     from employees e2
    where d.department_id = e2.department_id
)
 order by d.department_name;

--5. Haz un listado con nombre del puesto, nombre del empleado y fecha de contratación para el
--empleado más antiguo por cada puesto de trabajo.

select j.job_title,
       e.first_name,
       e.hire_date
  from jobs j
  join employees e
on j.job_id = e.job_id
 where e.employee_id = (
   select e2.employee_id
     from employees e2
    where e2.hire_date = (
         select min(e3.hire_date)
           from employees e3
          where e3.job_id = j.job_id
      )
      and e2.job_id = j.job_id
);

--6. Haz un listado con nombre del departamento, nombre del empleado y salario para todos los
--empleados en cuyo departamento haya algún empleado que gane menos que ellos.

select d.department_name,
       e.first_name,
       e.salary
  from employees e
  join departments d
on e.department_id = d.department_id
 where exists (
   select 1
     from employees e2
    where e2.salary < e.salary
      and e.department_id = e2.department_id
);

--7 Haz un listado de las ciudades en las que no está ubicado ningún departamento

select l.city
  from locations l
  left join departments d
on d.location_id = l.location_id
 where d.department_id is null;

--8 Haz un listado con el puesto de trabajo, nombre del puesto, y todos los empleados
--pertenecientes a este puesto menos el último que se ha contratado.

select j.job_title,
       e.first_name
  from employees e
  join jobs j
on j.job_id = e.job_id
 where ( e.job_id,
         e.hire_date ) not in (
   select e.job_id,
          max(e.hire_date)
     from employees e
    group by e.job_id
);

--9 Haz un listado con las ciudades, el empleado que más gana de cada ciudad (nombre, apellido
--y salario) y la diferencia de salario que hay entre el empleado que más gana y la media de
--salarios de su ciudad.

SELECT 
    l.city, 
    e.first_name, 
    e.last_name, 
    e.salary,
    -- Calculamos la diferencia respecto a la media de su ciudad
    (e.salary - stats.media_ciudad) AS diferencia
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
JOIN (
    -- Esta subconsulta calcula el máximo y la media por cada ciudad
    SELECT 
        loc.city, 
        MAX(emp.salary) AS salario_max_ciudad, 
        AVG(emp.salary) AS media_ciudad
    FROM employees emp
    JOIN departments dept ON emp.department_id = dept.department_id
    JOIN locations loc ON dept.location_id = loc.location_id
    GROUP BY loc.city
) stats 
ON l.city = stats.city AND e.salary = stats.salario_max_ciudad;

--10 (difícil) Haz un listado con los departamentos cuya media de salarios está por encima de la
--media de salarios de la empresa. Incluye entre las columnas del listado dos que indiquen
--● Cuantos empleados del departamento tienen un salario por encima de la media de la
--empresa
--● Cuantos empleados del departamento tienen un salario por encima de la media del
--departamento.

SELECT 
    d.department_name,
    -- Contamos filas solo si cumplen la condición del CASE
    COUNT(CASE WHEN e.salary > (SELECT AVG(salary) FROM employees) THEN 1 END) AS encima_media_empresa,
    COUNT(CASE WHEN e.salary > (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.department_id = d.department_id) THEN 1 END) AS encima_media_dept
FROM departments d
JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING AVG(e.salary) > (SELECT AVG(salary) FROM employees);

--11 Haz un listado que me de los trabajos que cumplan que la suma de los sueldos de los
--empleados de ese trabajo es superior a la suma de salario de los empleados que trabajan de
--IT_PROG. En el listado quiero ver descripción del trabajo, suma de salario de los trabajadores y
--fecha de contratación del empleado más antiguo que desempeña ese trabajo.
--12 (difícil) Haz un listado que me de el nombre y salario de un empleado y la diferencia salarial
--que tiene con la media del salario de los empleados que son jefes, pero sin considerar a su
--propio jefe.
--1