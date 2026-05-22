--
--1
--
--Automatic Zoom
--EJERCICIOS HR
--1. Devuelve el nombre del empleado que más gana

SELECT * 
FROM EMPLOYEES e 
where e.SALARY = (SELECT MAX(e1.salary) FROM EMPLOYEES e1);
--2. Devuelve el nombre del empleado que más gana de cada departamento. Añade al listado el
--nombre del departamento.
SELECT 
        (
            select d2.department_name
            from DEPARTMENTS d2
            where d2.DEPARTMENT_ID = stat.DEPARTMENT_id
        ) as departamento,
        e.FIRST_NAME as mvp
FROM (
    SELECT d1.DEPARTMENT_id, max(e1.salary) as max_sal
    FROM DEPARTMENTS d1
    JOIN EMPLOYEES e1 ON e1.DEPARTMENT_ID = d1.DEPARTMENT_ID
    group by d1.DEPARTMENT_id
) stat 
JOIN EMPLOYEES e ON e.DEPARTMENT_id = stat.DEPARTMENT_id and e.SALARY = stat.max_sal;
--3. Devuelve un listado con nombre del departamento, nombre del empleado y salario para
--todos los empleados que ganen más que la media de la empresa.
SELECT d.DEPARTMENT_NAME, e.FIRST_NAME, e.SALARY
FROM DEPARTMENTS d 
JOIN EMPLOYEES e ON e.DEPARTMENT_id = d.DEPARTMENT_id
where e.SALARY > (
    select avg(e2.salary)
    from EMPLOYEES e2
);
--4. Devuelve un listado con nombre del departamento, nombre del empleado y salario para
--todos los empleados que ganen más que la media de su departamento.
SELECT stat.DEPARTMENT_NAME, e.FIRST_NAME, e.SALARY
FROM (
    SELECT d2.DEPARTMENT_ID, d2.DEPARTMENT_NAME, avg(e2.SALARY) as sal_media
    FROM DEPARTMENTS d2 
    JOIN EMPLOYEES e2 ON e2.DEPARTMENT_ID = d2.DEPARTMENT_ID
    group by d2.DEPARTMENT_ID, d2.DEPARTMENT_NAME
) stat
JOIN EMPLOYEES e ON e.DEPARTMENT_ID = stat.DEPARTMENT_ID and e.SALARY > stat.sal_media
order by stat.DEPARTMENT_NAME, e.SALARY;

SELECT d.DEPARTMENT_NAME, e.FIRST_NAME, e.SALARY
FROM DEPARTMENTS d 
JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE e.SALARY > (
    SELECT AVG(e2.SALARY)
    FROM EMPLOYEES e2
    WHERE e2.DEPARTMENT_ID = d.DEPARTMENT_ID
) order by d.DEPARTMENT_NAME, e.SALARY
;
--5. Haz un listado con nombre del puesto, nombre del empleado y fecha de contratación para el
--empleado más antiguo por cada puesto de trabajo.
SELECT stat.JOB_TITLE, e.FIRST_NAME, e.HIRE_DATE
FROM (
    SELECT j1.JOB_ID, j1.JOB_TITLE, MIN(e1.HIRE_DATE) as antiguo
    FROM EMPLOYEES e1 
    JOIN JOBS j1 ON j1.JOB_ID = e1.JOB_ID
    GROUP BY j1.JOB_ID, j1.JOB_TITLE
) stat 
JOIN EMPLOYEES e ON e.HIRE_DATE = stat.antiguo and e.JOB_ID = stat.JOB_ID
order by stat.JOB_TITLE;

SELECT 
        j.JOB_TITLE, e.FIRST_NAME, e.HIRE_DATE
FROM EMPLOYEES e 
JOIN JOBS j ON j.JOB_ID = e.JOB_ID
WHERE e.HIRE_DATE = (
    SELECT MIN(e2.HIRE_DATE)
    FROM EMPLOYEES e2
    WHERE e2.JOB_ID = j.JOB_ID
);
--6. Haz un listado con nombre del departamento, nombre del empleado y salario para todos los
--empleados en cuyo departamento haya algún empleado que gane menos que ellos.
SELECT d.DEPARTMENT_NAME, e.FIRST_NAME, e.SALARY
FROM DEPARTMENTS d 
JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
WHERE EXISTS (
    SELECT 1
    FROM EMPLOYEES e2
    WHERE e2.DEPARTMENT_ID = d.DEPARTMENT_ID
    and e2.SALARY > e.SALARY
) order by d.DEPARTMENT_NAME;

--7 Haz un listado de las ciudades en las que no está ubicado ningún departamento
SELECT l.city
FROM LOCATIONS l 
LEFT JOIN DEPARTMENTS d ON d.LOCATION_ID = l.LOCATION_ID
WHERE d.DEPARTMENT_ID is NULL;

SELECT l.CITY
FROM LOCATIONS l 
WHERE not EXISTS (
    SELECT 1 
    FROM DEPARTMENTS d1
    WHERE d1.LOCATION_ID = l.LOCATION_ID
);
--8 Haz un listado con el puesto de trabajo, nombre del puesto, y todos los empleados
--pertenecientes a este puesto menos el último que se ha contratado.
SELECT j1.JOB_ID, MIN(e1.HIRE_DATE)
FROM EMPLOYEES e1 
JOIN JOBS j1 ON j1.JOB_ID = e1.JOB_ID
GROUP BY j1.JOB_ID;

SELECT j.JOB_ID, j.JOB_TITLE, e.*
FROM EMPLOYEES e 
JOIN JOBS j ON j.JOB_ID = e.JOB_ID
WHERE (j.JOB_ID, e.HIRE_DATE) not in (
    SELECT j1.JOB_ID, MIN(e1.HIRE_DATE)
    FROM EMPLOYEES e1 
    JOIN JOBS j1 ON j1.JOB_ID = e1.JOB_ID
    GROUP BY j1.JOB_ID
);
--9 Haz un listado con las ciudades, el empleado que más gana de cada ciudad (nombre, apellido
--y salario) y la diferencia de salario que hay entre el empleado que más gana y la media de
--salarios de su ciudad.
SELECT stat.city, emp.FIRST_NAME, emp.last_name, emp.salary, trunc(stat.mas_gana - stat.media,2) as diferencia
FROM (
    SELECT l2.city, MAX(e2.SALARY) as mas_gana, AVG(e2.SALARY) as media
    FROM LOCATIONS l2
    JOIN DEPARTMENTS d2 ON d2.LOCATION_ID = l2.LOCATION_ID 
    JOIN EMPLOYEES e2 ON e2.DEPARTMENT_ID = d2.DEPARTMENT_ID
    GROUP BY l2.city
) stat 
JOIN (
    SELECT e3.FIRST_NAME, e3.last_name ,e3.salary, l3.CITY
    FROM EMPLOYEES e3
    JOIN DEPARTMENTS d3 ON d3.DEPARTMENT_ID = e3.DEPARTMENT_ID 
    JOIN LOCATIONS l3 ON l3.LOCATION_ID = d3.LOCATION_ID
) emp ON emp.CITY = stat.city and emp.salary = stat.mas_gana;
--10 (difícil) Haz un listado con los departamentos cuya media de salarios está por encima de la
--media de salarios de la empresa. Incluye entre las columnas del listado dos que indiquen
--● Cuantos empleados del departamento tienen un salario por encima de la media de la
--empresa
--● Cuantos empleados del departamento tienen un salario por encima de la media del
--departamento.

