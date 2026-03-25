--1. Devuelve el nombre del empleado que más gana
SELECT FIRST_NAME
FROM EMPLOYEES
WHERE SALARY = (
    SELECT MAX(SALARY) FROM EMPLOYEES
);
--2. Devuelve el nombre del empleado que más gana de cada departamento. 
--Añade al listado el
--nombre del departamento.
WITH MAX_SALARY AS (
    SELECT
            D.DEPARTMENT_NAME AS DEPARTAMENTO,
            MAX(E.SALARY) AS SALARIO,
            D.DEPARTMENT_ID AS ID
    FROM EMPLOYEES E
    INNER JOIN DEPARTMENTS D
        ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
    GROUP BY D.DEPARTMENT_NAME, D.DEPARTMENT_ID
)
SELECT 
        MS.DEPARTAMENTO,
        E2.FIRST_NAME,
        E2.SALARY
FROM MAX_SALARY MS
INNER JOIN EMPLOYEES E2
    ON MS.SALARIO = E2.SALARY
        AND MS.ID = E2.DEPARTMENT_ID;

SELECT
    D.DEPARTMENT_NAME AS DEPARTAMENTO,
    E.FIRST_NAME,
    E.SALARY
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.SALARY = (
        SELECT MAX(E2.SALARY)
        FROM EMPLOYEES E2
        WHERE E2.DEPARTMENT_ID = E.DEPARTMENT_ID
    );
--3. Devuelve un listado con nombre del departamento, nombre del empleado y salario para todos los empleados que ganen más que la media de la empresa.
SELECT
        D.DEPARTMENT_NAME,
        E.FIRST_NAME,
        E.SALARY
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.SALARY > (
    SELECT AVG(E2.SALARY)
    FROM EMPLOYEES E2
);
--4. Devuelve un listado con nombre del departamento, nombre del empleado y salario para todos los empleados que ganen más que la media de su departamento.

WITH MEDIA_SALARIO AS (
    SELECT AVG(E.SALARY) AS SALARIO,
    D.DEPARTMENT_ID AS ID
FROM DEPARTMENTS D 
INNER JOIN EMPLOYEES E 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
GROUP BY D.DEPARTMENT_NAME, D.DEPARTMENT_ID
)
SELECT
        D2.DEPARTMENT_NAME,
        E2.FIRST_NAME,
        E2.SALARY
FROM EMPLOYEES E2 
INNER JOIN DEPARTMENTS D2
    ON E2.DEPARTMENT_ID = D2.DEPARTMENT_ID
INNER JOIN MEDIA_SALARIO MS 
    ON MS.ID = E2.DEPARTMENT_ID
WHERE MS.ID = E2.DEPARTMENT_ID
    AND E2.SALARY > MS.SALARIO;
--5. Haz un listado con nombre del puesto, nombre del empleado y fecha de contratación para el
--empleado más antiguo por cada puesto de trabajo.

WITH ANTIGUOS AS (
    SELECT 
        MIN(E.HIRE_DATE) FECHA, 
        J.JOB_ID ID
    FROM EMPLOYEES E
    INNER JOIN JOBS J   
        ON J.JOB_ID = E.JOB_ID
    GROUP BY J.JOB_ID
)
SELECT 
        J2.JOB_TITLE,
        E2.FIRST_NAME,
        E2.HIRE_DATE
FROM EMPLOYEES E2 
INNER JOIN JOBS J2
    ON J2.JOB_ID = E2.JOB_ID
INNER JOIN ANTIGUOS A 
    ON A.ID = E2.JOB_ID
WHERE A.ID = E2.JOB_ID
    AND A.FECHA = E2.HIRE_DATE;

--6. Haz un listado con nombre del departamento, nombre del empleado y salario para todos los
--empleados en cuyo departamento haya algún empleado que gane menos que ellos.
SELECT
        D.DEPARTMENT_NAME,
        E.FIRST_NAME,
        E.SALARY
FROM EMPLOYEES E    
INNER JOIN DEPARTMENTS D 
    ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE EXISTS (
    SELECT 1
    FROM EMPLOYEES F
    WHERE E.DEPARTMENT_ID = F.DEPARTMENT_ID
        AND E.SALARY > F.SALARY
);
--7 Haz un listado de las ciudades en las que no está ubicado ningún departamento

SELECT L.CITY
FROM LOCATIONS L 
WHERE L.LOCATION_ID NOT IN (
    SELECT DISTINCT D.LOCATION_ID
    FROM DEPARTMENTS D
);

SELECT L.CITY
FROM LOCATIONS L 
WHERE NOT EXISTS (
    SELECT 1
    FROM DEPARTMENTS D
    WHERE D.LOCATION_ID = L.LOCATION_ID
);
--8 Haz un listado con el puesto de trabajo, nombre del puesto, y todos los empleados
--pertenecientes a este puesto menos el último que se ha contratado.

