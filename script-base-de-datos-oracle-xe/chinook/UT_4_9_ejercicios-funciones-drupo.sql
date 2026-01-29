--1. Haz una consulta que saque las listas de música que hayan vendido --canciones por más de
--500€.
SELECT t.NAME , SUM(i.UNITPRICE * i.QUANTITY ) total
FROM TRACK t 
INNER JOIN INVOICELINE i 
	ON i.TRACKID = t.TRACKID  
GROUP BY t.NAME, t.TRACKID 
HAVING SUM(i.UNITPRICE * i.QUANTITY ) > 500;

--2. Para los países en los que se han pedido más de 50 canciones distintas, --nombre del país,
--total de canciones distintas que se han pedido y la fecha del último pedido.
SELECT 
		c.COUNTRY pais,
		COUNT(DISTINCT t.NAME) canciones,
		MAX(TO_CHAR(i2.INVOICEDATE,'DD-MM-YYYY') )
FROM TRACK t 
INNER JOIN INVOICELINE i 
	ON t.TRACKID = i.TRACKID
INNER JOIN INVOICE i2 
	ON i.INVOICEID = i2.INVOICEID
INNER JOIN CUSTOMER c 
	ON i2.CUSTOMERID = c.CUSTOMERID
GROUP BY c.COUNTRY 
HAVING COUNT(DISTINCT t.NAME) > 50;
--3. Para todos los artistas con más de 30 canciones queremos ver su nombre, --el número de
--canciones que tenemos y la media de duración de sus canciones (redondeada a --1 decimal)
SELECT 
		ar.NAME artista,
		COUNT (t.NAME ) canciones,
		round(AVG(t.MILLISECONDS )/1000/60,1) duracion
FROM TRACK t 
	INNER JOIN ALBUM a 
		ON t.ALBUMID = a.ALBUMID
	INNER JOIN ARTIST ar 
		ON a.ARTISTID = ar.ARTISTID
GROUP BY ar.NAME 
HAVING COUNT(t.NAME) > 30; 
--4. Cuenta el nº de canciones que tiene la lista de nombre: 'Grunge'
SELECT COUNT (t.NAME )
FROM TRACK t 
INNER JOIN PLAYLISTTRACK pt
	ON pt.TRACKID = t.TRACKID 
INNER JOIN PLAYLIST p 
	ON p.PLAYLISTID = pt.PLAYLISTID 
WHERE upper(p.NAME) LIKE 'GRUNGE';

SELECT COUNT (t.NAME )
FROM TRACK t 
INNER JOIN PLAYLISTTRACK pt
	ON pt.TRACKID = t.TRACKID 
INNER JOIN PLAYLIST p 
	ON p.PLAYLISTID = pt.PLAYLISTID 
GROUP BY p.NAME 
HAVING p.NAME = 'Grunge';
--5. Informe de las listas (nombre) con menos de 30 canciones y el número de --canciones que
--tienen.
SELECT 
		p.NAME lista,
		COUNT (t.TRACKID ) canciones
FROM TRACK t 
INNER JOIN PLAYLISTTRACK pt 
	ON t.TRACKID = pt.TRACKID
INNER JOIN PLAYLIST p 
	ON pt.PLAYLISTID = p.PLAYLISTID
GROUP BY p.NAME 
HAVING COUNT(t.TRACKID) < 30;
--6. Queremos un informe que por país y ciudad me diga el gasto que se ha --hecho en pedidos
--(cantidad x coste unitario) y el número de pedidos que se han hecho. Sólo --para ciudades
--que hayan gastado más de 38€.
--Ordena la consulta por gasto de mayor a menor, luego por país y luego por --ciudad.
SELECT 
		i.BILLINGCOUNTRY pais,
		i.BILLINGCITY ciudad,
		sum(il.QUANTITY * il.UNITPRICE) gastado,
		COUNT(i.INVOICEID) numero_pedidos 
FROM INVOICE i 
INNER JOIN INVOICELINE il
	ON i.INVOICEID = il.INVOICEID
GROUP BY i.BILLINGCOUNTRY , i.BILLINGCITY 
HAVING sum((il.QUANTITY * il.UNITPRICE)) > 38
ORDER BY gastado DESC, pais DESC, ciudad desc;

--7. Saca un informe con la descripción de los géneros y el número de --artistas que tienen
--canciones en cada género
SELECT 
		g.NAME ,
		COUNT (a2.ARTISTID )
FROM TRACK t 
INNER JOIN ALBUM a 
	ON t.ALBUMID = a.ALBUMID
INNER JOIN ARTIST a2 
	ON a.ARTISTID = a2.ARTISTID
INNER JOIN GENRE g 
	ON g.GENREID = t.GENREID 
GROUP BY g.NAME ;
--8. Para el género de Rock dime los artistas que tienen 40 o más canciones. --Ordena la
--consulta por el número de canciones

--9. Saca las listas de música y su duración en minutos.
--10. Saca un listado con los artistas cuyo nombre contenga la secuencia de --letras “AC” (en
--mayúsculas y minúsculas) y aquellos discos de estos artistas cuyo precio --sea superior a
--10€ (suponemos que el precio de un álbum es la suma del precio de todas sus --canciones)
--11. Devuelve el total de clientes que han comprado canciones de AC/DC.
--12. ¿Cual es el artista que más canciones ha vendido?
--13. ¿Y el disco que más dinero ha recaudado?
--14. Cuál es el principio (3 primeras letras) más repetido en el título de --las canciones y cuantas
--veces se repite. ¿Y con 5 letras?
--15. Saca el nombre de las listas de música en las que todas las canciones --son del mismo
--género.
--2
