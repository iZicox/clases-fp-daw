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
--4. Haz una función donde se nos muestre el IRPF de un empleado. Si gana por debajo de
--4000 devolverá 10% de su salario y si gana igual o más devolverá 15% de su salario.
--5. Escribir un programa que incremente el salario de los empleados de un determinado
--departamento que se pasará como primer parámetro. El incremento será una cantidad
--en euros que se pasará como segundo parámetro en la llamada. El programa deberá
--informar del número de filas afectadas por la actualización.
--6. Haz una función que reciba el id de empleado y devuelva el número de empleados que
--tiene a su cargo.
--7. Haz un procedimiento que reciba como parámetro un código de empleado y Modifica
--el salario de un empleado en función del número de empleados que tiene a su cargo:
--● si no tiene ningún empleado a su cargo subirle 50 euros
--● si tiene 1 empleado a su cargo subirle 80 euros
--● si tiene 2 empleados a su cargo subirle 100 euros
--● si tiene más de tres empleados a su cargo subirle 110 euros
--● si es el PRESIDENTE su salario se incrementa en 30 euros
--Para saber el número de empleados a cargo de un trabajador debes llamar a la función
--del ejercicio anterior.