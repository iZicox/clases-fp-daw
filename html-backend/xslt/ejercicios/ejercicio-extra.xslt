<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
   <html lang="en">
   <head>
      <meta charset="UTF-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
      <title>Catalogo</title>
   </head>
   <body>
      <h1>Catalogo de hobbies</h1>
      <div>
         <xsl:for-each select="hobbies">
            <xsl:apply-templates select="hobby"/>
         </xsl:for-each>
      </div>
   </body>   </html>
</xsl:template>

<xsl:template match="hobby">
   <h2><xsl:value-of select="name"></xsl:value-of></h2>
   <p><xsl:value-of select="description"></xsl:value-of></p>
   <p><strong>Popularity: </strong><xsl:value-of select="popularity"></xsl:value-of></p>
   <p><strong>Difficulty: </strong><xsl:value-of select="./@difficulty"></xsl:value-of></p>
</xsl:template>
</xsl:stylesheet>


<!--
https://www.eniun.com/ejercicios-xslt-practicas-resueltas-examenes-ejemplo/#22_Examen_XSLT_Catalogo_de_hobbies
-->
<!-- xml -->
<!--
<?xml version="1.0" encoding="UTF-8"?>
<hobbies>
  <hobby difficulty="Moderate">
    <name>Photography</name>
    <description>Capturing moments through the lens of a camera, exploring the art of visual storytelling.</description>
    <popularity>High</popularity>
  </hobby>
  <hobby difficulty="Easy">
    <name>Gardening</name>
    <description>Cultivating plants and creating a beautiful outdoor space for relaxation and enjoyment.</description>
    <popularity>Moderate</popularity>
  </hobby>
  <hobby difficulty="Moderate">
    <name>Board Games</name>
    <description>Engaging in strategic and social tabletop games with friends and family.</description>
    <popularity>High</popularity>
  </hobby>
  <hobby>
    <name>Reading</name>
    <description>Exploring imaginary worlds through books, a relaxing and enriching pastime.</description>
    <popularity>Moderate</popularity>
  </hobby>
  <hobby difficulty="Difficult">
    <name>Hiking</name>
    <description>Exploring nature trails, enjoying outdoor adventures, and staying active.</description>
    <popularity>High</popularity>
  </hobby>
</hobbies>
-->
<!-- salida -->
<!--
<html>
   <head>
      <title>Catalog of Hobbies</title>
   </head>
   <body>
      <h1>Catalog of Hobbies</h1>
      <div class="hobby">
         <h2>Photography</h2>
         <p>Capturing moments through the lens of a camera, exploring the art of visual storytelling.</p>
         <p>Popularity: High</p>
         <p>Difficulty: Moderate</p>
      </div>
      <div class="hobby">
         <h2>Gardening</h2>
         <p>Cultivating plants and creating a beautiful outdoor space for relaxation and enjoyment.</p>
         <p>Popularity: Moderate</p>
         <p>Difficulty: Easy</p>
      </div>
      <div class="hobby">
         <h2>Board Games</h2>
         <p>Engaging in strategic and social tabletop games with friends and family.</p>
         <p>Popularity: High</p>
         <p>Difficulty: Moderate</p>
      </div>
      <div class="hobby">
         <h2>Reading</h2>
         <p>Exploring imaginary worlds through books, a relaxing and enriching pastime.</p>
         <p>Popularity: Moderate</p>
      </div>
      <div class="hobby">
         <h2>Hiking</h2>
         <p>Exploring nature trails, enjoying outdoor adventures, and staying active.</p>
         <p>Popularity: High</p>
         <p>Difficulty: Difficult</p>
      </div>
   </body>
</html>
-->


<!-- XSLT -->
