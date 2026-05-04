--
--1
--
--Automatic Zoom
--Ejercicio Viveros – EJERCICIOS PL - Cursores
--Utiliza la BBDD Viveros

--1. Crear un bloque PL que recorra un cursor con todos los clientes que vivan en España y
--pinte el nombre del cliente, su teléfono y su ciudad.
DECLARE
    CURSOR c_clientes IS
        SELECT * FROM CLIENTE WHERE PAIS like 'Spain';
BEGIN
    FOR r_cliente IN c_clientes LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || r_cliente.nombrecliente || ' ' || r_cliente.telefono || ' ' || r_cliente.ciudad);
    END LOOP;
END;
/

--2. Crear un bloque PL que le pida al usuario un precio para que introduzca por teclado y
--haga un cursor con todos los productos que valgan (precio venta) menos del precio
--introducido. Sacar nombre del producto, precio de venta y dimensiones.
DECLARE
    CURSOR c_productos (p_precio PRODUCTO.PRECIOVENTA%TYPE) IS
        SELECT NOMBRE, PRECIOVENTA, DIMENSIONES 
        FROM PRODUCTO 
        WHERE PRECIOVENTA < p_precio;

    v_in PRODUCTO.PRECIOVENTA%TYPE := '&INTRODUCE_UN_PRECIO';

BEGIN
    DBMS_OUTPUT.PUT_LINE('Productos con un precio menor a ' || v_in);
    DBMS_OUTPUT.PUT_LINE('');
    FOR r_producto IN c_productos (v_in) LOOP
        DBMS_OUTPUT.PUT_LINE(r_producto.NOMBRE);
        DBMS_OUTPUT.PUT_LINE('- Precio: ' || r_producto.PRECIOVENTA);
        DBMS_OUTPUT.PUT_LINE('- Dimensiones: ' || r_producto.DIMENSIONES);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/

--3. Escribir un bloque PL que reciba una cadena y visualice el apellido y el código de
--empleado de todos los empleados cuyo apellido contenga la cadena especificada. Al
--finalizar se visualizará el número de empleados mostrados.
DECLARE
    CURSOR c_empleados (p_cadena EMPLEADO.APELLIDO1%TYPE) IS
        SELECT APELLIDO1 as apellido, CODEMPLEADO as cod 
        FROM EMPLEADO
        WHERE upper(APELLIDO1) like upper('%'||p_cadena||'%');

    v_in EMPLEADO.APELLIDO1%TYPE := upper('&ESCRIBE_CADENA');
BEGIN
    DBMS_OUTPUT.PUT_LINE('Palabra: ' || v_in);
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Coincidencias');
    FOR x IN c_empleados(v_in) LOOP
      DBMS_OUTPUT.PUT_LINE(x.apellido || ' ' || x.cod);
    END LOOP;
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
    v_in EMPLEADO.CODEMPLEADO%TYPE := '&COD_EMPLEADO';

    CURSOR c_clientes (p_id EMPLEADO.CODEMPLEADO%TYPE) IS
        SELECT 
            c.CODCLIENTE, 
            COUNT(p.CODPEDIDO) as pedidos,
            c.LIMITECREDITO
        FROM CLIENTE c
        JOIN PEDIDO p ON p.CODCLIENTE = c.CODCLIENTE
        WHERE c.CODEMPLEADOVENTAS = p_id
        group by c.CODCLIENTE, c.LIMITECREDITO;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Codigo de empleado: ' || v_in);
    DBMS_OUTPUT.PUT_LINE('');
    FOR r_cliente IN c_clientes (v_in) LOOP
        DBMS_OUTPUT.PUT_LINE('Antes: ' || r_cliente.CODCLIENTE || ' ' || r_cliente.LIMITECREDITO );
        IF r_cliente.pedidos >= 1 AND r_cliente.pedidos <= 5 THEN
            UPDATE CLIENTE SET LIMITECREDITO = LIMITECREDITO * 1.10 WHERE CODCLIENTE = r_cliente.CODCLIENTE;
        ELSIF r_cliente.pedidos >= 6 AND r_cliente.pedidos <= 10 THEN
            UPDATE CLIENTE SET LIMITECREDITO = LIMITECREDITO * 1.15 WHERE CODCLIENTE = r_cliente.CODCLIENTE;
        ELSE  
            UPDATE CLIENTE SET LIMITECREDITO = LIMITECREDITO * 1.20 WHERE CODCLIENTE = r_cliente.CODCLIENTE;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Despues: ' || r_cliente.CODCLIENTE || ' ' || r_cliente.LIMITECREDITO );
    END LOOP;
