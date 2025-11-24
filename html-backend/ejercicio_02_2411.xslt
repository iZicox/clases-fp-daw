<!-- /*
<?xml version="1.0" encoding="ISO-8859-1"?>
<ciudades>
    <ciudad>
        <nombre>Madrid</nombre>
        <habitantes>3500000</habitantes>
    </ciudad>
    <ciudad>
        <nombre>Málaga</nombre>
        <habitantes>800000</habitantes>
    </ciudad>
    <ciudad>
        <nombre>Toledo</nombre>
        <habitantes>50000</habitantes>
    </ciudad>
</ciudades>

resultado

<?xml version="1.0" encoding="ISO-8859-1"?>
<html>
<head>
    <title>Ejemplo XSLT</title>
</head>
<body>
    <h2>Madrid</h2>
    <h2>Málaga</h2>
    <h2>Toledo</h2>
</body>
</html>
*/
-->

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <table border="1">
            <tr>
                <th>Ciudad</th>
                <th>Habitantes</th>
            </tr>
            <xsl:for-each select="ciudades/ciudad">
            <xsl:sort select="nombre" order="descending"/>
            <tr>
                <td><xsl:value-of select="nombre"/></td>
                <td><xsl:value-of select="habitantes"/></td>
            </tr>
            </xsl:for-each>
        </table>
    </xsl:template>

</xsl:stylesheet>