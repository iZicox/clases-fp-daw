/*
Ejercicios CHINOOK
Utiliza el usuario CHINOOK
1. Selecciona las canciones (track) cuyo título (name) empieza por la misma letra que el nombre
de su compositor (composer)
*/
SELECT * FROM TRACK t WHERE SUBSTR(NAME ,1,1) = SUBSTR(COMPOSER ,1,1);

/*
2.Haz un listado de canciones. El listado tendrá una columna código y el título (nombre). El
código es un campo que vamos a generar nosotros y serán las 3 últimas posiciones de la
duración de la canción y las 4 primeras del título en mayúsculas.
*/
SELECT SUBSTR(t.MILLISECONDS ,-3) || SUBSTR(t.NAME ,1,3) AS codigo ,name FROM TRACK t ;

--3. Selecciona las playlist cuyo nombre contenga Music.
SELECT * FROM PLAYLIST p WHERE p.NAME LIKE '%Music%';

--4. Selecciona las canciones de géneros Pop, Rock y Metal, cuya duración sea superior a
--300000 milisegundos y cuyo compositor empiece por la letra A o V.
SELECT * FROM TRACK t 
	INNER JOIN GENRE g 
	ON t.GENREID = g.GENREID  
WHERE lower(g.NAME) IN ('pop','rock','metal')
AND t.MILLISECONDS > 300000
AND SUBSTR(loweR(t.COMPOSER),1,1) = 'a' OR SUBSTR(loweR(t.COMPOSER),1,1) = 'v';

/*
5. Selecciona los clientes que sean una compañía (el campo compañía es no nulo). De cada
cliente veremos el nombre, el correo y generamos un campo password que serán los 4
primeros caracteres del apellido, en mayúsculas, los 3 primeros del código postal y los 3
primeros de la ciudad (en mayúsculas)
*/
SELECT c.FIRSTNAME || ' ' || c.LASTNAME AS nombre , c.EMAIL , SUBSTR(UPPER(c.LASTNAME) ,1,4) || 
SUBSTR(c.POSTALCODE ,1,3) || SUBSTR(UPPER(c.CITY) ,1,3) AS password
FROM CUSTOMER c WHERE c.COMPANY IS NOT NULL ;

--6. Muestra los artistas cuyo nombre tenga más de 10 caracteres.
SELECT * FROM ARTIST WHERE LENGTH(NAME ) > 10;

