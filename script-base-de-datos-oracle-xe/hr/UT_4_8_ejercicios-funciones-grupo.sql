--1. Haz un listado con todos los departamentos, nombre del departamento, el número de
--trabajadores que hay en el departamento y la media de su salario.
SELECT 	d.DEPARTMENT_NAME ,
		COUNT(e.EMPLOYEE_ID ),
		round(AVG(e.SALARY ),2) AS salarios
FROM DEPARTMENTS d 
INNER JOIN EMPLOYEES e 
	ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME 
ORDER BY salarios desc;

SELECT 	d.DEPARTMENT_NAME ,
		COUNT(e.EMPLOYEE_ID ),
		round(AVG(e.SALARY ),2) AS salarios
FROM DEPARTMENTS d 
left JOIN EMPLOYEES e 
	ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME 
ORDER BY salarios desc;
--2. Haz un listado con todas las ciudades y el número de trabajadores que hay en cada ciudad.
SELECT 
		l.CITY ,
		COUNT(e.EMPLOYEE_ID )
FROM EMPLOYEES e 
INNER JOIN DEPARTMENTS d 
	ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
INNER JOIN LOCATIONS l 
	ON d.LOCATION_ID = l.LOCATION_ID
GROUP BY l.CITY ;
--3. Haz un listado con todos los países, nombre del país, y el salario del trabajador que más
--gana y el que menos de cada país.
SELECT 	c.COUNTRY_NAME ,
		MAX(e.SALARY ) max,
		MIN(e.SALARY ) min
FROM EMPLOYEES e 
INNER JOIN DEPARTMENTS d 
	ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
INNER JOIN LOCATIONS l 
	ON d.LOCATION_ID = l.LOCATION_ID
INNER JOIN COUNTRIES c 
	ON l.COUNTRY_ID = c.COUNTRY_ID
GROUP BY c.COUNTRY_NAME ;
--4. Haz un listado con todos los años en que se contrató a más de 10 personas. Saca el año y el
--número de contrataciones por año.
SELECT 
		TO_CHAR(jh.START_DATE , 'YYYY') anio,
		COUNT (jh.EMPLOYEE_ID ) contrataciones
FROM JOB_HISTORY jh 
GROUP BY TO_CHAR(jh.START_DATE , 'YYYY')
HAVING COUNT (jh.EMPLOYEE_ID  ) > 10
ORDER BY anio desc;
--5. Muestra en un listado los departamentos que tengan más de 5 empleados. Ordénalos de
--mayor a menor número de trabajadores.
SELECT 
		d.DEPARTMENT_NAME , 
		COUNT (e.EMPLOYEE_ID ) empleados
FROM EMPLOYEES e 
INNER  JOIN DEPARTMENTS d 
	ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME 
HAVING COUNT(e.EMPLOYEE_ID ) > 5
ORDER BY empleados desc;
--6. Muestra los países, nombre, donde haya departamentos en más de una ciudad,.
SELECT 
		c.COUNTRY_NAME pais	
FROM DEPARTMENTS d 
INNER JOIN LOCATIONS l 
	ON d.LOCATION_ID = l.LOCATION_ID
INNER JOIN COUNTRIES c 
	ON l.COUNTRY_ID = c.COUNTRY_ID
GROUP BY c.COUNTRY_NAME 
HAVING COUNT(DISTINCT l.CITY ) > 1;
--7. Muestra la suma de los salarios de los empleados cuyo teléfono acabe en 9.
SELECT sum(e.SALARY ) FROM EMPLOYEES e 
WHERE e.PHONE_NUMBER LIKE '%9';
--8. Muestra un listado con el número de empleados de cada ciudad de Europa.

-- usando where
SELECT l.CITY , COUNT(e.EMPLOYEE_ID ) 
FROM EMPLOYEES e 
INNER JOIN DEPARTMENTS d 
	ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
INNER JOIN LOCATIONS l 
	ON d.LOCATION_ID = l.LOCATION_ID
INNER JOIN COUNTRIES c 
	ON l.COUNTRY_ID = c.COUNTRY_ID
INNER JOIN REGIONS r 
	ON c.REGION_ID = r.REGION_ID
WHERE r.REGION_NAME IN ('Europe')
GROUP BY l.CITY;

--usando having
SELECT 
        l.CITY,
        COUNT(e.EMPLOYEE_ID) AS num_empleados
FROM EMPLOYEES e
JOIN DEPARTMENTS d
        ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
JOIN LOCATIONS l
        ON d.LOCATION_ID = l.LOCATION_ID
JOIN COUNTRIES c
        ON l.COUNTRY_ID = c.COUNTRY_ID
JOIN REGIONS r
        ON c.REGION_ID = r.REGION_ID
GROUP BY l.CITY, r.REGION_NAME
HAVING r.REGION_NAME = 'Europe';

-- si quieres ver las ciudades sin empleados con left join
SELECT 
        l.CITY,
        COUNT(e.EMPLOYEE_ID) AS num_empleados
FROM LOCATIONS l
JOIN COUNTRIES c
        ON l.COUNTRY_ID = c.COUNTRY_ID
JOIN REGIONS r
        ON c.REGION_ID = r.REGION_ID
LEFT JOIN DEPARTMENTS d
        ON l.LOCATION_ID = d.LOCATION_ID
LEFT JOIN EMPLOYEES e
        ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
WHERE r.REGION_NAME = 'Europe'
GROUP BY l.CITY
ORDER BY l.CITY;

--9. Muestra la fecha de contratación del empleado más antiguo de cada departamento.
SELECT 
	d.DEPARTMENT_NAME , 
	MIN(TO_CHAR(jh.START_DATE,'DD-MM-YYYY') ) 
FROM JOB_HISTORY jh 
INNER JOIN DEPARTMENTS d 
	ON jh.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME ;
--10. Obtén la suma de salarios de los empleados cuyo nombre empiece por A.
SELECT SUM(e.SALARY ) FROM EMPLOYEES e 
WHERE upper(e.FIRST_NAME) LIKE 'A%';

SELECT SUM(e.SALARY ) FROM EMPLOYEES e 
GROUP BY  e.FIRST_NAME 
HAVING UPPER(e.FIRST_NAME ) LIKE  'A%';
--11. Obtén la media de salarios de los empleados agrupando por la primera letra del apellido.
--Ordena el listado alfabéticamente
SELECT 	SUBSTR(e.LAST_NAME,1,1) letra, 
		round(AVG(e.SALARY ),2) 
FROM EMPLOYEES e 
GROUP BY   SUBSTR(e.LAST_NAME,1,1)
ORDER BY letra;
