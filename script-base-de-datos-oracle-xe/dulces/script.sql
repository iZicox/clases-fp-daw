CREATE USER dulces IDENTIFIED BY 123 quota unlimited ON users;
GRANT CONNECT, resource, CREATE VIEW TO dulces;

--EJERCICIO DULCES– CONSULTA CON VARIAS TABLAS
--Utiliza la BBDD DULCES--
--1. Devuelve los pedidos de clientes de USA hechos en 1997--
select p.* from pedidos p 
JOIN clientes c on p.idcliente = c.idcliente
where c.pais = 'USA' 
and EXTRACT(year from p.fecha_pedido) = 1997;
select nombre from bombones;
--2. Devuelve las cajas de bombones que corresponden a colecciones y que con--tienen
--anacardos.--
--3. Devuelve las cajas con bombones de chocolate puro--
--4. Pedidos que contengan bombones de más de 35€ ordenados por fecha descen--dente.
--5. Clientes que no sean de España ni USA y que hayan comprado la caja más --cara.
--6. Clientes de España que hayan comprado la caja más barata entre las que --tienen 4 o
--más bombones.--
--7. Listado de bombones y el precio de la caja más cara en la que está ese --bombón.
--8. Listado de bombones y el precio de la caja más cara en la que está ese --bombón y que
--el bombón se haya vendido en USA--
--9. Lista los bombones que no se han vendido en España--
SELECT *
FROM BOMBONES WHERE IDBOMBON NOT IN(
    SELECT DISTINCT IDBOMBON
    FROM DETALLE_CAJA DC
    JOIN CAJAS C ON DC.IDCAJA = C.IDCAJA
    JOIN DETALLE_PEDIDOS DP ON C.IDCAJA = DP.IDCAJA
    JOIN PEDIDOS P ON DP.IDPEDIDO = P.IDPEDIDO
    JOIN CLIENTES CL ON P.IDCLIENTE = CL.IDCLIENTE
    WHERE CL.PAIS = 'España'
);
select nombre from clientes;
--10. Muestra las cajas junto con el bombón más caro de esa caja, que no se --hayan vendido
--en Canadá y que las cajas contengan más 5 bombones--
--11. Muestra las cajas junto con el bombón más caro de esa caja, que no se --hayan vendido
--en Canadá y que la caja no contenga bombones rellenos de mora