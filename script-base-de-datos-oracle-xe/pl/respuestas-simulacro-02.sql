--
--3
--
--Automatic Zoom
-- 
--Tenemos el siguiente modelo de BBDD 
-- 
-- 
--Ejercicio 1  
--Crea un proceso de BD que cada vez que se inserte un detalle de pedidos, reste de las existencias 
--de la caja la cantidad que se ha pedido. 
-- 
--Si el número de existencias, después de actualizar, es menor que 0 debe dar un error para que falle 
--la inserción. 
-- 
CREATE OR REPLACE TRIGGER trg_actualizar_stock 
BEFORE INSERT 
ON detalle_pedidos
FOR EACH ROW
DECLARE
    v_nuevo_stock number;
    v_stock_actual cajas.EXISTENCIAS%TYPE;
BEGIN
    
    SELECT existencias 
    INTO v_stock_actual 
    FROM cajas 
    WHERE IDCAJA = :new.IDCAJA;

    v_nuevo_stock := v_stock_actual - :new.cantidad;

    IF v_nuevo_stock < 0 THEN
        RAISE_APPLICATION_ERROR(
            -20100, 'No hay stock suficiente. Unidades disponibles: ' || v_stock_actual);
    END IF;
END;
/
SELECT * FROM CAJAS;
SELECT * FROM DETALLE_PEDIDOS;

INSERT INTO DETALLE_PEDIDOS 
VALUES('6','BITT','500');

--Ejercicio 2  
--Crea un proceso de BD que reciba un bombón y devuelva una cadena (VARCHAR2) con los 
--siguientes valores: 
---  Alto: si el bombón recibido está en 4 o  más cajas 
---  Medio: si el bombón recibido está en 2 o más cajas y menos de 4. 
---  Bajo: si el bombón recibido está en menos de 2 cajas 
--

SELECT b.IDBOMBON , count(c.idcaja) as cajas, F_DISPONIBILIDAD(b.IDBOMBON)
FROM BOMBONES b 
left JOIN DETALLE_CAJAS dc ON dc.IDBOMBON = b.IDBOMBON
left JOIN CAJAS c ON c.IDCAJA = dc.IDCAJA
group by b.IDBOMBON
order by cajas;

SELECT count(c.IDCAJA)
FROM BOMBONES b 
LEFT JOIN DETALLE_CAJAS dc ON dc.IDBOMBON = b.IDBOMBON
left JOIN CAJAS c ON c.IDCAJA = dc.IDCAJA
WHERE b.IDBOMBON = 'M03';

SELECT * FROM BOMBONES;

CREATE OR REPLACE FUNCTION F_disponibilidad (p_id_bombon BOMBONES.IDBOMBON%TYPE)
RETURN VARCHAR2 IS
        v_total_cajas NUMBER; 
BEGIN
    SELECT count(c.IDCAJA)
    into v_total_cajas
    FROM BOMBONES b 
    LEFT JOIN DETALLE_CAJAS dc ON dc.IDBOMBON = b.IDBOMBON
    left JOIN CAJAS c ON c.IDCAJA = dc.IDCAJA
    WHERE b.IDBOMBON = p_id_bombon;

    IF v_total_cajas >= 4 THEN
        RETURN 'Alto';
    ELSIF v_total_cajas >= 2 THEN
        RETURN 'Medio';  
    ELSE
        RETURN 'Bajo';
    END IF;
END;
/
-- 
--Ejercicio 3  
--Ejecuta el script de BD que crea una nueva columna en la tabla de BOMBONES llamada 
--“BENEFICIO_ESTIMADO” de tipo Number(10,2). 
-- 
--ALTER TABLE bombones ADD beneficio_estimado number(10,2); 
-- 
--Crea un proceso de BD la rellene. Para eso se estima que el beneficio del bombón depende del 
--número de cajas en las que esté. 
---  Si está en un número alto de cajas: será del 20% de su coste. 
---  Si está en un número medio de cajas: será del 10% de su coste. 
---  Si está en un número bajo de cajas: será del 5% de su coste. 
-- 
--Debes utilizar el proceso creado en el ejercicio 2. 


CREATE OR REPLACE PROCEDURE pr_llenar_beneficio_estimado AS 
    CURSOR c_datos IS
        SELECT  b.IDBOMBON, 
                F_DISPONIBILIDAD(b.IDBOMBON) as disponibilidad,
                b.coste
        FROM BOMBONES b;
    v_beneficio NUMBER(5,2);
BEGIN
    FOR registro IN c_datos LOOP
        IF registro.disponibilidad = 'Alto' THEN
            v_beneficio := 0.2 * registro.coste;
        ELSIF registro.disponibilidad = 'Medio' THEN
            v_beneficio := 0.1 * registro.coste;
        ELSE
            v_beneficio := 0.05 * registro.coste;
        END IF;

        UPDATE BOMBONES b 
        SET b.BENEFICIO_ESTIMADO = v_beneficio 
        WHERE b.IDBOMBON = registro.IDBOMBON;
    END LOOP;
END;
/
EXECUTE PR_LLENAR_BENEFICIO_ESTIMADO;
SELECT IDBOMBON, nvl(BENEFICIO_ESTIMADO,0) from bombones;