WITH MIN_FECHA AS (
    SELECT
            MAX(E.HIRE_DATE) AS FECHA,
            E.JOB_ID AS JOB_ID
    FROM EMPLOYEES E 
    GROUP BY E.JOB_ID
)
SELECT
        J.JOB_TITLE,
        E2.FIRST_NAME
FROM EMPLOYEES E2
INNER JOIN MIN_FECHA MF 
    ON E2.JOB_ID = MF.JOB_ID
INNER JOIN JOBS J
    ON E2.JOB_ID = J.JOB_ID
WHERE E2.HIRE_DATE <> MF.FECHA;
--------------------------------------
SELECT 
        J.JOB_TITLE,
        E.FIRST_NAME
FROM EMPLOYEES E 
INNER JOIN JOBS J 
    ON E.JOB_ID = J.JOB_ID
WHERE E.HIRE_DATE NOT IN (
    SELECT MAX(E2.HIRE_DATE)
    FROM EMPLOYEES E2
    WHERE E2.JOB_ID = E.JOB_ID
);
--9 Haz un listado con las ciudades, el empleado que más gana de cada ciudad (nombre, apellido
--y salario) y la diferencia de salario que hay entre el empleado que más gana y la media de
--salarios de su ciudad.

WITH PROMEDIO_CIUDAD AS (
    SELECT 
            AVG(E3.SALARY) AS PROM_SAL,
            L3.CITY AS CIUDAD
    FROM EMPLOYEES E3
    INNER JOIN DEPARTMENTS D3
        ON D3.DEPARTMENT_ID = E3.DEPARTMENT_ID
    INNER JOIN LOCATIONS L3
        ON L3.LOCATION_ID = D3.LOCATION_ID
    GROUP BY L3.CITY
)
SELECT 
        L.CITY,
        E.FIRST_NAME,
        E.LAST_NAME,
        E.SALARY,
        ROUND(E.SALARY - PM.PROM_SAL,2) AS DIFF
FROM EMPLOYEES E 
INNER JOIN DEPARTMENTS D 
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
INNER JOIN LOCATIONS L 
    ON L.LOCATION_ID = D.LOCATION_ID
INNER JOIN PROMEDIO_CIUDAD PM 
    ON PM.CIUDAD = L.CITY
WHERE E.SALARY = (
    SELECT MAX(E2.SALARY)
    FROM EMPLOYEES E2
    INNER JOIN DEPARTMENTS D2 
        ON D2.DEPARTMENT_ID = E2.DEPARTMENT_ID
    INNER JOIN LOCATIONS L2 
        ON L2.LOCATION_ID = D2.LOCATION_ID
    WHERE L2.CITY = L.CITY
);
--V2
WITH PROMEDIO_CIUDAD AS (
    SELECT 
        L3.CITY AS CIUDAD,
        AVG(E3.SALARY) AS PROM_SAL
    FROM EMPLOYEES E3
    INNER JOIN DEPARTMENTS D3
        ON D3.DEPARTMENT_ID = E3.DEPARTMENT_ID
    INNER JOIN LOCATIONS L3
        ON L3.LOCATION_ID = D3.LOCATION_ID
    GROUP BY L3.CITY
),
MAXIMO_CIUDAD AS (
    SELECT 
        L2.CITY AS CIUDAD,
        MAX(E2.SALARY) AS MAX_SAL
    FROM EMPLOYEES E2
    INNER JOIN DEPARTMENTS D2
        ON D2.DEPARTMENT_ID = E2.DEPARTMENT_ID
    INNER JOIN LOCATIONS L2
        ON L2.LOCATION_ID = D2.LOCATION_ID
    GROUP BY L2.CITY
)
SELECT 
        L.CITY,
        E.FIRST_NAME,
        E.LAST_NAME,
        E.SALARY,
        ROUND(E.SALARY - PC.PROM_SAL, 2) AS DIFF
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
INNER JOIN LOCATIONS L
    ON L.LOCATION_ID = D.LOCATION_ID
INNER JOIN MAXIMO_CIUDAD MC
    ON MC.CIUDAD = L.CITY
INNER JOIN PROMEDIO_CIUDAD PC
    ON PC.CIUDAD = L.CITY
WHERE E.SALARY = MC.MAX_SAL;
--V3
SELECT 
        L.CITY,
        E.FIRST_NAME,
        E.LAST_NAME,
        E.SALARY,
        ROUND(
            E.SALARY - (
                SELECT AVG(E3.SALARY)
                FROM EMPLOYEES E3
                INNER JOIN DEPARTMENTS D3
                    ON D3.DEPARTMENT_ID = E3.DEPARTMENT_ID
                INNER JOIN LOCATIONS L3
                    ON L3.LOCATION_ID = D3.LOCATION_ID
                WHERE L3.CITY = L.CITY
            ), 
        2) AS DIFF
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D
    ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
