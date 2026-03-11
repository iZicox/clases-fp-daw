<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">
	<xsl:output method="html" encoding="ISO-8859-1"/>	
	<xsl:template match="/">
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="/contenido/eventos/evento/titulo">
		<h2><xsl:value-of select="."/></h2>
	</xsl:template>
	<xsl:template match="/contenido/eventos/evento/fecha_evento">
		<h3>(<xsl:value-of select="."/>)</h3>
	</xsl:template>
	<xsl:template match="/contenido/eventos/evento/descripcion">
		<p><xsl:value-of select="."/></p>
		<hr />
	</xsl:template>
	<xsl:template match="/contenido/noticias">
	</xsl:template>
</xsl:stylesheet>
