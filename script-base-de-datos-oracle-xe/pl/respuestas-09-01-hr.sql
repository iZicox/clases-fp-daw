--
--1
--
--Automatic Zoom
--Para lanzar errores personalizados puedes utilizar: 
-- 
--RAISE_APPLICATION_ERROR(error_number, message); 
-- 
--Donde error_number es un entero negativo comprendido entre –20000..-20999 y 
--message es una cadena que devolvemos a la aplicación. 
-- 
--1. Crea un trigger de tabla que cuando cambie el número de teléfono de un empleado 
--guarde en una tabla que debes haber creado previamente el código de empleado, el 
--número de teléfono antiguo y el número de teléfono nuevo, además de la fecha del 
--cambio. 
create table historial_telefonos (
    id_empleado NUMBER(6),
    telefono_antiguo VARCHAR2(20),
    telefono_nuevo varchar2(20),
    fecha_cambio DATE
);

ALTER TABLE historial_telefonos
ADD ( CONSTRAINT hist_tlf_pk
       		 PRIMARY KEY (id_empleado,telefono_antiguo,telefono_nuevo)
    ) ;

ALTER TABLE historial_telefonos
ADD ( CONSTRAINT hist_tlf_fk
        	 FOREIGN KEY (id_empleado)
          	  REFERENCES employees(employee_id) 
    ) ;

CREATE OR REPLACE trigger trg_telefonos 
AFTER UPDATE OF phone_number
ON employees
FOR EACH ROW
WHEN (old.phone_number != new.phone_number)
BEGIN
    INSERT INTO HISTORIAL_TELEFONOS (
        ID_EMPLEADO, TELEFONO_ANTIGUO, TELEFONO_NUEVO,
        FECHA_CAMBIO
    ) VALUES (
        :old.EMPLOYEE_ID, :old.phone_number,
        :new.phone_number, sysdate);
END;
/
SELECT PHONE_NUMBER, EMPLOYEE_ID FROM EMPLOYEES;
UPDATE EMPLOYEES e SET e.PHONE_NUMBER = '1'
WHERE e.EMPLOYEE_ID = '101';
SELECT * FROM HISTORIAL_TELEFONOS;
-- 
--2. Crear un trigger que se ejecutará antes de eliminar un empleado e insertará en una 
--tabla de BackUp el id, nombre y apellidos, email, salario, departamento y trabajo, 
--además de la fecha de la eliminación. 
-- 
CREATE OR REPLACE TRIGGER trg_empleado_eliminado
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO empleados_eliminados (
        EMPLOYEE_ID, FIRST_NAME, LAST_NAME,
        EMAIL, SALARY, DEPARTMENT_ID, JOB_ID
    ) VALUES (
        :old.employee_id, :old.first_name,
        :old.last_name, :old.email, :old.salary,
        :old.department_id, :old.job_id
    );
    
END;
/
EXECUTE ELIMINAR_EMPLEADO(105);

CREATE TABLE empleados_eliminados as (
SELECT EMPLOYEE_ID,
        FIRST_NAME, LAST_NAME, EMAIL, SALARY,
        DEPARTMENT_ID, JOB_ID
FROM employees where 1=2
);

SELECT * from EMPLEADOS_ELIMINADOS;


--3. Dentro de la tabla de trabajos hay un salario mínimo y un salario máximo. 
--Necesitamos un control por el que cada vez que se cambie uno de estos datos, 
--saber si hay empleados de ese trabajo que quedan fuera de ese rango, y si es así 
--impedirlo dando un mensaje por consola. 
-- 
--a. Por ejemplo, el salario mínimo de IT_PROG es 4.000. Si se quisiera cambiar 
--el salario mínimo a 5.000, debe dar error porque hay trabajadores con este 
--trabajo que no ganan 5.000. 
-- 
SELECT * FROM JOBS;

CREATE OR REPLACE TRIGGER trg_salario_fuera_rango
BEFORE UPDATE OF min_salary, max_salary ON jobs
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT count(*)
    into v_count
    FROM EMPLOYEES
    WHERE JOB_ID = :new.job_id
    and (salary < :new.min_salary 
        or SALARY > :new.max_salary);

    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Hay empleados fuera del rango');
    END IF;
     
END;
/

SELECT * FROM EMPLOYEES;
SELECT * FROM jobs where JOB_ID = 'AD_VP';

UPDATE JOBS SET MIN_SALARY = '20000' 
WHERE JOB_ID = 'AD_VP';

UPDATE EMPLOYEES E SET E.SALARY = '1000'
WHERE E.EMPLOYEE_ID = '101';

ROLLBACK;

--4. Crea un trigger que me avise al cambiar el departamento de un empleado si el 
--departamento antiguo y el nuevo no están en la misma ciudad. 

CREATE OR REPLACE TRIGGER trg_cambio_dpt 
AFTER UPDATE OF DEPARTMENT_ID ON EMPLOYEES
FOR EACH ROW
DECLARE
    v_ciudad_viejo LOCATIONS.CITY%TYPE;
    v_ciudad_nuevo LOCATIONS.CITY%TYPE;
