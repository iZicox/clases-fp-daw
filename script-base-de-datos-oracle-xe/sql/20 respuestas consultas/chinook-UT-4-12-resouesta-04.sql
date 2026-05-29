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
<<<<<<< Updated upstream
SELECT ar.Name AS Artista,
       al.Title AS Album_Mas_Largo,
       CASE 
           WHEN COUNT(t.TrackId) > 0 THEN 'Sí'
           ELSE 'No'
       END AS Tiene_Canciones
FROM Artist ar
JOIN Album al 
    ON ar.ArtistId = al.ArtistId
JOIN (
    SELECT AlbumId,
           SUM(Milliseconds) AS DuracionTotal
    FROM Track
    GROUP BY AlbumId
) dur 
    ON al.AlbumId = dur.AlbumId
LEFT JOIN Track t
    ON al.AlbumId = t.AlbumId
WHERE dur.DuracionTotal = (
    SELECT MAX(SUM(t2.Milliseconds))
    FROM Album a2
    JOIN Track t2 
        ON a2.AlbumId = t2.AlbumId
    WHERE a2.ArtistId = ar.ArtistId
    GROUP BY a2.AlbumId
)
GROUP BY ar.Name, al.Title
ORDER BY ar.Name;
=======
SELECT 
    art.Name AS Artista,
    album_largo.Title AS Album_Mas_Largo,
    CASE 
        WHEN EXISTS (
            -- Subconsulta para verificar si hay ventas de este álbum específico
            SELECT 1 
            FROM InvoiceLine il 
            JOIN Track t ON il.TrackId = t.TrackId 
            WHERE t.AlbumId = album_largo.AlbumId
        ) THEN 'SÍ' 
        ELSE 'NO' 
    END AS Ha_Vendido
FROM Artist art
LEFT JOIN (
    -- Subconsulta que calcula la duración total de cada álbum
    SELECT a.ArtistId, a.AlbumId, a.Title, SUM(t.Milliseconds) AS Duracion_Total
    FROM Album a
    JOIN Track t ON a.AlbumId = t.AlbumId
    GROUP BY a.ArtistId, a.AlbumId, a.Title
) album_largo ON art.ArtistId = album_largo.ArtistId
WHERE (album_largo.ArtistId, album_largo.Duracion_Total) IN (
    -- Identificamos la duración máxima por cada artista
    SELECT a2.ArtistId, MAX(Duracion_Album)
    FROM (
        SELECT alb.ArtistId, alb.AlbumId, SUM(tr.Milliseconds) AS Duracion_Album
        FROM Album alb
        JOIN Track tr ON alb.AlbumId = tr.AlbumId
        GROUP BY alb.ArtistId, alb.AlbumId
    ) a2
    GROUP BY a2.ArtistId
) OR album_largo.AlbumId IS NULL
ORDER BY art.Name;
>>>>>>> Stashed changes
--.
--9. Sacar las listas y los álbumes que están completos dentro de una lista (sólo para álbumes de
--más de 10 canciones). Sacar nombre de la lista, nombre del álbum, número de canciones del
--álbum y número de canciones totales que tiene la lista.
<<<<<<< Updated upstream

--10. Artista, álbum que más ingresos le ha generado e ingresos que le ha generado.
--2
with facturacion as (
    SELECT t.AlbumId, sum(il.UNITPRICE * il.QUANTITY) as facturacion
    FROM TRACK t 
    JOIN INVOICELINE il ON il.TRACKID = t.TRACKID
    group by t.ALBUMID

)
SELECT ar.name
FROM facturacion f
join album al ON al.ALBUMID = f.AlbumId
join artist ar on ar.ARTISTID = al.ARTISTID
join TRACK t2 on t2.albumid = f.albumid
JOIN INVOICELINE il2 ON il2.TRACKID = t2.TRACKID
group by ar.name
order by ar.NAME, al.ALBUMID
having sum(il2.UNITPRICE * il2.QUANTITY) = 100;
=======
SELECT 
    p.Name AS Nombre_Lista, 
    a.Title AS Nombre_Album, 
    stats_album.total_album AS Canciones_Album,
    stats_lista.total_lista AS Total_Canciones_Lista
FROM Playlist p
JOIN (
    -- 1. Calculamos el total de canciones que tiene cada lista de reproducción
    SELECT PlaylistId, COUNT(TrackId) AS total_lista
    FROM PlaylistTrack
    GROUP BY PlaylistId
) stats_lista ON p.PlaylistId = stats_lista.PlaylistId
JOIN (
    -- 2. Contamos cuántas canciones de cada álbum hay en cada lista
    SELECT pt.PlaylistId, t.AlbumId, COUNT(t.TrackId) AS canciones_presentes
    FROM PlaylistTrack pt
    JOIN Track t ON pt.TrackId = t.TrackId
    GROUP BY pt.PlaylistId, t.AlbumId
) cruce ON p.PlaylistId = cruce.PlaylistId
JOIN Album a ON cruce.AlbumId = a.AlbumId
JOIN (
    -- 3. Obtenemos el total de canciones por álbum, filtrando los de más de 10
    SELECT AlbumId, COUNT(TrackId) AS total_album
    FROM Track
    GROUP BY AlbumId
    HAVING COUNT(TrackId) > 10
) stats_album ON a.AlbumId = stats_album.AlbumId
-- 4. Filtro de "Álbum Completo": lo que hay en la lista debe ser igual al total del álbum
WHERE cruce.canciones_presentes = stats_album.total_album;
--10. Artista, álbum que más ingresos le ha generado e ingresos que le ha generado.
--2

SELECT a.NAME, album.title, ventas.total
FROM ARTIST a 
JOIN (
    SELECT al2.ARTISTID, al2.ALBUMID, SUM(il2.Quantity * il2.UNITPRICE) as total
    FROM TRACK t2 
    JOIN INVOICELINE il2 ON il2.TRACKID = t2.TRACKID
    JOIN ALBUM al2 ON al2.ALBUMID = t2.ALBUMID
    GROUP BY al2.ARTISTID, al2.ALBUMID
) ventas ON ventas.ARTISTID = a.ARTISTID
JOIN ALBUM ON ALBUM.ALBUMID = ventas.ALBUMID
JOIN (

    Select a4.ARTISTID, MAX(a4.total) as total
    FROM (
        SELECT al3.ARTISTID, al3.ALBUMID, SUM(il3.Quantity * il3.UNITPRICE) as total
        FROM TRACK t3 
        JOIN INVOICELINE il3 ON il3.TRACKID = t3.TRACKID
        JOIN ALBUM al3 ON al3.ALBUMID = t3.ALBUMID
        GROUP BY al3.ARTISTID, al3.ALBUMID
    ) a4 
    GROUP BY a4.ARTISTID

) stat on stat.ARTISTID = a.ARTISTID and stat.total = ventas.total
order by name;


select count(*) from artist;

>>>>>>> Stashed changes
