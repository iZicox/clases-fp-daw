--Ejercicios manipulación de datos – MULTAS
--1. Crea un nueva persona indicando con DNI “123456789D” y Nombre “Alumno
--Aprendiendo”

insert into personas (dni,nombre) values('123456789D','Alumno Aprendiendo');
--2. Inserta 2 coches asociados a esta persona con matrículas '3344-PPP' y '2221-JJJ',
select * from MATRICULAS where dni in ('123456789D','123456789D');
insert into MATRICULAS (MATRICULA,DNI) 
        values('3344-PPP','123456789D'),
                ('2221-JJJ','123456789D');
commit;
--3. Crea una multa en la CALLE PADRE CLARET de 150€ para el coche con matrícula
--'2221-JJJ' y otra de 100€ en CALLE CORAZON DE MARIA para el coche con matrícula
--'3344-PPP'.
--select * from MULTAS where MATRICULA in ('2221-JJJ','3344-PPP');

insert into MULTAS(REF,MATRICULA,IMPORTE,LUGAR)
    VALUES ('9999900','2221-JJJ','150','CALLE PADRE CLARET');
insert into MULTAS(REF,MATRICULA,IMPORTE,LUGAR) 
    VALUES('999919199','3344-PPP','100','CALLE CORAZON DE MARIA');
commit;
--4. Modifica esta última multa y ponla de 200€.
select * from multas where MATRICULA = '3344-PPP';

UPDATE MULTAS
SET IMPORTE = '200'
WHERE MATRICULA = '3344-PPP';

commit;
--5. Crea una tabla con el nombre personas_total_multas que tenga las siguientes
--columnas: DNI de la persona, nombre de la persona e importe total de multas que
--tiene considerando todos los coches/matrículas que tenga esa persona.
create table personas_total_multas (
    dni VARCHAR2(10) PRIMARY key,
    nombre VARCHAR2(50),
    multa_total number(8,2) 
);

select * from PERSONAS_TOTAL_MULTAS;

INSERT INTO PERSONAS_TOTAL_MULTAS
(select  p.dni,
        p.nombre,
        sum(mu.importe)
from PERSONAS p 
inner join MATRICULAS m on m.dni = p.dni 
inner join MULTAS mu on mu.MATRICULA = m.MATRICULA
group by p.dni, p.NOMBRE);


commit;
--6. Elimina la persona 222549765B. ¿Es posible eliminarlo? ¿Por qué? Si no pudiste, ¿qué
--cambios deberías realizar para que fuese posible borrarlo?
DELETE
FROM PERSONAS
WHERE dni = '222549765B';
--7. Elimina la persona 147956320S ¿Es posible eliminarlo?¿Por qué?Si no pudiste, ¿qué
--cambios deberías realizar para que se pudiera borrar?
--8. Actualiza el DNI de la persona con DNI 452103687F y asígnale el valor 452103687D. ¿Es
--posible actualizarlo? Si no es posible, ¿qué cambios deberías realizar para que se
--pudiera actualizar?
--9. Actualiza el DNI de la persona 203254778N y asígnale el valor 203254778H. ¿Es posible
--actualizarlo? Si no es posible, ¿qué cambios deberías realizar para que fuese posible
--actualizarlo?
--10. Crea una nueva columna en la tabla de multas que indique si la multa está pagado. El
--nombre de la columna será “PAGADO”, será de 1 sólo carácter y el valor para todos los
--campos debe ser N
--11. Crea una nueva columna en la tabla de multas que sea “DESC_PUNTOS”. También es
--un carácter de una única posición y se debe rellenar con la siguiente lógica.
--1. Para las multas de 200€ o menos => Se rellena con N
--2. Para las multas de más de 200€ => Se rellena con S
--12. Elimina todas las multas de importe menor a 10€
