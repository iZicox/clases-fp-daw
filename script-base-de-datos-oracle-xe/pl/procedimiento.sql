CREATE OR REPLACE FUNCTION get_sal (p_id empleado.codemp%TYPE)
RETURN empleado.salemp%TYPE IS
    v_salario empleado.salemp%TYPE := 0;
BEGIN
    SELECT salemp INTO v_salario 
    FROM EMPLEADO
    WHERE codemp = p_id;

    RETURN v_salario;
END;
/
select get_sal(1) from dual;
    
