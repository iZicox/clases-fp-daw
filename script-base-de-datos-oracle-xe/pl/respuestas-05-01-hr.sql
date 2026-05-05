--
--1
--
--Automatic Zoom
--EJERCICIO HR – EJERCICIOS PL - Procedimientos y Funciones
--Utiliza la BBDD HR
--1. Codificar un procedimiento que permita borrar un empleado cuyo número se pasa en
--la llamada.
CREATE OR REPLACE PROCEDURE eliminar_empleado (
        p_employee_id IN employees.employee_id%TYPE ) AS
BEGIN
    -- 1. Borrar historial de trabajos del empleado
    DELETE FROM job_history WHERE employee_id = p_employee_id;
    -- 2. Si el empleado es manager de algún departamento, dejar ese campo NULL
    UPDATE departments SET manager_id = NULL WHERE manager_id = p_employee_id;
    -- 3. Si el empleado es manager de otros empleados, quitar esa referencia
    UPDATE employees SET manager_id = NULL WHERE manager_id = p_employee_id;
    -- 4. Finalmente borrar al empleado
    DELETE FROM employees WHERE employee_id = p_employee_id;
END eliminar_empleado;
/
call ELIMINAR_EMPLEADO (102);
ROLLBACK;
select * FROM EMPLOYEES;
--2. Escribir un procedimiento que modifique la descripción de un departamento. El
--procedimiento recibirá como parámetros el número de departamento y la nueva
--descripción.
CREATE OR REPLACE PROCEDURE cambiar_departamento (p_id IN DEPARTMENTS.DEPARTMENT_ID%TYPE, 
                                                    p_nombre IN DEPARTMENTS.DEPARTMENT_NAME%TYPE) AS 

BEGIN
    UPDATE DEPARTMENTS d SET d.DEPARTMENT_NAME = p_nombre WHERE d.DEPARTMENT_ID = p_id;
END;
/
EXECUTE CAMBIAR_DEPARTAMENTO (10, 'asdad');

SELECT * from DEPARTMENTS;
--3. Haz un procedimiento donde visualicemos los 2 departamentos más caros y el total de
--dinero destinado en salarios por esos departamentos (se considera como
--departamento más caro aquel cuya suma de sueldos de sus empleados sea la más
--alta).
CREATE OR REPLACE PROCEDURE departamentos_caros AS
    v_cont NUMBER := 0;
BEGIN
    FOR registro IN (
        SELECT d.DEPARTMENT_ID, d.DEPARTMENT_NAME, sum(e.SALARY) as salario FROM DEPARTMENTS d 
        JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID 
        group by d.DEPARTMENT_ID, d.DEPARTMENT_NAME
        order by salario desc
    ) LOOP
        EXIT WHEN v_cont = 2;
        DBMS_OUTPUT.PUT_LINE(registro.DEPARTMENT_NAME || ' - ' || registro.salario);
        v_cont := v_cont + 1;
    END LOOP;
END;
/
EXECUTE DEPARTAMENTOS_CAROS;
--4. Haz una función donde se nos muestre el IRPF de un empleado. Si gana por debajo de
--4000 devolverá 10% de su salario y si gana igual o más devolverá 15% de su salario.
SELECT e.FIRST_NAME, e.SALARY FROM EMPLOYEES e;

CREATE OR REPLACE FUNCTION get_irpf (p_id EMPLOYEES.employee_id%type) 
RETURN EMPLOYEES.SALARY%TYPE IS
    v_salario EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT e.SALARY into v_salario FROM EMPLOYEES e WHERE e.EMPLOYEE_ID = p_id;
    IF v_salario < 4000 THEN
      RETURN 0.1 * v_salario;
    ELSE
      RETURN 0.15 * v_salario;
    END IF;
END;
/
SELECT * FROM EMPLOYEES;
SELECT get_irpf(101) from dual;

DECLARE
    v_salario EMPLOYEES.SALARY%TYPE;
BEGIN
    v_salario := GET_IRPF (&id);
    DBMS_OUTPUT.PUT_LINE('IRPF: ' || v_salario);
END;
 /
