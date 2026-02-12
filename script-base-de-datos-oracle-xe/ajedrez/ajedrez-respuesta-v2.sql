--CREATE USER gambito IDENTIFIED BY 123
--               QUOTA UNLIMITED ON USERS;
--
--GRANT CREATE MATERIALIZED VIEW,
--      CREATE PROCEDURE,
--      CREATE SEQUENCE,
--      CREATE SESSION,
--      CREATE SYNONYM,
--      CREATE TABLE,
--      CREATE TRIGGER,
--      CREATE TYPE,
--      CREATE VIEW
--  TO gambito;
--
--
--
--BASES DE DATOS - 22/02/2023 (EXAMEN A)
--DM1E 2ª EVALUACIÓN
--NOMBRE
--INDICACIONES:
--● NO ESTÁN ORDENADOS EN NIVEL DE DIFICULTAD.
--● TODAS LAS PREGUNTAS SE HACEN CON UNA SOLA SENTENCIA SQL Y
--UTILIZANDO ÚNICAMENTE LOS DATOS PROPORCIONADOS EN EL ENUNCIADO
--DE CADA EJERCICIO.
--● En las consultas que no se pide un orden específico, con el fin de poder
--comprobar mejor los resultados, se puede ordenar el resultado siguiendo el
--criterio que se desee (o ninguno).
--● Crear un usuario AJEDREZ. Crea una conexión con este usuario
--y lanza el script Ajedrez,sql. Si no utilizas ese esquema no
--funcionará el script.
--● El esquema representa el resultado de un torneo de ajedrez. El
--esquema incluye la gestión de:
--● Participantes (Jugadores y árbitros), así como el hotel en el que se aloja
--el participante.
--● Países y sus relaciones de representación.
--● Hoteles y salas donde se desarrollan las partidas y alojan participantes.
--● Partidas, incluyendo contrincantes, movimientos, ganadores (si lo hay) y
--árbitros asignados.

--Ejercicio 1.
--Sacar un informe con el nombre del país, nombre del jugador y campeonatos
--ganados, para participantes que sean jugadores. La consulta debe ordenarse por nº
--de campeonatos ganados de más a menos, nombre del país y nombre del jugador
--alfabéticamente.

SELECT  
        PA.NOMBRE,
        PAR.NOMBRE,
        PAR.CAMPEONATOS 
FROM PARTICIPANTES PAR 
INNER JOIN PAISES PA ON PA.NUM_PAIS = PAR.PAIS 
WHERE UPPER(PAR.TIPO) = 'JUGADOR'
ORDER BY PAR.CAMPEONATOS DESC, PA.NOMBRE, PAR.NOMBRE DESC;

--Ejercicio 2.
--Sacar un informe con el nombre del participante, fecha de entrada y fecha de
--salida, nombre del hotel y dirección para hoteles cuya dirección sea una calle (ni
--plaza ni paseo) y para alojamientos que empezasen el 22 o el 23 de abril del 2007
--y acabasen el 25 o el 26 de abril del 2007.
SELECT 
        PAR.NOMBRE,
        AL.FECHAIN,
        AL.FECHAOUT,
        H.NOMBRE,
        H.DIRECCION
FROM PARTICIPANTES PAR 
INNER JOIN ALOJAMIENTOS AL ON AL.PARTICIPANTE = PAR.NUM_ASOCIADO
INNER JOIN HOTELES H ON H.NOMBRE = AL.HOTEL
WHERE UPPER(PAR.TIPO) = 'JUGADOR'
AND UPPER(H.DIRECCION) LIKE 'C%'
AND (AL.FECHAIN BETWEEN TO_DATE('22-04-2007','DD-MM-YYYY') AND TO_DATE('23-04-2007','DD-MM-YYYY'))
AND (AL.FECHAOUT BETWEEN TO_DATE('25-04-2007','DD-MM-YYYY') AND TO_DATE('26-04-2007','DD-MM-YYYY'));

--Ejercicio 3.
--Queremos un informe con el 
    --nombre del jugador, 
    --nombre del país, 
    --número de campeonatos ganados
    --número de partidas ganadas 
    
    --para todos los jugadores que
--pertenezcan a países que tengan algún jugador que haya ganado algún
--campeonato.

SELECT 
        PAR.NOMBRE JUGADOR,
        PA.NOMBRE PAIS,
        PAR.CAMPEONATOS CAMPEONATOS,
        (
            SELECT COUNT(PT2.GANADOR)
            FROM PARTIDAS PT2
            WHERE PT2.GANADOR = PAR.NUM_ASOCIADO
        ) PARTIDAS_GANADAS
FROM PARTICIPANTES PAR 
INNER JOIN PAISES PA ON PA.NUM_PAIS = PAR.PAIS
WHERE PAR.TIPO = 'JUGADOR'
AND EXISTS (
    SELECT 1 
    FROM PARTICIPANTES PAR2
    WHERE PAR2.PAIS = PA.NUM_PAIS
    AND PAR2.CAMPEONATOS > 0
);

