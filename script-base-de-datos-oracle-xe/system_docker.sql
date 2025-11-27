CREATE TABLE alumos (
    dni CHAR(10) CONSTRAINT pk_alumno PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    apellido1 VARCHAR2(50) NOT NULL,
    apellido2 VARCHAR2(50),
    fechanacimiento DATE NOT NULL,
    curso VARCHAR2(20),
    trabaja CHAR(1) DEFAULT 'N',
        CONSTRAINT ck_alumno_trabaja CHECK (trabaja IN ('S','N'))
    );
    
CREATE TABLE asignatura (
    codasignatura VARCHAR2(10) CONSTRAINT pk_asignatura PRIMARY KEY,
    nombre VARCHAR2(80) NOT NULL,
    numhoras NUMBER(3) NOT NULL,
        CONSTRAINT ck_asignatura_numhoras CHECK (numhoras BETWEEN 1 AND 999)
);



CREATE TABLE matricula (
    dni VARCHAR2(10) REFERENCES alumos(dni),
    codasignatura NUMBER REFERENCES asignatura(codasignatura)
    
)



