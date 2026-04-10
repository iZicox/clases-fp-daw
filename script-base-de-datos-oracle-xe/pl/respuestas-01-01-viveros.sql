CREATE USER VIVEROS_VM IDENTIFIED BY 123 QUOTA UNLIMITED ON users;
GRANT   
    CREATE SESSION,
    CREATE TABLE,
    CREATE VIEW,
    CREATE SEQUENCE,
    CREATE PROCEDURE
TO VIVEROS_VM;


--1.
--Crear un bloque PL que visualice el país de una tienda que se pida al usuario por
--teclado.

DECLARE
    cod_tienda tienda.CODTIENDA%TYPE;
    pais tienda.PAIS%TYPE;
BEGIN
    cod_tienda := '&codigo_de_tienda';
    select pais into pais from TIENDA where UPPER(codtienda) = UPPER(cod_tienda);
    DBMS_OUTPUT.PUT_LINE('El pais de la tienda codigo ' || upper(cod_tienda) || ' es: ' || pais);
END;
/
--2. Dado un tipo de producto introducido por teclado, obtener el número de productos
--que hay asociados a este tipo de producto.

DECLARE
    cant_prod NUMBER;
    tip_prod producto.TIPOPRODUCTO%TYPE;
BEGIN
    tip_prod := upper('&tipo_producto');
    select count(*) into cant_prod from producto where upper(tipoproducto) = upper(tip_prod);
    DBMS_OUTPUT.PUT_LINE('Hay ' || cant_prod || ' productos del tipo ' || tip_prod);
END;
/
select count(*) from producto where tipoproducto = 'Frutales';
select distinct tipoproducto from producto;
--3. Incrementar el precio de venta en 5€  a todos productos para los que su stock sea
--menor de 25 unidades.
BEGIN
    update PRODUCTO
    set PRECIOVENTA = PRECIOVENTA + 5
    where stock < 25;
END;
/
--4. Haz un bloque anónimo que asigne a una variable declarada el código de un cliente y
--cuente el número de pedidos del cliente.
DECLARE
    cod_cli cliente.CODCLIENTE%TYPE := '9';
    pedidos number;
BEGIN
    select count(*) into pedidos from pedido where CODCLIENTE = cod_cli;
    DBMS_OUTPUT.PUT_LINE('El cliente ' || cod_cli || ' tiene ' || pedidos || ' pedidos.');
END;
/
--5. Pide dos tiendas por teclado e indica cuál de las dos tiendas ingresó más dinero por los
--pedidos hechos por sus clientes.
DECLARE
    cod_tienda_1 tienda.CODTIENDA%TYPE := 'BCN-ES';
    cod_tienda_2 tienda.CODTIENDA%TYPE := 'BOS-USA'; 
    ventas_1 NUMBER;
    ventas_2 NUMBER;
BEGIN
    --cod_tienda_1 := UPPER('&cod_tienda_1');
    --cod_tienda_2 := UPPER('&cod_tienda_2');

    select sum(dp.cantidad*dp.preciounidad)
    into ventas_1
    from detalle_pedido dp 
    INNER JOIN PEDIDO p on p.CODPEDIDO = dp.CODPEDIDO 
    INNER JOIN CLIENTE c on c.CODCLIENTE = p.CODCLIENTE 
    INNER JOIN EMPLEADO e on e.CODEMPLEADO = c.CODEMPLEADOVENTAS 
    INNER JOIN TIENDA t on t.CODTIENDA = e.CODTIENDA
    where upper(t.CODTIENDA) = UPPER(cod_tienda_1);

    select sum(dp.cantidad*dp.preciounidad)
    into ventas_2
    from detalle_pedido dp 
    INNER JOIN PEDIDO p on p.CODPEDIDO = dp.CODPEDIDO 
    INNER JOIN CLIENTE c on c.CODCLIENTE = p.CODCLIENTE 
    INNER JOIN EMPLEADO e on e.CODEMPLEADO = c.CODEMPLEADOVENTAS 
    INNER JOIN TIENDA t on t.CODTIENDA = e.CODTIENDA
    where upper(t.CODTIENDA) = UPPER(cod_tienda_2);

    IF ventas_1 > ventas_2 THEN
      DBMS_OUTPUT.PUT_LINE('La tienda ' || cod_tienda_1 || ' tiene mas ventas: ' || ventas_1);
    ELSIF ventas_1 < ventas_2 THEN
      DBMS_OUTPUT.PUT_LINE('La tienda ' || cod_tienda_2 || ' tiene mas ventas: ' || ventas_2);
    ELSE
      DBMS_OUTPUT.PUT_LINE('Las dos tiendas tienen las mismas ventas');
    END IF;

END;
/
select sum(dp.cantidad*dp.preciounidad)
from detalle_pedido dp 
INNER JOIN PEDIDO p on p.CODPEDIDO = dp.CODPEDIDO 
INNER JOIN CLIENTE c on c.CODCLIENTE = p.CODCLIENTE 
INNER JOIN EMPLEADO e on e.CODEMPLEADO = c.CODEMPLEADOVENTAS 
INNER JOIN TIENDA t on t.CODTIENDA = e.CODTIENDA
where t.CODTIENDA = '13';

select CODTIENDA from tienda;


--6. Para un producto introducido por teclado calcula y muestra si su margen de beneficio
--es alto (mayor o igual que el 30%), normal (entre el 30% y el 20%)  o bajo (menor o
--igual que el 20%).
--1.
--7.
--El margen se calculará como ( (precio de venta - precio proveedor)/precio
--proveedor) *100 siempre el que precio proveedor sea distinto de 0. Si es 0
--pondremos SIN DATOS.
--Para un cliente que se pase por teclado indica si su ciudad coincide con la de la tienda
--en la que trabaja el empleado que tiene asignado o no.
--8. Renombra el tipo de producto Utensilios y llamalo Herramientas. Para ello tendrás que
--hacer los siguientes pasos
--    1.
--    Inserta un nuevo tipo de producto llamado Herramientas. El resto de campos deben
--    ser los que tenga actualmente el tipo de Utensilios.
--    2. Actualiza todos los productos que tuvieran como tipo Utensilios para que tengan el
--    nuevo tipo de Herramientas
--    3. Borra el tipo de producto Utensilios.
--    4. Al final de todo, haz commit.FOR x IN 1..n LOOP