BEGIN
    SELECT l.CITY 
    into v_ciudad_viejo
    FROM DEPARTMENTS d 
    JOIN LOCATIONS l 
        ON l.LOCATION_ID = d.LOCATION_ID
    WHERE d.DEPARTMENT_ID = :old.DEPARTMENT_ID;

    SELECT l.CITY 
    into v_ciudad_nuevo
    FROM DEPARTMENTS d 
    JOIN LOCATIONS l 
        ON l.LOCATION_ID = d.LOCATION_ID
    WHERE d.DEPARTMENT_ID = :new.DEPARTMENT_ID;

    IF v_ciudad_nuevo != v_ciudad_viejo THEN
        RAISE_APPLICATION_ERROR(-20100,'La ciudad el diferente');
    END IF;
END;
/
SELECT * from EMPLOYEES;

UPDATE EMPLOYEES e 
SET e.DEPARTMENT_ID = '20' 
WHERE e.EMPLOYEE_ID = '108';

SELECT  d.DEPARTMENT_ID,
        d.DEPARTMENT_NAME,
        l.city
 from departments d
JOIN LOCATIONS l 
        ON l.LOCATION_ID = d.LOCATION_ID  ;
-- 
--5. Crea un trigger que, al insertar o actualizar un empleado, verifique que su salario no es 
--inferior al MIN_SALARY ni superior al MAX_SALARY de su puesto en la tabla JOBS. Si es 
--menor al mínimo dará un error e impedirá el cambio, y si es mayor al máximo emite un 
--mensaje de alerta pero permite la modificación. 
-- 

CREATE OR REPLACE TRIGGER trg_salario_empleado
BEFORE INSERT OR UPDATE OF SALARY 
ON EMPLOYEES
FOR EACH ROW

DECLARE
    v_min_sal JOBS.MIN_SALARY%TYPE;
    v_max_sal JOBS.MAX_SALARY%TYPE;
BEGIN
    SELECT MIN_SALARY, MAX_SALARY 
    INTO v_min_sal, v_max_sal 
    FROM JOBS 
    WHERE JOB_ID = :new.job_id;

    IF :new.salary < v_min_sal THEN
        RAISE_APPLICATION_ERROR(-20200,'Salario por debajo del minimo ' || v_min_sal);
    END IF;

    IF :new.salary > v_max_sal THEN
        DBMS_OUTPUT.PUT_LINE('Salario por encima del maximo ' || v_max_sal);
    END IF;
END;
/
SELECT EMPLOYEE_ID, FIRST_NAME, SALARY 
        , JOB_ID
FROM EMPLOYEES;

UPDATE EMPLOYEES e 
SET e.SALARY = '100000' 
WHERE e.EMPLOYEE_ID = '101';

--6. Crea un trigger que avise mediante un mensaje si, al asignar un departamento a un 
--empleado, su jefe directo (manager_id en employees) no coincide con el jefe 
--responsable de dicho departamento (manager_id en departments). (Si al actualizar el 
--departamento de un empleado obtienes un error originado por el trigger 
--HR.UPDATE_JOB_HISTORY, deshabilita dicho trigger). 
-- zz
alter trigger "HR2"."UPDATE_JOB_HISTORY" disable;

CREATE OR REPLACE TRIGGER trg_cambio_dpt_empleado 
AFTER UPDATE OF DEPARTMENT_ID 
ON EMPLOYEES
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN 

    SELECT count(*)
    into v_count
        FROM DEPARTMENTS d 
    WHERE d.MANAGER_ID != :new.manager_id;

    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Jefe directo no coincide con el departamento');
    END IF;
END;
/
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.MANAGER_ID,
        d.MANAGER_ID, e.DEPARTMENT_ID
FROM EMPLOYEES e 
JOIN DEPARTMENTS d 
    ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
order by e.EMPLOYEE_ID;

UPDATE EMPLOYEES e 
SET e.DEPARTMENT_ID = '20' 
WHERE e.EMPLOYEE_ID = '111';

SELECT * from DEPARTMENTS;
--7. Añade la columna COMMISSION_AMT a la tabla EMPLOYEES. Crea un trigger que, cada 
--vez que cambie el salario o el porcentaje de comisión, calcule automáticamente el importe 
--resultante y lo guarde en dicha columna. Si el porcentaje actual es null, el importe de la 
--comisión será 0 (cero, no null). 
select * from EMPLOYEES;
alter table EMPLOYEES ADD COMMISSION_AMT NUMBER(12,2);

CREATE OR REPLACE TRIGGER trg_cambio_salario 
BEFORE UPDATE OF SALARY, commission_pct 
ON employees 
FOR EACH ROW 
BEGIN
    :new.COMMISSION_AMT := :new.salary * nvl(:new.COMMISSION_PCT,0);
END;
/
SELECT e.EMPLOYEE_ID,
        e.FIRST_NAME,
        e.SALARY,
        e.COMMISSION_PCT,
        e.COMMISSION_AMT
FROM EMPLOYEES e;

UPDATE EMPLOYEES e 
SET e.SALARY = 7550 
WHERE e.EMPLOYEE_ID = 160;
    