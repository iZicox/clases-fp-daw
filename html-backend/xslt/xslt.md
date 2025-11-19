Claro, aquí tienes las soluciones para ambas partes del ejercicio.

a. Hoja de estilo XSLT para generar un documento HTML con:
Título del navegador = contenido de <titulo>
Cuerpo: <h1> con el título, seguido de <h3> con la descripción
xsl


1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="test1/titulo"/></title>
      </head>
      <body>
        <h1><xsl:value-of select="test1/titulo"/></h1>
        <h3><xsl:value-of select="test1/descripcion"/></h3>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
b. Hoja de estilo XSLT para que en el documento de salida aparezca:
Primero: contenido de <fecha> con formato <h3>
Luego: contenido de <titulo> con formato <h2>
xsl


1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Documento transformado</title>
      </head>
      <body>
        <h3><xsl:value-of select="test1/fecha"/></h3>
        <h2><xsl:value-of select="test1/titulo"/></h2>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
Explicación breve:
Ambas hojas usan <xsl:template match="/"> para procesar el nodo raíz.
xsl:value-of select="..." extrae el texto de los elementos XML.
La etiqueta <xsl:output method="html"/> asegura que la salida sea HTML válido.
En (a), el título del navegador se toma del elemento <titulo> y se muestra también como <h1> en el cuerpo.
En (b), se cambia el orden y los encabezados: primero <h3> con la fecha, luego <h2> con el título.
Ambas hojas son compatibles con XSLT 1.0 y funcionarán con el XML proporcionado.

✅ ¡Listo!

explicame linea por linea todo lo que usas en el xlts para el ejercicio

profile
Qwen3-Max
5:11 pm
¡Claro! Vamos a explicar línea por línea una de las hojas de estilo XSLT (por ejemplo, la parte a), ya que ambas son muy similares. Al final también haré un breve comentario sobre las diferencias con la parte b.

📄 Hoja de estilo XSLT – Parte (a)
xsl


1
<?xml version="1.0" encoding="ISO-8859-1"?>
🔹 Explicación:
Esta es la declaración XML estándar. Indica que el documento es XML versión 1.0 y usa la codificación de caracteres ISO-8859-1 (también conocida como Latin-1). Aunque hoy en día se suele usar UTF-8, aquí se respeta lo que probablemente aparece en el ejemplo del ejercicio o en el entorno académico.

xsl


1
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
🔹 Explicación:
Esta línea abre el documento XSLT.

version="1.0": indica que usamos XSL Transformations versión 1.0 (la más común y compatible).
xmlns:xsl="http://www.w3.org/1999/XSL/Transform": define el espacio de nombres (namespace) para los elementos XSLT. Sin esto, el procesador no reconocería etiquetas como <xsl:template> o <xsl:value-of>.
xsl


1
<xsl:output method="html" indent="yes"/>
🔹 Explicación:
Define cómo se generará la salida del documento transformado.

method="html": indica que la salida será HTML, no XML ni texto plano. Esto afecta cómo se serializan ciertas etiquetas (por ejemplo, <br> no necesita cierre en HTML).
indent="yes": le pide al procesador que formatee con sangrías la salida para que sea más legible (útil para depuración; en producción a veces se omite).
xsl


1
<xsl:template match="/">
🔹 Explicación:
Define una plantilla (template) que se aplica al nodo raíz del documento XML (/ representa la raíz del árbol XML, no el primer elemento).
Esta es la plantilla principal: es la entrada al proceso de transformación.

xsl


1
<html>
🔹 Explicación:
Empieza a escribir HTML literal en la salida. Todo lo que no está dentro de etiquetas <xsl:...> se copia tal cual al resultado.

xsl


1
<head>
🔹 Explicación:
Abre la sección <head> del HTML, que contiene metadatos como el título de la pestaña del navegador.

xsl


1
<title><xsl:value-of select="test1/titulo"/></title>
🔹 Explicación:

<title>: etiqueta HTML que define el título que se muestra en la pestaña del navegador.
<xsl:value-of select="test1/titulo"/>:
xsl:value-of extrae el valor de texto de un nodo del XML.
select="test1/titulo": es una expresión XPath que dice:
“Desde la raíz, ve al elemento <test1>, y dentro de él, selecciona el elemento <titulo>”. 
📌 Suponiendo que tu XML es algo como:
xml


1
2
3
4
5
⌄
<test1>
  <titulo>Ejemplo de título</titulo>
  <descripcion>Esta es una descripción</descripcion>
  <fecha>2025-11-20</fecha>
</test1>
Entonces test1/titulo devuelve "Ejemplo de título".
xsl


1
</head>
🔹 Explicación:
Cierra la sección <head>.

xsl


1
<body>
🔹 Explicación:
Abre el cuerpo del documento HTML.

xsl


1
<h1><xsl:value-of select="test1/titulo"/></h1>
🔹 Explicación:
Crea un encabezado de nivel 1 (<h1>) con el mismo título del XML.
Esto muestra el título en grande al inicio del cuerpo del documento.

xsl


1
<h3><xsl:value-of select="test1/descripcion"/></h3>
🔹 Explicación:
Crea un encabezado de nivel 3 (<h3>) con el contenido del elemento <descripcion> del XML, usando la misma lógica de XPath: test1/descripcion.

xsl


1
</body>
🔹 Explicación:
Cierra el <body>.

xsl


1
</html>
🔹 Explicación:
Cierra el documento HTML.

xsl


1
</xsl:template>
🔹 Explicación:
Cierra la plantilla principal que empezamos con <xsl:template match="/">.

xsl


1
</xsl:stylesheet>
🔹 Explicación:
Cierra el documento XSLT.

✅ Resumen de conceptos usados:
<?xml ...?>
Declaración XML
<xsl:stylesheet>
Raíz de la hoja XSLT
xmlns:xsl
Namespace obligatorio para usar XSLT
<xsl:output>
Controla cómo se genera la salida
<xsl:template match="/">
Plantilla principal que procesa todo el XML
<xsl:value-of select="..."/>
Extrae texto de un nodo usando XPath
test1/titulo
Expresión XPath: "hijo
titulo
de
test1
"
HTML literal
Todo lo que no es XSLT se copia directamente

🔁 ¿Y la parte (b)?
Es casi idéntica, solo cambian dos cosas:

El orden de los elementos en el <body>:
xsl


1
2
<h3><xsl:value-of select="test1/fecha"/></h3>
<h2><xsl:value-of select="test1/titulo"/></h2>
El <title> del HTML ya no depende del XML, sino que es fijo: "Documento transformado".
Pero la estructura, sintaxis y mecanismos son los mismos.

¿Quieres que también explique la parte (b) línea por línea? ¿O tienes dudas sobre el XML de entrada?