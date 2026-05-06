--
--1
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

CREATE OR REPLACE TRIGGER trg_nuevo_detalle_pedido 
BEFORE insert 
ON detalle_pedidos 
FOR EACH ROW
DECLARE
    v_nuevo_stock cajas.existencias%type;
    v_existencias cajas.EXISTENCIAS%TYPE;
BEGIN
    SELECT EXISTENCIAS 
    INTO v_existencias 
    FROM CAJAS 
    WHERE IDCAJA = :new.IDCAJA;

    v_nuevo_stock := v_existencias - :new.cantidad;

    IF v_nuevo_stock <= 0 THEN
        RAISE_APPLICATION_ERROR(-20100, 'La cantidad vendida es mayor que la existencia: ' || v_existencias);
    END IF;
END;
/
SELECT * FROM CAJAS;
SELECT * FROM PEDIDOS;
SELECT * FROM DETALLE_PEDIDOS;

INSERT INTO DETALLE_PEDIDOS VALUES ('6','BITT','500');

-- 
--Ejercicio 2  
--Crea un proceso de BD que reciba un bombón y devuelva una cadena (VARCHAR2) con los 
--siguientes valores: 
---  Alto: si el bombón recibido está en 4 o  más cajas 
---  Medio: si el bombón recibido está en 2 o más cajas y menos de 4. 
---  Bajo: si el bombón recibido está en menos de 2 cajas 
-- 



SELECT * FROM bombones;

CREATE OR REPLACE FUNCTION f_bombon_demanda (p_id_bombon BOMBONES.idbombon%TYPE)
RETURN VARCHAR2 is 
    v_cajas NUMBER;
BEGIN
    SELECT COUNT(dc.IDCAJA)
    into v_cajas 
    FROM DETALLE_CAJAS dc 
    WHERE dc.IDBOMBON = p_id_bombon;

    IF v_cajas >= 4 THEN
        RETURN 'Alto';
    ELSIF v_cajas >= 2 THEN
        RETURN 'Medio';
    ELSE
      RETURN 'Bajo';
    END IF;
END;
/
SELECT * FROM BOMBONES;
SELECT IDBOMBON, F_BOMBON_DEMANDA(IDBOMBON) FROM BOMBONES;
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
-- 
SELECT * FROM BOMBONES;

CREATE OR REPLACE PROCEDURE pr_actualiza_beneficio_estimado IS
    v_beneficio BOMBONES.BENEFICIO_ESTIMADO%TYPE;
    v_demanda VARCHAR2(20);
    CURSOR c_bombones IS
        SELECT idbombon, coste FROM BOMBONES;
BEGIN
    FOR r_bombon IN c_bombones LOOP
        v_demanda := F_BOMBON_DEMANDA(r_bombon.IDBOMBON);

        IF v_demanda = 'Alto' THEN
            v_beneficio := 0.2 * r_bombon.coste;
        ELSIF v_demanda = 'Medio' THEN
            v_beneficio := 0.1 * r_bombon.coste;
        ELSE
            v_beneficio := 0.05 * r_bombon.coste;
        END IF;


        UPDATE BOMBONES b 
        set b.BENEFICIO_ESTIMADO = v_beneficio 
        
        WHERE b.IDBOMBON = r_bombon.idbombon;

    END LOOP;
END;
/
BEGIN
    pr_actualiza_beneficio_estimado;
END;
/
SELECT b.IDBOMBON, b.BENEFICIO_ESTIMADO FROM BOMBONES b;
UPDATE BOMBONES set BENEFICIO_ESTIMADO = null;
--Ejercicio 4   
--Haz un proceso de BD  que reciba como parámetro un pedido y devuelva el coste de este pedido. El 
--coste de un pedido es la suma de la cantidad de cada caja que hay en pedido * el precio de la caja.  
-- 


CREATE OR REPLACE FUNCTION f_total_pedido(p_id_pedido PEDIDOS.IDPEDIDO%TYPE)
RETURN NUMBER IS
    v_total NUMBER(10,2);
BEGIN
    SELECT SUM(c.PRECIO * dp.CANTIDAD)
    into v_total
    FROM PEDIDOS p 
    JOIN DETALLE_PEDIDOS dp ON p.IDPEDIDO = dp.IDPEDIDO 
    JOIN CAJAS c ON c.IDCAJA = dp.IDCAJA
    WHERE p.IDPEDIDO = p_id_pedido
    GROUP BY p.IDPEDIDO;

    RETURN v_total;
END;
/
SELECT F_TOTAL_PEDIDO(6) from dual;

--Ejercicio 5 
-- 
--Haz un proceso de BD  que reciba como parámetro una ciudad  y lista todos los clientes (nombre y 
--apellidos) de esa ciudad. Debajo de cada cliente veremos sus pedidos (id de pedido y fecha) y el 
--coste del pedido. Se debe usar el proceso hecho en el ejercicio anterior. 
-- 
SELECT 
        p.IDPEDIDO
FROM PEDIDOS p
JOIN CLIENTES c ON c.IDCLIENTE = p.IDCLIENTE
WHERE c.IDCLIENTE = '10';

SELECT *  from clientes;

