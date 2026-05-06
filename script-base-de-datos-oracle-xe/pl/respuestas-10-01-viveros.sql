--
--1
--
--Automatic Zoom
--1. Crea un trigger de tabla que impida cambiar el precio de venta si este es menor que
--el precio de proveedor.
CREATE OR REPLACE TRIGGER trg_precio_venta 
BEFORE UPDATE OF precioventa 
ON producto 
FOR EACH ROW 
WHEN (new.precioventa < new.precioproveedor)
BEGIN
    RAISE_APPLICATION_ERROR(-20100,'El precio de venta no puede ser menor al del proveedor. ' || :new.precioproveedor);
END;
/
SELECT * FROM producto;

UPDATE PRODUCTO p 
SET p.PRECIOVENTA = '15' 
WHERE p.CODPRODUCTO = '11679';
--2. Crear un trigger que cuando se cambie el estado de un pedido a “Entregado”, rellene
--automáticamente la fecha de entrega con el día.
CREATE OR REPLACE TRIGGER trg_pedido_entregado
BEFORE UPDATE OF ESTADO 
ON PEDIDO 
for EACH ROW
WHEN (new.ESTADO = 'Entregado')
BEGIN
    :new.fechaEntrega := sysdate;
END;
/
SELECT * FROM PEDIDO WHERE ESTADO = 'Pendiente' ORDER BY FECHAPREVISTA;
SELECT * FROM PEDIDO WHERE CODPEDIDO = '90';

UPDATE PEDIDO p 
SET p.ESTADO = 'Entregado' 
WHERE p.CODPEDIDO = '90';
--3. Crea un trigger que cuando se inserte un pago, aumente el límite de crédito del
--cliente en la misma cantidad que el pago realizado.
CREATE OR REPLACE TRIGGER trg_cambio_credito
BEFORE INSERT 
ON Pago
for EACH ROW

BEGIN
    UPDATE CLIENTE c 
    SET c.LIMITECREDITO = c.LIMITECREDITO + :new.ImporteTotal 
    WHERE c.CODCLIENTE = :new.codCliente;
END;
/
SELECT * from pago;
SELECT * from CLIENTE;
EXECUTE PAGOS_CLIENTE_V2(1);
INSERT INTO PAGO VALUES(
    '1','PayPal','xxd2',sysdate,'500'
);
ROLLBACK;

--4. Crea un trigger que cuando cambie de tienda a un empleado haga las siguientes
--acciones:
--a. Si el empleado no tiene jefe, no deja hacer el cambio.
--b. Si el empleado tiene jefe, pone a este como Empleado de ventas de todos
--los clientes que tuviera el empleado al que han cambiado de tienda.
--c. Pone a nulo el campo de jefe del empleado al que están moviendo de tienda.
CREATE OR REPLACE TRIGGER trg_cambio_tienda
BEFORE UPDATE OF codtienda 
ON empleado
for EACH ROW 

BEGIN
    IF :old.codJefe is null THEN
        RAISE_APPLICATION_ERROR(-20200,'No se puede hacer el cambio porque el empleado no tiene jefe');
    ELSE
        UPDATE CLIENTE c 
        SET c.CODEMPLEADOVENTAS = :old.codJefe 
        WHERE c.CODEMPLEADOVENTAS = :old.codEmpleado;

        :new.codJefe := null;
    END IF;
END;
/
SELECT * FROM EMPLEADO;
SELECT * FROM EMPLEADO WHERE CODEMPLEADO = '5';
SELECT * FROM CLIENTE WHERE CODEMPLEADOVENTAS = '3';
SELECT * FROM TIENDA;

UPDATE EMPLEADO e 
SET e.CODTIENDA = 'BCN-ES' 
WHERE e.CODEMPLEADO = '5';
-- clientes con empleado 5 -> 16,17,25,29,30

--5. Crea un trigger que si ponemos a 0 el límite de crédito de un cliente, marque como
--rechazados todos los pedidos que tuviera pendientes
CREATE OR REPLACE TRIGGER trg_limite_credito_cero 
BEFORE UPDATE OF limiteCredito 
ON cliente 
FOR EACH ROW 
WHEN (new.limiteCredito = 0)

BEGIN
    UPDATE PEDIDO p 
    SET p.ESTADO = 'Rechazado' 
    WHERE p.ESTADO = 'Pendiente'
    AND p.CODPEDIDO in (
        SELECT p2.CODPEDIDO from pedido p2 
        where p2.codCliente = :old.codCliente
        and p2.ESTADO = 'Pendiente'
    );
END;
/

UPDATE CLIENTE c 
SET c.LIMITECREDITO = '0' 
WHERE c.CODCLIENTE = '3';

SELECT p2.CODPEDIDO from pedido p2 
JOIN cliente c2 ON c2.codCliente = p2.codCliente
where c2.codCliente = '1';

SELECT * FROM PEDIDO p 
WHERE p.CODCLIENTE = '3'
ORDER BY p.FECHAPREVISTA;

-- pedidos pendiente del cliente 3 -> 61, 10

SELECT c.codCliente, count(p.CODPEDIDO)
FROM CLIENTE c 
JOIN PEDIDO p ON c.CODCLIENTE = p.CODCLIENTE 
WHERE p.ESTADO = 'Pendiente'
group by c.CODCLIENTE
;