--5. Escribir un programa que incremente el salario de los empleados de un determinado
--departamento que se pasará como primer parámetro. El incremento será una cantidad
--en euros que se pasará como segundo parámetro en la llamada. El programa deberá
--informar del número de filas afectadas por la actualización.

CREATE OR REPLACE PROCEDURE subir_salario (
    p_id IN EMPLOYEES.EMPLOYEE_ID%TYPE,
    p_cantidad IN EMPLOYEES.SALARY%TYPE
) AS
    v_filas NUMBER;
BEGIN

    UPDATE EMPLOYEES e SET e.SALARY = e.SALARY + p_cantidad WHERE e.EMPLOYEE_ID = p_id;

    v_filas := sql%rowcount;

    DBMS_OUTPUT.PUT_LINE('Registros afectados: ' || v_filas);
END;

/
SELECT * from EMPLOYEES;
EXECUTE SUBIR_SALARIO(101,500);

--6. Haz una función que reciba el id de empleado y devuelva el número de empleados que
--tiene a su cargo.

CREATE OR REPLACE FUNCTION empleados_A_cargo (p_id EMPLOYEES.EMPLOYEE_ID%TYPE) 
RETURN NUMBER IS
    v_cantidad NUMBER;
BEGIN
    SELECT count(*) into v_cantidad from EMPLOYEES e where e.MANAGER_ID = p_id and e.EMPLOYEE_ID != p_id;
    RETURN v_cantidad;
   
END;
/

select EMPLEADOS_A_CARGO(101) FROM DUAL;
SELECT EMPLEADOS_A_CARGO(d.MANAGER_ID) FROM DEPARTMENTS d;
--7. Haz un procedimiento que reciba como parámetro un código de empleado y Modifica
--el salario de un empleado en función del número de empleados que tiene a su cargo:
--● si no tiene ningún empleado a su cargo subirle 50 euros
--● si tiene 1 empleado a su cargo subirle 80 euros
--● si tiene 2 empleados a su cargo subirle 100 euros
--● si tiene más de tres empleados a su cargo subirle 110 euros
--● si es el PRESIDENTE su salario se incrementa en 30 euros
--Para saber el número de empleados a cargo de un trabajador debes llamar a la función
--del ejercicio anterior.

CREATE OR REPLACE PROCEDURE subir_salario_jefes (p_id IN EMPLOYEES.EMPLOYEE_ID%TYPE) AS
    v_a_cargo NUMBER;
    v_id_trabajo EMPLOYEES.JOB_ID%TYPE;
BEGIN
    --sacar el id del trabajo
    SELECT e.JOB_ID into v_id_trabajo FROM EMPLOYEES e where e.EMPLOYEE_ID = p_id;
    --validar si es el presidente
    IF v_id_trabajo = 'AD_PRES' THEN
        DBMS_OUTPUT.PUT_LINE('Es el presidente');
        UPDATE EMPLOYEES e SET e.SALARY = e.SALARY + 30 WHERE e.EMPLOYEE_ID = p_id;
        DBMS_OUTPUT.PUT_LINE('Ingremento de 30');
    --si no es hacemos las otras validaciones
    ELSE
        DBMS_OUTPUT.PUT_LINE('No es el presidente');
        v_a_cargo := EMPLEADOS_A_CARGO(p_id);
        IF v_a_cargo = 1 THEN
        UPDATE EMPLOYEES e SET e.SALARY = e.SALARY + 80; 
        DBMS_OUTPUT.PUT_LINE('Ingremento de 80');
        ELSIF v_a_cargo = 2 THEN
        UPDATE EMPLOYEES e SET e.SALARY = e.SALARY + 100;
        DBMS_OUTPUT.PUT_LINE('Ingremento de 100');
        ELSIF v_a_cargo >= 3 THEN
        UPDATE EMPLOYEES e SET e.SALARY = e.SALARY + 110;
        DBMS_OUTPUT.PUT_LINE('Ingremento de 110');
        END IF;
        DBMS_OUTPUT.PUT_LINE('Empleados a cargo: ' || v_a_cargo);
    END IF;
END;
/
select j.*from jobs j;
select * from EMPLOYEES;
EXECUTE SUBIR_SALARIO_JEFES(101);