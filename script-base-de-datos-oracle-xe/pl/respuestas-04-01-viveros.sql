--
--1
--
--Automatic Zoom
--Ejercicio Viveros – EJERCICIOS PL - Cursores
--Utiliza la BBDD Viveros
--1. Crear un bloque PL que recorra un cursor con todos los clientes que vivan en España y
--pinte el nombre del cliente, su teléfono y su ciudad.

DECLARE
    CURSOR lista IS
        SELECT C.NOMBRECLIENTE NOMBRE, C.TELEFONO TLF, C.CIUDAD
        FROM CLIENTE C
        WHERE C.PAIS = 'Spain';
BEGIN
    FOR x IN lista LOOP
      DBMS_OUTPUT.PUT_LINE(x.NOMBRE || ', ' || x.TLF || ', ' || x.CIUDAD);
    END LOOP;
END;
/
--2. Crear un bloque PL que le pida al usuario un precio para que introduzca por teclado y
--haga un cursor con todos los productos que valgan (precio venta) menos del precio
--introducido. Sacar nombre del producto, precio de venta y dimensiones.
DECLARE
    CURSOR productos_menores (p_precio_max PRODUCTO.PRECIOVENTA%TYPE) IS
        SELECT NOMBRE, PRECIOVENTA AS PRECIO, DIMENSIONES 
        FROM PRODUCTO 
        WHERE PRECIOVENTA < p_precio_max;
    v_precio_entrada PRODUCTO.PRECIOVENTA%TYPE := '&precio';
    v_nombre PRODUCTO.NOMBRE%TYPE;
    v_precio PRODUCTO.PRECIOVENTA%TYPE;
    v_dimensiones PRODUCTO.DIMENSIONES%TYPE;
BEGIN
    OPEN productos_menores(v_precio_entrada);
    LOOP 
        FETCH productos_menores INTO v_nombre, v_precio, v_dimensiones;
        EXIT WHEN productos_menores%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_nombre || ' - ' || v_precio || ' - ' || v_dimensiones);
    END LOOP;
    CLOSE productos_menores;
END;
/
--3. Escribir un bloque PL que reciba una cadena y visualice el apellido y el código de
--empleado de todos los empleados cuyo apellido contenga la cadena especificada. Al
--finalizar se visualizará el número de empleados mostrados.
DECLARE
    v_letra CHAR := '&INGRESA_LETRA';
    CURSOR lista (p_letra CHAR) IS
        SELECT CODEMPLEADO codigo, APELLIDO1 apellido
        FROM EMPLEADO
        WHERE UPPER(APELLIDO1) LIKE '%'||UPPER(p_letra)||'%';
    v_codigo EMPLEADO.CODEMPLEADO%TYPE;
    v_apellido EMPLEADO.APELLIDO1%TYPE;
    v_registros NUMBER;
BEGIN
    OPEN lista(v_letra);
    LOOP
        FETCH lista INTO v_codigo, v_apellido;
        EXIT WHEN lista%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_codigo || ' - ' || v_apellido);
    END LOOP;
    v_registros := lista%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('==================================');
    DBMS_OUTPUT.PUT_LINE('Registros: ' || v_registros);
    DBMS_OUTPUT.PUT_LINE('==================================');
    CLOSE lista;
END;
/
--4. Crear un bloque PL que le pida al usuario un código de empleado y recorra los clientes
--asociados a ese código de empleado. Por cada cliente contará el número de pedidos y
--en función de estos le aumentará el límite de crédito.
--1. Si el cliente tiene entre 1 y 5 pedidos: Aumenta el límite de crédito en un 10%
--2. Si el cliente tiene entre 6 y 10 pedidos: Aumenta el límite de crédito en un 15%
--3. Si el cliente tiene más de 10 pedidos: Aumenta el límite de crédito en un 20%
--4. Si el cliente no tiene pedidos, no se actualiza el límite de crédito.
--Queremos ver en la salida el código de cliente, el número de pedidos que tiene y el
--límite de crédito antes y después de actualizarse.