UPDATE BOMBONES 
SET BENEFICIO_ESTIMADO = NULL;
-- 
--Ejercicio 4   
--Haz un proceso de BD  que reciba como parámetro un pedido y devuelva el coste de este pedido. El 
--coste de un pedido es la suma de la cantidad de cada caja que hay en pedido * el precio de la caja.  
-- 
CREATE OR REPLACE FUNCTION f_obtener_total_pedido(p_id_pedido PEDIDOS.IDPEDIDO%TYPE) 
RETURN NUMBER IS
    v_total_pedido NUMBER;
BEGIN
    SELECT  SUM(dp.CANTIDAD * c.PRECIO)
    into v_total_pedido
    FROM PEDIDOS p 
    JOIN DETALLE_PEDIDOS dp ON dp.IDPEDIDO = p.IDPEDIDO 
    JOIN CAJAS c ON dp.IDCAJA = c.IDCAJA
    WHERE p.IDPEDIDO = p_id_pedido;

    RETURN v_total_pedido;
END;
/
SELECT
        F_OBTENER_TOTAL_PEDIDO('44')
from dual;



--Ejercicio 5 
-- 
--Haz un proceso de BD  que reciba como parámetro una ciudad  y lista todos los clientes (nombre y 
--apellidos) de esa ciudad. Debajo de cada cliente veremos sus pedidos (id de pedido y fecha) y el 
--coste del pedido. Se debe usar el proceso hecho en el ejercicio anterior. 
-- 
SELECT p.IDPEDIDO, p.FECHA_PEDIDO
FROM PEDIDOS p 
JOIN CLIENTES c ON p.IDCLIENTE = c.IDCLIENTE
WHERE c.IDCLIENTE = '15';

SELECT * from CLIENTES;

CREATE OR REPLACE PROCEDURE pr_listar_clientes_ciudad (p_ciudad clientes.ciudad%type) AS
    CURSOR c_clientes IS
        SELECT 
        c.IDCLIENTE, c.NOMBRE, c.APELLIDOS
        FROM CLIENTES c
        WHERE c.CIUDAD = p_ciudad;
    CURSOR c_pedidos (p_id_cliente CLIENTES.IDCLIENTE%type) IS
        SELECT p.IDPEDIDO, p.FECHA_PEDIDO
        FROM PEDIDOS p 
        JOIN CLIENTES c ON p.IDCLIENTE = c.IDCLIENTE
        WHERE c.IDCLIENTE = p_id_cliente;
BEGIN
    FOR r_cliente IN c_clientes LOOP
        DBMS_OUTPUT.PUT_LINE('**************************************************************');
        DBMS_OUTPUT.PUT_LINE('INICIO CIUDAD ' || p_ciudad);
        DBMS_OUTPUT.PUT_LINE('**************************************************************');

        DBMS_OUTPUT.PUT_LINE('Cliente: ' || r_cliente.NOMBRE || ' - ' || r_cliente.APELLIDOS);
        FOR r_pedido IN c_pedidos (r_cliente.IDCLIENTE) LOOP
            DBMS_OUTPUT.PUT_LINE('Pedido: ' 
                                    || r_pedido.IDPEDIDO || ' - ' 
                                    || r_pedido.FECHA_PEDIDO || ' - '
                                    || F_OBTENER_TOTAL_PEDIDO(r_pedido.IDPEDIDO));
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('**************************************************************');
        DBMS_OUTPUT.PUT_LINE('FIN CIUDAD');
        DBMS_OUTPUT.PUT_LINE('**************************************************************');

    END LOOP;
END;
/
BEGIN
    FOR r_ciudad IN (
        SELECT distinct CIUDAD 
        FROM CLIENTES
    ) LOOP
        PR_LISTAR_CLIENTES_CIUDAD(r_ciudad.ciudad);
    END LOOP;
END;
/
-- 
--Ejercicio 6  
-- 
--Crea un proceso de BD que cuando se modifiquen las existencias de una caja, cuando queden 
--menos de 100 unidades de existencias, suba el precio de la caja un 10% (su precio * 1.1) 
-- 
CREATE OR REPLACE TRIGGER trg_bajo_stock 
BEFORE UPDATE OF EXISTENCIAS 
ON CAJAS
FOR EACH ROW 
BEGIN
    IF :new.existencias < 100 THEN
        :new.precio := :new.precio * 1.1;
    END IF;
END;
/
SELECT * from cajas;
UPDATE CAJAS c 
SET c.EXISTENCIAS = 90 
WHERE c.IDCAJA = 'FUDG';
--Ejercicio 7 
--Ejecuta el script para crear la tabla RESUMEN_CAJAS (es el mismo script que para el ejercicio 3). 
-- 
--En esta tabla vamos a guardar por cada caja el número total de bombones que contiene y un 
--indicador para saber si se han hecho más de 10 pedidos de esta caja. 
-- 
--Crea un proceso  de BD que rellene esta tabla. 
-- 
SELECT * FROM RESUMEN_CAJAS;
SELECT * FROM CAJAS c 
JOIN 
-- 
-- 
