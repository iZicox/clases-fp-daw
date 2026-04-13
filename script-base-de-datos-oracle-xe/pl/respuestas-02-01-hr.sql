--
--1
--
--Automatic Zoom
--EJERCICIO HR – EJERCICIOS PL
--Utiliza la BBDD HR
--1. Crear un bloque PL que visualice el departamento de un empleado que se pida al
--usuario por teclado.

DECLARE 
    V_COD_EMP EMPLOYEES.EMPLOYEE_ID%TYPE := '&COD_EMP';
    V_DEPARTAMENTO DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('CODIGO EMPLEADO: ' || V_COD_EMP);
    SELECT D.DEPARTMENT_NAME 
    INTO V_DEPARTAMENTO
    FROM EMPLOYEES E 
    JOIN DEPARTMENTS D ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
    WHERE E.EMPLOYEE_ID = V_COD_EMP;
    DBMS_OUTPUT.PUT_LINE('DEPARTAMENTO: ' || V_DEPARTAMENTO);
END;
/
--2. Incrementar el salario 100€  a todos los trabajadores que sean ‘IT_PROG’, mediante un
--bloque anónimo PL, asignando dicho valor a una variable declarada.

DECLARE
    V_INCREMENTO NUMBER := 100;
BEGIN
    UPDATE EMPLOYEES
    SET SALARY = SALARY + 100
    WHERE JOB_ID = 'IT_PROG';
END;
/
SELECT * FROM EMPLOYEES WHERE JOB_ID = 'IT_PROG';
--3. Crea un bloque de PL/SQL que inserte un nuevo registro en la tabla de empleados. Con
--las siguientes características:
--3.a.Pedirá por teclado al usuario un código de empleado válido (employee_id)
--3.b.Buscará al empleado que menos dinero gane que pertenezca al mismo
--departamento que el que nos han pasado y duplicará todos sus datos menos
--3.b.i. El id (sacarlo de la secuencia)
--3.b.ii. El nombre y apellidos que será: PEPITO GRILLO
--3.b.iii. La fecha de contratación será hoy.

DECLARE
    v_cod_empleado EMPLOYEES.EMPLOYEE_ID%TYPE := '&INGRESA_COD_EMPLEADO';
    v_departamento_id EMPLOYEES.DEPARTMENT_ID%TYPE;
    v_empleado_existe NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('===========================');
    DBMS_OUTPUT.PUT_LINE('Codigo empleado: ' || v_cod_empleado);
    DBMS_OUTPUT.PUT_LINE('===========================');
    
    -- Verificar si el empleado existe
    SELECT COUNT(*) INTO v_empleado_existe
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = v_cod_empleado;
    
    IF v_empleado_existe = 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: El empleado con código ' || v_cod_empleado || ' no existe');
        RETURN;
    END IF;
    
    -- Obtener el departamento del empleado ingresado
    SELECT DEPARTMENT_ID INTO v_departamento_id
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = v_cod_empleado;
    
    -- Insertar nuevo empleado usando la secuencia
    INSERT INTO EMPLOYEES (
        EMPLOYEE_ID,
        FIRST_NAME,
        LAST_NAME,
        EMAIL,
        PHONE_NUMBER,
        HIRE_DATE,
        JOB_ID,
        SALARY,
        COMMISSION_PCT,
        MANAGER_ID,
        DEPARTMENT_ID
    )
    SELECT 
        employees_seq.NEXTVAL,
        'PEPITO',
        'GRILLO',
        'PGRILLO' || TO_CHAR(employees_seq.NEXTVAL) || '@empresa.com', -- Email único
        '555-' || TO_CHAR(employees_seq.NEXTVAL), -- Teléfono único
        SYSDATE,
        E.JOB_ID,
        E.SALARY,
        E.COMMISSION_PCT,
        E.MANAGER_ID,
        E.DEPARTMENT_ID
    FROM EMPLOYEES E
    WHERE E.DEPARTMENT_ID = v_departamento_id
    ORDER BY E.SALARY ASC
    FETCH FIRST 1 ROWS ONLY;
    
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('===========================');
        DBMS_OUTPUT.PUT_LINE('Inserción exitosa');
        DBMS_OUTPUT.PUT_LINE('===========================');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('ERROR: No se encontraron empleados en el departamento');
        ROLLBACK;
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No se encontró el departamento');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        ROLLBACK;
END;
/
SELECT  DEFAULT,
        'PEPITO',
        'GRILLO',
        E.EMAIL,
        E.PHONE_NUMBER,
        SYSDATE,
        E.JOB_ID,
        E.SALARY,
        E.COMMISSION_PCT,
        E.MANAGER_ID,
        E.DEPARTMENT_ID
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
WHERE E.DEPARTMENT_ID = (
    SELECT D2.DEPARTMENT_ID FROM EMPLOYEES E2 
    JOIN DEPARTMENTS D2 ON D2.DEPARTMENT_ID = E2.DEPARTMENT_ID
    WHERE E2.EMPLOYEE_ID = '100'
) ORDER BY E.SALARY ASC
FETCH FIRST 1 ROWS ONLY;

SELECT  *
  FROM employees e
  order by EMPLOYEE_ID desc;




select * from EMPLOYEES;

--4. Diseñar un bloque PL que introduciendo el código de un empleado por teclado,
--visualice el sueldo y su código, para posteriormente actualizar su comisión teniendo en
--cuenta que si su salario es menor de 3.000 € su comisión será del 10% de este, si está
--entre 3.000 y 5.000 del 15% y si es mayor de 5.000 el 20%. Posteriormente se
--visualizará su comisión actualizada.
--5. Introduciendo un año por teclado, decir si este es bisiesto o no.
--6. Diseñar un bloque de PL que le pida al usuario un código de empleado y que devuelva
--el mayor divisor del salario del empleado.
--7. Dado un país introducido por teclado, obtener el número de empleados que hay en ese
--país.
--8. Crear una tabla llamada TANGULOS con tres columnas ángulo, seno, coseno. Rellenar
--la misma mediante un bloque PL de todos los ángulos comprendidos entre 0 y 90, en
--intervalos de diez en diez.
--9. Haz un bloque anónimo que pida un id de empleado y cuente el número de vocales
--que hay en su email.
--10. Los departamentos de RRHH e ADMINISTRACIÓN se van a fusionar, por lo que
--debemos hacer un proceso que:
--10.a. Genere un nuevo departamento (RRHH+ADMIN)
--10.b. Cuyo responsable ý localización será igual al del actual de RRHH
--10.c. Asigne a los trabajadores de ambos departamentos el nuevo manager y el
--nuevo departamento