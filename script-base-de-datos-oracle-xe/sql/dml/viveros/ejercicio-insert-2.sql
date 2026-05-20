-- 
-- 1
-- 
-- Automatic Zoom
--  
-- Ejercicios manipulación de datos - Viveros       
--  
-- 1. Inserta una nueva tienda en ‘Tres Cantos’ 
select * from tienda where pais = 'España' order by codtienda;
select * from tienda where CODTIENDA = 'TCA-ES';
insert into 
    TIENDA(CODTIENDA,CIUDAD,PAIS,CP,TELEFONO,LINEADIRECCION1)
    VALUES('TCA-ES','Madrid','España','000000','123456789','por ahi');
COMMIT;
-- 2. Inserta un empleado para la tienda de ‘Tres Cantos’ que sea representante de ventas. 
SELECT * from EMPLEADO order by CODEMPLEADO desc;
select * from empleado where codtienda = 'TCA-ES';

INSERT INTO 
    EMPLEADO(CODEMPLEADO,NOMBRE,APELLIDO1,EXTENSION,EMAIL,CODTIENDA,CARGO)
    VALUES('32','Pedro','Picapiedra','123','pedrop@gmail.com','TCA-ES','Representate de ventas');

COMMIT;
-- 3. Inserta un cliente que tenga como empleado de ventas al empleado que hemos creado 
-- en el punto anterior. 
select * from CLIENTE order by CODCLIENTE DESC
FETCH first 5 rows only;

select * from cliente c 
inner join empleado e on e.codEmpleado = c.CODEMPLEADOVENTAS
where e.CODEMPLEADO = '32';

INSERT INTO 
    CLIENTE(CODCLIENTE,NOMBRECLIENTE,TELEFONO,TELEFONO2, LINEADIRECCION1, CIUDAD,CODEMPLEADOVENTAS)
    VALUES('39','Juanito Alimaña','987654321','123456789','su casa','Madrid','32');
COMMIT;
-- 4. Inserta un pedido para el cliente que acabamos de crear, que contenga al menos dos 
-- productos diferentes. 
select * from pedido order by pedido.CODPEDIDO desc;
INSERT INTO 
    PEDIDO(CODPEDIDO,FECHAPEDIDO,FECHAPREVISTA,ESTADO,CODCLIENTE)
    VALUES('129','15/03/2026','18/03/2026','Pendiente','39');
INSERT into 
    DETALLE_PEDIDO(CODPEDIDO, CODPRODUCTO,CANTIDAD,PRECIOUNIDAD, NUMLINEAPEDIDO)
    VALUES('129','FR-22','5','4','1');
INSERT into 
    DETALLE_PEDIDO(CODPEDIDO, CODPRODUCTO,CANTIDAD,PRECIOUNIDAD, NUMLINEAPEDIDO)
    VALUES('129','FR-25','5','8','2');
SELECT * FROM PRODUCTO;
SELECT * FROM DETALLE_PEDIDO DP 
JOIN PEDIDO P ON P.CODPEDIDO = DP.CODPEDIDO
WHERE P.CODPEDIDO = '129';
COMMIT;
-- 5. Actualiza el código del cliente que hemos creado en el punto anterior y averigua si hubo 
-- cambios en las tablas relacionadas. 

select * from cliente c
left join pedido p on p.CODCLIENTE = c.CODCLIENTE 
left join DETALLE_PEDIDO dp on dp.CODPEDIDO = p.CODPEDIDO
where c.CODCLIENTE = '39';

select  '40',
        c.NOMBRECLIENTE,
        c.TELEFONO,
        c.TELEFONO2,
        c.LINEADIRECCION1,
        c.CIUDAD,
        c.CODEMPLEADOVENTAS
from cliente c where CODCLIENTE = '39';

