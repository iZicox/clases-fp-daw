--
--1
--
--Automatic Zoom
--Ejercicio Viveros – EJERCICIOS PL - Procedimientos y Funciones
--Utiliza la BBDD Viveros

--1. Crea la función f_calcular_precio_total_pedido para que dado un código de pedido
--calcule la suma total del pedido. Ten en cuenta que un pedido puede contener varios
--productos diferentes y varias cantidades de cada producto.

CREATE OR REPLACE FUNCTION f_calcular_precio_total_pedido (p_cod_pedido PEDIDO.CODPEDIDO%TYPE)
RETURN NUMBER IS
    v_total DETALLE_PEDIDO.PRECIOUNIDAD%TYPE;
BEGIN
    select SUM(dp.CANTIDAD * dp.PRECIOUNIDAD) into v_total 
    from PEDIDO p 
    JOIN DETALLE_PEDIDO dp ON dp.CODPEDIDO = p.CODPEDIDO
    where p.CODPEDIDO = p_cod_pedido 
    group by p.CODPEDIDO;

    RETURN v_total;
END;
/
select f_calcular_precio_total_pedido(1) from dual;

select p.CODPEDIDO , SUM(dp.CANTIDAD * dp.PRECIOUNIDAD) 
    from PEDIDO p 
    JOIN DETALLE_PEDIDO dp ON dp.CODPEDIDO = p.CODPEDIDO

    group by p.CODPEDIDO;

select dp.* from PEDIDO p 
JOIN DETALLE_PEDIDO dp ON dp.CODPEDIDO = p.CODPEDIDO
where dp.CODPEDIDO = 42;
--2. Crea la función f_calcular_suma_pedidos_cliente que a partir de un código de cliente
--calcule la suma total de todos los pedidos realizados por el cliente. Debes utilizar
--función f_calcular_precio_total_pedido que has creado en el ejercicio anterior.

--clientes con pedidos
SELECT * FROM CLIENTE WHERE CODCLIENTE IN (
    SELECT p.CODCLIENTE FROM PEDIDO p
);

CREATE OR REPLACE FUNCTION f_calcular_suma_pedidos_cliente_v1 (p_id_cliente CLIENTE.CODCLIENTE%TYPE)
RETURN NUMBER IS
    v_total NUMBER;
BEGIN

    with lista as (
        SELECT  c.CODCLIENTE, 
            p.CODPEDIDO, 
            F_CALCULAR_PRECIO_TOTAL_PEDIDO(p.CODPEDIDO) as total_pedido 
    FROM CLIENTE c 
    JOIN PEDIDO p ON c.CODCLIENTE = p.CODCLIENTE 
    JOIN DETALLE_PEDIDO dp ON p.CODPEDIDO = dp.CODPEDIDO
    WHERE c.CODCLIENTE = p_id_cliente
    group by p.CODPEDIDO, c.CODCLIENTE
    ) 
    select sum(total_pedido) into v_total from lista;

    RETURN v_total;
END;
/

SELECT f_calcular_suma_pedidos_cliente_v1 (5) from dual;


CREATE OR REPLACE FUNCTION f_calcular_suma_pedidos_cliente_v2 (p_id_cliente CLIENTE.CODCLIENTE%TYPE)
RETURN NUMBER IS
    CURSOR c_totales_pedidos (p_cliente CLIENTE.CODCLIENTE%TYPE) IS
        SELECT  
                F_CALCULAR_PRECIO_TOTAL_PEDIDO(p.CODPEDIDO) as total_pedido 
        FROM CLIENTE c 
        JOIN PEDIDO p ON c.CODCLIENTE = p.CODCLIENTE 
        JOIN DETALLE_PEDIDO dp ON p.CODPEDIDO = dp.CODPEDIDO
        WHERE c.CODCLIENTE = p_cliente
        group by p.CODPEDIDO;
    v_sum NUMBER := 0;
BEGIN
    FOR registro IN c_totales_pedidos (p_id_cliente) LOOP
        v_sum := v_sum + registro.total_pedido;
    END LOOP;
    RETURN v_sum;
END;
/
SELECT f_calcular_suma_pedidos_cliente_v1 (5) from dual;
SELECT f_calcular_suma_pedidos_cliente_v2 (5) from dual;



--3. Crea la función f_calcular_pagos_cliente que a partir de un código de cliente calcule la
--suma total de los pagos realizados por ese cliente.

CREATE OR REPLACE FUNCTION f_calcular_pagos_cliente (p_id_cliente CLIENTE.CODCLIENTE%TYPE)
RETURN NUMBER IS
    v_total PAGO.IMPORTETOTAL%TYPE;
BEGIN

    SELECT SUM(p.IMPORTETOTAL) into v_total from CLIENTE c
    JOIN PAGO p ON p.CODCLIENTE = c.CODCLIENTE
    WHERE c.CODCLIENTE = p_id_cliente
    GROUP BY c.CODCLIENTE;

    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RETURN 0; -- Adjust error handling as needed
END;
/
SELECT F_CALCULAR_PAGOS_CLIENTE(1) from dual;
--4. Crea un procedimiento almacenado que muestre un listado con el nombre del cliente y
--el importe de sus pagos pendientes. Consideramos que los pagos pendientes de un
--cliente es la diferencia entre el importe total de los pedidos y el importe total de los
--pagos. Utiliza las funciones que has creado en los últimos 2 ejercicios.

