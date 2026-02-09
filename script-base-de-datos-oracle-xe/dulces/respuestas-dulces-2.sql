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
--Haz un listado con el nombre de la caja y el nombre completo en un solo campo del cliente 
--que hizo el último pedido de cada caja. Añade al listado también la fecha de ese pedido en 
--formato “dd-mm-aaaa”. 

SELECT 
        C.NOMBRE,
        TO_CHAR(P.FECHA_PEDIDO,'DD-MM-YYYY'),
        CL.NOMBRE || ' ' || CL.APELLIDOS
FROM CAJAS C
INNER JOIN DETALLE_PEDIDOS DP 
    ON C.IDCAJA = DP.IDCAJA 
INNER JOIN PEDIDOS P 
    ON DP.IDPEDIDO = P.IDPEDIDO 
INNER JOIN CLIENTES CL 
    ON P.IDCLIENTE = CL.IDCLIENTE
WHERE P.FECHA_PEDIDO = (
    SELECT 
            MAX(P2.FECHA_PEDIDO)
    FROM PEDIDOS P2
    INNER JOIN DETALLE_PEDIDOS DP2 
        ON P2.IDPEDIDO = DP2.IDPEDIDO
    WHERE DP2.IDCAJA = C.IDCAJA
)
;


--Ejercicio 2.   
-- 
--Devuelve nombre de las cajas y nombre del bombón para las cajas con bombones en los 
--que tanto el nombre del chocolate como el nombre del relleno aparezcan en el nombre del 
--bombón, pero solamente si la primera palabra del nombre del bombón tiene menos de 5 
--letras. 
SELECT 
        CA.NOMBRE CAJA,
        BO.NOMBRE BOMBON 
FROM CAJAS CA 
INNER JOIN DETALLE_CAJAS DC ON CA.IDCAJA = DC.IDCAJA 
INNER JOIN BOMBONES BO ON DC.IDBOMBON = BO.IDBOMBON 
WHERE INSTR(BO.NOMBRE, BO.CHOCOLATE) > 0
    AND INSTR(BO.NOMBRE, BO.RELLENO) > 0
    AND INSTR(BO.NOMBRE, ' ') <= 5;
--Ejercicio 3.  
--Crea una vista que llamaremos VISTA_TIPO_NUEZ. Guardaremos por cada tipo de nuez 
--cuántos bombones tenemos, el coste más alto y el coste más bajo. 
CREATE VIEW VISTA_TIPO_NUEZ_2 AS 
SELECT 
        BO.NUEZ AS NUEZ,
        COUNT(BO.IDBOMBON) AS CANTIDAD,
        MAX(BO.COSTE) AS MAX,
        MIN(BO.COSTE) AS MIN
FROM BOMBONES BO 
GROUP BY BO.NUEZ;


--Ejercicio 4.  
--Haz una vista a la que llamaremos PEDIDOS_VERANO. Vamos a guardar en la vista el id, 
--nombre y apellidos del cliente, el id y nombre de la caja de bombones que compraron, el 
--precio de la caja, la fecha del pedido y el nombre del bombón, para todos los pedidos que 
--se hicieran en los meses de julio o agosto y que el chocolate del bombón sea puro u oscuro. 
CREATE OR REPLACE VIEW PEDIDOS_VERANO AS
SELECT 
        CL.IDCLIENTE,
        CL.NOMBRE,
        CL.APELLIDOS,
        CA.IDCAJA,
        CA.NOMBRE,
        CA.PRECIO,
        PE.FECHA_PEDIDO,
        BO.NOMBRE 
FROM BOMBONES BO 
INNER JOIN DETALLE_CAJAS DC ON BO.IDBOMBON = DC.IDBOMBON 
INNER JOIN CAJAS CA ON DC.IDCAJA = CA.IDCAJA 
INNER JOIN DETALLE_PEDIDOS DP ON CA.IDCAJA = DP.IDCAJA 
INNER JOIN PEDIDOS PE ON DP.IDPEDIDO = PE.IDPEDIDO 
INNER JOIN CLIENTES CL ON PE.IDCLIENTE = CL.IDCLIENTE
WHERE TO_CHAR(PE.FECHA_PEDIDO, 'MM') IN ('07','08')
        AND UPPER(BO.CHOCOLATE) IN ('PURO','OSCURO');

--Ejercicio 5.   
-- 
--Haz un listado con el nombre de las cajas y coste para cajas cuyo coste sea menor de 
--400€. 
-- 
--El coste de la caja se calcula sumando por cada bombón de la caja, la cantidad que hay de 
--ese bombon * por el coste de ese bombón. 
-- 
SELECT  
        CA.NOMBRE,
        SUM(DC.CANTIDAD * BO.COSTE)
FROM BOMBONES BO 
INNER JOIN DETALLE_CAJAS DC 
        ON BO.IDBOMBON = DC.IDBOMBON 
INNER JOIN CAJAS CA 
        ON DC.IDCAJA = CA.IDCAJA
WHERE SUM(DC.CANTIDAD * BO.COSTE) < 400 
GROUP BY CA.NOMBRE;
WITH COSTES AS (
SELECT 
        DC.IDCAJA IDCAJA,
        SUM(DC.CANTIDAD * BO.COSTE) COSTECAJA
FROM BOMBONES BO 
INNER JOIN DETALLE_CAJAS DC ON DC.IDBOMBON = BO.IDBOMBON
GROUP BY DC.IDCAJA
)
SELECT 
        C.NOMBRE,
        CO.COSTECAJA
FROM CAJAS C 
INNER JOIN COSTES CO ON C.IDCAJA = CO.IDCAJA
WHERE CO.COSTECAJA < 400;


    
-- 
--Ejercicio 6.  
-- 
--Haz un listado con las cajas, nombre de la caja, el nombre del bombón más caro de cada 
--caja y el número de cajas que se han pedido de esa caja. 



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
-- 
--Crea una vista que llamaremos BOMBON_CAJA con el nombre de cada bombón y un 
--campo S/N de si el bombón está en alguna caja de bombones o no.  
-- 
-- 
--Ejercicio 10.   
-- 
--