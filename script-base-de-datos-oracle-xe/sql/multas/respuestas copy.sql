--Ejercicios manipulación de datos – MULTAS
--1. Crea un nueva persona indicando con DNI “123456789D” y Nombre “Alumno
--Aprendiendo”
insert into 
    TIENDA(CODTIENDA,CIUDAD,PAIS,CP,TELEFONO,LINEADIRECCION1)
    VALUES('TCA-ES','Madrid','España','000000','123456789','por ahi');

select * from personas where dni = '123456789D';

insert into 
    personas(DNI,NOMBRE)
    VALUES('123456789D','Alumno Aprendiendo');

SAVEPOINT eje_01;
--2. Inserta 2 coches asociados a esta persona con matrículas '3344-PPP' y '2221-JJJ',

insert into MATRICULAS(MATRICULA,DNI)
VALUES('3344-PPP','123456789D');

insert into MATRICULAS(MATRICULA,DNI)
VALUES('2221-JJJ','123456789D');

select * from MATRICULAS where dni = '123456789D';

SAVEPOINT eje_02;

--3. Crea una multa en la CALLE PADRE CLARET de 150€ para el coche con matrícula
--'2221-JJJ' y otra de 100€ en CALLE CORAZON DE MARIA para el coche con matrícula
--'3344-PPP'.

select * from multas;

insert into multas(REF,MATRICULA,IMPORTE,LUGAR)
    VALUES('JEJEJE','2221-JJJ','150','CALLE PADRE CLARET');

insert into multas(REF,MATRICULA,IMPORTE,LUGAR)
    VALUES('JOJOJO','3344-PPP','100','CALLE CORAZON DE MARIA');

commit;

select * from personas p
left join MATRICULAS m on m.dni = p.dni
left join multas mu on mu.MATRICULA = m.MATRICULA
where p.dni = '123456789D';

--4. Modifica esta última multa y ponla de 200€.

update multas 
set importe = 200 
where MATRICULA = '3344-PPP';

SAVEPOINT eje_04;
ROLLBACK to eje_04;

--5. Crea una tabla con el nombre personas_total_multas que tenga las siguientes
--columnas: DNI de la persona, nombre de la persona e importe total de multas que
--tiene considerando todos los coches/matrículas que tenga esa persona.

create table personas_total_multas(
    dni varchar2(10) primary key,
    nombre varchar(30),
    total_multas number(10,2)
);

select * from PERSONAS_TOTAL_MULTAS;


insert into PERSONAS_TOTAL_MULTAS
select  p.dni,
        p.nombre,
        sum(mu.importe)
from personas p 
inner join MATRICULAS m on m.dni = p.DNI 
inner join multas mu on mu.MATRICULA = m.MATRICULA
group by p.dni, p.nombre;

SAVEPOINT eje_08;

--6. Elimina la persona 222549765B. ¿Es posible eliminarlo? ¿Por qué? Si no pudiste, ¿qué
--cambios deberías realizar para que fuese posible borrarlo?

delete MULTAS
where matricula in (
    select m.MATRICULA from matriculas m 
    inner join personas p on p.dni = m.dni
    where p.dni = '222549765B'
);

delete matriculas 
where dni = '222549765B';

delete personas 
where dni = '222549765B';

select * from personas p
left join MATRICULAS m on m.dni = p.dni
left join multas mu on mu.MATRICULA = m.MATRICULA
where p.dni = '222549765B';

--7. Elimina la persona 147956320S ¿Es posible eliminarlo?¿Por qué?Si no pudiste, ¿qué
--cambios deberías realizar para que se pudiera borrar?

delete personas where dni = '147956320S';

select * from personas p
left join MATRICULAS m on m.dni = p.dni
left join multas mu on mu.MATRICULA = m.MATRICULA
where p.dni = '147956320S';

--8. Actualiza el DNI de la persona con DNI 452103687F y asígnale el valor 452103687D. ¿Es
--posible actualizarlo? Si no es posible, ¿qué cambios deberías realizar para que se
--pudiera actualizar?

update PERSONAS
set dni = '452103687D'
where dni = '452103687F';

select * from personas p
left join MATRICULAS m on m.dni = p.dni
left join multas mu on mu.MATRICULA = m.MATRICULA
where p.dni = '452103687F';

--9. Actualiza el DNI de la persona 203254778N y asígnale el valor 203254778H. ¿Es posible
--actualizarlo? Si no es posible, ¿qué cambios deberías realizar para que fuese posible
--actualizarlo?

--insert into personas

insert into PERSONAS(dni,nombre)
select '203254778H', nombre from personas where dni = '203254778N';

update matriculas 
set dni = '203254778H' 
where dni = '203254778N';

delete personas 
where dni = '203254778N';

select * from personas p
left join MATRICULAS m on m.dni = p.dni
left join multas mu on mu.MATRICULA = m.MATRICULA
where p.dni in ('203254778N');

select * from personas p
left join MATRICULAS m on m.dni = p.dni
left join multas mu on mu.MATRICULA = m.MATRICULA
where p.dni in ('203254778N','203254778H');

--10. Crea una nueva columna en la tabla de multas que indique si la multa está pagado. El
--nombre de la columna será “PAGADO”, será de 1 sólo carácter y el valor para todos los
--campos debe ser N

alter table multas add pagado char(1);

update multas 
set pagado = 'N';

select * from multas;

--11. Crea una nueva columna en la tabla de multas que sea “DESC_PUNTOS”. También es
--un carácter de una única posición y se debe rellenar con la siguiente lógica.
--1. Para las multas de 200€ o menos => Se rellena con N
--2. Para las multas de más de 200€ => Se rellena con S

alter table multas add desc_puntos char(1);

select * from multas;

SAVEPOINT eje_11;

update multas 
set desc_puntos = 
            case
                when importe <= 200 then 'N'
                else 'S'
            end;

--12. Elimina todas las multas de importe menor a 10€

delete multas m
where m.matricula in (
    select m2.matricula from multas m2 where m2.importe < 10
);

