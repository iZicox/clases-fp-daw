-- ejercicio 1
-- creacion de usuario
CREATE USER ventas_app IDENTIFIED BY ventas123;
-- privilegio de conectarse y crear tablas
GRANT CONNECT, resource, CREATE SESSION, CREATE TABLE TO ventas_app;

-- ejercicio 2

-- crear tabla

CREATE TABLE clientes (
id_cliente NUMBER PRIMARY KEY 
);

-- ejercicio 3

-- crear rol

CREATE ROLE rol_desarrollo;
GRANT CREATE TABLE TO rol_desarrollo;
