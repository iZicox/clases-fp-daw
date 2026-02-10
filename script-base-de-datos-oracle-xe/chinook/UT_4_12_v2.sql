/*
1

Automatic Zoom
EJERCICIOS CHINOOK
1. Devuelve el total de canciones que no se han vendido ninguna vez.
*/
SELECT COUNT(*)
FROM TRACK T 
LEFT JOIN InvoiceLine IL ON IL.TrackId = T.TrackId
WHERE IL.TRACKID IS NULL;
/*
2. Devuelve el total de artistas que no han vendido ninguna canción
*/
-- REVISAR
SELECT COUNT(DISTINCT AR.ArtistId)
FROM ARTIST AR 
INNER JOIN ALBUM AL ON AL.ARTISTID = AR.ARTISTID 
INNER JOIN TRACK T ON AL.ALBUMID = T.ALBUMID 
INNER JOIN INVOICELINE IL ON IL.TRACKID = T.TRACKID
LEFT JOIN INVOICE I ON I.INVOICEID = IL.INVOICEID
WHERE I.INVOICEID IS NULL;
/*
3. (difícil) Haz una consulta que saque para todos los artistas: su nombre, el nombre de la
canción más larga, el álbum al que pertenece la canción más larga, el total de canciones que
han vendido y el total de veces que han vendido la canción más larga.
*/
SELECT DISTINCT 
        AR.NAME,
        (
            SELECT T3.NAME 
            FROM ARTIST AR3 
            INNER JOIN ALBUM AL3 ON AL3.ARTISTID = AR3.ARTISTID 
            INNER JOIN TRACK T3 ON T3.ALBUMID = AL3.ALBUMID
            WHERE AR3.ARTISTID = AR.ARTISTID
            AND T3.MILLISECONDS = 
            (
                SELECT MAX(MILLISECONDS)
                FROM ARTIST AR2 
                INNER JOIN ALBUM AL2 ON AL2.ARTISTID = AR2.ARTISTID 
                INNER JOIN TRACK T2 ON T2.ALBUMID = AL2.ALBUMID
                WHERE AR2.ARTISTID = AR.ARTISTID
            )
        )
         AS CANCION_LARGA,
        AL.TITLE AS ALBUM,
        (
            SELECT SUM(IL.QUANTITY)
            FROM ARTIST AR3 
            INNER JOIN ALBUM AL3 ON AL3.ARTISTID = AR3.ARTISTID 
            INNER JOIN TRACK T3 ON T3.ALBUMID = AL3.ALBUMID
            INNER JOIN INVOICELINE IL3 ON IL3.TRACKID = T3.TRACKID
            WHERE AR3.ARTISTID = AR.ARTISTID
            GROUP BY AR3.NAME
        )
         AS TOTAL_VENDIDO,
        '' AS TOTAL_VENTA_CANCION_MAS_LARGA
FROM ARTIST AR 
INNER JOIN ALBUM AL ON AL.ARTISTID = AR.ARTISTID 
INNER JOIN TRACK T ON T.ALBUMID = AL.ALBUMID
INNER JOIN INVOICELINE IL ON IL.TRACKID = T.TRACKID
ORDER BY AR.NAME
;

SELECT * 
FROM TRACK T
INNER JOIN ALBUM AL ON T.ALBUMID = AL.ALBUMID
INNER JOIN ARTIST AR ON AR.ARTISTID = AL.ARTISTID
WHERE AR.NAME = 'AC/DC'
ORDER BY T.MILLISECONDS DESC;
/*
4. Devuelve todas las playlist (nombre) y el número de artistas que tiene cada playlist.
*/
SELECT 
        PL.NAME,
        COUNT(AR.ARTISTID)
FROM PLAYLIST PL 
INNER JOIN PLAYLISTTRACK PLT ON PLT.PLAYLISTID = PL.PLAYLISTID
INNER JOIN TRACK T ON T.TRACKID = PLT.TRACKID
INNER JOIN ALBUM AL ON T.ALBUMID = AL.ALBUMID
INNER JOIN ARTIST AR ON AR.ARTISTID = AL.ARTISTID
GROUP BY PL.NAME;
/*
5. Por cada género, total de canciones que tenemos y total de listas en las que hay canciones
de ese género.
*/
SELECT 
        G.NAME,
        COUNT(DISTINCT T.TRACKID),
        (
            SELECT COUNT(DISTINCT PL2.PLAYLISTID)
            FROM PLAYLIST PL2
            INNER JOIN PLAYLISTTRACK PLT2 
                    ON PLT2.PLAYLISTID = PL2.PLAYLISTID
            INNER JOIN TRACK T2 ON T2.TRACKID = PLT2.TRACKID
            INNER JOIN GENRE G2 ON T2.GENREID = G2.GENREID
            WHERE G2.GENREID = G.GENREID
        )
        FROM PLAYLIST PL
        INNER JOIN PLAYLISTTRACK PLT ON PLT.PLAYLISTID = PL.PLAYLISTID
        INNER JOIN TRACK T ON T.TRACKID = PLT.TRACKID
        INNER JOIN GENRE G ON T.GENREID = G.GENREID
        GROUP BY G.GENREID, G.NAME;

        

