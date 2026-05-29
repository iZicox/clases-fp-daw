--
--1
--
--Automatic Zoom
--T6. Lenguaje de manipulación de datos (DML)
--Ejercicio HR– Consultas varias tablas
--Utiliza la BBDD HR
--1. Devuelve los departamentos y en caso de que el departamento tenga manager, los
--datos del manger (nombre, apellidos, salario y fecha de contratación)
select d.DEPARTMENT_NAME, e.FIRST_NAME, e.LAST_NAME, e.SALARY, e.HIRE_DATE
from DEPARTMENTS d 
left join EMPLOYEES e on e.EMPLOYEE_ID = d.MANAGER_ID;
--2. Devuelve los países (código y descripción) y en caso de que haya direcciones en ese
--país, la ciudad de la dirección.
SELECT co.COUNTRY_NAME, l.CITY
FROM COUNTRIES co 
LEFT JOIN LOCATIONS l ON l.COUNTRY_ID = co.COUNTRY_ID;
--3. Al listado anterior, añade código y descripción del departamento.
SELECT co.COUNTRY_NAME, l.CITY, d.DEPARTMENT_ID, d.DEPARTMENT_NAME
FROM COUNTRIES co 
LEFT JOIN LOCATIONS l ON l.COUNTRY_ID = co.COUNTRY_ID
LEFT JOIN DEPARTMENTS d ON d.LOCATION_ID = l.LOCATION_ID;
--4. Al listado anterior, añade el nombre y apellidos del manager.
SELECT co.COUNTRY_NAME, l.CITY, d.DEPARTMENT_ID, d.DEPARTMENT_NAME, e.FIRST_NAME, e.LAST_NAME
FROM COUNTRIES co 
LEFT JOIN LOCATIONS l ON l.COUNTRY_ID = co.COUNTRY_ID
LEFT JOIN DEPARTMENTS d ON d.LOCATION_ID = l.LOCATION_ID
LEFT JOIN EMPLOYEES e ON e.EMPLOYEE_ID = d.MANAGER_ID;
--5. Devuelve todos los empleados (nombre y apellido) con el nombre del departamento al
--que pertenecen, los departamentos que no tienen empleados y los empleados que no
--tienen departamento. Si puedes haz la select de 2 formas distintas.
--1
--T6. Lenguaje de manipulación de datos (DML)
--Realiza las consultas utilizando UNION, UNION ALL, INTERSEC, MINUS
-- Caso A: Empleados con su departamento + Empleados sin departamento
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id

UNION

-- Caso B: Departamentos que no tienen empleados
SELECT NULL, NULL, d.department_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 
    FROM employees e 
    WHERE e.department_id = d.department_id
);
-- 1. Empleados (con o sin departamento)
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id

UNION ALL

-- 2. Departamentos que no tienen empleados (obtenidos mediante MINUS)
SELECT NULL, NULL, d.department_name
FROM departments d
WHERE d.department_id IN (
    SELECT department_id FROM departments -- Todos los departamentos
    MINUS
    SELECT department_id FROM employees   -- Departamentos con empleados
);
--6. Devuelve un listado que muestre el salario medio, máximo y mínimo de los empleados
--con comisión y los mismos datos de los empleados sin comisión.
SELECT avg(e.SALARY) media, MAX(e.SALARY) maximo, MIN(e.SALARY) minimo,
        (
            case when 
        )
FROM EMPLOYEES e
GROUP by e.EMPLOYEE_ID;
--7. Devuelve un listado con el nombre, apellidos y fecha de contratación de los empleados
--y un literal al lado que indique “TIENE EMPLEADOS A SU CARGO” o “NO TIENE
--EMPLEADOS A SU CARGO”.
--8. Devuelve un listado con todos los empleados salvo los que su nombre empieza por
--vocal o ganan más de 12.000$.
--9. Devuelve un listado con todos los empleados salvo los que su nombre empieza por
--vocal y cuyo salario está por encima de la media de su departamento.
--o ganan más de 12.000$
--2