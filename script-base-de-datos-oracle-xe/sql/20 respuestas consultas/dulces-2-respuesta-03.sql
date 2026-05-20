--Ejercicio 1. 
-- 
--Haz un listado con el nombre de la caja y el nombre completo en un solo campo del cliente 
--que hizo el último pedido de cada caja. Añade al listado también la fecha de ese pedido en 
--formato “dd-mm-aaaa”. 
-- 
SELECT distinct
        ca.NOMBRE || ' - ' || 
        (
            select c2.NOMBRE
            FROM CLIENTES c2 
            JOIN PEDIDOS p2 
                ON p2.IDCLIENTE = c2.IDCLIENTE 
            JOIN DETALLE_PEDIDOS dp2 
                ON dp2.IDPEDIDO = p2.IDPEDIDO
            JOIN CAJAS ca2 
                ON ca2.IDCAJA = dp2.IDCAJA
            where ca.NOMBRE = ca2.NOMBRE 
            and p2.FECHA_PEDIDO = (
                select max(p3.FECHA_PEDIDO)
                FROM CLIENTES c3 
                JOIN PEDIDOS p3 
                    ON p3.IDCLIENTE = c3.IDCLIENTE 
                JOIN DETALLE_PEDIDOS dp3 
                    ON dp3.IDPEDIDO = p3.IDPEDIDO
                JOIN CAJAS ca3 
                    ON ca3.IDCAJA = dp3.IDCAJA
                where ca.NOMBRE = ca3.NOMBRE
            )
        ) as caja_cliente,
        (
            select TO_CHAR(max(p2.FECHA_PEDIDO), 'DD-MM-YYYY')
            FROM CLIENTES c2 
            JOIN PEDIDOS p2 
                ON p2.IDCLIENTE = c2.IDCLIENTE 
            JOIN DETALLE_PEDIDOS dp2 
                ON dp2.IDPEDIDO = p2.IDPEDIDO
            JOIN CAJAS ca2 
                ON ca2.IDCAJA = dp2.IDCAJA
            where ca.NOMBRE = ca2.NOMBRE
        ) as Fecha_pedido
        
FROM CLIENTES c 
JOIN PEDIDOS p 
    ON p.IDCLIENTE = c.IDCLIENTE 
JOIN DETALLE_PEDIDOS dp 
    ON dp.IDPEDIDO = p.IDPEDIDO
JOIN CAJAS ca 
    ON ca.IDCAJA = dp.IDCAJA
order by fecha_pedido;

--Ejercicio 2.   
-- 
--Devuelve nombre de las cajas y nombre del bombón para las cajas con bombones en los 
--que tanto el nombre del chocolate como el nombre del relleno aparezcan en el nombre del 
--bombón, pero solamente si la primera palabra del nombre del bombón tiene menos de 5 
--letras. 
-- 
SELECT c.NOMBRE, b.NOMBRE
FROM DETALLE_CAJAS dc 
JOIN CAJAS c ON dc.IDCAJA = c.IDCAJA 
JOIN BOMBONES b ON dc.IDBOMBON = b.IDBOMBON
where upper(b.NOMBRE) like '%'||upper(b.CHOCOLATE)||'%' 
and upper(b.NOMBRE) like '%'||upper(b.RELLENO)||'%'
order by c.nombre, b.nombre;
--Ejercicio 3.  
-- 
--Crea una vista que llamaremos VISTA_TIPO_NUEZ. Guardaremos por cada tipo de nuez 
--cuántos bombones tenemos, el coste más alto y el coste más bajo. 

select 
        b.nuez, 
        count(b.IDBOMBON) bombones,
        (
            select max(b2.coste)
            from BOMBONES b2
            where b2.NUEZ = b.nuez
        ) as mas_caro,
        (
            select min(b2.coste)
            from BOMBONES b2
            where b2.NUEZ = b.nuez
        ) as mas_economico