-- primero hacemos una copia del cliente id 39 pero usando el id 40
insert into cliente(CODCLIENTE,NOMBRECLIENTE,TELEFONO,TELEFONO2,LINEADIRECCION1,CIUDAD,CODEMPLEADOVENTAS)
select  '40',
        c.NOMBRECLIENTE,
        c.TELEFONO,
        c.TELEFONO2,
        c.LINEADIRECCION1,
        c.CIUDAD,
        c.CODEMPLEADOVENTAS
from cliente c where CODCLIENTE = '39';

select * from cliente where cliente.CODCLIENTE in ('39','40');

-- luego cambiamos los valores de las relaciones que usan el id de este cliente por el id nuevo 40
select * from pedido where codcliente = '39';

update pedido
set codcliente = '40'
where codcliente = '39';

-- ahora eliminamos el cliente con el id antiguo, 39
select * from cliente where codcliente = '40';

delete CLIENTE
where codcliente = '39';

SAVEPOINT eje_05;

-- 6. Borra el cliente y averigua si hubo cambios en las tablas relacionadas. 

select c.CODCLIENTE, dp.* from cliente c 
left join pedido p on p.CODCLIENTE = c.CODCLIENTE 
left join DETALLE_PEDIDO dp on dp.CODPEDIDO =  p.CODPEDIDO
where c.CODCLIENTE = '40';

delete DETALLE_PEDIDO
where DETALLE_PEDIDO.CODPEDIDO = '129';

delete PEDIDO
where PEDIDO.CODPEDIDO = '129';

delete CLIENTE
where CLIENTE.CODCLIENTE = '40';

SAVEPOINT eje_06;

-- 7. Elimina los clientes que no hayan realizado ningún pedido. 

select * from CLIENTE c 
where not exists(
    select 1 from pedido p 
    where p.codcliente = c.codcliente
);

delete CLIENTE
where CLIENTE.CODCLIENTE in (
    select c.CODCLIENTE from cliente c 
    left join pedido p on p.CODCLIENTE = c.CODCLIENTE 
    where p.CODPEDIDO is null
);
SAVEPOINT eje_07;

-- 8. Incrementa en un 25% el precio de los productos que no tengan pedidos.

update PRODUCTO p
set p.PRECIOVENTA = p.PRECIOVENTA * 1.25
where not exists(
    select 1
    from DETALLE_PEDIDO dp
    where dp.CODPRODUCTO = p.CODPRODUCTO
);

SAVEPOINT eje_08;
select * from producto p
where not exists(
    select 1
    from DETALLE_PEDIDO dp
    where dp.CODPRODUCTO = p.CODPRODUCTO
) ;

---
UPDATE PRODUCTO
SET PRODUCTO.PRECIOVENTA = PRODUCTO.PRECIOVENTA * 1.25
WHERE PRODUCTO.CODPRODUCTO IN (
    SELECT P.CODPRODUCTO FROM PRODUCTO P 
    LEFT JOIN DETALLE_PEDIDO DP ON DP.CODPRODUCTO = P.CODPRODUCTO
    WHERE DP.CODPRODUCTO IS NULL
);

COMMIT;
-- 9. Borra los pagos del cliente con menor límite de crédito.

delete PAGO
where PAGO.CODCLIENTE = (
    select c.codcliente from cliente c
    where c.LIMITECREDITO = (
        select min(c2.LIMITECREDITO) from cliente c2 
    )
);

select * from pago p
where p.codCliente = '16';

SAVEPOINT eje_09;


---
DELETE FROM PAGO
WHERE CODCLIENTE = (

SELECT CODCLIENTE FROM CLIENTE
ORDER BY CLIENTE.LIMITECREDITO ASC 
FETCH FIRST 1 ROWS ONLY
);

COMMIT;
-- 10. Modifica la tabla detalle_pedido para insertar un campo numérico llamado IVA. 
-- Mediante una transacción, establece el valor de ese campo a 18 para aquellos registros 
-- cuyo pedido tenga fecha a partir de Enero de 2019. Después, con otra sentencia,  
-- actualiza el resto de pedidos estableciendo el IVA al 21. 