SELECT stat.department_name
FROM (
    SELECT d2.DEPARTMENT_ID, d2.DEPARTMENT_NAME, AVG(e2.SALARY) as media_dep
    FROM DEPARTMENTS d2 
    JOIN EMPLOYEES e2 ON e2.DEPARTMENT_ID = d2.DEPARTMENT_ID
    GROUP BY d2.DEPARTMENT_ID, d2.DEPARTMENT_NAME
) stat
where stat.media_dep > (select avg(e3.salary) from employees e3);



SELECT d.DEPARTMENT_NAME,
        COUNT(e.EMPLOYEE_ID) as encima_media_empresa
FROM DEPARTMENTS d 
JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME, d.DEPARTMENT_NAME
HAVING AVG(e.SALARY) > (
    SELECT AVG(e2.SALARY)
    FROM EMPLOYEES e2
);
--
--Chat
--🪟
--sql consultas
--4 fuentes
--·
--15 may 2026
--Estas fuentes ofrecen una guía técnica integral sobre el lenguaje SQL y el diseño de bases de datos relacionales. El primer documento detalla la sintaxis de la instrucción SELECT, explicando funciones de filtrado, ordenación y manipulación de datos mediante operadores aritméticos y lógicos. Se incluyen explicaciones sobre herramientas de gestión como SQL Developer y Docker, además de un catálogo de funciones numéricas, de texto y de conversión específicas de Oracle. Por otro lado, los archivos complementarios proporcionan los esquemas estructurales para las bases de datos denominadas HR y World. Estos registros definen tablas, restricciones de integridad, claves foráneas e índices para organizar información sobre empleados, departamentos, países y ciudades. En conjunto, el material sirve tanto de manual de consulta para realizar peticiones de datos como de base práctica para el modelado de información.
--
--¿Cómo puedo filtrar y ordenar datos usando SELECT en SQL?
--¿Qué funciones de Oracle existen para manipular textos, números y fechas?
--¿Cuál es la diferencia entre realizar un JOIN implícito y uno explícito?
--miércoles, 20 de mayo d
--que error tiene
--
--
--SELECT c.IDCLIENTE
--FROM CLIENTES c
--where instr(upper(c.APELLIDOS),substr(upper(c.nombre),1,2))
--GROUP BY c.IDCLIENTE;
--
--La consulta que presentas tiene un error principal de lógica sintáctica en la cláusula WHERE y una redundancia en el uso del GROUP BY.
--1. Error en la cláusula WHERE
--El error fundamental es que la función INSTR devuelve un valor numérico (la posición de la cadena buscada o 0 si no la encuentra)
--. En SQL, la cláusula WHERE requiere una condición completa siguiendo el formato: expresión operador expresión
--.
--Actualmente, tienes WHERE instr(...), lo cual para el motor de la base de datos es simplemente un número (por ejemplo, 5 o 0). SQL no interpreta automáticamente que "un número distinto de cero es verdadero" como hacen otros lenguajes de programación. Debes compararlo explícitamente con un valor para crear una condición booleana
--.
--Corrección: Debes añadir > 0 para indicar que quieres los registros donde se haya encontrado la coincidencia.
--2. Uso redundante de GROUP BY
--Estás utilizando GROUP BY c.IDCLIENTE sin incluir ninguna función de agregado (como SUM, COUNT o AVG) en el SELECT
--. Aunque no produce un error si la columna del SELECT está en el GROUP BY, es una mala práctica
--.
--Si lo que buscas es evitar duplicados en el listado de IDs, lo estándar y más legible es utilizar la cláusula DISTINCT
--.
--
----------------------------------------------------------------------------------
--Consulta corregida y simplificada
--Para que la consulta funcione correctamente y sea más eficiente, debería quedar así:
--SELECT DISTINCT c.IDCLIENTE
--FROM CLIENTES c 
--WHERE INSTR(UPPER(c.APELLIDOS), SUBSTR(UPPER(c.NOMBRE), 1, 2)) > 0;
--Explicación de las mejoras:
--> 0: Ahora la condición es válida. Si las dos primeras letras del nombre están en el apellido, INSTR devolverá un número mayor a 0 y la fila será seleccionada
--.
--DISTINCT: Reemplaza al GROUP BY para asegurar que cada IDCLIENTE aparezca una sola vez de forma más clara
--.
--Funciones anidadas: Mantienes correctamente el uso de UPPER y SUBSTR anidados, lo cual es una técnica válida para asegurar que la búsqueda no sea sensible a mayúsculas/minúsculas
--.
--dime si esto esta bien
--

--8. Saca un listado donde se vean los continentes, el número de países de cada continente, el
--número de ciudades de cada continente (de las que tenemos en las tablas), el número de
--países de cada continente cuya esperanza de vida es mayor a la media de la esperanza de vida
--del mundo y el número de países de cada continente cuya esperanza de vida es superior a la
--media del continente.


