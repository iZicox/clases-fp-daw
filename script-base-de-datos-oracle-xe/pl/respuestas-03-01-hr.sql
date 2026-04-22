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
--5. Necesitamos obtener una salida en que se indique por cada región el número de
--trabajadores y su salario medio y a continuación de cada región todos los países
--pertenecientes a esa región con su número de trabajadores y salario medio.