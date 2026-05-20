--
--3
--
--Automatic Zoom
-- 
--BASES DE DATOS  
-- DW1D1E  2ª EVALUACIÓN  
--NOMBRE   
-- 
--INDICACIONES: 
--●  NO ESTÁN ORDENADOS EN NIVEL DE DIFICULTAD. 
--●  TODAS LAS PREGUNTAS SE HACEN CON UNA SOLA SENTENCIA SQL Y 
--UTILIZANDO ÚNICAMENTE LOS DATOS PROPORCIONADOS EN EL ENUNCIADO DE 
--CADA EJERCICIO.  
--●  En las consultas que no se pide un orden específico, con el fin de poder 
--comprobar mejor los resultados, se puede poner el orden que se desee (o 
--ninguno). 
--●  Si no sabes crear las vistas, haz los ejercicios como una select sin más. 
--●  Si no lo tienes ya, crear un usuario DULCES, password DULCES. Crea una 
--conexión con este usuario y lanza el script de DULCES.sql. 
--Ejercicio 1. 
-- 
--Haz un listado con el nombre de la caja y el nombre completo en un solo campo del cliente 
--que hizo el último pedido de cada caja. Añade al listado también la fecha de ese pedido en 
--formato “dd-mm-aaaa”. 
select 
        c.nombre || ' - ' || cl.nombre nombre,
        TO_char(p.FECHA_PEDIDO,'dd-mm-yyyy') fecha
from CLIENTES cl 
    INNER JOIN PEDIDOS p on p.IDCLIENTE = cl.IDCLIENTE 
    INNER JOIN DETALLE_PEDIDOS dp on dp.IDPEDIDO = p.IDPEDIDO 
    INNER JOIN cajas c on c.IDCAJA = dp.IDCAJA
WHERE p.FECHA_PEDIDO = (
    SELECT MAX(p2.FECHA_PEDIDO)
    FROM DETALLE_PEDIDOS dp2 
        INNER JOIN PEDIDOS p2 on p2.IDPEDIDO = dp2.IDPEDIDO
    WHERE dp2.IDCAJA = c.IDCAJA
)
;
--Ejercicio 2.   
-- 
--Devuelve nombre de las cajas y nombre del bombón para las cajas con bombones en los 
--que tanto el nombre del chocolate como el nombre del relleno aparezcan en el nombre del 
--bombón, pero solamente si la primera palabra del nombre del bombón tiene menos de 5 
--letras. 
SELECT 
        c.nombre caja, 
        b.nombre bombon,
        b.CHOCOLATE,
        b.RELLENO
FROM BOMBONES b 
INNER JOIN DETALLE_CAJAS dc on dc.IDBOMBON = b.IDBOMBON 
INNER JOIN CAJAS c on c.IDCAJA = dc.IDCAJA
WHERE upper(b.NOMBRE) like '%'||upper(b.CHOCOLATE)||'%' 
    and upper(b.NOMBRE) like '%'||upper(b.RELLENO)||'%'
    AND length(substr(b.NOMBRE,1,instr(b.NOMBRE,' ')-1)) < 5;
--Ejercicio 3.  
-- 
--Crea una vista que llamaremos VISTA_TIPO_NUEZ. Guardaremos por cada tipo de nuez 
--cuántos bombones tenemos, el coste más alto y el coste más bajo. 
-- 
--Ejercicio 4.  
-- 
--Haz una vista a la que llamaremos PEDIDOS_VERANO. Vamos a guardar en la vista el id, 
--nombre y apellidos del cliente, el id y nombre de la caja de bombones que compraron, el 
--precio de la caja, la fecha del pedido y el nombre del bombón, para todos los pedidos que 
--se hicieran en los meses de julio o agosto y que el chocolate del bombón sea puro u oscuro. 
-- 
--Ejercicio 5.   
-- 
--Haz un listado con el nombre de las cajas y coste para cajas cuyo coste sea menor de 
--400€. 
-- 
--El coste de la caja se calcula sumando por cada bombón de la caja, la cantidad que hay de 
--ese bombon * por el coste de ese bombón. 
-- 
-- 
--Ejercicio 6.  
-- 
--Haz un listado con las cajas, nombre de la caja, el nombre del bombón más caro de cada 
--caja y el número de cajas que se han pedido de esa caja. 
-- 
--Ejercicio 7.   
-- 
--Queremos un informe con el nombre de cliente y nombre del bombón para clientes que han 
--comprado bombones cuyo nombre empieza por la misma letra que el nombre del cliente y 
--que hayan pasado más de 6 meses entre la fecha del pedido y la fecha de envío 
--(suponemos fecha de envío posterior a fecha del pedido). 
-- 
--Ejercicio 8.  
-- 
--Por cada tipo de chocolate, y para bombones que no tengan en el relleno Mazapán, 
--queremos saber cuántos bombones tenemos. 
-- 
--Ejercicio 9.  
--(IMAGEN)
--Crea una vista que llamaremos BOMBON_CAJA con el nombre de cada bombón y un 
--campo S/N de si el bombón está en alguna caja de bombones o no.  
-- 
-- 
--Ejercicio 10.   
-- 
--Número total de pedidos hechos en el primer semestre de un año por clientes para los que 
--se cumpla que las dos primeras letras de su nombre estén contenidas en su apellido (sin 
--tener en cuenta mayúsculas/minúsculas, ni importar en qué posición aparecen) 
-- 
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