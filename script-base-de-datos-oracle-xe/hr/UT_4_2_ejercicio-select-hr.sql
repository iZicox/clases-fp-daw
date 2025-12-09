--Consultas con cadenas de texto

--1. Obtener el nombre y apellido de todos los empleados en minúsculas y en una sola columna.
SELECT LOWER(e.FIRST_NAME || ' ' || e.LAST_NAME) AS nombre_completo FROM EMPLOYEES e ;

--2. Obtener el nombre y apellido de todos los empleados en mayúsculas y en una sola columna.
SELECT upper(e.FIRST_NAME || ' ' || e.LAST_NAME) AS nombre_completo FROM EMPLOYEES e ;

--3. Obtener el nombre y apellido de todos los empleados en una sola columna. Si el managerID
--es NULL, devolveremos el nombre y apellido en mayúsculas, si no lo es, devolveremos el
--nombre y apellido tal como están en la BBDD.
SELECT CASE 
	WHEN MANAGER_ID IS NULL THEN upper(first_name || ' ' || last_name) 
	ELSE first_name || ' ' || last_name 
	END AS empleados
FROM EMPLOYEES e ;

--4. Mostrar un listado con 2 columnas, en la primera estará el nombre de los empleados y en la
--segunda la cantidad de caracteres que tiene el nombre
SELECT e.FIRST_NAME AS nombre , LENGTH(e.FIRST_NAME ) AS caracteres FROM EMPLOYEES e;

--5. Muestra una lista con dos columnas, en la primera estará el nombre y apellido de los
--empleados y en la segunda el email en minúsculas, justificado a la derecha y rellenado con *.
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME AS nombre,
		lpad(LOWER(e.EMAIL ),25,'*') AS email 
FROM EMPLOYEES e ;

--6. Muestra un listado con 3 columnas, las dos primeras serán las mismas del ejercicio 4. La
--tercera será la contraseña que se generará con los 2 primeros caracteres del apellido, seguidos
--de 3 primeros caracteres del número de teléfono y por último los 2 últimos caracteres del
--nombre.
SELECT e.FIRST_NAME AS nombre , 
	LENGTH(e.FIRST_NAME ) AS caracteres, 
	SUBSTR(e.LAST_NAME , 1,2) || SUBSTR(e.PHONE_NUMBER ,1,3) || SUBSTR(e.FIRST_NAME ,-2) 
	AS contrasena
FROM EMPLOYEES e;

SELECT e.FIRST_NAME AS nombre , 
	LENGTH(e.FIRST_NAME ) AS caracteres, 
	SUBSTR(e.LAST_NAME , 1,2) || SUBSTR(REPLACE(e.PHONE_NUMBER,'.','') ,1,3) || SUBSTR(e.FIRST_NAME ,-2) 
	AS contrasena
FROM EMPLOYEES e;

-- Consultas con fechas
 --7. Muestra una lista con 4 columnas, en la primera se mostrará la fecha de contratación, en la
 --segunda el día, en la tercera el mes y en la cuarta el año.
 SELECT e.HIRE_DATE AS dia_contratacion,
		TO_CHAR(e.HIRE_DATE ,'DD') AS dia,
		TO_CHAR(e.HIRE_DATE ,'MM') AS mes,
		TO_CHAR(e.HIRE_DATE ,'YYYY') AS ano
FROM EMPLOYEES e ;

-- 8. Muestra
-- una lista con 3 columnas, en la primera la fecha de contratación y en la segunda los
--días que han pasado desde esa fecha hasta hoy, en la tercera los meses que han pasado desde
--esa fecha hasta hoy. Redondea tanto días como meses a 2 decimales.
--Consultas con números
SELECT e.HIRE_DATE AS fecha_contratacion,
		ROUND(sysdate  - e.HIRE_DATE,2) AS dias_contratado,
		ROUND(MONTHS_BETWEEN(SYSDATE,e.HIRE_DATE),2) AS meses_contratado
