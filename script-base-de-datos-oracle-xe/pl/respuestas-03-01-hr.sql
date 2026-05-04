create user hr_vm IDENTIFIED by 123 QUOTA UNLIMITED on users;
GRANT create session, create view, create table, create PROCEDURE, create SEQUENCE to hr_vm;

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
        SELECT department_id, department_name from DEPARTMENTS;
    CURSOR c_clientes (p_department_id departments.department_id%TYPE) IS
        select count(*) as num from EMPLOYEES where department_id = p_department_id;
BEGIN
    FOR r_departamento IN c_departamentos LOOP
        FOR r_cliente IN c_clientes (r_departamento.department_id) LOOP
            DBMS_OUTPUT.PUT_LINE('Departamento: ' || r_departamento.department_name);
            DBMS_OUTPUT.PUT_LINE('Clientes: ' || r_cliente.num);
            DBMS_OUTPUT.PUT_LINE('*************************************');
        end loop;
    END LOOP;
end;
/
select * from departments;
select count(*) from EMPLOYEES where department_id = '40';
--2. Construye un bloque de Pl/sql que dado un país me saque por consola (dbms_output)
--el nombre y apellidos y fecha de incorporación de los empleados que trabajan en ese
--país. Los empleados irán ordenados alfabéticamente por apellido.
SET SERVEROUTPUT ON;
DECLARE
    v_pais_buscado countries.COUNTRY_NAME%TYPE := '&nombre_del_pais';
    CURSOR c_empleados(p_pais countries.country_name%type) IS
    SELECT e.first_name, e.last_name, e.hire_date
    FROM countries c 
    JOIN locations l ON c.country_id = l.country_id 
    JOIN departments d ON l.location_id = d.location_id
    JOIN employees e ON d.department_id = e.department_id
    WHERE upper(c.country_name) = upper(p_pais) 
    order by e.last_name;
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('Pais: ' || v_pais_buscado);
    FOR r_empleado IN c_empleados(v_pais_buscado) LOOP
        DBMS_OUTPUT.PUT_LINE(r_empleado.last_name || ', ' || r_empleado.first_name);
    END LOOP;
END;
/
--3. Codificar un programa que visualice los dos empleados que ganan menos de cada
--oficio.
DECLARE
    v_cont NUMBER;

    CURSOR c_oficios IS
    SELECT * FROM JOBS;

    CURSOR c_empleados (p_oficio JOBS.JOB_ID%TYPE) IS
    SELECT * FROM EMPLOYEES 
    WHERE JOB_ID = p_oficio
    order by SALARY;

BEGIN
    FOR r_oficio IN c_oficios LOOP
        v_cont := 0;
        DBMS_OUTPUT.PUT_LINE('Trabajo: ' || r_oficio.JOB_TITLE);
        FOR r_empleado IN c_empleados(r_oficio.JOB_ID) LOOP
            DBMS_OUTPUT.PUT_LINE('- ' || r_empleado.FIRST_NAME || ' / ' || r_empleado.SALARY);
            v_cont := v_cont + 1;
            EXIT when v_cont = 2;
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

DECLARE
    CURSOR c_trabajos IS
    SELECT j.JOB_ID, j.JOB_TITLE, AVG(e.SALARY) as media 
    FROM JOBS j
    LEFT JOIN EMPLOYEES e ON e.JOB_ID = j.JOB_ID
    group by j.JOB_ID, j.JOB_TITLE;

    CURSOR c_empleados (p_trabajo JOBS.JOB_ID%TYPE) IS
    SELECT e.FIRST_NAME, e.LAST_NAME, e.SALARY 
    FROM EMPLOYEES e
    WHERE e.JOB_ID = p_trabajo;
BEGIN
    FOR r_trabajo IN c_trabajos LOOP
        DBMS_OUTPUT.PUT_LINE(r_trabajo.JOB_ID || ' - ' || r_trabajo.JOB_TITLE || ' - ' || r_trabajo.media);
        FOR r_empleado IN c_empleados (r_trabajo.JOB_ID) LOOP
            DBMS_OUTPUT.PUT_LINE('- ' || r_empleado.FIRST_NAME || ' ' || r_empleado.LAST_NAME || ' - ' || r_empleado.SALARY);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
