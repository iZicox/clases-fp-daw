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
4. Devuelve todas las playlist (nombre) y el número de artistas que tiene cada playlist.
5. Por cada género, total de canciones que tenemos y total de listas en las que hay canciones
de ese género.
6.Queremos ver clientes (nombre, código de cliente y país), y nº de pedidos que han hecho
estos clientes para todos los clientes que han comprado canciones que pertenezcan a los
mismos álbumes a los que pertenecen las canciones que han comprado los clientes españoles.
7. Haz un listado de artistas, todos sus álbumes, número de canciones que tiene el álbum y en
cuantas playlist hay canciones de ese álbum.
MUY DIFICILES
8. Haz un listado de artistas, su álbum más largo y si ha venido o no alguna canción de ese
álbum
1
.
9. Sacar las listas y los álbumes que están completos dentro de una lista (sólo para álbumes de
más de 10 canciones). Sacar nombre de la lista, nombre del álbum, número de canciones del
álbum y número de canciones totales que tiene la lista.
10. Artista, álbum que más ingresos le ha generado e ingresos que le ha generado.
2
*/