--1. Devuelve el nombre del empleado que más gana
SELECT E.FIRST_NAME 
FROM EMPLOYEES E
WHERE E.SALARY = (SELECT MAX(E2.SALARY)
                    FROM EMPLOYEES E2);
--2. Devuelve el nombre del empleado que más gana de cada departamento. 
--Añade al listado el
--nombre del departamento.
SELECT E.FIRST_NAME,
        D.DEPARTMENT_NAME
FROM EMPLOYEES E 
INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.SALARY = (SELECT MAX(E2.SALARY)
                    FROM EMPLOYEES E2
                    WHERE E2.DEPARTMENT_ID = D.DEPARTMENT_ID)
ORDER BY D.DEPARTMENT_ID;

SELECT 
        D.DEPARTMENT_NAME,
        (SELECT E.FIRST_NAME
        FROM EMPLOYEES E 
        WHERE E.DEPARTMENT_ID = D.DEPARTMENT_ID
                        AND E.SALARY = (SELECT MAX(E2.SALARY)
                            FROM EMPLOYEES E2
                            WHERE E2.DEPARTMENT_ID = D.DEPARTMENT_ID
                            )) AS EMPLEADO_QUE_MAS_GANA
FROM DEPARTMENTS D 
ORDER BY D.DEPARTMENT_ID;
--3. Devuelve un listado con nombre del departamento, nombre del empleado y salario para todos los empleados que ganen más que la media de la empresa.
SELECT 
        D.DEPARTMENT_NAME,
        E.FIRST_NAME,
        E.SALARY 
FROM EMPLOYEES E 
INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.SALARY > (SELECT AVG(E2.SALARY) FROM EMPLOYEES E2);
--4. Devuelve un listado con nombre del departamento, nombre del empleado y salario para todos los empleados que ganen más que la media de su departamento.
SELECT 
        D.DEPARTMENT_NAME,
        E.FIRST_NAME,
        E.SALARY
FROM EMPLOYEES E 
INNER JOIN DEPARTMENTS D ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.SALARY > (SELECT AVG(E2.SALARY)
                    FROM EMPLOYEES E2
                    WHERE E2.DEPARTMENT_ID = D.DEPARTMENT_ID)
ORDER BY D.DEPARTMENT_ID;


--5. Haz un listado con nombre del puesto, nombre del empleado y fecha de contratación para el
--empleado más antiguo por cada puesto de trabajo.
SELECT 
        J.JOB_TITLE,
        E.FIRST_NAME,
        E.HIRE_DATE
FROM EMPLOYEES E 
INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE E.HIRE_DATE = (SELECT MIN(E2.HIRE_DATE)
                    FROM EMPLOYEES E2 
                    INNER JOIN JOBS J2 ON E2.JOB_ID = J2.JOB_ID
                    WHERE J.JOB_ID = J2.JOB_ID)
ORDER BY J.JOB_ID;

--6. Haz un listado con nombre del departamento, nombre del empleado y salario para todos los
--empleados en cuyo departamento haya algún empleado que gane menos que ellos.
SELECT 
        D.DEPARTMENT_NAME,
        E.FIRST_NAME,
        E.SALARY
FROM EMPLOYEES E 
INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE EXISTS (
    SELECT 1
    FROM EMPLOYEES E2
    WHERE E2.DEPARTMENT_ID = E.DEPARTMENT_ID
    AND E2.SALARY < E.SALARY
); 
--7 Haz un listado de las ciudades en las que no está ubicado ningún departamento
SELECT 
        L.CITY
FROM LOCATIONS L
WHERE NOT EXISTS (
    SELECT 1
    FROM DEPARTMENTS D 
    WHERE L.LOCATION_ID = D.LOCATION_ID
);
--8 Haz un listado con el puesto de trabajo, nombre del puesto, y todos los empleados
--pertenecientes a este puesto menos el último que se ha contratado.
SELECT
        J.JOB_TITLE,
        E.FIRST_NAME
FROM EMPLOYEES E 
INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE E.HIRE_DATE < (SELECT MAX(E2.HIRE_DATE)
                        FROM EMPLOYEES E2
                        WHERE E2.JOB_ID = J.JOB_ID);
