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

select  P.NOMBRE NOMBRE, 
        P.CAMPEONATOS CAMPEONATOS, 
        PA.NOMBRE PAIS
from participantes P
INNER JOIN PAISES PA 
    ON P.PAIS = PA.NUM_PAIS
where UPPER(P.tipo) = 'JUGADOR' 
ORDER BY P.CAMPEONATOS DESC, P.NOMBRE ASC;

--Ejercicio 2.
--Sacar un informe con el nombre del participante, fecha de entrada y fecha de
--salida, nombre del hotel y dirección para hoteles cuya dirección sea una calle (ni
--plaza ni paseo) y para alojamientos que empezasen el 22 o el 23 de abril del 2007
--y acabasen el 25 o el 26 de abril del 2007.
SELECT  P.NOMBRE AS NOMBRE,
        AL.FECHAIN AS ENTRADA,
        AL.FECHAOUT AS SALIDA,
        H.NOMBRE AS HOTEL,
        H.DIRECCION AS DIRECCION
FROM PARTICIPANTES P
INNER JOIN ALOJAMIENTOS AL
    ON P.NUM_ASOCIADO = AL.PARTICIPANTE
INNER JOIN HOTELES H
    ON AL.HOTEL = H.NOMBRE
WHERE UPPER(H.DIRECCION) LIKE 'C%'
AND (TO_CHAR(AL.FECHAIN,'DD-MM-YYYY') = '22-04-2007'
        OR TO_CHAR(AL.FECHAIN,'DD-MM-YYYY') = '23-04-2007')
AND (TO_CHAR(AL.FECHAOUT,'DD-MM-YYYY') = '25-04-2007' 
        OR TO_CHAR(AL.FECHAOUT,'DD-MM-YYYY') = '26-04-2007');

--Ejercicio 3.
--Queremos un informe con el nombre del jugador, nombre del país, número de
--campeonatos ganados y número de partidas ganadas para todos los jugadores que
--pertenezcan a países que tengan algún jugador que haya ganado algún
--campeonato.
SELECT
    P.NOMBRE AS NOMBRE,
    PA.NOMBRE AS PAIS,
    P.CAMPEONATOS AS CAMPEONATOS,
    COUNT(PT.COD_PARTIDA) AS PARTIDAS_GANADAS
FROM PARTICIPANTES P
JOIN PAISES PA ON PA.NUM_PAIS = P.PAIS
LEFT JOIN PARTIDAS PT ON PT.GANADOR = P.NUM_ASOCIADO
WHERE UPPER(P.TIPO) = 'JUGADOR'
  AND PA.NUM_PAIS IN (
      SELECT P2.PAIS
      FROM PARTICIPANTES P2
      WHERE UPPER(P2.TIPO) = 'JUGADOR'
      GROUP BY P2.PAIS
      HAVING SUM(P2.CAMPEONATOS) > 0
  )
GROUP BY P.NOMBRE, PA.NOMBRE, P.CAMPEONATOS;

--
SELECT 
        P.NOMBRE AS NOMBRE,
        PA.NOMBRE AS PAIS,
        P.CAMPEONATOS AS CAMPEONATOS,
        COUNT(PT.COD_PARTIDA) AS PARTIDAS_GANADAS
FROM PARTICIPANTES P
INNER JOIN PAISES PA
    ON P.PAIS = PA.NUM_PAIS
LEFT JOIN PARTIDAS PT 
    ON PT.GANADOR = P.NUM_ASOCIADO
WHERE UPPER(P.tipo) = 'JUGADOR'
AND PA.NOMBRE IN (
    SELECT PA.NOMBRE
    FROM PARTICIPANTES P
    INNER JOIN PAISES PA
        ON P.PAIS = PA.NUM_PAIS
    WHERE UPPER(P.tipo) = 'JUGADOR'
    GROUP BY PA.NUM_PAIS, PA.NOMBRE
    HAVING SUM(P.CAMPEONATOS) > 0
)
GROUP BY 
    P.NOMBRE,
    PA.NOMBRE,
    P.CAMPEONATOS;

--LOS PAISES QUE TIENEN GANADORES DE CAMPEONATO
SELECT PA.NOMBRE
FROM PARTICIPANTES P
INNER JOIN PAISES PA
    ON P.PAIS = PA.NUM_PAIS
GROUP BY PA.NUM_PAIS, PA.NOMBRE
HAVING SUM(P.CAMPEONATOS) > 0;