SELECT co.CONTINENT,
count(distinct co.code) paises, count(distinct c.id) ciudades,
(
select count(distinct co2.code)
from COUNTRY co2
where co2.LIFEEXPECTANCY > (select avg(co3.LIFEEXPECTANCY) from COUNTRY co3)
and co2.CONTINENT = co.CONTINENT
) as paises_esperanza_mayor_media_mundial,
(
select count(distinct co2.code)
from COUNTRY co2
where co2.LIFEEXPECTANCY > (
select avg(co3.LIFEEXPECTANCY)
from COUNTRY co3
where co3.CONTINENT = co.CONTINENT
)
and co2.CONTINENT = co.CONTINENT
) as paises_esperanza_mayor_media_continente
FROM CITY c
JOIN COUNTRY co ON c.COUNTRYCODE = co.CODE
GROUP BY co.CONTINENT;
--
--Tu consulta es funcionalmente coherente y utiliza correctamente las subconsultas correlacionadas para resolver los requisitos más complejos, pero tiene un par de detalles importantes que podrías mejorar para asegurar la exactitud de los datos y la eficiencia del código.
--A continuación, analizo los puntos clave y te propongo una versión simplificada:
--1. El problema del JOIN inicial
--En tu consulta original usas: FROM CITY c JOIN COUNTRY co ON c.COUNTRYCODE = co.CODE
--El riesgo: Al hacer un JOIN (interno) empezando por la tabla CITY, solo estás teniendo en cuenta los países que tienen al menos una ciudad registrada en la tabla CITY
--. Si existe algún país en la tabla COUNTRY que no tenga ciudades en la base de datos, ese país (y posiblemente su continente si fuera el único caso) no aparecería en el conteo de países ni en las estadísticas
--.
--La solución: Es mejor usar COUNTRY como tabla principal y hacer un LEFT JOIN con CITY
--.
--2. Simplificación con el "Truco del CASE"
--Tal como vimos en ejercicios anteriores, puedes evitar subconsultas pesadas en el SELECT utilizando la expresión CASE dentro de un COUNT
--. Esto permite que el motor de la base de datos procese la información de forma más lineal.
--Para las medias, lo más eficiente es calcular la media de cada continente en una subconsulta en la cláusula FROM (Inline View)
--.
--Propuesta de consulta simplificada:
--SELECT 
--    co.CONTINENT,
--    COUNT(DISTINCT co.CODE) AS num_paises,
--    COUNT(c.ID) AS num_ciudades, -- COUNT ignora nulos del LEFT JOIN [5]
--    -- Paises con esperanza mayor a la media mundial
--    COUNT(CASE WHEN co.LIFEEXPECTANCY > (SELECT AVG(LIFEEXPECTANCY) FROM COUNTRY) THEN 1 END) AS esperanza_mayor_mundial,
--    -- Paises con esperanza mayor a la media de su continente
--    COUNT(CASE WHEN co.LIFEEXPECTANCY > stats.media_cont THEN 1 END) AS esperanza_mayor_continente
--FROM COUNTRY co
--LEFT JOIN CITY c ON co.CODE = c.COUNTRYCODE
--JOIN (
--    -- Calculamos la media por continente una sola vez
--    SELECT CONTINENT, AVG(LIFEEXPECTANCY) AS media_cont
--    FROM COUNTRY
--    GROUP BY CONTINENT
--) stats ON co.CONTINENT = stats.CONTINENT
--GROUP BY co.CONTINENT, stats.media_cont;
--¿Qué mejoras incluye esta versión?
--Precisión de datos: Al usar COUNTRY como base y LEFT JOIN, te aseguras de contar todos los países de la tabla, tengan o no ciudades registradas
--.
--Eficiencia: En lugar de ejecutar dos subconsultas completas por cada fila de resultado (una para la media mundial y otra para la del continente), calculamos la media de cada continente una sola vez en el JOIN de la cláusula FROM
--.
--Claridad: El uso de COUNT(CASE WHEN ... THEN 1 END) es una técnica estándar recomendada para realizar conteos condicionales sobre un mismo grupo de datos
--.
--Conteo de ciudades: Al agrupar por continente, COUNT(c.ID) contará todas las ciudades asociadas a ese continente sin necesidad de subconsultas adicionales
--.
--Nota sobre DISTINCT: He mantenido COUNT(DISTINCT co.CODE) porque al unir países con ciudades, las filas de los países se repiten. Sin el DISTINCT, estarías contando el país tantas veces como ciudades tenga
--. El COUNT(c.ID) no necesita DISTINCT porque cada ID de ciudad es único por definición
--.
--como sinplificarias esta consulta
--

SELECT  co.CONTINENT,
(
SELECT co2.NAME
FROM COUNTRY co2
WHERE co2.CONTINENT = co.CONTINENT
and co2.SURFACEAREA = (
SELECT min(co3.SURFACEAREA)
FROM COUNTRY co3
WHERE co3.CONTINENT = co.CONTINENT
)
) as pais,
(
SELECT nvl(co2.LIFEEXPECTANCY,0)
FROM COUNTRY co2
WHERE co2.CONTINENT = co.CONTINENT
and co2.SURFACEAREA = (
SELECT min(co3.SURFACEAREA)
FROM COUNTRY co3
WHERE co3.CONTINENT = co.CONTINENT
)
) as esperanza_vida,
(
SELECT co2.SURFACEAREA
FROM COUNTRY co2
WHERE co2.CONTINENT = co.CONTINENT
and co2.SURFACEAREA = (
SELECT min(co3.SURFACEAREA)
FROM COUNTRY co3
WHERE co3.CONTINENT = co.CONTINENT
)
) as superficie,
(
SELECT co2.POPULATION
FROM COUNTRY co2
WHERE co2.CONTINENT = co.CONTINENT
and co2.SURFACEAREA = (
SELECT min(co3.SURFACEAREA)
FROM COUNTRY co3
WHERE co3.CONTINENT = co.CONTINENT
)
) as poblacion
FROM COUNTRY co
GROUP BY co.CONTINENT;