from BOMBONES b 
group by b.nuez;


-- 
--Ejercicio 4.  
-- 
--Haz una vista a la que llamaremos PEDIDOS_VERANO. Vamos a guardar en la vista el id, 
--nombre y apellidos del cliente, el id y nombre de la caja de bombones que compraron, el 
--precio de la caja, la fecha del pedido y el nombre del bombón, para todos los pedidos que 
--se hicieran en los meses de julio o agosto y que el chocolate del bombón sea puro u oscuro. 

SELECT  c.IDCLIENTE, c.NOMBRE, c.APELLIDOS, 
        ca.IDCAJA, ca.NOMBRE, ca.PRECIO, 
        p.FECHA_PEDIDO, b.NOMBRE
FROM CLIENTES c
JOIN PEDIDOS p ON p.IDCLIENTE = c.IDCLIENTE
JOIN DETALLE_PEDIDOS dp ON dp.IDPEDIDO = p.IDPEDIDO 
JOIN CAJAS ca ON dp.IDCAJA = ca.IDCAJA
JOIN DETALLE_CAJAS dc ON dc.IDCAJA = ca.IDCAJA 
JOIN BOMBONES b ON dc.IDBOMBON = b.IDBOMBON
where to_char(p.FECHA_PEDIDO,'MM') in ('07','08')
;


-- 
--Ejercicio 5.   
-- 
--Haz un listado con el nombre de las cajas y coste para cajas cuyo coste sea menor de 
--400€. 
-- 
--El coste de la caja se calcula sumando por cada bombón de la caja, la cantidad que hay de 
--ese bombon * por el coste de ese bombón. 
-- 
with coste_cajas as (
SELECT c.NOMBRE, SUM(b.COSTE * dc.CANTIDAD) as coste_caja
FROM BOMBONES b 
JOIN DETALLE_CAJAS dc ON dc.IDBOMBON = b.IDBOMBON
JOIN CAJAS c ON c.IDCAJA = dc.IDCAJA
group by c.NOMBRE
)
select * 
from coste_cajas
where coste_caja < 400;


SELECT c.NOMBRE, SUM(b.COSTE * dc.CANTIDAD) as coste_caja
FROM BOMBONES b 
JOIN DETALLE_CAJAS dc ON dc.IDBOMBON = b.IDBOMBON
JOIN CAJAS c ON c.IDCAJA = dc.IDCAJA
group by c.NOMBRE
having SUM(b.COSTE * dc.CANTIDAD) < 400;
-- 
--Ejercicio 6.  
-- 
--Haz un listado con las cajas, nombre de la caja, el nombre del bombón más caro de cada 
--caja y el número de cajas que se han pedido de esa caja. 

SELECT 
  
    c.IDCAJA, 
    (
        select c2.NOMBRE
        from CAJAS c2
        where c2.IDCAJA = c.IDCAJA
    ) as nombre_caja,
    (
        select b3.nombre
        from bombones b3
        join DETALLE_CAJAS dc3 on dc3.IDBOMBON = b3.IDBOMBON
        where b3.COSTE = (
            select max(b4.coste)
            from BOMBONES b4
            join DETALLE_CAJAS dc4 on dc4.IDBOMBON = b4.IDBOMBON
            where c.IDCAJA = dc4.IDCAJA
        ) and c.IDCAJA = dc3.IDCAJA and rownum = 1
    ) as bombon_mas_caro,
    (
        select count(distinct dp5.IDPEDIDO)
        from DETALLE_PEDIDOS dp5
        where dp5.IDCAJA = c.IDCAJA
    ) as pedidos
FROM CAJAS c
LEFT JOIN DETALLE_PEDIDOS dp ON dp.idcaja = c.idcaja
GROUP BY c.idcaja;


