

DECLARE
    CURSOR C_EMP_X_DEP IS
        select 
            d.DEPARTMENT_NAME,
            count(e.EMPLOYEE_ID) as total
        from DEPARTMENTS d
        inner join EMPLOYEES e on e.DEPARTMENT_ID = d.DEPARTMENT_ID
        group by d.DEPARTMENT_NAME
        order by total desc;
BEGIN
    FOR REG IN C_EMP_X_DEP LOOP
        DBMS_OUTPUT.PUT_LINE(
            'DEPARTAMENTO: ' || REG.DEPARTMENT_NAME ||
            ' - CANTIDAD: ' || REG.TOTAL
        );
    END LOOP;
END;