--Tu consulta actual es muy ineficiente porque ejecuta ocho subconsultas por cada continente (dos por cada columna del SELECT), repitiendo innecesariamente el cálculo del valor mínimo
--.
--A continuación, te presento las dos mejores formas de simplificarla basándome en las fuentes:
--1. Simplificación mediante Subconsulta Multicolumna (Más elegante)
--Esta técnica permite comparar varias columnas a la vez (continente y superficie) con los resultados de una única subconsulta
--. Es la forma más limpia de obtener "la fila que contiene el mínimo de un grupo".
--SELECT 
--    CONTINENT, 
--    NAME as pais, 
--    NVL(LIFEEXPECTANCY, 0) as esperanza_vida, 
--    SURFACEAREA as superficie, 
--    POPULATION as poblacion
--FROM COUNTRY
--WHERE (CONTINENT, SURFACEAREA) IN (
--    SELECT CONTINENT, MIN(SURFACEAREA)
--    FROM COUNTRY
--    GROUP BY CONTINENT
--)
--ORDER BY CONTINENT;
--Ventajas:
--Elimina la redundancia: Solo calculas el MIN(SURFACEAREA) una vez por continente en lugar de hacerlo para cada columna
--.
--Legibilidad: El código es mucho más corto y fácil de entender.
--NVL incorporado: Se mantiene el uso de NVL para asegurar que las esperanzas de vida nulas aparezcan como 0
--.
--2. Simplificación mediante Subconsulta en el FROM (Inline View)
--Otra opción muy recomendada en las fuentes es crear una "tabla temporal" al vuelo que contenga los mínimos y unirla a la tabla principal
--.
--SELECT 
--    co.CONTINENT, 
--    co.NAME as pais, 
--    NVL(co.LIFEEXPECTANCY, 0) as esperanza_vida, 
--    co.SURFACEAREA as superficie, 
--    co.POPULATION as poblacion
--FROM COUNTRY co
--JOIN (
--    -- Esta subconsulta calcula los mínimos una sola vez
--    SELECT CONTINENT, MIN(SURFACEAREA) as min_surf
--    FROM COUNTRY
--    GROUP BY CONTINENT
--) mins ON co.CONTINENT = mins.CONTINENT AND co.SURFACEAREA = mins.min_surf
--ORDER BY co.CONTINENT;
--¿Por qué estas opciones son mejores?
--Rendimiento: Tu consulta original utiliza subconsultas escalares en el SELECT. Según las fuentes, estas deben devolver exactamente una fila y una columna por cada registro de la consulta principal
--. Al tener tantas, el motor de la base de datos trabaja en exceso.
--Simplicidad: En lugar de repetir la lógica de WHERE co2.CONTINENT = co.CONTINENT cuatro veces, utilizas la potencia del GROUP BY y los JOINs para relacionar los datos de forma natural
--.
--Manejo de duplicados: Tu consulta original usaba un GROUP BY exterior solo para obtener la lista de continentes. En las versiones simplificadas, el filtrado ocurre en el WHERE o en el JOIN, lo cual es semánticamente más correcto para obtener registros detallados de países
--.
--Nota: Si en un continente hubiera dos países con exactamente la misma superficie mínima, estas versiones mostrarían ambos. Si solo quisieras uno (como intentaba forzar tu estructura original), podrías añadir un DISTINCT o FETCH FIRST 1 ROW según el caso
--.
--ahora hazlo con esta
--

--7. Por cada país devuelve el nombre del país, nombre de la ciudad más poblada de ese país y el
--lenguaje más hablado en ese país.


SELECT  (
SELECT co2.NAME
FROM COUNTRY co2
WHERE co2.CODE = co.CODE
) as pais,
(
SELECT c3.NAME
FROM COUNTRY co3 JOIN CITY c3 ON c3.COUNTRYCODE = co3.CODE
WHERE c3.POPULATION = (
SELECT MAX(c31.POPULATION)
FROM CITY c31 JOIN COUNTRY co31 ON co31.CODE = c31.COUNTRYCODE
WHERE co31.CODE = co.CODE
)and co.code = co3.code and ROWNUM = 1
) as ciudad_mas_poblada,
(
SELECT cl4.LANGUAGE
FROM COUNTRYLANGUAGE cl4 JOIN COUNTRY co4 ON co4.CODE = cl4.COUNTRYCODE
WHERE cl4.PERCENTAGE = (
SELECT MAX(cl41.PERCENTAGE)
FROM COUNTRYLANGUAGE cl41 JOIN COUNTRY co41 ON co41.CODE = cl41.COUNTRYCODE
WHERE co41.CODE = co.CODE
) and co.CODE = co4.code and rownum = 1
) as idioma
FROM COUNTRY co
JOIN CITY c ON c.COUNTRYCODE = co.CODE
GROUP BY co.CODE;

--Esta consulta se puede simplificar drásticamente. Tu versión original es muy poco eficiente porque utiliza subconsultas escalares en el SELECT que, a su vez, contienen joins redundantes y subconsultas de tercer nivel para encontrar el valor máximo
--.
--Aquí tienes la forma más eficiente y limpia de resolverlo utilizando subconsultas en la cláusula FROM (Inline Views), una técnica que las fuentes recomiendan para combinar datos de detalle con valores máximos por grupo
--.
--Propuesta Simplificada (Recomendada)
SELECT 
    co.name AS pais, 
    mc.name AS ciudad_mas_poblada, 
    ml.language AS idioma
FROM country co
-- Join para obtener la ciudad con más población de cada país
LEFT JOIN (
    SELECT countrycode, name
    FROM city
    WHERE (countrycode, population) IN (
        SELECT countrycode, MAX(population)
        FROM city
        GROUP BY countrycode
    )
) mc ON co.code = mc.countrycode
-- Join para obtener el idioma más hablado de cada país
LEFT JOIN (
    SELECT countrycode, language
    FROM countrylanguage
    WHERE (countrycode, percentage) IN (
        SELECT countrycode, MAX(percentage)
        FROM countrylanguage
        GROUP BY countrycode
    )
) ml ON co.code = ml.countrycode;
--¿Por qué esta versión es mucho mejor?
--Eliminación de redundancia en "pais": En tu consulta original, hacías un SELECT de la tabla COUNTRY dentro del SELECT principal para obtener el nombre del país. Esto es innecesario ya que el nombre ya está disponible directamente en la tabla del FROM principal (co.name)
--.
--Uso de Subconsultas Multicolumna: En lugar de joins complejos dentro de cada subconsulta, utilizamos el operador IN con un par de valores (countrycode, valor_maximo). Esta es una técnica avanzada detallada en las fuentes para encontrar el registro que ostenta el máximo de un grupo de forma directa
--.
--Eficiencia de Join vs. Subconsulta Escalar: Tu consulta ejecutaba tres subconsultas completas por cada fila del resultado. La versión propuesta calcula los máximos una sola vez mediante un join, lo que mejora significativamente el rendimiento
--.
--Uso de LEFT JOIN: Al usar LEFT JOIN, te aseguras de que si un país no tiene ciudades registradas (o idiomas), el país siga apareciendo en la lista con valores NULL en lugar de desaparecer del listado
--.
--Adiós al ROWNUM innecesario: Al filtrar directamente por el par (código, valor_máximo), ya obtienes la fila correcta. El uso de ROWNUM = 1 solo sería necesario si existieran dos ciudades con exactamente la misma población máxima y solo quisieras ver una
--.
--Errores específicos detectados en tu código:
--Joins redundantes: Dentro de las subconsultas unías COUNTRY con CITY. No es necesario, ya que la tabla CITY ya tiene la columna COUNTRYCODE para relacionarse con la consulta principal
--.
--Estructura del FROM: Hacías un JOIN con CITY en la consulta principal y luego un GROUP BY, pero luego no usabas los datos de ese join para nada, ya que toda la información venía de las subconsultas del SELECT. Esto generaba un trabajo innecesario para el motor de la base de datos
--.
--8. Saca un listado donde se vean los continentes, el número de países de cada continente, el
--número de ciudades de cada continente (de las que tenemos en las tablas), el número de
--países de cada continente cuya esperanza de vida es mayor a la media de la esperanza de vida
--del mundo y el número de países de cada continente cuya esperanza de vida es superior a la
--media del continente.
SELECT  co.CONTINENT,
COUNT(distinct co.CODE) as paises,