--9 Haz un listado con las ciudades, el empleado que más gana de cada ciudad (nombre, apellido
--y salario) y la diferencia de salario que hay entre el empleado que más gana y la media de
--salarios de su ciudad.
SELECT  
        L.CITY,
        E.FIRST_NAME AS MAS_GANA,
        E.LAST_NAME,
        E.SALARY,
        E.SALARY - (SELECT AVG(E3.SALARY)
                FROM EMPLOYEES E3
                INNER JOIN DEPARTMENTS D3 ON E3.DEPARTMENT_ID = D3.DEPARTMENT_ID
                INNER JOIN LOCATIONS L3 ON L3.LOCATION_ID = D3.LOCATION_ID
                WHERE L3.CITY = L.CITY) AS DIFERENCIA_MEDIA_CIUDAD
FROM EMPLOYEES E 
INNER JOIN DEPARTMENTS D ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
INNER JOIN LOCATIONS L ON L.LOCATION_ID = D.LOCATION_ID
WHERE E.SALARY = (SELECT MAX(E2.SALARY)
                  FROM EMPLOYEES E2
                  INNER JOIN DEPARTMENTS D2 ON D2.DEPARTMENT_ID = E2.DEPARTMENT_ID
                  INNER JOIN LOCATIONS L2 ON L2.LOCATION_ID = D2.LOCATION_ID
                  WHERE L2.CITY = L.CITY)
;
--10 (difícil) Haz un listado con los departamentos cuya media de salarios está por encima de la
--media de salarios de la empresa. Incluye entre las columnas del listado dos que indiquen
--● Cuantos empleados del departamento tienen un salario por encima de la media de la
--empresa
--● Cuantos empleados del departamento tienen un salario por encima de la media del
--departamento.
WITH MEDIA_DEPT AS (
SELECT 
        D.DEPARTMENT_ID, D.DEPARTMENT_NAME, AVG(E.SALARY) AS MEDIA_SALARIO_DEPT
FROM EMPLOYEES E 
INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_ID, D.DEPARTMENT_NAME
)
SELECT 
        D.DEPARTMENT_NAME,
        /* Empleados del departamento por encima de la media de la empresa */
        COUNT(
                CASE 
                        WHEN E.SALARY > (SELECT AVG(SALARY) FROM EMPLOYEES)
                        THEN 1
                END
        ) AS ENCIMA_MEDIA_EMPRESA,
        (SELECT COUNT(*) 
        FROM EMPLOYEES E3 
        WHERE MD.DEPARTMENT_ID = E3.DEPARTMENT_ID
        AND E3.SALARY > MD.MEDIA_SALARIO_DEPT) AS ENCIMA_MEDIA_DEPT
FROM EMPLOYEES E 
INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN MEDIA_DEPT MD ON MD.DEPARTMENT_ID = D.DEPARTMENT_ID
/* Departamentos cuya media está por encima de la media de la empresa */
WHERE MD.MEDIA_SALARIO_DEPT > (
    SELECT AVG(SALARY)
    FROM EMPLOYEES
)
GROUP BY 
    D.DEPARTMENT_NAME,
    MD.DEPARTMENT_ID,
    MD.MEDIA_SALARIO_DEPT;
--11 Haz un listado que me de los trabajos que cumplan que la suma de los sueldos de los
--empleados de ese trabajo es superior a la suma de salario de los empleados que trabajan de
--IT_PROG. En el listado quiero ver descripción del trabajo, suma de salario de los trabajadores y
--fecha de contratación del empleado más antiguo que desempeña ese trabajo.
SELECT
        J.JOB_TITLE,
        SUM(E.SALARY),
        MIN(E.HIRE_DATE)
FROM EMPLOYEES E 
INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE E.JOB_ID <> 'IT_PROG'
GROUP BY J.JOB_TITLE
HAVING SUM(E.SALARY) > (SELECT SUM(SALARY)
                        FROM EMPLOYEES
                        WHERE JOB_ID = 'IT_PROG');
--12 (difícil) Haz un listado que me de el nombre y salario 
--de un empleado y la diferencia salarial
--que tiene con la media del salario de los empleados que son jefes, 
--pero sin considerar a su
--propio jefe.
SELECT
        E.FIRST_NAME,
        E.SALARY,
        - E.SALARY + ROUND(
                (
                        SELECT AVG(E2.SALARY)
                        FROM EMPLOYEES E2
                        INNER JOIN DEPARTMENTS D2 ON D2.DEPARTMENT_ID = E2.DEPARTMENT_ID
                        WHERE E2.EMPLOYEE_ID = D2.MANAGER_ID
                        AND D2.MANAGER_ID <> E.MANAGER_ID
                ),2) AS DIFERENCIA_CON_JEFES
FROM EMPLOYEES E 
INNER JOIN DEPARTMENTS D ON D.DEPARTMENT_ID = E.DEPARTMENT_ID;
































