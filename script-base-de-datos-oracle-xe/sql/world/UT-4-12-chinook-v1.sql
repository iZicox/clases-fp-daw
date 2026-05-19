--
--1
--
--Automatic Zoom
--EJERCICIOS CHINOOK
--1. Devuelve el total de canciones que no se han vendido ninguna vez.
SELECT * 
FROM TRACK t 
LEFT JOIN INVOICELINE il ON il.TRACKID = t.TRACKID
where il.TRACKID is null; 
--2. Devuelve el total de artistas que no han vendido ninguna canción
SELECT COUNT(distinct a.ARTISTID) 
FROM ARTIST a 
LEFT JOIN ALBUM al ON al.ARTISTID = a.ARTISTID 
LEFT JOIN TRACK t ON t.ALBUMID = al.ALBUMID 
LEFT JOIN INVOICELINE il ON il.TRACKID = t.TRACKID
where il.TRACKID is null;
--3. (difícil) Haz una consulta que saque para todos los artistas: su nombre, el nombre de la
--canción más larga, el álbum al que pertenece la canción más larga, el total de canciones que
--han vendido y el total de veces que han vendido la canción más larga.

with max_track as (
    SELECT a.ARTISTID, max(t.MILLISECONDS) as tiempo
    FROM ARTIST a 
    JOIN ALBUM al ON al.ARTISTID = a.ARTISTID 
    JOIN TRACK t ON t.ALBUMID = al.ALBUMID
    group by a.ARTISTID
)
SELECT distinct 
                a.NAME artista, 
                t.NAME cancion_mas_larga, 
                al.TITLE album,
                (
                    SELECT sum(il2.QUANTITY)
                    FROM INVOICELINE il2
                    JOIN TRACK t2 ON t2.TRACKID = il2.TRACKID 
                    JOIN ALBUM al2 ON al2.ALBUMID = t2.ALBUMID
                    JOIN ARTIST a2 ON a2.ARTISTID = al2.ARTISTID
                    where a2.ARTISTID = a.ARTISTID
                ) as canciones_vendidas,
                (
                    SELECT sum(il2.QUANTITY)
                    FROM INVOICELINE il2
                    JOIN TRACK t2 ON t2.TRACKID = il2.TRACKID 
                    JOIN ALBUM al2 ON al2.ALBUMID = t2.ALBUMID
                    JOIN ARTIST a2 ON a2.ARTISTID = al2.ARTISTID
                    where a2.ARTISTID = a.ARTISTID 
                    and t2.TRACKID = t.TRACKID
                ) as cancion_mas_larga_vendida
FROM ARTIST a 
JOIN ALBUM al ON al.ARTISTID = a.ARTISTID 
JOIN TRACK t ON t.ALBUMID = al.ALBUMID
JOIN INVOICELINE il ON il.TRACKID = t.TRACKID
Join max_track mt ON mt.ARTISTID = a.ARTISTID and mt.tiempo = t.MILLISECONDS 
order by a.NAME;


--4. Devuelve todas las playlist (nombre) y el número de artistas que tiene cada playlist.
SELECT pl.NAME, COUNT(distinct ar.NAME)
FROM ARTIST ar 
JOIN ALBUM al ON al.ARTISTID = ar.ARTISTID 
JOIN TRACK t ON t.ALBUMID = al.ALBUMID 
JOIN PLAYLISTTRACK plt ON plt.TRACKID = t.TRACKID 
JOIN PLAYLIST pl ON pl.PLAYLISTID = plt.PLAYLISTID
group by pl.NAME;
--5. Por cada género, total de canciones que tenemos y total de listas en las que hay canciones
--de ese género.
SELECT g.NAME, COUNT(distinct t.TRACKID), COUNT(distinct pl.PLAYLISTID)
FROM GENRE g 
JOIN TRACK t ON t.GENREID = g.GENREID 
JOIN PLAYLISTTRACK plt ON plt.TRACKID = t.TRACKID 
JOIN PLAYLIST pl ON pl.PLAYLISTID = plt.PLAYLISTID
group by g.NAME;
--6.Queremos ver clientes (nombre, código de cliente y país), y nº de pedidos que han hecho
--estos clientes para todos los clientes que han comprado canciones que pertenezcan a los
--mismos álbumes a los que pertenecen las canciones que han comprado los clientes españoles.