COUNT(distinct ci.id) as ciudades,
le.paises, lec.paises
FROM COUNTRY co JOIN CITY ci ON ci.COUNTRYCODE = co.CODE
JOIN (
SELECT co2.CONTINENT, COUNT(co2.CODE) as paises
FROM COUNTRY co2
WHERE co2.LIFEEXPECTANCY > (
SELECT AVG(co3.LIFEEXPECTANCY) FROM COUNTRY co3
) GROUP BY co2.CONTINENT
) le ON le.CONTINENT = co.CONTINENT
JOIN (
SELECT co2.CONTINENT, COUNT(co2.CODE) as paises
FROM COUNTRY co2
WHERE co2.LIFEEXPECTANCY > (
SELECT AVG(co3.LIFEEXPECTANCY) FROM COUNTRY co3 WHERE co3.CONTINENT = co2.CONTINENT
) GROUP BY co2.CONTINENT
) lec ON lec.CONTINENT = co.CONTINENT
GROUP BY co.CONTINENT, le.paises, lec.paises;

--Tu consulta es lógica y funcionalmente se acerca a lo que se pide, pero presenta algunos problemas de precisión y eficiencia que podrías mejorar basándote en las fuentes:
--1. El problema del JOIN (Países sin ciudades)
--Al usar un JOIN (interno) entre COUNTRY y CITY, tu consulta excluye automáticamente a los países que no tienen ninguna ciudad registrada en la tabla CITY
--. Si un continente tuviera países pero ninguna ciudad en la base de datos, los conteos de esos países no aparecerían.
--Solución: Usa un LEFT JOIN para asegurar que todos los países de la tabla COUNTRY sean procesados, tengan o no ciudades
--.
--2. Ineficiencia por múltiples JOINs de subconsultas
--Estás uniendo la tabla principal con dos subconsultas pesadas (le y lec). Esto obliga a la base de datos a procesar la tabla COUNTRY varias veces por separado. Como se menciona en las fuentes, es mucho más eficiente realizar los conteos condicionales dentro de la propia agregación principal usando la expresión CASE
--.
--3. Conteo de ciudades
--En tu consulta usas COUNT(distinct ci.id). El DISTINCT aquí es innecesario y consume recursos, ya que la columna ID es la clave primaria de la tabla CITY y, por definición, todos sus valores son únicos
--.

--------------------------------------------------------------------------------
--Propuesta de consulta simplificada y corregida
--Siguiendo las técnicas de subconsultas en la cláusula FROM
-- y el uso de CASE para conteos condicionales
--, la consulta quedaría así:
SELECT 
    co.CONTINENT,
    COUNT(DISTINCT co.CODE) AS num_paises,
    COUNT(ci.ID) AS num_ciudades,
    -- Países con esperanza mayor a la media mundial (subconsulta escalar)
    COUNT(CASE WHEN co.LIFEEXPECTANCY > (SELECT AVG(LIFEEXPECTANCY) FROM COUNTRY) THEN 1 END) AS mayor_media_mundo,
    -- Países con esperanza mayor a la media de su continente (usando la tabla 'stats')
    COUNT(CASE WHEN co.LIFEEXPECTANCY > stats.media_cont THEN 1 END) AS mayor_media_continente
FROM COUNTRY co
LEFT JOIN CITY ci ON co.CODE = ci.COUNTRYCODE
LEFT JOIN (
    -- Calculamos la media por continente una sola vez para unirla
    SELECT CONTINENT, AVG(LIFEEXPECTANCY) as media_cont
    FROM COUNTRY
    GROUP BY CONTINENT
) stats ON co.CONTINENT = stats.CONTINENT
GROUP BY co.CONTINENT, stats.media_cont;
--Por qué esta versión es mejor:
--Integridad de los datos: Al usar LEFT JOIN, incluyes países sin ciudades y continentes completos que de otro modo podrían desaparecer
--.
--Rendimiento: Solo hay una subconsulta de agrupación (stats) que se calcula una vez. Los conteos específicos se hacen "al vuelo" mientras se recorren los grupos de continentes
--.
--Claridad: Eliminas la necesidad de agrupar por múltiples alias de subconsultas en el GROUP BY final, lo que hace el código más fácil de mantener
--.
--Precisión en la media: Usar AVG en una subconsulta es la forma estándar de comparar valores individuales contra un promedio grupal
--.
--Hoy • 10:31
--como simplificarias esto
--

SELECT co.CONTINENT,
(
SELECT co2.NAME
FROM COUNTRY co2
WHERE co2.SURFACEAREA = (
SELECT max(co21.SURFACEAREA)
FROM COUNTRY co21
WHERE co21.CONTINENT = co.CONTINENT
)
) as grande,
(
SELECT co2.NAME
FROM COUNTRY co2
WHERE co2.SURFACEAREA = (
SELECT min(co21.SURFACEAREA)
FROM COUNTRY co21
WHERE co21.CONTINENT = co.CONTINENT
)
) as pequeno,
(
SELECT ci3.POPULATION
FROM COUNTRY co3
JOIN CITY ci3 ON ci3.COUNTRYCODE = co3.CODE
WHERE ci3.POPULATION = (
SELECT max(ci31.POPULATION)
FROM COUNTRY co31
JOIN CITY ci31 ON ci31.COUNTRYCODE = co31.CODE
WHERE co31.CONTINENT = co.CONTINENT
)
) as poblacion_ciudad_mas_grande,
(
SELECT ci3.name
FROM COUNTRY co3
JOIN CITY ci3 ON ci3.COUNTRYCODE = co3.CODE
WHERE ci3.POPULATION = (
SELECT max(ci31.POPULATION)
FROM COUNTRY co31
JOIN CITY ci31 ON ci31.COUNTRYCODE = co31.CODE
WHERE co31.CONTINENT = co.CONTINENT
)
) as nombre_ciudad_mas_grande
FROM COUNTRY co
group by co.CONTINENT;