END;
/
SELECT CODEMPLEADO FROM EMPLEADO;

select * from CLIENTE where CODCLIENTE = 1;

SELECT e.CODEMPLEADO, COUNT(p.CODPEDIDO) 
FROM EMPLEADO e
JOIN CLIENTE c ON c.CODEMPLEADOVENTAS = e.CODEMPLEADO 
JOIN PEDIDO p ON p.CODCLIENTE = c.CODCLIENTE
group by e.CODEMPLEADO;



--5. Haz un informe que me dé por cada producto el nombre del producto, el nombre de
--los clientes que han comprado el producto, el total de clientes que han comprado el
--producto y si no hay pedidos, que indique que no hay pedidos.
--1
DECLARE
    CURSOR c_productos IS
        select nombre, CODPRODUCTO from PRODUCTO;
    CURSOR c_clientes (p_producto producto.CODPRODUCTO%type) IS
        select * from cliente c 
        join pedido p on p.CODCLIENTE = c.CODCLIENTE 
        join DETALLE_PEDIDO dp on dp.CODPEDIDO = p.CODPEDIDO
        where dp.CODPRODUCTO = p_producto;
    v_total_clientes NUMBER;
BEGIN
    FOR r_producto IN c_productos LOOP
        DBMS_OUTPUT.PUT_LINE('Producto: ' || r_producto.nombre);
        v_total_clientes := 0;
        FOR r_cliente IN c_clientes (r_producto.CODPRODUCTO) LOOP
            DBMS_OUTPUT.PUT_LINE('- ' || r_cliente.nombrecliente);
            v_total_clientes := v_total_clientes + 1;
        END LOOP;
        IF v_total_clientes > 0 THEN DBMS_OUTPUT.PUT_LINE('Total clientes: ' || v_total_clientes);
        ELSE DBMS_OUTPUT.PUT_LINE('Total clientes: 0');
        END IF;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
select * from cliente;
select * from cliente c 
join pedido p on p.CODCLIENTE = c.CODCLIENTE 
join DETALLE_PEDIDO dp on dp.CODPEDIDO = p.CODPEDIDO
where dp.CODPRODUCTO = '';
--6. Crea en la tabla de productos un campo llamado “Oferta” que admitirá valores (SI/NO)
--(estaría bien que el valor por defecto sea NO). Haz un script con un cursor que recorra
--los productos con stock de más de 100 unidades y para los que no haya pedidos. Para
--estos pedidos se marcará el campo oferta con SI.
--Asegúrate que nadie puede modificar los registros del cursor que estás recorriendo.
select * from producto;
alter table producto add oferta varchar2(5) DEFAULT 'NO';
ALTER TABLE PRODUCTO ADD CONSTRAINT CK_ CHECK (OFERTA IN ('SI','NO'));

DECLARE
    CURSOR c_producto IS
        select p.nombre, p.CODPRODUCTO, p.STOCK from producto p 
        left join DETALLE_PEDIDO dp on dp.CODPRODUCTO = p.CODPRODUCTO 
        left join pedido pe on pe.CODPEDIDO = dp.CODPEDIDO
        where p.stock > 100 and p.CODPRODUCTO not in (
            select dp2.CODPRODUCTO from DETALLE_PEDIDO dp2
        ) for update;
BEGIN
    FOR r IN c_producto LOOP
        update PRODUCTO set OFERTA = 'SI'
        where CODPRODUCTO = r.codproducto;
    END LOOP;
END;
/

selECT codproducto 
            FROM producto 
            WHERE stock > 100 
            AND codproducto NOT IN 
            (
                SELECT DISTINCT codproducto 
                FROM detalle_pedido
            )
            FOR UPDATE;
--7. Crea una nueva tabla de productos descatalogados (misma estructura que la tabla de
--productos). Haz un cursor que recorra los productos con stock de menos de 5 unidades
--y para los que no haya pedidos. Estos productos hay que meterlos en la tabla de
--productos descatalogados y borrarlos de la tabla de productos.
--2