-- con el while
DECLARE
    CURSOR c_trabajos IS
    SELECT j.JOB_ID, j.JOB_TITLE, AVG(e.SALARY) as media 
    FROM JOBS j
    LEFT JOIN EMPLOYEES e ON e.JOB_ID = j.JOB_ID
    group by j.JOB_ID, j.JOB_TITLE;

    CURSOR c_empleados (p_trabajo JOBS.JOB_ID%TYPE) IS
    SELECT e.FIRST_NAME, e.LAST_NAME, e.SALARY 
    FROM EMPLOYEES e
    WHERE e.JOB_ID = p_trabajo;

    r_empleado c_empleados%rowtype;
    r_trabajo c_trabajos%rowtype;
BEGIN
    OPEN c_trabajos;
    LOOP
        FETCH c_trabajos INTO r_trabajo;
        EXIT when c_trabajos%notfound;
        DBMS_OUTPUT.PUT_LINE(r_trabajo.JOB_ID || ' - ' || r_trabajo.JOB_TITLE || ' - ' || r_trabajo.media);
        OPEN c_empleados(r_trabajo.JOB_ID);
        LOOP
            FETCH c_empleados INTO r_empleado;
            EXIT when c_empleados%notfound;
            DBMS_OUTPUT.PUT_LINE('- ' || r_empleado.FIRST_NAME || ' ' || r_empleado.LAST_NAME || ' - ' || r_empleado.SALARY);
        END LOOP;
        CLOSE c_empleados;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    CLOSE c_trabajos;
END;
/
--SALES - DEPARTAMENTO DE VENTAS -10.000
--5. Necesitamos obtener una salida en que se indique por 
--cada región 
    --el número de trabajadores 
    --y su salario medio 

--y a continuación de cada región todos los países
--pertenecientes a esa región con su número de trabajadores y salario medio.

DECLARE
    CURSOR c_regiones IS
        SELECT r.REGION_ID, r.REGION_NAME, 
            COUNT(e.employee_id) as num_emp, 
            round(AVG(e.SALARY),2) as sal_medio
        FROM REGIONS r
        LEFT JOIN COUNTRIES c ON c.REGION_ID = r.REGION_ID 
        LEFT JOIN LOCATIONS l ON l.COUNTRY_ID = c.COUNTRY_ID
        LEFT JOIN DEPARTMENTS d ON d.LOCATION_ID = l.LOCATION_ID 
        LEFT JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID 
        group by r.REGION_ID, r.REGION_NAME;
    
    CURSOR c_paises (p_region REGIONS.REGION_ID%TYPE) IS
        SELECT c.COUNTRY_NAME, 
            COUNT(e.EMPLOYEE_ID) as num_emp, 
            round(AVG(e.SALARY),2) as sal_medio
        FROM REGIONS r
        LEFT JOIN COUNTRIES c ON c.REGION_ID = r.REGION_ID 
        LEFT JOIN LOCATIONS l ON l.COUNTRY_ID = c.COUNTRY_ID
        LEFT JOIN DEPARTMENTS d ON d.LOCATION_ID = l.LOCATION_ID 
        LEFT JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID 
        WHERE r.REGION_ID = p_region
        group by c.COUNTRY_NAME;
BEGIN
    FOR r_region IN c_regiones LOOP
        DBMS_OUTPUT.PUT_LINE(r_region.REGION_NAME || ' - ' || r_region.num_emp || ' - ' || r_region.sal_medio);
        FOR r_pais IN c_paises(r_region.REGION_ID) LOOP
            DBMS_OUTPUT.PUT_LINE('- ' || r_pais.COUNTRY_NAME || ' - ' || r_pais.num_emp || ' - ' || r_pais.sal_medio);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/