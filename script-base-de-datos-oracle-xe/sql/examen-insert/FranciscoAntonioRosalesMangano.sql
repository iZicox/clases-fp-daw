--1

insert into ACTORES(IDACTOR,NOMBRE,APELLIDOS,SALARIO_MES_RODAJE,PAIS_NACIMIENTO,OBSERVACIONES)
VALUES('21','Francisco','Rosales','75000,50','España','');

commit;

--2

INSERT INTO PELICULA(IDPELICULA,NOMBRE,IDGENERO,FECHA_ESTRENO,PAIS,DURACION)
VALUES('18','Ladrón de recuerdos','7',TO_DATE('20/03/2026','DD/MM/YYYY'),'España','112');

commit;

--3

insert into REPARTO(IDPELICULA,IDACTOR,PAPEL,MESES_RODAJE)
values('18','21','secundario','2');

insert into REPARTO(IDPELICULA,IDACTOR,PAPEL,MESES_RODAJE)
values('18','2','cameo','1');

insert into REPARTO(IDPELICULA,IDACTOR,PAPEL,MESES_RODAJE)
values('18','1','principal','3');


commit;

--4

update REPARTO 
set IDACTOR = '16' 
where IDACTOR = '21';

SAVEPOINT PS1;
--5
select * from ACTORES;

update actores 
set SALARIO_MES_RODAJE = SALARIO_MES_RODAJE * 1.10,
    observaciones = 'Revision salarial 2026'
where IDACTOR in (
    select a3.IDACTOR from actores a3 
    where a3.IDACTOR not in (
        select a2.IDACTOR from actores a2 where a2.PAIS_NACIMIENTO = 'Japón'
    )
);

--6a

update ACTORES a2
set a2.SALARIO_MES_RODAJE = a2.SALARIO_MES_RODAJE * 1.05 
where a2.SALARIO_MES_RODAJE in (
    SELECT distinct min(a.SALARIO_MES_RODAJE) from ACTORES a 
    GROUP by a.PAIS_NACIMIENTO
);

--6b

ROLLBACK to PS1;

--6c

ROLLBACK;

--7

alter table pelicula add (coste_total number(14,2));

update pelicula p
set p.coste_total = (
    select sum(a.SALARIO_MES_RODAJE * r.MESES_RODAJE) 
    from pelicula p2
    inner join reparto r on r.idpelicula = p2.idpelicula
    inner join actores a on a.idactor = r.idactor
    WHERE p2.IDPELICULA = p.IDPELICULA
    GROUP by p.NOMBRE
);

select nombre, COSTE_TOTAL from PELICULA;

select a.NOMBRE, r.MESES_RODAJE, a.SALARIO_MES_RODAJE
        , r.MESES_RODAJE * a.SALARIO_MES_RODAJE total
 from pelicula p 
inner join REPARTO r on r.IDPELICULA = p.IDPELICULA
inner join actores a on a.IDACTOR = r.IDACTOR
where p.IDPELICULA = '1';










