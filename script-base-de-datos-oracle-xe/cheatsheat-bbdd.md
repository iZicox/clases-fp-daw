# round

redondeo al numero de decimales deseado, si no queremos decimales quitamos el 1
si es -1 redondea a la decena mas cercana
ROUND([columna],1) 

# trunc

elimina los decimales que tenga sin redondear
si colocas un numero te deja esos decimales

SELECT TRUNC(123.456, 2) FROM DUAL;
Resultado: 123.45

# order by
SELECT * FROM COUNTRY c ORDER BY c.CONTINENT ASC, c.POPULATION DESC;

- ORDER BY [columna] ASC/DESC;

se le puede agregar varios argumentos separados por coma

- ORDER BY [columna] ASC, [columna2] DESC;

# rownum

si quieres var las primeras x filas de una consulta
rownum < x;
SELECT * FROM COUNTRY c WHERE rownum <= 5;

# buscar un dato especifico

si buscamos un dato especifico podemor decir

= 'Dato' esto mostrara solo los que en ese campo tengan esa cadena

para evitar conflicto con mayusculas podemos pasar el daro primeor a minuscuka

SELECT * FROM COUNTRY c WHERE lower(GOVERNMENTFORM) = 'republic';

la forma normal
SELECT * FROM COUNTRY c WHERE c.CONTINENT = 'Asia';

# substr
Asi accedemos a la primera letra que cumpla la condicion
SUBSTR(c.NAME ,1,1) = 'A'

el primer numero selecciona el caracter y el segundo cuantos caracteres contamos desde el que seleccionamos
aqui se puede usar numeros negativos