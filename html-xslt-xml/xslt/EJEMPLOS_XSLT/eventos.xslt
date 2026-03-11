<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version=”1.0”>
	<xsl:output method="html" encoding="ISO-8859-1"/>	
	<xsl:template match="/contenido/eventos/evento">
		<h2><xsl:value-of select=”titulo”/></h2>
		<h3>(<xsl:value-of select="fecha_evento"/>)</h3>
		<p><xsl:value-of select="descripcion"/></p>
		<hr />
	</xsl:template>

	<xsl:template match="/contenido/noticias">
	</xsl:template>
</xsl:stylesheet>