--Ejercicio 4.
--Por cada hotel muestra un informe que nos dé: el nombre del hotel, la media de
--entradas vendidas en las partidas jugadas en salas de ese hotel y el total de
--entradas que se quedaron sin vender.
SELECT 
        H.NOMBRE,
        AVG(PT.ENTRADAS),
        SUM(S.CAPACIDAD - PT.ENTRADAS)
FROM HOTELES H 
LEFT JOIN SALAS S ON S.HOTEL = H.NOMBRE 
LEFT JOIN PARTIDAS PT ON PT.SALA = S.COD_SALA
GROUP BY H.NOMBRE;
--Ejercicio 5.
--Haz una consulta que me de el nombre de los participantes, si son JUGADOR o
--ÁRBITRO y un campo de totales que contará: si es jugador el número de partidas
--ganadas y si es árbitro el número de partidas arbitradas. Sólo para jugadores de
--países que tengan más de 3 participantes

SELECT
        PAR.NUM_ASOCIADO,
        PAR.NOMBRE,
        PAR.TIPO AS TIPO,
        CASE    
            WHEN PAR.TIPO = 'JUGADOR' 
                THEN (
                    SELECT COUNT(C2.PARTIDA)
                    FROM CONTRINCANTES C2 
                    WHERE C2.JUGADOR = PAR.NUM_ASOCIADO
                )
                ELSE (
                    SELECT COUNT(PT2.COD_PARTIDA)
                    FROM PARTIDAS PT2 
                    WHERE PT2.ARBITRO = PAR.NUM_ASOCIADO
                ) END AS PARTIDAS
FROM PARTICIPANTES PAR
WHERE PAR.PAIS IN (
    SELECT PA3.NUM_PAIS 
    FROM PAISES PA3 
    INNER JOIN PARTICIPANTES PAR3 ON PAR3.PAIS = PA3.NUM_PAIS
    GROUP BY PA3.NUM_PAIS
    HAVING COUNT(PAR3.NUM_ASOCIADO) > 3
);


--Ejercicio 6.
--Queremos saber el número de partidas que se han iniciado con el movimiento:
--P3x4Q 
SELECT 
        COUNT(PT.COD_PARTIDA)
FROM PARTIDAS PT 
INNER JOIN MOVIMIENTOS M ON M.PARTIDA = PT.COD_PARTIDA
WHERE M.JUGADA = 'P3x4Q'
AND M.NUM_ORDEN = 1;

--Ejercicio 7.
--Necesitamos un informe que indique
--● Código de partida
--● Nombre del jugador que jugaba con blancas
--● Nombre del jugador que jugaba con negras
--● Árbitro
--● Nombre del ganador (si no lo hay se indicará como ‘TABLAS’)
--● Número de movimientos de la partida

SELECT 
        PT.COD_PARTIDA,
        PB.NOMBRE AS BLANCAS,
        PN.NOMBRE AS NEGRAS,
        A.NOMBRE AS ARBITRO,
        CASE 
            WHEN PT.GANADOR = CB.JUGADOR THEN PB.NOMBRE
            WHEN PT.GANADOR = CN.JUGADOR THEN PN.NOMBRE
            ELSE 'TABLAS'
        END AS GANADOR,
        (
            SELECT COUNT(M2.NUM_ORDEN)
            FROM MOVIMIENTOS M2 
            WHERE M2.PARTIDA = PT.COD_PARTIDA
        ) AS MOVIMIENTOS
FROM PARTIDAS PT 
--BLANCAS
INNER JOIN CONTRINCANTES CB 
    ON CB.PARTIDA = PT.COD_PARTIDA 
        AND CB.COLOR = 'BLANCAS'
INNER JOIN PARTICIPANTES PB
    ON PB.NUM_ASOCIADO = CB.JUGADOR

--NEGRAS
INNER JOIN CONTRINCANTES CN 
    ON CN.PARTIDA = PT.COD_PARTIDA 
        AND CN.COLOR = 'NEGRAS'
INNER JOIN PARTICIPANTES PN
    ON PN.NUM_ASOCIADO = CN.JUGADOR

--ARBITROS
INNER JOIN PARTICIPANTES A 
    ON A.NUM_ASOCIADO = PT.ARBITRO;

--Ejercicio 8.
--Haz un listado de las salas en las que no se hayan vendido 50 entradas contando
--todas las partidas jugadas en esa sala.
SELECT 
        S.COD_SALA
FROM SALAS S 
INNER JOIN PARTIDAS PT ON PT.SALA = S.COD_SALA
GROUP BY S.COD_SALA 
HAVING SUM(PT.ENTRADAS) < 50;
--Ejercicio 9.
--Haz un listado con el código de partida y el ganador de la partida (si no hay se indicará
--como ‘TABLAS’) que más entradas vendió en cada sala.
--Ejercicio 10.
--Haz una consulta que me de por país:
--● nombre del país
--● número de jugadores del país
--● nivel medio de los jugadores (redondeado a 1 decimal)
--● total de partidas jugadas
--Siempre que el jugador de menos nivel del país sea al menos de nivel 3

