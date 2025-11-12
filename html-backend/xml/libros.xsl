<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/libros">
    <html>
      <body>
        <h2>Lista de libros</h2>
        <ul>
          <xsl:for-each select="libro">
            <li>
              <strong><xsl:value-of select="titulo"/></strong> -
              <xsl:value-of select="autor"/> (<xsl:value-of select="anio"/>)
            </li>
          </xsl:for-each>
        </ul>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>