-- 
--Ejercicio 7.   
-- 
--Queremos un informe con el nombre de cliente y nombre del bombón para clientes que han 
--comprado bombones cuyo nombre empieza por la misma letra que el nombre del cliente y 
--que hayan pasado más de 6 meses entre la fecha del pedido y la fecha de envío 
--(suponemos fecha de envío posterior a fecha del pedido). 
-- 

SELECT MONTHS_BETWEEN(ADD_MONTHS(sysdate, 6), sysdate) from dual;

SELECT c.NOMBRE cliente, b.NOMBRE bombon
FROM CLIENTES c
JOIN PEDIDOS p ON p.IDCLIENTE = c.IDCLIENTE
JOIN DETALLE_PEDIDOS dp ON dp.IDPEDIDO = p.IDPEDIDO 
JOIN CAJAS ca ON dp.IDCAJA = ca.IDCAJA
JOIN DETALLE_CAJAS dc ON dc.IDCAJA = ca.IDCAJA 
JOIN BOMBONES b ON dc.IDBOMBON = b.IDBOMBON
where substr(upper(c.NOMBRE),1,1) = substr(upper(b.NOMBRE),1,1)
and MONTHS_BETWEEN(p.FECHA_ENVIO, p.FECHA_PEDIDO) > 6;

--Ejercicio 8.  
-- 
--Por cada tipo de chocolate, y para bombones que no tengan en el relleno Mazapán, 
--queremos saber cuántos bombones tenemos. 

SELECT b.CHOCOLATE, count(b.IDBOMBON)
from BOMBONES b 
where upper(b.RELLENO) not like '%'||upper('Mazapá')||'%'
group by b.CHOCOLATE;

SELECT b.CHOCOLATE, 
        (
            select sum(dc2.cantidad)
            from BOMBONES b2
            join DETALLE_CAJAS dc2 on dc2.IDBOMBON = b2.IDBOMBON
            join cajas c2 on c2.IDCAJA = dc2.IDCAJA
            where b.CHOCOLATE = b2.CHOCOLATE
        ) as existencias
from BOMBONES b 
where upper(b.RELLENO) not like '%'||upper('Mazapá')||'%'
group by b.CHOCOLATE;


-- 
--Ejercicio 9.  
-- 
--Crea una vista que llamaremos BOMBON_CAJA con el nombre de cada bombón y un 
--campo S/N de si el bombón está en alguna caja de bombones o no.  
-- 
create VIEW bombon_caja AS 

select b.nombre,
        case when dc.IDBOMBON is null then 'N' else 'S' end
from BOMBONES b 
left join DETALLE_CAJAS dc on dc.IDBOMBON = b.IDBOMBON

;
-- 
--Ejercicio 10.   
-- 
--Número total de pedidos hechos en el primer semestre de un año por clientes para los que 
--se cumpla que las dos primeras letras de su nombre estén contenidas en su apellido (sin 
--tener en cuenta mayúsculas/minúsculas, ni importar en qué posición aparecen) 
-- 

SELECT 
    COUNT(*) AS total_pedidos
FROM PEDIDOS p
JOIN CLIENTES c ON c.idcliente = p.idcliente
WHERE EXTRACT(MONTH FROM p.fecha_pedido) BETWEEN 1 AND 6
  AND INSTR(UPPER(c.apellidos), UPPER(SUBSTR(c.nombre, 1, 2))) > 0;

--Ejercicio 11.  
-- 
--Queremos ver un listado de todos los clientes con sus pedidos. Veremos nombre, apellidos 
--y ciudad del cliente y fecha del pedido. Si un cliente no ha hecho pedidos también debe 
--salir. Ordena la consulta por ciudad de forma ascendente y luego por apellidos del cliente 
--(ascendente también). 
-- 
--Ejercicio 12. 
-- 
--Crea una vista llamada BOMBON_MAS_BARATO con el nombre de la caja y el nombre 
--bombón de menor coste de cada caja. Incluye el coste en la vista. 
-- 
-- 
-- 