CREATE OR REPLACE PROCEDURE pagos_cliente AS
    v_diferencia NUMBER;
    v_total_pedidos NUMBER;
    v_total_pagos NUMBER;
BEGIN
    FOR registro IN (
                        select CODCLIENTE, NOMBRECLIENTE from CLIENTE
                    ) LOOP
        v_total_pedidos := f_calcular_suma_pedidos_cliente_v2(registro.CODCLIENTE);
        v_total_pagos := F_CALCULAR_PAGOS_CLIENTE(registro.CODCLIENTE);
        v_diferencia := v_total_pedidos - v_total_pagos;
        DBMS_OUTPUT.PUT_LINE(
            registro.NOMBRECLIENTE || ' - ' || v_total_pedidos || ' - ' || v_total_pagos || ' - ' || v_diferencia);
    END LOOP;
END;
/
CREATE OR REPLACE PROCEDURE pagos_cliente_v2 (p_id_cliente CLIENTE.CODCLIENTE%TYPE) AS
    v_diferencia NUMBER;
    v_total_pedidos NUMBER;
    v_total_pagos NUMBER;
BEGIN
    FOR registro IN (
                        select CODCLIENTE, NOMBRECLIENTE 
                        from CLIENTE 
                        where CODCLIENTE = p_id_cliente
                    ) LOOP
        v_total_pedidos := f_calcular_suma_pedidos_cliente_v2(registro.CODCLIENTE);
        v_total_pagos := F_CALCULAR_PAGOS_CLIENTE(registro.CODCLIENTE);
        v_diferencia := v_total_pedidos - v_total_pagos;
        DBMS_OUTPUT.PUT_LINE(
            registro.NOMBRECLIENTE || ' - ' || v_total_pedidos || ' - ' || v_total_pagos || ' - ' || v_diferencia);
    END LOOP;
END;
/
EXECUTE PAGOS_CLIENTE_v2(1);

--5. Crea un procedimiento que reciba un empleado y haga un cursor con los clientes a los
--que está asociado el empleado. Por cada cliente asociado deberá llamar al
--procedimiento del ejercicio anterior para que vaya “pintando” si tiene pagos
--pendientes.
CREATE OR REPLACE PROCEDURE clientes_penidente_pago_empleado (p_id_empleado EMPLEADO.CODEMPLEADO%TYPE) AS 
    CURSOR c_clientes (id_empleado EMPLEADO.CODEMPLEADO%TYPE) IS
        select CODCLIENTE, NOMBRECLIENTE from cliente where codempleadoventas = id_empleado;
    registro c_clientes%rowtype;
BEGIN
    OPEN c_clientes (p_id_empleado);
        LOOP
            FETCH c_clientes INTO registro;
            EXIT WHEN c_clientes%notfound;
            PAGOS_CLIENTE_V2(registro.CODCLIENTE);
        END LOOP;
    CLOSE c_clientes;
END;
/
execute CLIENTES_PENIDENTE_PAGO_EMPLEADO(19);
--6. Crea una función que reciba como parámetro el codTienda y devuelva su dirección de
--email. La dirección de email se formará concatenando el codTienda y la ciudad, y el
--dominio ‘@viverosdelmundo.org’. Ejemplo: si tenemos la tienda 'BCN-ES' que está en
--Barcelona, su email quedará 'BCN-ES_Barcelona@viverosdelmundo.org'
CREATE OR REPLACE FUNCTION obtener_correo(p_cod_tienda tienda.codTienda%TYPE) 
RETURN VARCHAR2 IS
    v_dominio VARCHAR2(50) := 'viverosdelmundo.org';
    registro tienda%rowtype;
BEGIN
    SELECT * into registro FROM TIENDA where CODTIENDA = p_cod_tienda;
    RETURN registro.codTienda || '_' || registro.ciudad || '@' || v_dominio;
END;
/
SELECT CODTIENDA, OBTENER_CORREO(CODTIENDA) from tienda;
--7. Crea una tabla tienda_email con las columnas:
--codTienda
--email
--Crea un procedimiento almacenado que inserte los codTienda y su email utilizando la
--función creada en el ejercicio anterior
--1

create table tienda_email (
    codtienda VARCHAR2(50),
    email VARCHAR2(50) UNIQUE
);

insert into TIENDA_EMAIL  (
    SELECT CODTIENDA, OBTENER_CORREO(CODTIENDA) from tienda
);

CREATE OR REPLACE PROCEDURE llenar_tabla_v1 AS
BEGIN
    insert into TIENDA_EMAIL  (
        SELECT CODTIENDA, OBTENER_CORREO(CODTIENDA) from tienda
    );
END;
/
CREATE OR REPLACE PROCEDURE llenar_tabla_v2 AS
    CURSOR c_tiendas IS
        select codtienda from tienda;
    registro c_tiendas%rowtype;
BEGIN
    OPEN c_tiendas;
    LOOP
        FETCH c_tiendas INTO registro;
        EXIT WHEN c_tiendas%notfound;
        INSERT INTO TIENDA_EMAIL VALUES(registro.codTienda, OBTENER_CORREO(registro.codtienda));
    END LOOP;
    CLOSE c_tiendas;
END;
/
EXECUTE LLENAR_TABLA_V1;
EXECUTE LLENAR_TABLA_V2;
delete from TIENDA_EMAIL;
select * from tienda_email;