DECLARE
    v_cod_emp EMPLEADO.CODEMPLEADO%TYPE := '&codigo_empleado';
    CURSOR c_clientes (p_cod CLIENTE.CODEMPLEADOVENTAS%TYPE) IS
        SELECT c.CODCLIENTE COD, c.NOMBRECLIENTE NOMBRE, c.CODEMPLEADOVENTAS COD_EMPLEADO, c.LIMITECREDITO limite 
        FROM CLIENTE c
        WHERE c.CODEMPLEADOVENTAS = p_cod;
    v_editados NUMBER := 0;
    v_aumento NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('==================================');
    DBMS_OUTPUT.PUT_LINE('Codigo de empleado: ' || v_cod_emp);
    DBMS_OUTPUT.PUT_LINE('==================================');

    DBMS_OUTPUT.PUT_LINE('==================================');
    DBMS_OUTPUT.PUT_LINE('Limite anterior');
    DBMS_OUTPUT.PUT_LINE('==================================');

    FOR r_cliente IN c_clientes(v_cod_emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r_cliente.COD || ' - ' || r_cliente.NOMBRE || ' - ' || r_cliente.limite);
        FOR r_num_pedidos IN (SELECT count(*) num_pedidos FROM PEDIDO WHERE CODCLIENTE = r_cliente.COD) LOOP
            IF r_num_pedidos.num_pedidos >= 0 AND r_num_pedidos.num_pedidos <= 6 THEN
                --aumento 10%
                v_aumento := 10;
                UPDATE CLIENTE
                SET LIMITECREDITO = LIMITECREDITO * 1.10
                WHERE CODCLIENTE = r_cliente.COD;
            ELSIF r_num_pedidos.num_pedidos >= 7 AND r_num_pedidos.num_pedidos <= 10 THEN
                --aumento 15%
                v_aumento := 15;
                UPDATE CLIENTE
                SET LIMITECREDITO = LIMITECREDITO * 1.15
                WHERE CODCLIENTE = r_cliente.COD;
            ELSIF r_num_pedidos.num_pedidos > 10 THEN
                --aumento 20%
                v_aumento := 20;
                UPDATE CLIENTE
                SET LIMITECREDITO = LIMITECREDITO * 1.20
                WHERE CODCLIENTE = r_cliente.COD;
            ELSE
                DBMS_OUTPUT.PUT_LINE('==================================');
                DBMS_OUTPUT.PUT_LINE('No tiene pedidos.');
                DBMS_OUTPUT.PUT_LINE('==================================');
            END IF;
            v_editados := v_editados + sql%ROWCOUNT;
        END LOOP;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('==================================');
    DBMS_OUTPUT.PUT_LINE('El aumento fue de ' || v_aumento || '%');
    DBMS_OUTPUT.PUT_LINE('==================================');

    DBMS_OUTPUT.PUT_LINE('==================================');
    DBMS_OUTPUT.PUT_LINE('Nuevo limite');
    DBMS_OUTPUT.PUT_LINE('==================================');

    FOR r_cliente IN c_clientes(v_cod_emp) LOOP
        DBMS_OUTPUT.PUT_LINE(r_cliente.COD || ' - ' || r_cliente.NOMBRE || ' - ' || r_cliente.limite);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('==================================');
    DBMS_OUTPUT.PUT_LINE('Valores editados: ' || v_editados);
    DBMS_OUTPUT.PUT_LINE('==================================');
END;
/
ROLLBACK;
SELECT c.CODCLIENTE COD, c.NOMBRECLIENTE NOMBRE, c.CODEMPLEADOVENTAS COD_EMPLEADO, c.LIMITECREDITO limite 
        FROM CLIENTE c
        WHERE c.CODEMPLEADOVENTAS = '5';

--5. Haz un informe que me dé por cada producto el nombre del producto, el nombre de
--los clientes que han comprado el producto, el total de clientes que han comprado el
--producto y si no hay pedidos, que indique que no hay pedidos.
--(IMAGEN)
--1
DECLARE
    CURSOR c_lista_clientes (p_codproducto PRODUCTO.CODPRODUCTO%TYPE) IS
        SELECT distinct C.NOMBRECLIENTE
        FROM PRODUCTO P 
        JOIN DETALLE_PEDIDO DP ON DP.CODPRODUCTO = P.CODPRODUCTO 
        JOIN PEDIDO PE ON PE.CODPEDIDO = DP.CODPEDIDO 
        JOIN CLIENTE C ON C.CODCLIENTE = PE.CODCLIENTE 
        WHERE P.CODPRODUCTO = p_codproducto;
    CURSOR c_nombre_producto (p_codproducto PRODUCTO.CODPRODUCTO%TYPE) IS
        SELECT P.NOMBRE as nombre
        FROM PRODUCTO P
        WHERE P.CODPRODUCTO = p_codproducto;
    v_codproducto_in PRODUCTO.CODPRODUCTO%TYPE := '&codigo_producto';
    v_nombre_producto PRODUCTO.NOMBRE%TYPE;
    v_cliente CLIENTE.NOMBRECLIENTE%TYPE;
BEGIN
    OPEN c_nombre_producto(v_codproducto_in);
    FETCH c_nombre_producto INTO v_nombre_producto;

    DBMS_OUTPUT.PUT_LINE('===============================');
    DBMS_OUTPUT.PUT_LINE('Codigo de producto: ' || v_codproducto_in);
    
    IF c_nombre_producto%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nombre producto: ' || v_nombre_producto);
        DBMS_OUTPUT.PUT_LINE('===============================');

        OPEN c_lista_clientes(v_codproducto_in);
        FETCH c_lista_clientes INTO v_cliente;
        WHILE c_lista_clientes%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE('Cliente: ' || v_cliente);
            FETCH c_lista_clientes INTO v_cliente;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('Filas: ' || c_lista_clientes%rowcount);
        CLOSE c_lista_clientes;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Producto no encontrado');
        DBMS_OUTPUT.PUT_LINE('===============================');
    END IF;
    CLOSE c_nombre_producto;



