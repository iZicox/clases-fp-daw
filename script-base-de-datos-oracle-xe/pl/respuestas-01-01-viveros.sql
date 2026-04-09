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
    var NUMBER;
    in1 NUMBER;
    in2 NUMBER;
BEGIN
    var := &in1;
    DBMS_OUTPUT.PUT_LINE('Valor: ' || &in2);
    DBMS_OUTPUT.PUT_LINE('Valor 2: ' || var);
END;

--2. Dado un tipo de producto introducido por teclado, obtener el número de productos
--que hay asociados a este tipo de producto.
--3. Incrementar el precio de venta en 5€  a todos productos para los que su stock sea
--menor de 25 unidades.
--4. Haz un bloque anónimo que asigne a una variable declarada el código de un cliente y
--cuente el número de pedidos del cliente.
--5. Pide dos tiendas por teclado e indica cuál de las dos tiendas ingresó más dinero por los
--pedidos hechos por sus clientes.
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