SELECT 
        P.NOMBRE,
        PA.NOMBRE,
        P.CAMPEONATOS
        
FROM PARTICIPANTES P
INNER JOIN PAISES PA
    ON P.PAIS = PA.NUM_PAIS
WHERE EXISTS (
    SELECT 1
    FROM PARTICIPANTES P2
    WHERE P2.PAIS = PA.NUM_PAIS
      AND P2.CAMPEONATOS > 0
);

--Ejercicio 4.
--Por cada hotel muestra un informe que nos dé: el nombre del hotel, la media de
--entradas vendidas en las partidas jugadas en salas de ese hotel y el total de
--entradas que se quedaron sin vender.
SELECT 
        H.NOMBRE,
        AVG(PA.ENTRADAS),
        SUM(S.CAPACIDAD) - SUM(PA.ENTRADAS)
FROM HOTELES H 
INNER JOIN SALAS S 
    ON S.HOTEL = H.NOMBRE
LEFT JOIN PARTIDAS PA 
    ON PA.SALA = S.COD_SALA
GROUP BY H.NOMBRE;
--Ejercicio 5.
--Haz una consulta que me de el nombre de los participantes, si son JUGADOR o
--ÁRBITRO y un campo de totales que contará: si es jugador el número de partidas
--ganadas y si es árbitro el número de partidas arbitradas. Sólo para jugadores de
--países que tengan más de 3 participantes
SELECT 
        PA.NOMBRE PARTICIPANTE,
        PA.TIPO,
        CASE    
            WHEN PA.TIPO = 'JUGADOR' 
                THEN (
                    SELECT COUNT(DISTINCT PT1.COD_PARTIDA)
                    FROM PARTIDAS PT1
                    WHERE PT1.GANADOR = PA.NUM_ASOCIADO
                )
                ELSE (
                    SELECT COUNT(DISTINCT PT2.COD_PARTIDA)
                    FROM PARTIDAS PT2 
                    WHERE PT2.ARBITRO = PA.NUM_ASOCIADO
                )
            END AS CONTADOR
            FROM PARTICIPANTES PA 
            WHERE PA.PAIS IN (
                SELECT DISTINCT(PAIS)
                FROM PARTICIPANTES 
                GROUP BY PAIS 
                HAVING COUNT(*) > 3
            );

--Ejercicio 6.
--Queremos saber el número de partidas que se han iniciado con el movimiento:
--P3x4Q 
SELECT COUNT(*)
FROM MOVIMIENTOS 
WHERE NUM_ORDEN = 1 
AND JUGADA = 'P3x4Q';
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
        PA_B.NOMBRE BLANCAS,
        PA_N.NOMBRE NEGRAS,
        PA_A.NOMBRE ARBITRO,
        COALESCE(PA_G.NOMBRE, 'TABLAS') GANADOR,
        COUNT(MV.NUM_ORDEN) MOVIMIENTOS 
FROM PARTIDAS PT
LEFT JOIN PARTICIPANTES PA_A 
    ON PT.ARBITRO = PA_A.NUM_ASOCIADO
LEFT JOIN PARTICIPANTES PA_G 
    ON PT.GANADOR = PA_G.NUM_ASOCIADO
INNER JOIN CONTRINCANTES CO_B
    ON CO_B.PARTIDA = PT.COD_PARTIDA 
INNER JOIN CONTRINCANTES CO_N 
    ON CO_N.PARTIDA = PT.COD_PARTIDA 
INNER JOIN PARTICIPANTES PA_B 
    ON PA_B.NUM_ASOCIADO = CO_B.JUGADOR 
INNER JOIN PARTICIPANTES PA_N 
    ON PA_N.NUM_ASOCIADO = CO_N.JUGADOR 
LEFT JOIN MOVIMIENTOS MV 
    ON MV.PARTIDA = PT.COD_PARTIDA
WHERE CO_B.COLOR = 'BLANCAS'
    AND CO_N.COLOR = 'NEGRAS'
GROUP BY 
        PT.COD_PARTIDA,
        PA_B.NOMBRE,
        PA_N.NOMBRE,
        PA_A.NOMBRE,
        COALESCE(PA_G.NOMBRE, 'TABLAS')
ORDER BY PT.COD_PARTIDA;
--Ejercicio 8.
--Haz un listado de las salas en las que no se hayan vendido 50 entradas contando
--todas las partidas jugadas en esa sala.
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