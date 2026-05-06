--
--1
--
--Automatic Zoom
--EJERCICIO HR – EJERCICIOS PL - Procedimientos y Funciones
--Utiliza la BBDD HR
--1. Codificar un procedimiento que permita borrar un empleado cuyo número se pasa en
--la llamada.

CREATE OR REPLACE PROCEDURE proc_eliminar_empleado (p_empleado_id EMPLOYEES.EMPLOYEE_ID%TYPE) AS 
BEGIN
    --eliminar el historial
    DELETE FROM JOB_HISTORY WHERE EMPLOYEE_ID = p_empleado_id;
    --eliminar si aparece como manager de algun departamento
    UPDATE DEPARTMENTS d set d.MANAGER_ID = null WHERE d.MANAGER_ID = p_empleado_id;
    --eliminar su id si aparece como manager de algun empleado
    UPDATE EMPLOYEES e set e.MANAGER_ID = null WHERE e.MANAGER_ID = p_empleado_id;
    --ahora si se puede eliminar
    DELETE FROM EMPLOYEES e WHERE e.EMPLOYEE_ID = p_empleado_id;
END;
/
EXECUTE PROC_ELIMINAR_EMPLEADO(100);

select * from EMPLOYEES;

ROLLBACK;


--2. Escribir un procedimiento que modifique la descripción de un departamento. El
--procedimiento recibirá como parámetros el número de departamento y la nueva
--descripción.

CREATE OR REPLACE PROCEDURE cambiar_descripcion_departamento (
                p_id_departamento DEPARTMENTS.DEPARTMENT_ID%TYPE, 
                p_descripcion_departamento DEPARTMENTS.DEPARTMENT_NAME%TYPE
            ) AS
BEGIN 
    UPDATE DEPARTMENTS d set d.DEPARTMENT_NAME = p_descripcion_departamento
    WHERE d.DEPARTMENT_ID = p_id_departamento;
END;
/
EXECUTE CAMBIAR_DESCRIPCION_DEPARTAMENTO(60,'Information Technology');
select * from DEPARTMENTS;
ROLLBACK;

--3. Haz un procedimiento donde visualicemos los 2 departamentos más caros y el total de
--dinero destinado en salarios por esos departamentos (se considera como
--departamento más caro aquel cuya suma de sueldos de sus empleados sea la más
--alta).

CREATE OR REPLACE PROCEDURE proc_departamentos_caros AS
    CURSOR c_departamentos IS
        SELECT d.DEPARTMENT_ID, d.DEPARTMENT_NAME, SUM(e.SALARY) as total
        FROM DEPARTMENTS d 
        JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
        group BY d.DEPARTMEnT_ID, d.DEPARTMENT_NAME
        order by total desc
        fetch first 2 rows only;
BEGIN
    FOR x IN c_departamentos LOOP
        DBMS_OUTPUT.PUT_LINE(x.DEPARTMENT_NAME  || ' - ' || x.total);
    END LOOP;
END;
/
EXECUTE PROC_DEPARTAMENTOS_CAROS;

--4. Haz una función donde se nos muestre el IRPF de un empleado. Si gana por debajo de
--4000 devolverá 10% de su salario y si gana igual o más devolverá 15% de su salario.

CREATE OR REPLACE FUNCTION obtener_irpf (p_id_empleado EMPLOYEES.EMPLOYEE_ID%TYPE)
RETURN NUMBER IS
    v_registro EMPLOYEES%rowtype;
BEGIN
    SELECT * into v_registro FROM EMPLOYEES e WHERE e.EMPLOYEE_ID = p_id_empleado;
    IF v_registro.SALARY < 4000 THEN
        RETURN 0.1 * v_registro.SALARY;
    ELSE
      RETURN 0.15 * v_registro.SALARY;
    END IF;
