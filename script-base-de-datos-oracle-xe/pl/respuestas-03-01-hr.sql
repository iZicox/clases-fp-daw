create user hr_vm IDENTIFIED by 123 QUOTA UNLIMITED on users;
GRANT create session, create view, create table, create PROCEDURE, create SEQUENCE to hr_vm;

--2
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
