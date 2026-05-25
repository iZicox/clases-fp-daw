--
--1
--
--Automatic Zoom
--EJERCICIOS CHINOOK
--1. Devuelve el total de canciones que no se han vendido ninguna vez.
SELECT count(distinct t.name) 
from track t
WHERE NOT EXISTS (
    SELECT 1
    FROM INVOICELINE il
    WHERE il.TRACKID = t.TRACKID
);

--2. Devuelve el total de artistas que no han vendido ninguna canción

SELECT COUNT(distinct a.ARTISTID)
FROM ARTIST a 
JOIN ALBUM al ON al.ARTISTID = a.ARTISTID 
JOIN TRACK t ON t.ALBUMID = al.ALBUMID
where not EXISTS (
    SELECT 1
    FROM INVOICELINE il 
    WHERE il.TRACKID = t.TRACKID
);

SELECT COUNT(ARTISTID) FROM ARTIST;
--3. (difícil) Haz una consulta que saque para todos los artistas: su nombre, el nombre de la
--canción más larga, el álbum al que pertenece la canción más larga, el total de canciones que
--han vendido y el total de veces que han vendido la canción más larga.
-- cancion mas larga
-- su album
-- total unidades vendidas
-- ventas de la mas larga
with larga as (
SELECT MAX(t.MILLISECONDS) as mas_larga, a.ARTISTID
FROM ARTIST a 
JOIN ALBUM al ON al.ARTISTID = a.ARTISTID 
JOIN TRACK t ON t.ALBUMID = al.ALBUMID
group by a.ARTISTID

)

SELECT  a2.NAME as artista, 
        t2.NAME as cancion,
        (
            select al3.TITLE
            FROM ALBUM al3
            WHERE al3.ALBUMID = t2.ALBUMID
        ) as album,
        (
            select nvl(sum(il4.Quantity),0)
            from INVOICELINE il4
            JOIN TRACK t4 ON t4.TRACKID = il4.TRACKID
            JOIN ALBUM al4 ON al4.ALBUMID = t4.ALBUMID
            JOIN ARTIST a4 ON a4.ARTISTID = al4.ARTISTID
            where a4.ARTISTID = a2.ARTISTID
        ) as ventas_totales,
        (
            select nvl(sum(il5.Quantity),0)
            from INVOICELINE il5
            where il5.TRACKID = t2.TRACKID
        ) as ventas_mas_larga
FROM larga
JOIN ARTIST a2 ON a2.ARTISTID = larga.ARTISTID
JOIN TRACK t2 ON t2.MILLISECONDS = larga.mas_larga
order by ventas_totales desc;

--4. Devuelve todas las playlist (nombre) y el número de artistas que tiene cada playlist.
SELECT pl.NAME, COUNT(distinct al.ArtistId) as artistas
FROM PLAYLIST pl
JOIN PLAYLISTTRACK plt ON plt.PLAYLISTID = pl.PLAYLISTID 
JOIN TRACK t ON t.TRACKID = plt.TRACKID
JOIN ALBUM al ON al.ALBUMID = t.ALBUMID
group by pl.NAME;
--5. Por cada género, total de canciones que tenemos y total de listas en las que hay canciones
--de ese género.
SELECT g.NAME, COUNT(distinct t.TrackId) as caciones, COUNT(distinct plt.PlaylistId) as listas
FROM GENRE g 
left JOIN TRACK t ON t.GENREID = g.GENREID
left JOIN PLAYLISTTRACK plt ON plt.TRACKID = t.TRACKID
group by g.NAME;
--6.Queremos ver clientes (nombre, código de cliente y país), y nº de pedidos que han hecho
--estos clientes para todos los clientes que han comprado canciones que pertenezcan a los
--mismos álbumes a los que pertenecen las canciones que han comprado los clientes españoles.

SELECT c.FIRSTNAME, stat.CUSTOMERID, c.COUNTRY, stat.pedidos
FROM CUSTOMER c 
JOIN (
    SELECT c1.CUSTOMERID, count(distinct i1.INVOICEID) as pedidos
    FROM CUSTOMER c1 
    JOIN INVOICE i1 ON i1.CUSTOMERID = c1.CUSTOMERID
    JOIN INVOICELINE il1 ON il1.INVOICEID = i1.INVOICEID
    JOIN TRACK t1 ON t1.TRACKID = il1.TRACKID
    WHERE EXISTS (
        SELECT distinct t3.ALBUMID
        FROM CUSTOMER c3 
        JOIN INVOICE i3 ON i3.CUSTOMERID = c3.CUSTOMERID
        JOIN INVOICELINE il3 ON il3.INVOICEID = i3.INVOICEID
        JOIN TRACK t3 ON t3.TRACKID = il3.TRACKID
        WHERE c3.COUNTRY = 'Spain' AND t3.ALBUMID = t1.ALBUMID
    )
    group by c1.CUSTOMERID 
) stat ON stat.CUSTOMERID = c.CUSTOMERID
;

--7. Haz un listado de artistas, todos sus álbumes, número de canciones que tiene el álbum y en
--cuantas playlist hay canciones de ese álbum.
SELECT a.NAME, al.TITLE, COUNT(distinct t.TRACKID), COUNT(distinct plt.PLAYLISTID)
FROM ARTIST a 
JOIN ALBUM al ON al.ARTISTID = a.ARTISTID
JOIN TRACK t ON t.ALBUMID = al.ALBUMID
JOIN PLAYLISTTRACK plt ON t.TRACKID = plt.TRACKID
group by a.NAME, al.TITLE;
--MUY DIFICILES
--8. Haz un listado de artistas, su álbum más largo y si ha venido o no alguna canción de ese
--álbum
--1
SELECT al.ARTISTID, al.ALBUMID, SUM(t.MILLISECONDS)
FROM ALBUM al 
JOIN TRACK t ON t.ALBUMID = al.ALBUMID
group by al.ARTISTID, al.ALBUMID order by al.ARTISTID, al.ALBUMID;

SELECT *
FROM ALBUM al2 
JOIN TRACK t2 ON t2.ALBUMID = al2.ALBUMID
group by al2.ALBUMID
having sum(t2.MILLISECONDS) = (
    
);
--.
--9. Sacar las listas y los álbumes que están completos dentro de una lista (sólo para álbumes de
--más de 10 canciones). Sacar nombre de la lista, nombre del álbum, número de canciones del
--álbum y número de canciones totales que tiene la lista.
--10. Artista, álbum que más ingresos le ha generado e ingresos que le ha generado.
--2