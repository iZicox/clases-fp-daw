<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet 	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0">
	<xsl:output method="html" encoding="ISO-8859-1"/>	
	<xsl:template match="/contenido/eventos/evento">

	<xsl:choose>
		<xsl:when test="@opcional='no'">
			<xsl:apply-templates select="titulo"/>
				<h3>(Evento número:<xsl:value-of select="@id_evento"/>)</h3>
			<hr />
		</xsl:when>
		<xsl:when test="@opcional='yes'">
			<xsl:apply-templates select="titulo"/>
				<h3>Evento opcional</h3>
			<hr />
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="titulo"/>
			<p>Evento sin parámetro opcional o con valor erróneo</p>
			<hr />
		</xsl:otherwise>
	</xsl:choose>

	</xsl:template>
	<xsl:template match="titulo">
		<h2><xsl:value-of select="."/></h2>
	</xsl:template>
	
	<xsl:template match="/contenido/noticias">
	</xsl:template>
</xsl:stylesheet>