INNER JOIN LOCATIONS L
    ON L.LOCATION_ID = D.LOCATION_ID
WHERE E.SALARY = (
    SELECT MAX(E2.SALARY)
    FROM EMPLOYEES E2
    INNER JOIN DEPARTMENTS D2
        ON D2.DEPARTMENT_ID = E2.DEPARTMENT_ID
    INNER JOIN LOCATIONS L2
        ON L2.LOCATION_ID = D2.LOCATION_ID
    WHERE L2.CITY = L.CITY
);
--10 (difícil) Haz un listado con los departamentos cuya media de salarios está por encima de la
--media de salarios de la empresa. Incluye entre las columnas del listado dos que indiquen
--● Cuantos empleados del departamento tienen un salario por encima de la media de la
--empresa
--● Cuantos empleados del departamento tienen un salario por encima de la media del
--departamento.

WITH MEDIA_EMPRESA AS (
    SELECT AVG(SALARY) AS AVG_SAL FROM EMPLOYEES
),
MEDIA_DEPT AS (
    SELECT DEPARTMENT_ID, AVG(SALARY) AS MEDIA_DEPT
    FROM EMPLOYEES
    GROUP BY 
    DEPARTMENT_ID 
),
CONTEO AS (
    SELECT
            E.DEPARTMENT_ID,
            SUM(
                CASE
                    WHEN E.SALARY > (SELECT AVG_SAL 
                                    FROM MEDIA_EMPRESA)
                    THEN 1 ELSE 0
                END                    
            ) AS ENCIMA_MEDIA_EMP,
            SUM(
                CASE
                    WHEN E.SALARY > MD.MEDIA_DEPT
                    THEN 1 ELSE 0
                END
            ) AS ENCIMA_MEDIA_DEPT
    FROM EMPLOYEES E
    INNER JOIN MEDIA_DEPT MD 
        ON MD.DEPARTMENT_ID = E.DEPARTMENT_ID
    GROUP BY E.DEPARTMENT_ID
)
SELECT
        D.DEPARTMENT_ID,
        D.DEPARTMENT_NAME,
        C.ENCIMA_MEDIA_EMP,
        C.ENCIMA_MEDIA_DEPT
FROM MEDIA_DEPT MD 
INNER JOIN MEDIA_EMPRESA ME 
    ON 1=1
INNER JOIN CONTEO C 
    ON MD.DEPARTMENT_ID = C.DEPARTMENT_ID
INNER JOIN DEPARTMENTS D 
    ON D.DEPARTMENT_ID = MD.DEPARTMENT_ID
WHERE MD.MEDIA_DEPT > ME.AVG_SAL
;




--11 Haz un listado que me de los trabajos que cumplan que la suma de los sueldos de los
--empleados de ese trabajo es superior a la suma de salario de los empleados que trabajan de
--IT_PROG. En el listado quiero ver descripción del trabajo, suma de salario de los trabajadores y
--fecha de contratación del empleado más antiguo que desempeña ese trabajo.
WITH SUMA_SALARIO_IT_PROG AS (
	SELECT SUM(e.SALARY ) AS suma_salario
	FROM EMPLOYEES e 
	WHERE e.JOB_ID = 'IT_PROG'
)
SELECT  
		j.JOB_ID,
		sum(e.SALARY) AS SUMA_SALARIOS,
		min(to_char(e.HIRE_DATE,'DD-MM-YYYY')) 
		AS PRIMER_CONTRATADO
FROM JOBS j 
INNER JOIN EMPLOYEES e 
	ON j.JOB_ID = e.JOB_ID
GROUP BY j.JOB_ID
HAVING SUM(e.SALARY ) > (SELECT SUMA_SALARIO  
						FROM SUMA_SALARIO_IT_PROG );
--12 (difícil) Haz un listado que me de el nombre y salario 
--de un empleado y la diferencia salarial
--que tiene con la media del salario de los empleados que son jefes, 
--pero sin considerar a su
--propio jefe.

SELECT 
		e.FIRST_NAME ,
		e.SALARY ,
		e.SALARY - 
		round((
			SELECT	AVG(e2.SALARY )
			FROM EMPLOYEES e2 
			INNER JOIN DEPARTMENTS d2
				ON e2.EMPLOYEE_ID  = d2.MANAGER_ID 
			WHERE e2.EMPLOYEE_ID != e.EMPLOYEE_ID 
		),2)
FROM EMPLOYEES e ;






