--Tu consulta original es muy costosa para la base de datos porque utiliza subconsultas escalares en el SELECT que, a su vez, contienen más subconsultas anidadas
--. Esto obliga al motor a recalcular los máximos y mínimos de cada continente una y otra vez por cada fila del resultado
--.
--La forma más eficiente de simplificarla es utilizar una subconsulta en la cláusula FROM (también llamada vista en línea o inline view)
--. Esta técnica permite calcular todos los valores de referencia (máximos y mínimos) una sola vez por continente y luego usarlos para "pescar" los nombres correspondientes mediante JOINs
--.
--Aquí tienes la propuesta simplificada:
SELECT 
    stats.continent, 
    c_max.name AS grande, 
    c_min.name AS pequeno, 
    ct_max.population AS poblacion_ciudad_mas_grande,
    ct_max.name AS nombre_ciudad_mas_grande
FROM (
    -- 1. Calculamos los valores de referencia por continente una sola vez
    SELECT 
        co.continent,
        MAX(co.surfacearea) AS max_surf,
        MIN(co.surfacearea) AS min_surf,
        MAX(ci.population) AS max_city_pop
    FROM country co
    LEFT JOIN city ci ON co.code = ci.countrycode
    GROUP BY co.continent
) stats
-- 2. "Pescamos" el nombre del país más grande
JOIN country c_max ON stats.continent = c_max.continent AND stats.max_surf = c_max.surfacearea
-- 3. "Pescamos" el nombre del país más pequeño
JOIN country c_min ON stats.continent = c_min.continent AND stats.min_surf = c_min.surfacearea
-- 4. "Pescamos" los datos de la ciudad más poblada del continente
JOIN city ct_max ON stats.max_city_pop = ct_max.population
JOIN country co_city ON ct_max.countrycode = co_city.code AND stats.continent = co_city.continent;
--¿Por qué es mejor esta versión?
--Eficiencia (Rendimiento): En lugar de ejecutar múltiples subconsultas por cada continente, agrupamos (GROUP BY) los datos una sola vez al principio para obtener los valores máximos y mínimos
--.
--Estructura Limpia: Al usar la subconsulta en el FROM como una "tabla temporal" creada al vuelo, la consulta principal se limita a realizar uniones (JOIN) naturales entre los datos estadísticos y las tablas de detalle (country y city)
--.
--Uso de Funciones de Agregado: Aprovechamos MAX y MIN de forma directa sobre los grupos de continentes, que es su uso estándar en SQL
--.
--Legibilidad: Evitas el anidamiento excesivo en la lista de proyección (SELECT), lo que hace que el código sea mucho más fácil de leer y mantener
--.
--Nota importante: Si en un continente hubiera dos países con exactamente la misma superficie máxima, o dos ciudades con la misma población máxima, esta consulta devolvería ambos registros. Si necesitas evitar esto, podrías usar la cláusula DISTINCT o FETCH FIRST 1 ROW ONLY según el caso específico
--.
--explicame la parte del analisis para llegar a esa consulta, porque no se me habria ocurrido que se puede hacer mas de un join de una misma tabla como lo haces con country
--
--Para llegar a esa consulta, el análisis se basa en un cambio de mentalidad: en lugar de intentar obtener todo en una sola pasada, dividimos el problema en "obtener los récords" (estadísticas) y luego "buscar quién ostenta esos récords" (detalle)
--.
--A continuación te explico el proceso lógico y por qué es posible (y necesario) unir una tabla varias veces.
--1. El Análisis: De lo General a lo Particular
--El problema de tu consulta original es que intentabas "preguntar" por el país más grande, el más pequeño y la ciudad más poblada de forma aislada para cada fila
--. El análisis correcto sigue estos pasos:
--Paso 1: Identificar los valores de referencia. Primero necesitamos saber, por cada continente, cuáles son los números "ganadores": ¿Cuál es la superficie máxima? ¿Cuál es la mínima? ¿Cuál es la población de ciudad más alta?
--.
--Paso 2: Crear una "Tabla de Medallas" (Subconsulta en el FROM). Esta es la clave. Creamos una tabla temporal "al vuelo" que solo tiene una fila por continente con esos valores máximos y mínimos
--. A esta tabla la llamamos stats.
--Paso 3: El proceso de "Pesca". Ahora que tienes la tabla stats, el motor de la base de datos sabe que en 'Asia' el récord de superficie es 44579000. Entonces, realizas un JOIN para volver a la tabla original y buscar qué país de 'Asia' tiene exactamente esa superficie
--.
--2. ¿Por qué se puede unir la misma tabla varias veces?
--Es normal que te resulte extraño al principio, pero las fuentes explican que puedes combinar una tabla consigo misma (o varias veces en la misma consulta) siempre y cuando utilices alias obligatorios
--.
--Imagina que la tabla COUNTRY es un archivo físico de fichas. Para resolver este reporte, necesitas "tres copias" de ese archivo trabajando al mismo tiempo:
--Copia A (stats): La usas para anotar en un papel los valores máximos y mínimos por continente
--.
--Copia B (c_max): La usas solo para buscar el nombre del país que coincide con la "superficie máxima" de tu papel.
--Copia C (c_min): La usas solo para buscar el nombre del país que coincide con la "superficie mínima" de tu papel.
--Sin los alias (c_max, c_min), el motor de SQL no sabría de qué "copia" del archivo estás hablando cada vez
--.
--3. La lógica de los múltiples JOINs en esta consulta
--En la consulta simplificada que te propuse, los JOINs actúan como filtros de precisión:
--JOIN c_max: Une stats con country pidiendo que coincidan el continente y la superficie máxima. Esto te da el nombre del "grande"
--.
--JOIN c_min: Vuelve a unir con country pero ahora pidiendo que coincidan el continente y la superficie mínima. Esto te da el nombre del "pequeño"
--.
--JOIN ct_max: Une la población máxima de ciudad que calculaste en stats con la tabla CITY para saber qué ciudad tiene ese número
--.
--Resumen del beneficio: Al hacerlo así, la base de datos no tiene que "pensar" cuál es el máximo cada vez que escribe una columna
--. Ya lo sabe desde el principio gracias a la subconsulta inicial, y solo se dedica a buscar nombres en las tablas unidas, lo que hace que la consulta sea muchísimo más rápida y eficiente.
--¿Cómo manejaría la consulta si hubiera varios países con la misma superficie mínima?
--
--Si en un continente existen varios países con la misma superficie mínima, el comportamiento de la consulta dependerá de la técnica que utilices. Según las fuentes, tienes tres formas principales de gestionarlo:
--1. Mostrar todos los países empatados (Comportamiento por defecto)
--Si utilizas la técnica de subconsulta multicolumna con IN o un JOIN con una vista en línea (como vimos en los ejemplos anteriores), la base de datos devolverá todas las filas que coincidan exactamente con ese valor mínimo
--.
--Si en el continente 'Oceanía' hubiera dos islas con la misma superficie mínima, aparecerían dos filas para ese continente en el resultado final.
--2. Mostrar solo uno de ellos (Uso de ONLY)
--Si tu objetivo es obtener un listado estrictamente de una fila por continente, sin importar los empates, puedes utilizar la cláusula FETCH FIRST 1 ROWS ONLY
--.
--Esta instrucción ordena los países por superficie de menor a mayor y "corta" el resultado en la primera fila. Si hay dos países con el mismo tamaño, Oracle elegirá uno de forma arbitraria (a menos que añadas un segundo criterio de ordenación, como el nombre)
--.
--3. Garantizar la equidad en el empate (Uso de WITH TIES)
--Si quieres limitar el resultado pero asegurarte de que, si hay un empate en la última posición permitida, aparezcan todos los involucrados, debes usar WITH TIES
--.
--Ejemplo: ORDER BY SURFACEAREA ASC FETCH FIRST 1 ROWS WITH TIES;
--Esta cláusula le indica a Oracle: "Tráeme el primero, pero si el segundo mide lo mismo que el primero, tráemelo también"
--. Esto es vital para garantizar la exactitud en informes estadísticos
--.
--4. Método tradicional con ROWNUM
--En versiones anteriores de Oracle (o si usas subconsultas en el SELECT), se suele recurrir a la condición WHERE ROWNUM = 1
--.
--Como se menciona en las fuentes, esta es una forma de forzar a que una subconsulta devuelva exactamente un valor, evitando errores en subconsultas escalares que solo pueden procesar una fila y una columna por registro principal
--.
--Resumen:
--Para ver todos los países pequeños aunque midan lo mismo: Usa la estructura de JOIN o IN que ya conoces
--.
--Para ver solo un país por continente pase lo que pase: Añade FETCH FIRST 1 ROWS ONLY
--.
--Para ver los primeros y sus empates: Usa FETCH FIRST 1 ROWS WITH TIES
--.
--COMO LO HARIAS EN ESTA CONSULTA
--