END;
/
select * from EMPLOYEES;
select OBTENER_IRPF(101) FROM dual;
--5. Escribir un programa que incremente el salario de los empleados de un determinado
--departamento que se pasará como primer parámetro. El incremento será una cantidad
--en euros que se pasará como segundo parámetro en la llamada. El programa deberá
--informar del número de filas afectadas por la actualización.
CREATE OR REPLACE PROCEDURE aumento_salarial (
                            p_id_departamento DEPARTMENTS.DEPARTMENT_ID%TYPE, 
                            cantidad EMPLOYEES.SALARY%TYPE) AS
BEGIN
    UPDATE EMPLOYEES e SET e.SALARY = e.SALARY + cantidad WHERE e.DEPARTMENT_ID = p_id_departamento;
    DBMS_OUTPUT.PUT_LINE('Registros afectados: ' || sql%rowcount);
END;
/
EXECUTE aumento_salarial(20, 500);
select e.EMPLOYEE_ID, e.SALARY from EMPLOYEES e WHERE e.DEPARTMENT_ID = 20;
--6. Haz una función que reciba el id de empleado y devuelva el número de empleados que
--tiene a su cargo.
select e.EMPLOYEE_ID, e.FIRST_NAME,  (
    select count(*) from EMPLOYEES e2
    where e2.MANAGER_ID = e.EMPLOYEE_ID
) as empleados_a_cargo
FROM EMPLOYEES e WHERE e.EMPLOYEE_ID IN (
    SELECT d.MANAGER_ID FROM DEPARTMENTS d
)
order by e.EMPLOYEE_ID;

CREATE OR REPLACE FUNCTION empleados_a_cargo (p_id_empleado EMPLOYEES.EMPLOYEE_ID%TYPE) 
RETURN NUMBER IS
    v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*) into v_cantidad
    FROM EMPLOYEES e
    WHERE e.MANAGER_ID = p_id_empleado;
    RETURN v_cantidad;
END;
/

select empleados_a_cargo(101) from dual;

select e.EMPLOYEE_ID, e.FIRST_NAME, EMPLEADOS_A_CARGO(e.EMPLOYEE_ID) from EMPLOYEES e 
JOIN DEPARTMENTS d ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
order by e.EMPLOYEE_ID;

select * from EMPLOYEES where MANAGER_ID = 101;

select * from DEPARTMENTS;
--7. Haz un procedimiento que reciba como parámetro un código de empleado y Modifica
--el salario de un empleado en función del número de empleados que tiene a su cargo:
--● si no tiene ningún empleado a su cargo subirle 50 euros
--● si tiene 1 empleado a su cargo subirle 80 euros
--● si tiene 2 empleados a su cargo subirle 100 euros
--● si tiene más de tres empleados a su cargo subirle 110 euros
--● si es el PRESIDENTE su salario se incrementa en 30 euros
--Para saber el número de empleados a cargo de un trabajador debes llamar a la función
--del ejercicio anterior.

CREATE OR REPLACE PROCEDURE cambiar_salario (id_empleado EMPLOYEES.EMPLOYEE_ID%TYPE) AS
    v_a_cargo NUMBER;
    v_incremento NUMBER;
    v_id_job jobs.JOB_ID%TYPE;
BEGIN 
    SELECT e.JOB_ID 
    into v_id_job 
    FROM EMPLOYEES e 
    WHERE e.EMPLOYEE_ID = id_empleado;
    IF v_id_job = 'AD_PRES' THEN
        v_incremento := 30;
    ELSE
        v_a_cargo := EMPLEADOS_A_CARGO(id_empleado);
        IF v_a_cargo = 1 THEN  v_incremento := 80;
        ELSIF v_a_cargo = 2 THEN v_incremento := 100;
        ELSIF v_a_cargo >= 3 THEN v_incremento := 110;
        ELSE v_incremento := 50;
        END IF;
    END IF;
    UPDATE EMPLOYEES e 
    SET e.SALARY = e.SALARY + v_incremento 
    WHERE e.EMPLOYEES_id = id_empleado;
END;
/

    

    