END;
/    
SELECT P.CODPRODUCTO, P.NOMBRE, C.NOMBRECLIENTE
FROM PRODUCTO P 
JOIN DETALLE_PEDIDO DP ON DP.CODPRODUCTO = P.CODPRODUCTO 
JOIN PEDIDO PE ON PE.CODPEDIDO = DP.CODPEDIDO 
JOIN CLIENTE C ON C.CODCLIENTE = PE.CODCLIENTE 
WHERE P.CODPRODUCTO = '11679';
--6. Crea en la tabla de productos un campo llamado “Oferta” que admitirá valores (SI/NO)
--(estaría bien que el valor por defecto sea NO). Haz un script con un cursor que recorra
--los productos con stock de más de 100 unidades y para los que no haya pedidos. Para
--estos pedidos se marcará el campo oferta con SI.
--Asegúrate que nadie puede modificar los registros del cursor que estás recorriendo.
DECLARE
    CURSOR c_oferta IS
        SELECT * FROM PRODUCTO P 
        WHERE P.STOCK > 100 
        AND P.CODPRODUCTO NOT IN (
            SELECT DISTINCT DP.CODPRODUCTO
            FROM DETALLE_PEDIDO DP
        )
        FOR UPDATE NOWAIT;
BEGIN
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('Primeros 5 registros antes del update');
    DBMS_OUTPUT.PUT_LINE('========================================');

    FOR x IN (
        SELECT P.NOMBRE, p.oferta FROM PRODUCTO P 
        WHERE P.STOCK > 100 
        AND P.CODPRODUCTO NOT IN (
            SELECT DISTINCT DP.CODPRODUCTO
            FROM DETALLE_PEDIDO DP
        ) and rownum <= 5
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(x.nombre || ' - ' || x.oferta);
    END LOOP;

    FOR r_oferta IN c_oferta LOOP
        UPDATE PRODUCTO
        SET OFERTA = 'SI'
        WHERE CURRENT OF c_oferta;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('Primeros 5 registros despues del update');
    DBMS_OUTPUT.PUT_LINE('========================================');

    FOR x IN (
        SELECT P.NOMBRE, p.oferta FROM PRODUCTO P 
        WHERE P.STOCK > 100 
        AND P.CODPRODUCTO NOT IN (
            SELECT DISTINCT DP.CODPRODUCTO
            FROM DETALLE_PEDIDO DP
        ) and rownum <= 5
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(x.nombre || ' - ' || x.oferta);
    END LOOP;
end;

/
rollback;
SELECT P.NOMBRE, p.oferta FROM PRODUCTO P 
WHERE P.STOCK > 100 
AND P.CODPRODUCTO NOT IN (
    SELECT DISTINCT DP.CODPRODUCTO
    FROM DETALLE_PEDIDO DP
) and rownum <= 5;
alter table producto add oferta varchar2(5) default 'NO';
alter table producto add constraint CHK_OFERTA check (oferta in ('SI','NO'));
select * from producto;
--7. Crea una nueva tabla de productos descatalogados (misma estructura que la tabla de
--productos). Haz un cursor que recorra los productos con stock de menos de 5 unidades
--y para los que no haya pedidos. Estos productos hay que meterlos en la tabla de
--productos descatalogados y borrarlos de la tabla de productos.
--2
DECLARE
    CURSOR c_descatalogados IS
        SELECT P.* FROM PRODUCTO P 
        WHERE P.STOCK < 5 
        AND NOT EXISTS (
            SELECT 1
            FROM DETALLE_PEDIDO DP
            WHERE DP.CODPRODUCTO = P.CODPRODUCTO
        );
    v_registro PRODUCTO%ROWTYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=============INICIO=================');
    -- inserta productos
    OPEN c_descatalogados;
    LOOP
        FETCH c_descatalogados INTO v_registro;
        EXIT WHEN c_descatalogados%NOTFOUND;
        INSERT INTO descatalogados VALUES v_registro;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Insertados: ' || c_descatalogados%ROWCOUNT);
    CLOSE c_descatalogados;
    -- elimina productos
    FOR registro IN c_descatalogados LOOP
        DELETE FROM PRODUCTO WHERE CODPRODUCTO = registro.codproducto;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=============FIN=================');

END;
/
create table descatalogados 
as
select * from producto where 1=2;

SELECT P.* FROM PRODUCTO P 
WHERE P.STOCK < 5 
AND P.CODPRODUCTO NOT IN (
    SELECT DISTINCT DP.CODPRODUCTO
    FROM DETALLE_PEDIDO DP
);

select * from descatalogados;

rollback;