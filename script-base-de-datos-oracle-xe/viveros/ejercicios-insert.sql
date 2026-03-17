--
--1
--
--Automatic Zoom
-- 
--Ejercicios manipulación de datos - Viveros       
-- 
--1. Inserta una nueva tienda en ‘Tres Cantos’ 
select * from TIENDA where pais = 'España' AND TIENDA.CODTIENDA = 'TCA-ES';

INSERT INTO TIENDA (CODTIENDA,CIUDAD,PAIS,REGION,CP,TELEFONO,LINEADIRECCION1,LINEADIRECCION2)
        VALUES('TCA-ES','Madrid','España','Tres Cantos','28000','+34 93 1234567','calle de nose','nose');
        commit;
--2. Inserta un empleado para la tienda de ‘Tres Cantos’ que sea representante de ventas. 
select * from EMPLEADO WHERE CODTIENDA = 'TCA-ES'
FETCH first 5 rows only;

insert INTO EMPLEADO (CODEMPLEADO,NOMBRE,APELLIDO1,APELLIDO2,EXTENSION,EMAIL,CODTIENDA,CODJEFE,CARGO)
        VALUES ('32','Juan','Perez','Rodriguez','3224','juanp@gardening.com','TCA-ES','32','Representate de ventas');

commit;
--3. Inserta un cliente que tenga como empleado de ventas al empleado que hemos creado 
--en el punto anterior. 
select * from CLIENTE WHERE CLIENTE.CODEMPLEADOVENTAS = '32';

INSERT  INTO CLIENTE(CODCLIENTE,NOMBRECLIENTE,TELEFONO,TELEFONO2,LINEADIRECCION1,CIUDAD,CODEMPLEADOVENTAS)
        VALUES('39','Luis','6541234567','123456789','en su casa','Madrid','32');
COMMIT;
--4. Inserta un pedido para el cliente que acabamos de crear, que contenga al menos dos 
--productos diferentes. 
select * from PRODUCTO p
LEFT JOIN TIPOPRODUCTO t on p.TIPOPRODUCTO = t.TIPO;

select * from DETALLE_PEDIDO order by CODPEDIDO, NUMLINEAPEDIDO;

select * from DETALLE_pedido WHERE CODPEDIDO = '129' order by CODPEDIDO desc;

-- 1) CREAMOS UN PEDIDO
INSERT INTO 
        PEDIDO(CODPEDIDO,FECHAPEDIDO,FECHAPREVISTA,ESTADO,CODCLIENTE)
        VALUES('129','14/03/26','16/03/26','Pendiente','39');

-- 2) INSERTAMOS EL DETALLE DEL PEDIDO
INSERT INTO DETALLE_PEDIDO(CODPEDIDO,CODPRODUCTO,CANTIDAD,PRECIOUNIDAD,NUMLINEAPEDIDO)
        VALUES  ('129','FR-41','5','8','1');

INSERT INTO DETALLE_PEDIDO(CODPEDIDO,CODPRODUCTO,CANTIDAD,PRECIOUNIDAD,NUMLINEAPEDIDO)
VALUES ('129','FR-42','3','8','2');

SELECT * FROM PEDIDO P
LEFT JOIN DETALLE_PEDIDO DP ON DP.CODPEDIDO = P.CODPEDIDO
LEFT JOIN CLIENTE C ON C.CODCLIENTE = P.CODCLIENTE
WHERE C.CODCLIENTE = '39';

COMMIT;

--5. Actualiza el código del cliente que hemos creado en el punto anterior y averigua si hubo 
--cambios en las tablas relacionadas.
SELECT * FROM CLIENTE C 
LEFT JOIN PEDIDO P ON P.CODCLIENTE = C.CODCLIENTE
--LEFT JOIN DETALLE_PEDIDO DP ON DP.CODPEDIDO = P.CODPEDIDO
WHERE C.CODCLIENTE = '40';

-- 1) DESACTIVAR LA CONSTRAINT DE PEDIDOS
ALTER TABLE PEDIDO DISABLE CONSTRAINT fk_cliente_pedido;

-- 2) HACEMOS EL CAMBIO DEL ID EN PEDIDOS EN EL ID DEL CLIENTE
UPDATE PEDIDO
SET CODCLIENTE = '40'
WHERE CODCLIENTE = '39';

-- 3) HACEMOS EL CAMBIO DEL CODIGO EN LA TABLA CLIENTE
UPDATE CLIENTE 
SET CODCLIENTE = '40'
WHERE CODCLIENTE = '39';

-- 4) VOLVEMOS ACTIVAR LA CONSTRAINT
ALTER TABLE PEDIDO ENABLE CONSTRAINT fk_cliente_pedido;

COMMIT;

--6. Borra el cliente y averigua si hubo cambios en las tablas relacionadas. 

SELECT * FROM CLIENTE C 
LEFT JOIN PEDIDO P ON P.CODCLIENTE = C.CODCLIENTE
LEFT JOIN DETALLE_PEDIDO DP ON DP.CODPEDIDO = P.CODPEDIDO
WHERE C.CODCLIENTE = '40';