/*
6.Queremos ver clientes (nombre, código de cliente y país), y nº de pedidos que han hecho
estos clientes para todos los clientes que han comprado canciones que pertenezcan a los
mismos álbumes a los que pertenecen las canciones que han comprado los clientes españoles.
*/
--REVISAR
SELECT * FROM INVOICE ORDER BY CUSTOMERID;
SELECT 
    C.FIRSTNAME AS NOMBRE,
    C.CUSTOMERID AS CODIGO_CLIENTE,
    C.COUNTRY AS PAIS,
    COUNT(I.INVOICEID) AS NUM_PEDIDOS
FROM CUSTOMER C
LEFT JOIN INVOICE I ON I.CUSTOMERID = C.CUSTOMERID
GROUP BY 
    C.CUSTOMERID,
    C.FIRSTNAME,
    C.COUNTRY
ORDER BY C.CUSTOMERID;

SELECT 
        C.FIRSTNAME,
        C.CUSTOMERID,
        C.COUNTRY,
        COUNT(I.INVOICEID)
FROM CUSTOMER C 
LEFT JOIN INVOICE I ON I.CUSTOMERID = C.CUSTOMERID

GROUP BY C.CUSTOMERID, C.FIRSTNAME, C.COUNTRY;

SELECT 
        C.FIRSTNAME,
        C.CUSTOMERID,
        C.COUNTRY,
        (
            SELECT COUNT(I2.INVOICEID)
            FROM INVOICE I2 
            WHERE I2.CUSTOMERID = C.CUSTOMERID
        ) AS PEDIDOS
FROM CUSTOMER C 
LEFT JOIN INVOICE I ON I.CUSTOMERID = C.CUSTOMERID
GROUP BY C.CUSTOMERID, C.FIRSTNAME, C.COUNTRY;

/*
7. Haz un listado de artistas, todos sus álbumes, número de canciones que tiene el álbum y en
cuantas playlist hay canciones de ese álbum.
*/

SELECT 
        AR.NAME ARTISTA,
        AL.TITLE ALBUM,
        (
            SELECT COUNT(T2.TRACKID)
            FROM TRACK T2
            WHERE T2.ALBUMID = AL.ALBUMID
        ) CANCIONES_ALBUM,
        (
            SELECT COUNT(DISTINCT PLT3.PLAYLISTID)
            FROM PLAYLISTTRACK PLT3
            INNER JOIN TRACK T3 ON T3.TRACKID = PLT3.TRACKID
            INNER JOIN ALBUM AL3 ON T3.ALBUMID = AL3.ALBUMID
            INNER JOIN ARTIST AR3 ON AR3.ARTISTID = AL3.ARTISTID
            WHERE T3.ALBUMID = AL.ALBUMID
        )
FROM ARTIST AR 
INNER JOIN ALBUM AL ON AL.ARTISTID = AR.ARTISTID
INNER JOIN TRACK T ON T.ALBUMID = AL.ALBUMID 
INNER JOIN PLAYLISTTRACK PLT ON T.TRACKID = PLT.TRACKID ;
/*
MUY DIFICILES
8. Haz un listado de artistas, su álbum más largo y si ha venido o no alguna canción de ese
álbum
1
*/
SELECT
    ar.name AS artista,
    al.title AS album_mas_largo,
    stats.total_ms AS duracion_total_ms,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM track t2
            JOIN invoiceline il2 ON il2.trackid = t2.trackid
            WHERE t2.albumid = al.albumid
        ) THEN 'SI'
        ELSE 'NO'
    END AS tiene_cancion_vendida
FROM artist ar
JOIN album al
    ON al.artistid = ar.artistid
JOIN (
    -- Duración total por álbum
    SELECT
        al2.albumid,
        SUM(t.milliseconds) AS total_ms
    FROM album al2
    JOIN track t ON t.albumid = al2.albumid
    GROUP BY al2.albumid
) stats
    ON stats.albumid = al.albumid
WHERE stats.total_ms = (
    -- Subconsulta correlacionada: máximo por artista
    SELECT MAX(SUM(t3.milliseconds))
    FROM album al3
    JOIN track t3 ON t3.albumid = al3.albumid
    WHERE al3.artistid = ar.artistid
    GROUP BY al3.albumid
)
ORDER BY ar.name;
/*
9. Sacar las listas y los álbumes que están completos dentro de una lista (sólo para álbumes de
más de 10 canciones). Sacar nombre de la lista, nombre del álbum, número de canciones del
álbum y número de canciones totales que tiene la lista.
*/

/*
10. Artista, álbum que más ingresos le ha generado e ingresos que le ha generado.
2
*/
SELECT 
        AR.NAME,
        AL.TITLE
FROM ARTIST AR 
INNER JOIN ALBUM AL ON AR.ARTISTID = AL.ARTISTID 
INNER JOIN TRACK T ON AL.ALBUMID = T.ALBUMID 
INNER JOIN INVOICELINE IL ON T.TRACKID = IL.TRACKID
INNER JOIN (
    SELECT 
            AL2.ALBUMID AS COD,
            SUM(IL2.UNITPRICE)
    WHERE ALBUM AL2  
    INNER JOIN TRACK T2 ON AL2.ALBUMID = T2.ALBUMID 
    INNER JOIN INVOICELINE IL2 ON T2.TRACKID = IL2.TRACKID
)
 ;