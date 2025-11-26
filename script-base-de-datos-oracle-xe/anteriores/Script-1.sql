CREATE TABLE libros (
	codlibro NUMBER(9) NOT	NULL,
	isbn VARCHAR2(30 CHAR)	NOT NULL,
	titulo VARCHAR2(30) NOT NULL,
	fechapublicacion DATE NOT NULL,
	superventas VARCHAR2(1) DEFAULT 'N' NOT NULL,
	precio NUMBER(10,2),
	CONSTRAINT pk_lib_cod PRIMARY KEY (codlibro),
	CONSTRAINT un_lib_isbn UNIQUE (isbn),
	CONSTRAINT ck_lib_sup CHECK (superventas IN ('N', 'S'))
	
);

CREATE TABLE autor (
	codautor NUMBER	(9) NOT NULL,
	documento VARCHAR2(20 CHAR) NOT NULL,
	nombre VARCHAR2(30 CHAR) NOT NULL,
	apellidos VARCHAR2(50 CHAR) NOT NULL,
	email VARCHAR2(30),
	fechanacimiento DATE NOT NULL,
	CONSTRAINT pk_aut_cod PRIMARY KEY (codautor),
	CONSTRAINT un_aut_doc UNIQUE (documento),
	CONSTRAINT un_aut_ema UNIQUE (email)
	);

CREATE TABLE autor_x_libros (
	codautor NUMBER(9),
	codlibro NUMBER(9),
	ganador VARCHAR2(1 CHAR) DEFAULT 'N' NOT NULL,
	CONSTRAINT PK_lib_X_aut_cod_cod PRIMARY KEY (CodLibro,CodAutor),
	CONSTRAINT FK_aut_x_lib_codlib FOREIGN KEY (CodLibro) REFERENCES libros,
	CONSTRAINT FK_aut_x_lib_codlaut FOREIGN KEY (CodAutor) REFERENCES autor,
	CONSTRAINT CK_lib_X_aut_gan CHECK (Ganador IN ('N','S'))
);


CREATE TABLE tematica (
codtema VARCHAR(9),
descripcion VARCHAR (30) NOT NULL,
CONSTRAINT PK_tem_cod PRIMARY KEY (codtema)
);


ALTER TABLE libros ADD (
CodTema VARCHAR(9),
CONSTRAINT FK_lib_tem FOREIGN KEY (CodTema) REFERENCES tematica);

CREATE TABLE ubicacion (
	codubicacion NUMBER	(9) NOT NULL,
	descripcion VARCHAR2(30),
	planta NUMBER(2) DEFAULT 1 NOT NULL,
	pasillo VARCHAR2(30 CHAR) NOT NULL,
	CONSTRAINT pk_ubi_cod PRIMARY KEY (codubicacion),
	CONSTRAINT ck_ubi_pla CHECK (planta <= 4)
);

ALTER TABLE TEMATICA ADD (
	codubicacion NUMBER(9) NOT NULL,
	CONSTRAINT fk_tem_ubi FOREIGN KEY(codubicacion) REFERENCES UBICACION
);

ALTER TABLE AUTOR ADD(
	codubicacion NUMBER(9) NOT NULL,
	CONSTRAINT fk_aut_ubi FOREIGN KEY(codubicacion) REFERENCES UBICACION

);