FROM EMPLOYEES e ; 
--9. Muestra una lista con las siguientes columnas:
-- ● Nombredelempleado
-- ● Puesto
-- ● Salario (el de la tabla que suponemos que es mensual)
-- ● Salario anual
-- ● Salario mensual suponiendo una subida del 9,8%
-- ● Salario anual suponiendo una subida del 9,8%
-- En las operaciones con los salarios, redondeamos a 2 decimales 
--la subida mensual y
-- truncamos a 1 decimal la subida anual.
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME AS nombredelempleado,
		e.JOB_ID AS puesto,
		e.SALARY AS salario_mensual,
		e.SALARY * 12 AS salario_anual,
		round(e.SALARY * 1.098,2) AS subida_mensual,
		trunc(e.SALARY * 12 * 1.098,1) AS subina_anual
FROM EMPLOYEES e ;
/*
10. Muestra una lista con 3 columnas, en la primera el nombre y 
en la segunda el apellido, y en
 la tercera => si el apellido empieza por K, el salario + un 10%, 
 si no empieza por K, el salario.
 Consultas ordenadas y con filtros
 */
SELECT e.FIRST_NAME AS nombre,
		e.LAST_NAME AS apellido, 
		CASE 
			WHEN e.LAST_NAME  LIKE 'K%' THEN salary * 1.10
			ELSE salary
		END AS salario_ajustado
FROM EMPLOYEES e ;

/*
 11. Mostrar los empleados con todos sus datos, ordenados por 
 fecha de contratación
 descendente.
 */
SELECT * FROM EMPLOYEES e ORDER BY e.HIRE_DATE DESC;

-- 12. Mostrar los datos del empleado cuyo id=109;
SELECT * FROM EMPLOYEES e WHERE e.EMPLOYEE_ID = 109;

--13. Mostrar los datos de los empleados vicepresidentes (AD_VP).
SELECT * FROM EMPLOYEES e WHERE e.JOB_ID  = 'AD_VP';

--14. Mostrar los datos de todos los empleados contratados 
--antes del 1 de enero de 2006.
SELECT * FROM EMPLOYEES e 
WHERE e.HIRE_DATE < TO_DATE('01/01/2006','DD/MM/YYYY') ;

--15. Mostrar los datos de los empleados que 
--trabajen de programadores y que ganen menos de
 --5000$.
SELECT  * FROM EMPLOYEES e WHERE e.JOB_ID = 'IT_PROG' AND e.SALARY < 5000;

--16. Mostrar las columnas de la consulta 3 para los empleados 
--cuyo teléfono empieza por 650.
SELECT CASE 
	WHEN MANAGER_ID IS NULL THEN upper(first_name || ' ' || last_name) 
	ELSE first_name || ' ' || last_name 
	END AS empleados
FROM EMPLOYEES e WHERE e.PHONE_NUMBER LIKE '650%';

/*
17. Mostrar los datos de los empleados que se contrataron 
durante los meses de Junio, Julio o
 Agosto. Ordenarlos por salario ascendente.
*/
SELECT * FROM EMPLOYEES e WHERE 
TO_char(e.HIRE_DATE ,'MM') = '06' OR 
TO_char(e.HIRE_DATE ,'MM') = '07' OR
TO_char(e.HIRE_DATE ,'MM') = '08' 
ORDER BY SALARY ASC;

SELECT * FROM EMPLOYEES e WHERE 
TO_char(e.HIRE_DATE ,'MM') IN ('06','07','08')
ORDER BY SALARY ASC;

SELECT * FROM EMPLOYEES e 
WHERE EXTRACT(MONTH FROM e.HIRE_DATE )
IN (6,7,8)
ORDER BY SALARY ASC;
/*
18. Mostrar los datos de los empleados cuyo apellido 
contenga una w. Ordenarlos por nombre
 descendente.
 */
SELECT * FROM EMPLOYEES e 
WHERE LOWER(e.LAST_NAME) LIKE '%w%' 
OR LOWER(e.LAST_NAME) LIKE 'w%'
OR LOWER(e.LAST_NAME ) LIKE '%w';
/*
 19. Mostrar los datos de los empleados cuyo campo manager_id 
 está vacio o es nulo.
 */
SELECT * FROM EMPLOYEES e WHERE e.MANAGER_ID IS NULL; 
 --20. Mostrar las columnas del ejercicio 5 para empleados 
 --cuyo salario está entre 10.000$ y
 --20.000$.
 SELECT e.FIRST_NAME || ' ' || e.LAST_NAME AS nombre,
		lpad(LOWER(e.EMAIL ),25,'*') AS email 