---
CREATE OR REPLACE PROCEDURE pr_lista_clientes_ciudad (
                                p_ciudad CLIENTES.CIUDAD%TYPE) as
    CURSOR c_clientes IS
        SELECT c.NOMBRE,
                c.APELLIDOS,
                c.IDCLIENTE
        FROM CLIENTES c
        WHERE c.CIUDAD = p_ciudad;

    CURSOR c_pedidos_cliente (p_id_cliente CLIENTES.IDCLIENTE%TYPE) IS
        SELECT 
                p.IDPEDIDO,
                F_TOTAL_PEDIDO(p.IDPEDIDO) as coste,
                p.FECHA_PEDIDO
        FROM PEDIDOS p
        JOIN CLIENTES c ON c.IDCLIENTE = p.IDCLIENTE
        WHERE c.IDCLIENTE = p_id_cliente;
BEGIN
    FOR r_cliente IN c_clientes LOOP
        DBMS_OUTPUT.PUT_LINE(
            r_cliente.NOMBRE || ' ' || r_cliente.APELLIDOS
        );
        FOR r_pedido IN c_pedidos_cliente (r_cliente.IDCLIENTE) LOOP
            -- id, coste, fecha
            DBMS_OUTPUT.PUT_LINE(
                '- ' ||
                r_pedido.IDPEDIDO || ' - ' 
                || r_pedido.coste || ' - '
                || r_pedido.FECHA_PEDIDO
            );
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
/
BEGIN
    FOR r_ciudad IN (
        SELECT CIUDAD FROM CLIENTES
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('***********************');
        DBMS_OUTPUT.PUT_LINE('INICIO CIUDAD ' || r_ciudad.CIUDAD);
        DBMS_OUTPUT.PUT_LINE('***********************');
        PR_LISTA_CLIENTES_CIUDAD(r_ciudad.CIUDAD);
        DBMS_OUTPUT.PUT_LINE('***********************');
        DBMS_OUTPUT.PUT_LINE('FIN CIUDAD');
        DBMS_OUTPUT.PUT_LINE('***********************');
    END LOOP;
end;
/
-- 
--
--Ejercicio 6  
-- 
--Crea un proceso de BD que cuando se modifiquen las existencias de una caja, cuando queden 
--menos de 100 unidades de existencias, suba el precio de la caja un 10% (su precio * 1.1) 

CREATE OR REPLACE TRIGGER trg_bajo_stock_cajas 
BEFORE UPDATE OF EXISTENCIAS 
ON CAJAS 
FOR EACH ROW

BEGIN
    IF :new.EXISTENCIAS < 100 THEN
        :new.PRECIO := :new.precio * 1.1;
    END IF;
END;
/
SELECT * FROM CAJAS;
-- precio 2775
UPDATE CAJAS c 
SET c.EXISTENCIAS = '50'
WHERE c.IDCAJA = 'BITT';
-- 
--Ejercicio 7 
--Ejecuta el script para crear la tabla RESUMEN_CAJAS (es el mismo script que para el ejercicio 3). 
-- 
--En esta tabla vamos a guardar por cada caja el número total de bombones que contiene y un 
--indicador para saber si se han hecho más de 10 pedidos de esta caja. 
-- 
--Crea un proceso  de BD que rellene esta tabla. 
 SELECT * FROM RESUMEN_CAJAS;
delete from RESUMEN_CAJAS;

SELECT c.IDCAJA, COUNT(dc.IDBOMBON)
FROM CAJAS c 
LEFT JOIN DETALLE_CAJAS dc ON dc.IDCAJA = c.IDCAJA
GROUP BY c.IDCAJA;

SELECT  c.IDCAJA, 
        COUNT(dc.IDBOMBON) as total_bomnones,
        COUNT(distinct p.IDPEDIDO) as total_pedidos
FROM CAJAS c 
JOIN DETALLE_CAJAS dc ON c.IDCAJA = dc.IDCAJA
JOIN DETALLE_PEDIDOS dp ON dp.IDCAJA = c.IDCAJA 
JOIN PEDIDOS p ON p.IDPEDIDO = dp.IDPEDIDO
GROUP BY c.IDCAJA;


 DECLARE
    CURSOR c_cajas IS
        SELECT  c.IDCAJA, 
                COUNT(dc.IDBOMBON) as total_bombones,
                COUNT(distinct p.IDPEDIDO) as total_pedidos
        FROM CAJAS c 
        JOIN DETALLE_CAJAS dc ON c.IDCAJA = dc.IDCAJA
        JOIN DETALLE_PEDIDOS dp ON dp.IDCAJA = c.IDCAJA 
        JOIN PEDIDOS p ON p.IDPEDIDO = dp.IDPEDIDO
        GROUP BY c.IDCAJA;
    v_mayor_de_10 VARCHAR2(1);
BEGIN
    FOR r_caja IN c_cajas LOOP
        v_mayor_de_10 := 'F';
        IF r_caja.total_bombones >= 10 THEN
            v_mayor_de_10 := 'T';
        END IF;
        INSERT INTO RESUMEN_CAJAS VALUES(
                                    r_caja.idcaja,
                                    r_caja.total_bombones,
                                    v_mayor_de_10);
        
    END LOOP;
END;
/
 
 
 