alter table detalle_pedido add iva number(6,2);

update DETALLE_PEDIDO dp
set dp.iva = '18'
where dp.CODPEDIDO in (
    select p.CODPEDIDO from pedido p 
    where to_char(p.FECHAPEDIDO, 'YYYY') >= '2019'
);

update DETALLE_PEDIDO dp
set dp.iva = '21'
where dp.CODPEDIDO not in (
    select p.CODPEDIDO from pedido p 
    where to_char(p.FECHAPEDIDO, 'YYYY') >= '2019'
);

select dp.* from pedido p 
left join detalle_pedido dp on dp.CODPEDIDO = p.CODPEDIDO
where to_char(p.FECHAPEDIDO, 'YYYY') < '2019';


select * from DETALLE_PEDIDO;

SAVEPOINT eje_10;

----
ALTER TABLE DETALLE_PEDIDO ADD IVA NUMBER(6,2);

UPDATE DETALLE_PEDIDO
SET IVA = 18
WHERE CODPEDIDO IN (
    SELECT DISTINCT DP.CODPEDIDO FROM DETALLE_PEDIDO DP 
    INNER JOIN PEDIDO P ON P.CODPEDIDO = DP.CODPEDIDO
    WHERE TO_CHAR(P.FECHAPEDIDO,'YYYY') >= 2019
);

UPDATE DETALLE_PEDIDO
SET IVA = 21
WHERE CODPEDIDO not IN (
    SELECT DISTINCT DP.CODPEDIDO FROM DETALLE_PEDIDO DP 
    INNER JOIN PEDIDO P ON P.CODPEDIDO = DP.CODPEDIDO
    WHERE TO_CHAR(P.FECHAPEDIDO,'YYYY') >= 2019
);
select * from DETALLE_PEDIDO;

commit;
-- 11. Modifica la tabla detalle_pedido para incorporar un campo numérico llamado 
-- total_linea y actualiza todos sus registros para calcular su valor con la fórmula: 
-- total_linea = precio_unidad*cantidad * (1 + (IVA/100)); 

alter table detalle_pedido add total_linea number(10,2);
select * from DETALLE_PEDIDO;

update DETALLE_PEDIDO
set TOTAL_LINEA = PRECIOUNIDAD * cantidad * (1+(iva/100));

SAVEPOINT eje_11;
-- 12. Crea una nueva tabla que sea TOTAL_TIPOS_PRODUCTO_PAIS que tendrá 3 columnas, 
-- una con la PK de la tabla de tipo de producto, otra con el PAIS (estas 2 serán la PK de la 
-- tabla) y otra con el total de unidades vendidas por tipo de producto. 
-- 1 ||||

create table total_tipos_producto_pais (
    tipo_producto varchar2(50),
    pais varchar2(50),
    total_unidades_vendidas number(10),
    primary key(tipo_producto,pais)
);

select * from total_tipos_producto_pais;

insert into TOTAL_TIPOS_PRODUCTO_PAIS
select  tp.tipo,
        c.pais,
        sum(dp.cantidad)
from cliente c 
join pedido p on p.CODCLIENTE = c.CODCLIENTE 
join DETALLE_PEDIDO dp on dp.CODPEDIDO = p.CODPEDIDO 
join producto po on po.CODPRODUCTO = dp.CODPRODUCTO 
join TIPOPRODUCTO tp on tp.tipo = po.TIPOPRODUCTO
group by tp.tipo,
        c.pais;

        commit;


---

create table lista_paises(
    id number generated by default as identity,
    pais varchar2(50),
    constraint pk_lista_paises primary key(id)
);

select * from lista_paises;


insert into lista_paises(pais)
select distinct pais from cliente;

insert into LISTA_PAISES(id,pais)
values(default,'Venezuela');