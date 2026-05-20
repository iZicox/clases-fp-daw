--1. Devuelve el total de canciones que no se han vendido ninguna vez.
SELECT 
        COUNT(*)
FROM TRACK T
LEFT JOIN INVOICELINE IL
    ON T.TRACKID = IL.TRACKID
WHERE IL.TRACKID IS NULL;
--2. Devuelve el total de artistas que no han vendido ninguna canción
SELECT 
        COUNT(AR.ARTISTID)
FROM TRACK T
INNER JOIN ALBUM AL 
    ON AL.ALBUMID = T.ALBUMID
INNER JOIN ARTIST AR 
    ON AR.ARTISTID = AL.ARTISTID
LEFT JOIN INVOICELINE IL 
    ON IL.TRACKID = T.TRACKID
WHERE IL.TRACKID IS NULL;
--3. (difícil) Haz una consulta que saque para todos los artistas: su nombre, el nombre de la
--canción más larga, el álbum al que pertenece la canción más larga, el total de canciones que
--han vendido y el total de veces que han vendido la canción más larga.
SELECT 
            TCL.NAME,
            ARCL.ARTISTID
    FROM TRACK TCL
    INNER JOIN ALBUM ALCL
        ON TCL.ALBUMID = ALCL.ALBUMID
    INNER JOIN ARTIST ARCL 
        ON ARCL.ARTISTID = ALCL.ARTISTID
    WHERE TCL.MILLISECONDS = (SELECT MAX(MILLISECONDS)
                                FROM TRACK
                                INNER JOIN 
                                WHERE )
    GROUP BY ARCL.ARTISTID;

WITH CANCION_LARGA AS (
    SELECT 
            MAX(TCL.MILLISECONDS)
    FROM TRACK TCL
    INNER JOIN ALBUM ALCL
        ON TCL.ALBUMID = ALCL.ALBUMID
    INNER JOIN ARTIST ARCL 
        ON ARCL.ARTISTID = ALCL.ARTISTID
)
SELECT 
        AR.NAME
FROM ARTIST AR;
--4. Devuelve todas las playlist (nombre) y el número de artistas que tiene cada playlist.
SELECT
        PL.NAME,
        COUNT(AR.NAME)
FROM PLAYLIST PL 
INNER JOIN PLAYLISTTRACK PLT
    ON PL.PLAYLISTID = PLT.PLAYLISTID
INNER JOIN TRACK T 
    ON T.TRACKID = PLT.TRACKID 
INNER JOIN ALBUM AL 
    ON AL.ALBUMID = T.ALBUMID 
INNER JOIN ARTIST AR 
    ON AR.ARTISTID = AL.ARTISTID
GROUP BY PL.NAME;
--5. Por cada género, total de canciones que tenemos y total de listas en las que hay canciones
--de ese género.
SELECT 
        G.NAME,
        COUNT(T.TRACKID),
        COUNT(DISTINCT PL.PLAYLISTID)
FROM GENRE G 
INNER JOIN TRACK T 
    ON T.GENREID = G.GENREID 
INNER JOIN PLAYLISTTRACK PLT 
    ON PLT.TRACKID = T.TRACKID 
INNER JOIN PLAYLIST PL 
    ON PL.PLAYLISTID = PLT.PLAYLISTID
GROUP BY G.NAME;
--6.Queremos ver clientes (nombre, código de cliente y país), y nº de pedidos que han hecho
--estos clientes para todos los clientes que han comprado canciones que pertenezcan a los
--mismos álbumes a los que pertenecen las canciones que han comprado los clientes españoles.
SELECT 
        AL.ALBUMID
FROM CUSTOMER C2 
INNER JOIN INVOICE I2 
    ON I2.CUSTOMERID = C2.CUSTOMERID
INNER JOIN INVOICELINE IL2 
    ON IL2.INVOICELINEID = I2.INVOICEID
INNER JOIN TRACK T2 
    ON T2.TRACKID = IL2.TRACKID 
INNER JOIN ALBUM AL2 
    ON AL2.ALBUMID = T2.ALBUMID
WHERE UPPER(C2.COUNTRY) = 'SPAIN';

    ------------------------------
SELECT 
        C.FIRSTNAME || ' ' || C.LASTNAME,
        C.CUSTOMERID,
        C.COUNTRY,
        COUNT(DISTINCT I.INVOICEID)
FROM CUSTOMER C 
INNER JOIN INVOICE I 
    ON I.CUSTOMERID = C.CUSTOMERID
INNER JOIN INVOICELINE IL 
    ON IL.INVOICEID = I.INVOICEID
INNER JOIN TRACK T 
    ON T.TRACKID = IL.TRACKID 
INNER JOIN ALBUM AL 
    ON AL.ALBUMID = T.ALBUMID
WHERE AL.ALBUMID IN (
    SELECT 
        AL.ALBUMID
    FROM CUSTOMER C2 
    INNER JOIN INVOICE I2 
        ON I2.CUSTOMERID = C2.CUSTOMERID
    INNER JOIN INVOICELINE IL2
        ON IL2.INVOICEID = I2.INVOICEID
    INNER JOIN TRACK T2
        ON T2.TRACKID = IL2.TRACKID 
    INNER JOIN ALBUM AL2
        ON AL2.ALBUMID = T2.ALBUMID
    WHERE UPPER(C2.COUNTRY) = 'SPAIN'
) AND UPPER(C.COUNTRY) != 'SPAIN'
GROUP BY 
    C.FirstName, C.LastName, C.CustomerId, C.Country
ORDER BY C.COUNTRY;
--7. Haz un listado de artistas, todos sus álbumes, número de canciones que tiene el álbum y en
--cuantas playlist hay canciones de ese álbum.
--MUY DIFICILES
--8. Haz un listado de artistas, su álbum más largo y si ha venido o no alguna canción de ese
--álbum
--1
--