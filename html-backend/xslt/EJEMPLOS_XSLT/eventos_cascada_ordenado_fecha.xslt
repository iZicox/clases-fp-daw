<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">
	<xsl:output method="html" encoding="ISO-8859-1"/>	
	<xsl:template match="/">
		<xsl:apply-templates select="contenido/eventos/evento">
 			<xsl:sort select="fecha_evento" order="descending"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="/contenido/eventos/evento">
		<xsl:apply-templates select="titulo"/>
		<xsl:apply-templates select="fecha_evento"/>
		<xsl:apply-templates select="descripcion"/>
		<hr />
	</xsl:template>
	<xsl:template match="titulo">
		<h2><xsl:value-of select="."/></h2>
	</xsl:template>
	<xsl:template match="fecha_evento">
		<h3>(<xsl:value-of select="."/>)</h3>
	</xsl:template>
	<xsl:template match="descripcion">
		<p><xsl:value-of select="."/></p>
	</xsl:template>


	<xsl:template match="/contenido/noticias">
	</xsl:template>
</xsl:stylesheet>