-- DESACTIVA LA CONSTRAINT 
ALTER TABLE PEDIDO DISABLE CONSTRAINT fk_cliente_pedido;
ALTER TABLE CLIENTE DISABLE CONSTRAINT fk_empledo_cliente;
ALTER TABLE DETALLE_PEDIDO DISABLE CONSTRAINT fk_pedido_detalle;

--- DELECTE PEDIDO
DELETE FROM PEDIDO
WHERE CODPEDIDO = '129';
-- DELETE DETALLE PEDIDO
DELETE FROM DETALLE_PEDIDO
WHERE CODPEDIDO = '129';
-- DELETE CLIENTE
DELETE FROM CLIENTE
WHERE CODCLIENTE = '40';

-- ACTIVAR CONSTRAINT
ALTER TABLE PEDIDO              ENABLE CONSTRAINT fk_cliente_pedido;
ALTER TABLE CLIENTE             ENABLE CONSTRAINT fk_empledo_cliente;
ALTER TABLE DETALLE_PEDIDO      ENABLE CONSTRAINT fk_pedido_detalle;

SELECT * FROM CLIENTE C 
LEFT JOIN PEDIDO P ON P.CODCLIENTE = C.CODCLIENTE
LEFT JOIN DETALLE_PEDIDO DP ON DP.CODPEDIDO = P.CODPEDIDO
ORDER BY C.CODCLIENTE DESC;



COMMIT;

--7. Elimina los clientes que no hayan realizado ningún pedido. 
delete from CLIENTE c1
where c1.CODCLIENTE in (
        select c.CODCLIENTE from cliente c
        left join pedido p on p.codCliente = c.codCliente
        where p.codPedido is null
);
commit;
--8. Incrementa en un 25% el precio de los productos que no tengan pedidos. 

update PRODUCTO p1
set p1.PRECIOVENTA = p1.PRECIOVENTA * 1.25
where p1.CODPRODUCTO in (
        select p.CODPRODUCTO from PRODUCTO p
        left join DETALLE_PEDIDO dp 
                on dp.CODPRODUCTO = p.CODPRODUCTO
        where dp.CODPEDIDO is null

);

commit;

select * from PRODUCTO p
left join DETALLE_PEDIDO dp 
        on dp.CODPRODUCTO = p.CODPRODUCTO
where dp.CODPEDIDO is null order by p.CODPRODUCTO;
-- fr-104 49
--9. Borra los pagos del cliente con menor límite de crédito. 
delete from pago pa
where pa.CODCLIENTE = (
        select c1.CODCLIENTE 
        from cliente c1 
        order by c1.LIMITECREDITO asc
        fetch first 1 rows only
);

commit;
--10. Modifica la tabla detalle_pedido para insertar un campo numérico llamado IVA. 
--Mediante una transacción, establece el valor de ese campo a 18 para aquellos registros 
--cuyo pedido tenga fecha a partir de Enero de 2019. Después, con otra sentencia,  
--actualiza el resto de pedidos estableciendo el IVA al 21. 
select * from DETALLE_PEDIDO;
alter table detalle_pedido add iva number(5,2);

update DETALLE_PEDIDO
set iva = 19
where codpedido in (
        select p.CODPEDIDO from PEDIDO p 
        where to_char(p.FECHAPEDIDO,'yyyy') >= '2019' 
);

update DETALLE_PEDIDO
set iva = 21
where codpedido not in (
        select p.CODPEDIDO from PEDIDO p 
        where to_char(p.FECHAPEDIDO,'yyyy') >= '2019' 
);


select p.CODPEDIDO, p.FECHAPEDIDO from PEDIDO p 
        where to_char(p.FECHAPEDIDO,'yyyy') >= '2019';
commit;

--11. Modifica la tabla detalle_pedido para incorporar un campo numérico llamado 
--total_linea y actualiza todos sus registros para calcular su valor con la fórmula: 
--total_linea = precio_unidad*cantidad * (1 + (IVA/100)); 

alter table detalle_pedido add total_linea NUMBER(8,2);

update detalle_pedido
set total_linea = preciounidad * cantidad * (1 + (iva/100));

select * from DETALLE_PEDIDO;

commit;
--12. Crea una nueva tabla que sea TOTAL_TIPOS_PRODUCTO_PAIS que tendrá 3 columnas, 
--una con la PK de la tabla de tipo de producto, otra con el PAIS (estas 2 serán la PK de la 
--tabla) y otra con el total de unidades vendidas por tipo de producto. 
create table total_tipos_productos_pais(
        id number GENERATED by default as identity,
        tipo_producto VARCHAR2(30),
        pais VARCHAR2(30),
        total NUMBER(9),
        PRIMARY KEY(tipo_producto,pais)
);

select * from TOTAL_TIPOS_PRODUCTOS_PAIS;

insert into TOTAL_TIPOS_PRODUCTOS_PAIS(tipo,pais,total)
select tp.tipo,c.pais, sum(dp.TOTAL_LINEA) from TIPOPRODUCTO tp
join producto p 
        on p.TIPOPRODUCTO = tp.TIPO
join DETALLE_PEDIDO dp 
        on dp.CODPRODUCTO = p.CODPRODUCTO
join pedido pe on pe.CODPEDIDO = dp.CODPEDIDO
join cliente c on c.CODCLIENTE = pe.CODCLIENTE
group by c.PAIS, tp.tipo;

select * from DETALLE_PEDIDO;

commit;