--
--1
--
--Automatic Zoom
--EJERCICIO HR – EJERCICIOS PL
--Utiliza la BBDD HR
--1. Diseñar un bloque PL que muestre el nombre del departamento y el número de
--trabajadores que tiene cada uno.

DECLARE
    CURSOR c_departamentos IS
        select DEPARTMENT_ID, DEPARTMENT_NAME from DEPARTMENTs  ;

    CURSOR c_empleados (p_departamento DEPARTMENTs.DEPARTMENT_ID%TYPE) IS
        select count(*) as num_emp from EMPLOYEES where DEPARTMENT_ID = p_departamento;
BEGIN
    FOR r_departamento IN c_departamentos LOOP
        DBMS_OUTPUT.PUT_LINE(r_departamento.DEPARTMENT_NAME);
        FOR r_empleado IN c_empleados (r_departamento.DEPARTMENT_ID) LOOP
            DBMS_OUTPUT.PUT_LINE('Numero de empleados: ' || r_empleado.num_emp);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/



--2. Construye un bloque de Pl/sql que dado un país me saque por consola (dbms_output)
--el nombre y apellidos y fecha de incorporación de los empleados que trabajan en ese
--país. Los empleados irán ordenados alfabéticamente por apellido.
DECLARE
    CURSOR c_empleados (p_pais COUNTRIES.country_name%TYPE ) IS
        SELECT e.FIRST_NAME, e.LAST_NAME, e.HIRE_DATE 
        FROM EMPLOYEES e 
        JOIN DEPARTMENTS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID 
        JOIN LOCATIONS l ON l.LOCATION_ID = d.LOCATION_ID 
        JOIN COUNTRIES c ON c.COUNTRY_ID = l.COUNTRY_ID
        where upper(c.country_name) = upper(p_pais)
        order by e.LAST_NAME;
    v_entrada COUNTRIES.country_name%TYPE := '&NOMBRE_PAIS';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Pais: ' || v_entrada);
    FOR r_empleado IN c_empleados (v_entrada) LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || r_empleado.FIRST_NAME || ' ' || r_empleado.LAST_NAME || ' - ' || r_empleado.HIRE_DATE);
    END LOOP;
END;
/

--3. Codificar un programa que visualice los dos empleados que ganan menos de cada
--oficio.
DECLARE
    CURSOR c_trabajos IS
        SELECT * FROM JOBS;

    CURSOR c_empleados (p_trabajo JOBS.JOB_ID%TYPE) IS
        select * from EMPLOYEES where JOB_ID = p_trabajo order by SALARY;

    v_count NUMBER;

BEGIN
    FOR r_trabajo IN c_trabajos LOOP
        DBMS_OUTPUT.PUT_LINE('Trabajo: ' || r_trabajo.job_title);
        v_count := 0;
        FOR r_empleado IN c_empleados (r_trabajo.JOB_ID) LOOP
            DBMS_OUTPUT.PUT_LINE('- ' || r_empleado.FIRST_NAME);
            v_count := v_count + 1;
            EXIT when v_count = 2;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

    

--4. Construye un bloque de pl/sql que me saque por consola la siguiente información:
--➢Trabajo (código y descripción)
--➢Sueldo medio de los empleados que tienen ese trabajo
--➢Por cada trabajo debajo aparecerán ordenados por salario
--descendente:
--○ nombre y apellidos del empleado
--○ Salario
--ITPROG - PROGRAMADOR IT - 20.000
--Juan Perez - 18.000
--Mario Martínez - 17.500
--Ana Fernández - 16.000
--...
--SALES - DEPARTAMENTO DE VENTAS -10.000
DECLARE
    CURSOR c_trabajos IS
        SELECT j.JOB_ID, j.JOB_TITLE, round(AVG(e.SALARY),2) as sal
        FROM JOBS j
        JOIN EMPLOYEES e ON e.JOB_ID = j.JOB_ID
        GROUP BY j.JOB_ID, j.JOB_TITLE;
    CURSOR c_empleados (p_trabajo JOBS.JOB_ID%TYPE) IS
        select * from EMPLOYEES where JOB_ID = p_trabajo ORDER BY SALARY;
BEGIN
    FOR r_trabajo IN c_trabajos LOOP
        DBMS_OUTPUT.PUT_LINE(r_trabajo.JOB_TITLE || ' - ' || r_trabajo.sal);
        FOR r_empleado IN c_empleados (r_trabajo.JOB_ID) LOOP
            DBMS_OUTPUT.PUT_LINE('- ' || r_empleado.FIRST_NAME || ' ' || r_empleado.LAST_NAME || ' - ' || r_empleado.SALARY);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

--5. Necesitamos obtener una salida en que se indique por cada región el número de
--trabajadores y su salario medio y a continuación de cada región todos los países
--pertenecientes a esa región con su número de trabajadores y salario medio.



DECLARE
    CURSOR c_regiones IS
        SELECT r.REGION_ID, r.REGION_NAME, 
            COUNT(e.EMPLOYEE_ID) as empleados, 
            round(avg(e.SALARY),2) as salario_media
        FROM REGIONS r
        JOIN COUNTRIES c ON r.REGION_ID = c.REGION_ID 
        JOIN LOCATIONS l ON c.COUNTRY_ID = l.COUNTRY_ID 
        JOIN DEPARTMENTS d ON l.LOCATION_ID = d.LOCATION_ID 
        JOIN EMPLOYEES e ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
        GROUP BY r.REGION_NAME, r.REGION_ID;

    CURSOR c_paises (p_id_region REGIONS.REGION_ID%TYPE)IS
        SELECT c.COUNTRY_NAME, 
            COUNT(e.EMPLOYEE_ID) as empleados, 
            round(avg(e.SALARY),2) as salario_media
        FROM REGIONS r
        JOIN COUNTRIES c ON r.REGION_ID = c.REGION_ID 
        JOIN LOCATIONS l ON c.COUNTRY_ID = l.COUNTRY_ID 
        JOIN DEPARTMENTS d ON l.LOCATION_ID = d.LOCATION_ID 
        JOIN EMPLOYEES e ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
        where r.REGION_ID = p_id_region
        GROUP BY c.COUNTRY_NAME;
BEGIN
    FOR r_region IN c_regiones LOOP
        DBMS_OUTPUT.PUT_LINE(r_region.REGION_NAME || '. Empleados: ' || r_region.empleados || '. Salario medio: ' || r_region.salario_media);
        FOR r_pais IN c_paises (r_region.REGION_ID) LOOP
            DBMS_OUTPUT.PUT_LINE('- ' || r_pais.COUNTRY_NAME || '. Empleados: ' || r_region.empleados || '. Salario medio: ' || r_region.salario_media);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
