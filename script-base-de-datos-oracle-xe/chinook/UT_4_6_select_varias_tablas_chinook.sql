/*
 * 
1. Sacar un informe con: título de la canción, título del álbum y nombre del artista para
canciones de género POP.
2. Haz una consulta que saque canciones que empiezan por T, que pertenezcan a los
géneros de blues y pop y que se hayan vendido en Enero o Junio.
3. Nombre y género (descripción) de todas las canciones que valgan menos de 1€
4. Saca los distintos álbumes para los que se han vendido canciones a clientes de Estados
Unidos.
5. Saca los distintos clientes y artistas en los que se cumpla que el cliente ha comprado
alguna canción del artista y el nombre del cliente (firstname) empieza por la misma letra
que el nombre del artista. Ordena la consulta por nombre del cliente y luego por
nombre del artista.
6. Pedidos hechos en la 2ª quincena de cada mes por clientes residentes en Alemania.
7. Lista las distintas listas que contengan alguna canción cuyo género contenga una ‘O’.
8. Haz un listado con el título de cada álbum, el título de cada canción y el nombre de los
artistas. El listado debe ordenarse por nombre del artista, título del álbum y título de la
canción.
9. Haz un listado con las distintas canciones que han comprado clientes que tienen cuenta
de correo en hotmail.
*/
SELECT t.NAME  FROM TRACK t 
INNER JOIN INVOICELINE il
	ON t.TRACKID = il.TRACKID
INNER JOIN INVOICE i 
	ON il.INVOICEID = i.INVOICEID
INNER JOIN CUSTOMER c 
	ON i.CUSTOMERID = c.CUSTOMERID
WHERE UPPER(c.EMAIL) LIKE '%HOTMAIL%';
/*
10. Haz un listado con el nombre del artista y el país donde ha vendido canciones (elimina
duplicados). Ordena el listado por el nombre del artista.
*/
SELECT DISTINCT a.NAME, i2.BILLINGCOUNTRY FROM ARTIST a 
INNER JOIN ALBUM al 
	ON	a.ARTISTID = al.ARTISTID
INNER JOIN TRACK t 
	ON al.ALBUMID = t.ALBUMID 
INNER JOIN INVOICELINE i 
	ON t.TRACKID = i.TRACKID
INNER JOIN INVOICE i2 
	ON i.INVOICEID = i2.INVOICEID
ORDER BY a.NAME;
/*
11. Haz una lista de las canciones que se llaman igual al álbum al que pertenecen.
*/
SELECT t.NAME , a.TITLE  FROM TRACK t 
INNER JOIN ALBUM a 
	ON a.ALBUMID = t.ALBUMID 
WHERE upper(a.TITLE) = upper(t.NAME) ;
/*
12. Haz un listado con el nombre del artista y el título de la canción para las canciones que
haya vendido por más de 1€ (elimina duplicados).
13. Haz una lista de las canciones, eliminando duplicados, dónde la descripción del género
al que pertenece la canción está incluída en el nombre de alguna playlist en la que esté
la canción.
*/