with album_spain as (
    SELECT distinct al.ALBUMID
    FROM ALBUM al 
    JOIN TRACK t ON t.ALBUMID = al.ALBUMID 
    JOIN INVOICELINE il ON il.TRACKID = t.TRACKID 
    JOIN INVOICE i ON i.INVOICEID = il.INVOICEID 
    JOIN CUSTOMER c ON c.CUSTOMERID = i.CUSTOMERID
    where c.Country = 'Spain'
)
SELECT  
        c.FIRSTNAME, 
        c.CUSTOMERID, 
        c.COUNTRY,
        count(i.INVOICEID)
FROM CUSTOMER c 
JOIN INVOICE i ON i.CUSTOMERID = c.CUSTOMERID 
JOIN INVOICELINE il ON il.INVOICEID = i.INVOICEID 
JOIN TRACK t ON t.TRACKID = il.TRACKID 
JOIN ALBUM al ON al.ALBUMID = t.ALBUMID 
JOIN album_spain als ON als.ALBUMID = al.ALBUMID 
group by c.FIRSTNAME, c.CUSTOMERID, c.COUNTRY ;

--7. Haz un listado de artistas, todos sus álbumes, número de canciones que tiene el álbum y en
--cuantas playlist hay canciones de ese álbum.

SELECT  
    substr(ar.NAME,1,5) as artista , 
    substr(al.TITLE,1,8) as album,
    (
        select count(t2.TRACKID)
        from TRACK t2
        where t2.ALBUMID = al.ALBUMID
    ) as canciones_album,
    (
        select count(distinct plt2.PlaylistId)
        from TRACK t2
        join PLAYLISTTRACK plt2 on plt2.TRACKID = t2.TRACKID
        where t2.ALBUMID = al.ALBUMID
    ) as playlist_album
FROM ALBUM al 
JOIN ARTIST ar ON ar.ARTISTID = al.ARTISTID 
group by ar.name, al.title
order by ar.name, al.title;
--MUY DIFICILES
--8. Haz un listado de artistas, su álbum más largo y si ha venido o no alguna canción de ese
--álbum
--1
    with duracion_album as (
        select ar2.ARTISTID, al2.ALBUMID, sum(t2.MILLISECONDS) 
        from ARTIST ar2 
        join album al2 on al2.ARTISTID = ar2.ARTISTID
        join track t2 on t2.ALBUMID = al2.ALBUMID
        group by ar2.ARTISTID, al2.ALBUMID
    )
    SELECT 
            ar.NAME,
            al.TITLE
    FROM ARTIST ar 
    JOIN ALBUM al ON al.ARTISTID = ar.ARTISTID 
    JOIN TRACK t ON t.ALBUMID = al.ALBUMID 
    LEFT JOIN INVOICELINE il ON il.TRACKID = t.TRACKID 
    LEFT JOIN INVOICE i ON i.INVOICEID = il.INVOICEID
    join duracion_album dal on 
            dal.ALBUMID = al.ALBUMID and dal.ARTISTID = ar.ARTISTID
    group by ar.name, al.title order by ar.name;

select ar2.ARTISTID, al2.ALBUMID, sum(t2.MILLISECONDS) 
from ARTIST ar2 
join album al2 on al2.ARTISTID = ar2.ARTISTID
join track t2 on t2.ALBUMID = al2.ALBUMID
group by ar2.ARTISTID, al2.ALBUMID;
--.
--9. Sacar las listas y los álbumes que están completos dentro de una lista (sólo para álbumes de
--más de 10 canciones). Sacar nombre de la lista, nombre del álbum, número de canciones del
--álbum y número de canciones totales que tiene la lista.
--10. Artista, álbum que más ingresos le ha generado e ingresos que le ha generado.
--2