SELECT


stats.continent,
c_max.name AS grande,
c_min.name AS pequeno,
ct_max.population AS poblacion_ciudad_mas_grande,
ct_max.name AS nombre_ciudad_mas_grande

FROM (
-- 1. Calculamos los valores de referencia por continente una sola vez
SELECT
co.continent,
MAX(co.surfacearea) AS max_surf,
MIN(co.surfacearea) AS min_surf,
MAX(ci.population) AS max_city_pop
FROM country co
LEFT JOIN city ci ON co.code = ci.countrycode
GROUP BY co.continent
) stats
-- 2. "Pescamos" el nombre del país más grande
JOIN country c_max ON stats.continent = c_max.continent AND stats.max_surf = c_max.surfacearea
-- 3. "Pescamos" el nombre del país más pequeño
JOIN country c_min ON stats.continent = c_min.continent AND stats.min_surf = c_min.surfacearea
-- 4. "Pescamos" los datos de la ciudad más poblada del continente
JOIN city ct_max ON stats.max_city_pop = ct_max.population
JOIN country co_city ON ct_max.countrycode = co_city.code AND stats.continent = co_city.continent;

Para manejar los empates en tu consulta (donde varios países tienen la misma superficie mínima), tienes tres enfoques principales dependiendo de si quieres ver a todos los "ganadores" o solo a uno.
Como indica el material de estudio, el comportamiento por defecto de los JOINs es devolver todas las filas que cumplan la condición
. Aquí te muestro cómo adaptarlo:
1. Opción por defecto: Mostrar todos los empates
Tal como tienes la consulta ahora, si hay dos países con la misma superficie mínima, el JOIN country c_min encontrará dos coincidencias para ese continente y mostrará ambos en filas separadas. No necesitas cambiar nada si quieres este comportamiento
.
2. Mostrar solo uno de los países empatados (ONLY)
Si quieres que aparezca estrictamente un solo país por continente, incluso si hay un empate técnico, debes usar la cláusula FETCH FIRST (disponible en Oracle 12c+). Para aplicarlo a tu estructura, lo más limpio es usar una subconsulta correlacionada específica para ese campo en lugar de un JOIN masivo:
SELECT 
    stats.continent, 
    -- Seleccionamos solo el primer nombre encontrado tras ordenar
    (SELECT name FROM country c2 
     WHERE c2.continent = stats.continent AND c2.surfacearea = stats.min_surf
     ORDER BY name ASC -- Criterio de desempate por orden alfabético
     FETCH FIRST 1 ROWS ONLY) AS pequeno,
    c_max.name AS grande, 
    ct_max.population AS poblacion_ciudad_mas_grande
FROM (
    SELECT co.continent, MAX(co.surfacearea) AS max_surf,
           MIN(co.surfacearea) AS min_surf, MAX(ci.population) AS max_city_pop
    FROM country co
    LEFT JOIN city ci ON co.code = ci.countrycode
    GROUP BY co.continent
) stats
JOIN country c_max ON stats.continent = c_max.continent AND stats.max_surf = c_max.surfacearea
JOIN city ct_max ON stats.max_city_pop = ct_max.population;
--3. Garantizar la equidad con WITH TIES
--Si quieres limitar el resultado pero te parece importante que, si hay un empate en el tamaño mínimo, aparezcan todos los que comparten ese récord, la instrucción adecuada es WITH TIES
--.
--Diferencia clave: Mientras que ONLY corta la lista de forma arbitraria en el número indicado, WITH TIES incluye a todos los registros que tengan el mismo valor que el último registro permitido por el corte
--.
--4. Alternativa para versiones antiguas (ROWNUM)
--Si trabajas en una versión de Oracle donde no existe FETCH FIRST, la forma de "forzar" que solo salga un país pequeño es añadir un filtro de ROWNUM = 1 dentro de una subconsulta escalar en el SELECT
--. Esto evita que la consulta principal falle si la búsqueda del país más pequeño devuelve más de un registro por accidente
--.
--Recomendación: En informes de geografía, lo más profesional suele ser la Opción 1 (dejar que el JOIN muestre a todos los empatados) o usar WITH TIES, ya que omitir un país que mide exactamente lo mismo que otro podría considerarse un error en los datos del reporte
--.
--esta consulta de hr esta bien?
--