FROM EMPLOYEES e 
WHERE  e.SALARY BETWEEN 10000 AND 20000;

--21. Mostrar los datos de los empleados cuyo trabajo sea programador (IT_PROG),
 --representantes (SA_REP) o responsable de cuenta (FI_ACCOUNT).
 SELECT * FROM EMPLOYEES e WHERE e.JOB_ID IN ('IT_PROG','SA_REP','FI_ACCOUNT');

--22. Muestra los datos de empleados que cumplan los criterios de consulta 21 y de la consulta 20.
SELECT * FROM EMPLOYEES e WHERE e.JOB_ID IN ('IT_PROG','SA_REP','FI_ACCOUNT') 
AND e.SALARY BETWEEN 10000 AND 20000;

-- 23. Muestra los datos de empleados que cumplan los criterios de consulta 21 o de la consulta 20.


-- 24. Muestra los datos de los empleados cuyos teléfonos empiecen por 515 o por 011
SELECT *
FROM employees
WHERE REPLACE(phone_number, '.', '') LIKE '515%' 
   OR REPLACE(phone_number, '.', '') LIKE '011%';
/*
25. Muestra las columnas de la consulta 9 para los empleados que trabajen como ST_CLERK y
 su manager sea el empleado 122 o ganen menos de 3000$ ordenados por su email
 ascendente.*/
SELECT e.FIRST_NAME || ' ' || e.LAST_NAME AS nombredelempleado,
		e.JOB_ID AS puesto,
		e.SALARY AS salario_mensual,
		e.SALARY * 12 AS salario_anual,
		round(e.SALARY * 1.098,2) AS subida_mensual,
		trunc(e.SALARY * 12 * 1.098,1) AS subina_anual
FROM EMPLOYEES e 
WHERE e.JOB_ID = 'ST_CLERK' 
AND e.MANAGER_ID = 122 
OR e.SALARY < 3000 
ORDER BY e.EMAIL asc;

/*
 26. Muestra las columnas de la consulta 6 para los empleados cuyo nombre empiece por A, B,
 2
S oN.
 */
SELECT e.FIRST_NAME AS nombre , 
	LENGTH(e.FIRST_NAME ) AS caracteres, 
	SUBSTR(e.LAST_NAME , 1,2) || SUBSTR(e.PHONE_NUMBER ,1,3) || SUBSTR(e.FIRST_NAME ,-2) 
	AS contrasena
FROM EMPLOYEES e;

SELECT e.FIRST_NAME AS nombre , 
	LENGTH(e.FIRST_NAME ) AS caracteres, 
	SUBSTR(e.LAST_NAME , 1,2) || SUBSTR(REPLACE(e.PHONE_NUMBER,'.','') ,1,3) || SUBSTR(e.FIRST_NAME ,-2) 
	AS contrasena
FROM EMPLOYEES e WHERE SUBSTR(upper(e.FIRST_NAME) ,1,1) IN ('A','B','S','N');


 /*
  27. Muestra los datos de los empleados cuyos nombre tiene 5 caracteres ordenados por
 nombre descendente.
 */
SELECT * FROM EMPLOYEES e WHERE LENGTH(e.FIRST_NAME ) = 5 ORDER BY e.FIRST_NAME DESC ;
/*
 28. Muestra los datos de los empleados con antigüedad en la empresa superior a 20 años
 ordenados por salario descendente.
 */
SELECT * FROM EMPLOYEES e WHERE MONTHS_BETWEEN(sysdate,e.HIRE_DATE ) > (20*12) ORDER BY e.SALARY DESC;

-- 29. Muestra los datos de los empleados cuyo teléfono contenga los números 423 (en este
 --orden).
SELECT * FROM EMPLOYEES e WHERE REPLACE(e.PHONE_NUMBER ,'.','') LIKE '%423%';

-- 30 Muestra los distintos salarios, sin repetirse, de los empleados ordenados de menor a mayor.
SELECT DISTINCT e.SALARY  FROM EMPLOYEES e ORDER BY e.SALARY asc; 


