# Ejercicios SQL - Base de Datos BIBLIOTECA

## 1.5.4 Consultas sobre una tabla

1. Devuelve un listado con el nombre y apellidos de todos los socios. El listado deberá estar ordenado alfabéticamente de menor a mayor por apellidos y nombre.

2. Averigua el nombre y apellidos de los socios que no han dado de alta su número de teléfono en la base de datos.

3. Devuelve el listado de los miembros (socios) que se dieron de alta durante el año 2023.

4. Devuelve el listado de los empleados cuyo salario sea superior a 20000.

5. Devuelve el listado de los libros publicados después del año 2000 y que tengan más de 400 páginas.

6. Devuelve el listado de los ejemplares que se encuentran en estado 'baja'.

## 1.5.5 Consultas multitabla (Composición interna)

1. Devuelve un listado con el nombre y apellidos de los socios junto con la fecha del préstamo y la fecha límite de devolución, para aquellos préstamos que aún no han sido devueltos (fecha_devolucion IS NULL).

2. Devuelve un listado con el título del libro y el nombre de la editorial de todos los libros registrados.

3. Devuelve un listado con el título del libro, el nombre y los apellidos de los autores, utilizando la tabla intermedia libro_autor.

4. Devuelve un listado de los préstamos realizados indicando el nombre del socio, el título del libro prestado y la fecha del préstamo. Para obtener el título del libro tendrás que recorrer la cadena préstamo → detalle_prestamo → ejemplar → libro.

5. Devuelve un listado con los nombres de todas las categorías que tienen al menos un libro asociado (sin repetir nombres).

6. Devuelve un listado con todos los ejemplares prestados que aún no han sido devueltos, mostrando el título del libro, el código de barras del ejemplar y la fecha límite de devolución.

## 1.5.6 Consultas multitabla (Composición externa)

Resuelva todas las consultas utilizando las cláusulas LEFT JOIN y RIGHT JOIN.

1. Devuelve un listado con todos los libros y sus editoriales. El listado también debe mostrar aquellos libros que no tienen editorial asociada. El resultado debe mostrar título del libro, nombre de la editorial y país de la editorial. El resultado estará ordenado alfabéticamente por título.

2. Devuelve un listado con todas las categorías y los libros que contienen. El listado también debe mostrar aquellas categorías que no tienen ningún libro asociado. Debe mostrar nombre de la categoría y título del libro.

3. Devuelve un listado con todos los socios y los préstamos que han realizado. El listado también debe mostrar aquellos socios que no han realizado ningún préstamo. Debe mostrar nombre del socio, apellidos, fecha del préstamo y fecha límite.

4. Devuelve un listado con todos los autores y los libros que han escrito. El listado también debe mostrar aquellos autores que no tienen ningún libro asociado. Debe mostrar nombre del autor, apellidos y título del libro.

5. Devuelve un listado con los libros que no tienen ningún ejemplar registrado en la biblioteca.

6. Devuelve un listado con todos los empleados y, si corresponde, los datos de los préstamos gestionados (asumiendo que existiera una relación). Como no existe dicha relación directa, lista todos los empleados con su cargo y salario, incluyendo aquellos que no tengan ningún socio asociado (simula una relación left join entre empleado y socio a través del hecho de que ambos son miembros).

## 1.5.7 Consultas resumen

1. Devuelve el número total de socios que hay en la biblioteca.

2. Calcula cuántos ejemplares hay en cada estado ('disponible', 'prestado', 'baja').

3. Calcula cuántos libros hay de cada editorial. El resultado solo debe mostrar dos columnas, una con el nombre de la editorial y otra con el número de libros. El resultado solo debe incluir las editoriales que tienen libros asociados y deberá estar ordenado de mayor a menor por el número de libros.

4. Devuelve un listado con todas las editoriales y el número de libros que hay en cada una de ellas. Tenga en cuenta que pueden existir editoriales que no tienen libros asociados. Estas editoriales también tienen que aparecer en el listado.

5. Devuelve un listado con el nombre de todas las categorías existentes en la base de datos y el número de libros que tiene cada una. Tenga en cuenta que pueden existir categorías que no tienen libros asociados. Estas categorías también tienen que aparecer en el listado. El resultado deberá estar ordenado de mayor a menor por el número de libros.

6. Devuelve un listado con el nombre de todas las categorías existentes en la base de datos y el número de libros que tiene cada una, de las categorías que tengan más de 2 libros asociados.

7. Devuelve un listado que muestre la media de páginas de los libros agrupada por editorial. El resultado debe tener dos columnas: nombre de la editorial y media de páginas.

8. Devuelve un listado que muestre cuántos préstamos ha realizado cada socio. El resultado deberá mostrar dos columnas, una con el nombre y apellidos del socio y otra con el número de préstamos realizados. El resultado estará ordenado de mayor a menor por el número de préstamos.

9. Devuelve un listado con el número de ejemplares que tiene cada libro. El listado debe tener en cuenta aquellos libros que no tienen ningún ejemplar. El resultado mostrará tres columnas: id, título del libro y número de ejemplares. El resultado estará ordenado de mayor a menor por el número de ejemplares.

## 1.5.8 Subconsultas

1. Devuelve todos los datos del socio más joven (con la fecha de nacimiento más reciente).

2. Devuelve un listado con las categorías que no tienen ningún libro asociado.

3. Devuelve un listado con las editoriales que no tienen ningún libro en la biblioteca.

4. Devuelve un listado con los socios que nunca han realizado ningún préstamo.

5. Devuelve un listado con los libros que nunca han sido prestados (ninguno de sus ejemplares aparece en detalle_prestamo).

6. Devuelve el libro más antiguo (el que tenga el año de publicación más pequeño).

7. Devuelve los autores que han escrito más libros que la media de libros por autor.

8. Devuelve las categorías cuyo número de libros supera la media de libros por categoría.

9. Devuelve el nombre y apellidos de los socios que tienen préstamos aún no devueltos y cuya fecha límite ya ha pasado (fecha_limite anterior a la fecha actual).

10. Devuelve el título y el número de ejemplares de aquellos libros cuyo número de ejemplares es mayor que el número de ejemplares medio de los libros de su misma categoría.

11. Devuelve el nombre y apellidos del socio que más préstamos ha realizado en la historia de la biblioteca.

12. Devuelve el nombre y apellidos de los autores que tienen la misma nacionalidad que el autor más prolífico (el que más libros ha escrito).

13. Devuelve el nombre de la categoría que tiene actualmente el mayor número de ejemplares prestados (estado 'prestado').

14. Devuelve el título de los libros de los cuales todos sus ejemplares están actualmente prestados (ninguno disponible).