--4. Devuelve un listado con nombre del departamento, nombre del empleado y salario para
--todos los empleados que ganen más que la media de su departamento.
SELECT stat.DEPARTMENT_NAME, e.FIRST_NAME, e.SALARY
FROM (
SELECT d2.DEPARTMENT_ID, d2.DEPARTMENT_NAME, avg(e2.SALARY) as sal_media
FROM DEPARTMENTS d2
JOIN EMPLOYEES e2 ON e2.DEPARTMENT_ID = d2.DEPARTMENT_ID
group by d2.DEPARTMENT_ID, d2.DEPARTMENT_NAME
) stat
JOIN EMPLOYEES e ON e.DEPARTMENT_ID = stat.DEPARTMENT_ID and e.SALARY > stat.sal_media;

Tu consulta es totalmente correcta y sigue una de las mejores prácticas para este tipo de problemas: utilizar una subconsulta en la cláusula FROM (también conocida como vista en línea)
.
Esta técnica es especialmente recomendada cuando necesitas mezclar datos de detalle (el nombre y salario de cada empleado) con datos agrupados (la media de cada departamento), ya que permite al motor de la base de datos calcular las medias una sola vez y luego simplemente compararlas
.
¿Se puede simplificar?
Tu consulta ya es eficiente, pero podrías hacerla un poco más limpia. Actualmente, estás uniendo la tabla DEPARTMENTS dos veces (una dentro de la subconsulta y otra implícitamente al agrupar). Puedes simplificar el "agregado" calculando las medias solo con la tabla EMPLOYEES y dejar el nombre del departamento para el JOIN final:
SELECT d.department_name, e.first_name, e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN (
    -- Solo calculamos las medias por ID de departamento
    SELECT department_id, AVG(salary) AS sal_media
    FROM employees
    GROUP BY department_id
) stat ON e.department_id = stat.department_id
WHERE e.salary > stat.sal_media;
Mejoras aplicadas:
Eficiencia: La subconsulta stat ahora es más ligera porque no tiene que hacer un JOIN con la tabla de departamentos; solo recorre la tabla de empleados
.
Legibilidad: Separas la lógica de "cálculo de estadísticas" de la lógica de "obtención de nombres descriptivos".

--------------------------------------------------------------------------------
Una alternativa: La subconsulta correlacionada
Si prefieres un código más corto (aunque a veces menos eficiente en tablas muy grandes), puedes usar una subconsulta correlacionada en el WHERE
:
SELECT d.department_name, e.first_name, e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);
Análisis de esta versión:
Funcionamiento: Por cada empleado de la consulta principal, la subconsulta calcula "al vuelo" el promedio de su departamento específico y lo compara
.
Uso: Es muy fácil de leer y entender, pero para miles de empleados, la versión que tú escribiste (usando el JOIN con la media precalculada) suele tener un mejor rendimiento
.
En resumen: Tu enfoque original es excelente y profesional. Solo la simplificaría quitando el JOIN interno de la subconsulta para que sea más "atómica".
quiero agregarle a la siguiente consulta una columna que cuente el numero de empleados que su salario supera la media de su departamento


SELECT d.DEPARTMENT_NAME,
COUNT(
    case when 
        e.salary > (select avg(e3.salary) from employees e3) 
    then 1 end
) as encima_media_empresa,
count(
    case when 
        e.salary > (select avg(e4.salary) from employees e4
                    where e4.department_id = d.department_id)
    then 1 end
) as encima_media_departamento
FROM DEPARTMENTS d
JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
GROUP BY d.DEPARTMENT_NAME, d.DEPARTMENT_NAME
HAVING AVG(e.SALARY) > (
SELECT AVG(e2.SALARY)
FROM EMPLOYEES e2
);

select * 
from employees e 
join departments d on  d.department_id = e.department_id
where d.department_name like 'Public%';


SELECT 
    d.DEPARTMENT_NAME,
    -- 1. Empleados que superan la media GLOBAL de la empresa
    COUNT(CASE WHEN e.SALARY > (SELECT AVG(salary) FROM employees) THEN 1 END) as encima_media_empresa,
    -- 2. NUEVA COLUMNA: Empleados que superan la media de su PROPIO departamento
    COUNT(CASE WHEN e.SALARY > (SELECT AVG(e2.salary) 
                                FROM employees e2 
                                WHERE e2.department_id = d.department_id) THEN 1 END) as encima_media_depto
FROM DEPARTMENTS d 
JOIN EMPLOYEES e ON e.DEPARTMENT_ID = d.department_id
GROUP BY d.department_id, d.DEPARTMENT_NAME
HAVING AVG(e.SALARY) > (SELECT AVG(salary) FROM employees);
--11 Haz un listado que me de los trabajos que cumplan que la suma de los sueldos de los
--empleados de ese trabajo es superior a la suma de salario de los empleados que trabajan de
--IT_PROG. En el listado quiero ver descripción del trabajo, suma de salario de los trabajadores y
--fecha de contratación del empleado más antiguo que desempeña ese trabajo.
SELECT j.JOB_TITLE, sum(e.salary), min(e.HIRE_DATE)
FROM JOBS j 
JOIN EMPLOYEES e ON e.JOB_ID = j.JOB_ID
GROUP BY j.JOB_ID, j.JOB_TITLE
HAVING SUM(e.SALARY) > (
    SELECT SUM(e2.SALARY)
    FROM EMPLOYEES e2
    WHERE e2.JOB_ID = 'IT_PROG'
);


--12 (difícil) Haz un listado que me de el nombre y salario de un empleado y la diferencia salarial
--que tiene con la media del salario de los empleados que son jefes, pero sin considerar a su
--propio jefe.
--1

SELECT e.FIRST_NAME, e.SALARY,
         + ROUND(
                (
                SELECT AVG(E2.SALARY)
                FROM EMPLOYEES E2
                INNER JOIN DEPARTMENTS D2 ON D2.DEPARTMENT_ID = E2.DEPARTMENT_ID
                WHERE E2.EMPLOYEE_ID = D2.MANAGER_ID
                AND D2.MANAGER_ID <> E.MANAGER_ID
                ),2) - E.SALARY  AS DIFERENCIA_CON_JEFES
FROM EMPLOYEES e

 ;

SELECT 
    e.first_name, 
    e.salary,
    -- Calculamos la diferencia con la media de los "otros" jefes
    ROUND(e.salary - (
        SELECT AVG(m.salary)
        FROM employees m
        WHERE m.employee_id IN (SELECT DISTINCT manager_id FROM employees WHERE manager_id IS NOT NULL)
          AND m.employee_id != NVL(e.manager_id, -1)
    ), 2) AS diferencia_media_jefes
FROM employees e;