--7. Saca un listado de álbumes de Led Zeppelin e Iron Maiden cuyo título contenga un 1 o un 2.
SELECT * FROM ALBUM a INNER JOIN ARTIST a2 ON a.ARTISTID = a2.ARTISTID 
WHERE a2.NAME IN ('Led Zeppelin','Iron Maiden')
AND (a.TITLE LIKE '%1%'
OR (a.TITLE LIKE '%2%');

/*
8. Saca un listado de facturas (INVOICE) emitidas en los 3 primeros meses de cualquier año y
cuyo país sea USA.
*/
SELECT * FROM INVOICE i WHERE EXTRACT(MONTH FROM i.INVOICEDATE ) IN (1,2,3) AND i.BILLINGCOUNTRY = 'USA';
SELECT * FROM INVOICE i WHERE TO_CHAR(i.INVOICEDATE ,'MM') IN ('01','02','03') AND i.BILLINGCOUNTRY = 'USA';

/*
9. Saca un listado de facturas (INVOICE) emitidas entre el 1 de enero de 2011 y el 30 de junio de
2013 y cuyo país sea España.
*/
SELECT * FROM INVOICE i WHERE i.INVOICEDATE BETWEEN TO_DATE('01/01/2011','DD/MM/YYYY') AND TO_DATE('30/06/2013','DD/MM/YYYY');

--10. Saca un listado de los distintos países que hayan tenido alguna factura de más de 5€.
SELECT DISTINCT i.BILLINGCOUNTRY  FROM INVOICE i WHERE i.TOTAL > 5;

/*
11. Saca un listado de los distintos países y las distintas ciudades que hayan tenido alguna
 factura. El listado debe salir ordenado por país de forma descendente y por ciudad de forma
 ascendente.
*/
SELECT DISTINCT BILLINGCOUNTRY , BILLINGCITY   FROM INVOICE i ORDER BY i.BILLINGCOUNTRY DESC, i.BILLINGCITY ASC ;


--12. Saca una lista de las canciones cuya dirección es un número par.
SELECT * FROM TRACK t WHERE MOD (t.TRACKID ,2)=0;

/*
13. Saca un listado de facturas para las que entre hoy y la fecha de factura hayan pasado más
 de 150meses.
 */
SELECT * FROM INVOICE i WHERE MONTHS_BETWEEN(sysdate, i.INVOICEDATE ) > 150;

/*
 14. Saca una lista de las facturas que se hacen en la 2ª quincena de cada mes. Ordenalas por
 importe descendente y por ciudad ascendente.
 */
SELECT * FROM INVOICE i WHERE EXTRACT(DAY FROM i.INVOICEDATE ) > 15 ORDER BY i.TOTAL DESC, BILLINGCITY ASC;

--15. Saca una lista de los álbumes cuyo título tenga un número impar de letras.
SELECT * FROM ALBUM a WHERE MOD(LENGTH(a.TITLE ),2)!=0;  

--16. Saca una lista de los álbumes de Metallica cuyo nombre contenga la palabra All o la
-- palabra Load.
SELECT a.TITLE FROM ALBUM a INNER JOIN ARTIST ar
ON a.ARTISTID = ar.ARTISTID
WHERE (lower(ar.NAME) IN ('metallica') )
AND (lower(a.TITLE) LIKE '%all%' 
OR lower(a.title) LIKE '%load%' );
/*
17. Saca una lista de las canciones. Saca el nombre y el precio en euros y 
en dólares (cambio
 1,04). Pon alias a los campos. Saca sólo aquellas canciones cuyo mediatype es 
 MPEG audio file.
 */
SELECT t.NAME , t.UNITPRICE AS usd, round(t.UNITPRICE * 1.04,2) AS eur 
FROM TRACK t 
INNER JOIN MEDIATYPE m 
ON m.MEDIATYPEID = t.MEDIATYPEID 
WHERE lower(m.NAME) LIKE '%mpeg%'; 
/*
 18. Saca una lista de los distintos compositores cuyo formato de canción
  es MPEG audio file y
 cuyo género es Latin.
*/
SELECT t.COMPOSER 
FROM TRACK t 
INNER JOIN MEDIATYPE m 
	ON m.MEDIATYPEID = t.MEDIATYPEID 
INNER JOIN GENRE g 
	ON t.GENREID = g.GENREID
WHERE m.NAME IN ('MPEG audio file')
AND g.NAME IN ('Latin');
/*
19. Haz una lista de canciones que ocupen entre 4.000.000 y 6.000.000 Kb y cuyo
 compositor contenga en el nombre las letras A y O pero no sean 
 la letra por la que empieza su
 nombre.
*/
SELECT t.NAME  FROM TRACK t 
WHERE t.BYTES BETWEEN 4000 AND 6000
AND LOWER(t.COMPOSER) LIKE '%a%' 
AND lower(t.COMPOSER) LIKE '%o%'
AND LOWER(t.COMPOSER ) NOT LIKE 'a%'
AND LOWER(t.COMPOSER ) NOT LIKE 'o%';
/*
20. Saca una lista de los distintos compositores, junto con la longitud 
de su nombre, que tienen
 una canción que contiene la palabra Love.
 */
SELECT t.COMPOSER,LENGTH(t.COMPOSER )  FROM TRACK t 
WHERE  lower(t.NAME) LIKE '%love%';
/*
21. Saca una lista de canciones. Queremos ver su nombre y al lado un campo que ponga
 LARGO(nombre de la canción más de 20 caracteres) o corto (otro caso). 
 (Investiga y usa la
 cláusula CASE en las Selects en Oracle)
*/
SELECT t.NAME ,
CASE 
	WHEN length(t.name) > 20 THEN 'Largo'
	ELSE 'Corto'
END AS longitud
FROM TRACK t ;
/*
22. Haz una lista de las facturas sacando la fecha, el importe y al lado un campo que las
cualifique en CARAS (más de 8€), NORMALES (entre 4€ y 8€) y BARATAS (menos de 4€). Sólo
para facturas en USA y Canada
*/
SELECT 
	i.INVOICEID ,
	i.TOTAL , 
	CASE 
		WHEN i.total > 8 THEN 'Caras'
		WHEN i.total < 4 THEN 'Baratas'
		ELSE 'Normales'
	END AS calificacion
FROM INVOICE i 
INNER JOIN CUSTOMER c 
	ON i.CUSTOMERID = c.CUSTOMERID 
WHERE c.COUNTRY IN ('USA','Canada');
/*
23. Haz una lista de empleados con 3 columnas: nombre del empleado, días que han pasado
desde que nació hasta que le contrataron y días que han pasado desde que le contrataron
hasta ahora.
*/
SELECT e.FIRSTNAME , 
		round(MONTHS_BETWEEN(e.HIREDATE, e.BIRTHDATE)*30) AS dias_nac_cont,
		ROUND(MONTHS_BETWEEN(TO_DATE(sysdate),e.HIREDATE)*30) AS dias_cont_hoy
FROM EMPLOYEE e; 
/*
24. Haz una lista de clientes con nombre, apellidos y la compañía. 
Si la compañía es nula, que
ponga “Cliente Persona Física”. No se puede utilizar el CASE.
*/
SELECT c.FIRSTNAME ,c.LASTNAME , NVL(c.COMPANY ,'Persona fisica')
FROM CUSTOMER c ;
/*
25. Haz una lista de clientes con nombre, apellidos. 
El nombre lo queremos relleno con * por la
derecha hasta 50 posiciones y el apellido con & hasta 30 posiciones por la izquierda
*/
SELECT RPAD(c.FIRSTNAME ,50,'*') , LPAD(c.LASTNAME ,30,'&')  FROM CUSTOMER c ;