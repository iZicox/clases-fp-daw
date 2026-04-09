DECLARE
    v_num_1 NUMBER(10,2) := 5;
    v_num_2 NUMBER(10,2) := 3;
    v_resultado NUMBER(10,2);
    v_in VARCHAR2;
    v_nombre VARCHAR2;
BEGIN
    v_nombre := &v_in;
    DBMS_OUTPUT.PUT_LINE('Escribe tu nombre: ' || v_nombre);

    DBMS_OUTPUT.PUT_LINE('Operaciones aritmeticas');

    v_resultado := v_num_1 + v_num_2;
    DBMS_OUTPUT.PUT_LINE('Suma: ' || v_resultado);

    v_resultado := v_num_1 - v_num_2;
    DBMS_OUTPUT.PUT_LINE('Resta: ' || v_resultado);

    v_resultado := v_num_1 / v_num_2;
    DBMS_OUTPUT.PUT_LINE('Division: ' || v_resultado);

    v_resultado := v_num_1 * v_num_2;
    DBMS_OUTPUT.PUT_LINE('Multiplicacion: ' || v_resultado);


end;