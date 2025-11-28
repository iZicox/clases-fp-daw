/*
1. Devuelve el listado con el nombre, apellidos, 
email y nombre del departamento al que
pertenecen todos los empleados.
*/
/*
2. A la consulta anterior añade la descripción de su puesto de trabajo.
3. Haz un listado con todos los departamentos y el nombre y apellido del manager del
departamento.
4. Al listado anterior, añade la ciudad dónde se ubican los departamentos.
5. Al listado anterior, añade el país dónde se ubican los departamentos.
6. Haz un listado con los departamentos y su dirección pero sólo deben salir los
departamentos ubicados en Italia.
7. Haz un listado con los departamentos y su dirección pero sólo deben salir los
departamentos ubicados en América.
*/
/*
8. Haz un listado con nombre, apellido, teléfono, ciudad donde está el 
departamento y
salario para los empleados que trabajan en Europa y ganan más de 10.000$.
*/
SELECT 
FROM EMPLOYEES e 
	INNER JOIN DEPARTMENTS d 	ON d.DEPARTMENT_ID = e.DEPARTMENT_ID 
	INNER JOIN LOCATIONS l 		ON d.LOCATION_ID = l.LOCATION_ID
	INNER JOIN COUNTRIES c 		ON l.COUNTRY_ID = c.COUNTRY_ID
	INNER JOIN REGIONS r 		ON c.REGION_ID = r.REGION_ID
WHERE UPPER(r.REGION_NAME) = 'EUROPE' 
	AND e.SALARY > 10000;
/*
 9. Haz un listado con las descripciones de los trabajos que se hacen en la región de
América. Ojo, no deben salir duplicados.
10. Haz un listado con nombre, apellido, teléfono, ciudad donde está el departamento y
salario para los empleados que trabajan en Toronto o Munich.
*/
/*
11. Haz un listado con el nombre y apellidos del empleado, nombre y 
apellidos de su jefe y
la diferencia de salario entre el empleado y el jefe.
*/
SELECT 	e1.FIRST_NAME NOMBRE_EMPLEADO, 
		e1.LAST_NAME APELLIDO_EMPLEADO,
		j.FIRST_NAME NOMBRE_JEFE,
		j.LAST_NAME APELLIDO_JEFE
FROM EMPLOYEES e1 
INNER JOIN EMPLOYEES J 
	ON e1.MANAGER_ID = J.EMPLOYEE_ID;
/*
12. Haz un listado con las ciudades de Europa, sin repetir, dónde hay trabajadores cuyo
puesto de trabajo incluye en la descripción la palabra “Representative”.
*/
/*
13. Haz un listado con los países que en esta BBDD tienen 
alguna dirección cuyo código
postal empieza por 2,4, 6 u 8,
*/
SELECT c.COUNTRY_NAME  
FROM COUNTRIES c 
INNER JOIN LOCATIONS l 
	ON c.COUNTRY_ID = l.COUNTRY_ID
WHERE SUBSTR(l.POSTAL_CODE ,1,1) IN ('2','4','6','8');
/*
*14. Haz un listado con los empleados cuyo salario está por debajo del rango salarial que
corresponde a su puesto de trabajo.
15. Haz un listado con los empleados cuyo salario está por 
encima del rango salarial que
corresponde a su puesto de trabajo.
*/
SELECT e.FIRST_NAME ,e.LAST_NAME ,e.SALARY, j.MIN_SALARY  
FROM EMPLOYEES e 
JOIN JOBS j 
	ON e.JOB_ID = j.JOB_ID 
WHERE e.SALARY < j.MIN_SALARY;
/*
16. Haz un listado con los empleados cuyo salario 
es igual al mínimo del rango salarial que
corresponde a su puesto de trabajo o es igual al 
máximo del rango salarial que
corresponde a su puesto de trabajo
*/
