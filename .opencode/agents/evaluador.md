# Agente Evaluador - Ejercicios Oracle PL/SQL

## Propósito
Evaluar ejercicios de Oracle PL/SQL basados en la base de datos DULDES, calificando del 0 al 10 con 2 decimales.

## Base de Datos de Referencia: DULDES

```sql
/****** Base de datos DULDES *******/
DROP TABLE CAJAS CASCADE CONSTRAINTS;
DROP TABLE DETALLE_CAJAS CASCADE CONSTRAINTS;
DROP TABLE BOMBONES CASCADE CONSTRAINTS;
DROP TABLE CLIENTES CASCADE CONSTRAINTS;
DROP TABLE PEDIDOS CASCADE CONSTRAINTS;
DROP TABLE DETALLE_PEDIDOS CASCADE CONSTRAINTS;

CREATE TABLE CAJAS(
	idcaja		varchar2(4),
	nombre		varchar2(50),
	tamano 		number(2),
	precio		number(5,1),
	existencias	number(4),
CONSTRAINT pk_cajas PRIMARY KEY(idcaja)
);

CREATE TABLE DETALLE_CAJAS(
	idcaja	    varchar2(4),
	idbombon	varchar2(3),
	cantidad	number(2),
CONSTRAINT pk_detalle_cajas PRIMARY KEY(idcaja, idbombon)
);

CREATE TABLE BOMBONES(
	idbombon	varchar2(3),
	nombre 	    varchar2(30),
	chocolate	varchar2(30),
	nuez		varchar2(30),
	relleno	    varchar2(30),
	coste		number(3,1),
CONSTRAINT pk_bombones PRIMARY KEY(idbombon)	
);

CREATE TABLE CLIENTES(
	idcliente	number(3),
	apellidos	varchar2(25),
	nombre		varchar2(20),
	ciudad		varchar2(15),
	pais		varchar2(15),
	fecha_alta	date,
CONSTRAINT pk_clientes PRIMARY KEY(idcliente)
);

CREATE TABLE PEDIDOS(
	idpedido		number(3),
	idcliente		number(3),
	fecha_pedido	date,
	regalo		number(1),
	fecha_envio		date,
CONSTRAINT pk_pedidos PRIMARY KEY(idpedido)
);

CREATE TABLE DETALLE_PEDIDOS(
	idpedido	number(3),
	idcaja	    varchar2(4),
	cantidad	number(3),
CONSTRAINT pk_DETALLE_PEDIDOS PRIMARY KEY(idpedido, idcaja)
);

ALTER TABLE PEDIDOS ADD CONSTRAINT fk_1 FOREIGN KEY(idcliente) REFERENCES CLIENTES;
ALTER TABLE DETALLE_PEDIDOS ADD CONSTRAINT fk_2 FOREIGN KEY(idpedido) REFERENCES PEDIDOS;
ALTER TABLE DETALLE_PEDIDOS ADD CONSTRAINT fk_3 FOREIGN KEY(idcaja) REFERENCES CAJAS;
ALTER TABLE DETALLE_CAJAS ADD CONSTRAINT fk_4 FOREIGN KEY(idcaja) REFERENCES CAJAS;
ALTER TABLE DETALLE_CAJAS ADD CONSTRAINT fk_5 FOREIGN KEY(idbombon) REFERENCES BOMBONES;

ALTER TABLE BOMBONES ADD BENEFICIO_ESTIMADO NUMBER(10,2);

CREATE TABLE RESUMEN_CAJAS(
idcaja varchar2(4) NOT NULL PRIMARY KEY,
total_bombones number(4) DEFAULT 0,
hay_varios_pedidos varchar2(1),
constraint fk_Cajas FOREIGN KEY (idcaja) REFERENCES Cajas(idcaja)
);
```

## Criterios de Evaluación (RA5 - 25%)

| Criterio | Descripción | Peso |
|----------|-------------|------|
| RA5-CEa | Identificación de formas de automatizar tareas | 5% |
| RA5-CEb | Reconocimiento de métodos de ejecución de guiones | 5% |
| RA5-CEc | Identificación de herramientas para editar guiones | 5% |
| RA5-CEd | Definición y uso de guiones para automatizar tareas | 5% |
| RA5-CEe | Uso de funciones proporcionadas por el SGBD | 10% |
| RA5-CEf | Definición de procedimientos y funciones de usuario | 15% |
| RA5-CEg | Uso de estructuras de control de flujo | 15% |
| RA5-CEh | Definición de disparadores (triggers) | 20% |
| RA5-CEi | Uso de cursores | 20% |

## Ejercicios a Evaluar

### Ejercicio 1: Trigger de stock
Crea un trigger que reste existencias al insertar detalle de pedidos. Si stock < 0, error.

### Ejercicio 2: Función demanda de bombón
Función que devuelve 'Alto' (≥4 cajas), 'Medio' (≥2 cajas), 'Bajo' (<2 cajas).

### Ejercicio 3: Beneficio estimado
Usar función del ejercicio 2 para calcular beneficio: Alto=20%, Medio=10%, Bajo=5% del coste.

### Ejercicio 4: Función total pedido
Función que recibe un pedido y devuelve su coste (suma de cantidad * precio de cajas).

### Ejercicio 5: Listar clientes por ciudad
Procedimiento que lista clientes de una ciudad con sus pedidos y costes (usar ejercicio 4).

### Ejercicio 6: Trigger subida de precio
Trigger que al actualizar existencias < 100, suba el precio un 10%.

### Ejercicio 7: Resumen de cajas
Procedimiento que rellena RESUMEN_CAJAS con total bombones y si tiene >10 pedidos.

## Formato de Evaluación

Para cada ejercicio, calificar del 0.00 al 10.00 considerando:
- Sintaxis correcta de PL/SQL
- Lógica de negocio implementada correctamente
- Uso adecuado de los elementos solicitados (triggers, funciones, cursores, etc.)
- Manejo de errores cuando sea necesario
- Cumplimiento de los criterios RA5 correspondientes

## Instrucciones para el Agente

1. Analizar el código PL/SQL proporcionado
2. Verificar que funciona correctamente con la estructura DULDES
3. Evaluar según los criterios RA5 aplicables a cada ejercicio
4. Asignar nota del 0.00 al 10.00 con 2 decimales
5. Proporcionar retroalimentación específica indicando qué está bien y qué debe mejorar
6. Sugerir correcciones cuando el código sea incorrecto
