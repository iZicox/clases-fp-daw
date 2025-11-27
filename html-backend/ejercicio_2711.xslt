<!--
<?xml version="1.0" encoding="ISO-8859-1"?>
<horario>
    <dia>
        <numdia>1</numdia>
        <tarea prioridad="media">
            <hora-ini>12</hora-ini>
            <hora-fin>14</hora-fin>
            <nombre>Tutorías</nombre>
        </tarea>
    </dia>
    <dia>
        <numdia>2</numdia>
        <tarea prioridad="alta">
            <hora-ini>12</hora-ini>
            <hora-fin>14</hora-fin>
            <nombre>Autómatas</nombre>
        </tarea>
    </dia>
    <dia>
        <numdia>4</numdia>
        <tarea prioridad="alta">
            <hora-ini>9</hora-ini>
            <hora-fin>11</hora-fin>
            <nombre>Procesadores de lenguajes</nombre>
        </tarea>
        <tarea>
            <hora-ini>16</hora-ini>
            <hora-fin>17</hora-fin>
            <nombre>EDI</nombre>
        </tarea>
    </dia>
    <dia>
        <numdia>3</numdia>
        <tarea prioridad="alta">
            <hora-ini>9</hora-ini>
            <hora-fin>11</hora-fin>
            <nombre>Procesadores de lenguajes</nombre>
        </tarea>
    </dia>
    <dia>
        <numdia>5</numdia>
        <tarea prioridad="baja">
            <hora-ini>17</hora-ini>
            <hora-fin>18</hora-fin>
            <nombre>Ver la tele</nombre>
        </tarea>
    </dia>
</horario>

a. El número de día de los días que aparecen en horario.xml, precedido de la palabra Dia.
b. Las tareas a realizar después del miércoles. Incluir el día (en formato H2), y los nombres de las tareas
(estas en forma de lista html). Cada día se separa del siguiente mediante una línea horizontal.
c. Procesar todos los nodos del documento, mostrando para cada uno de ellos su número de orden
(posición), su nombre (el del nodo) y el número de hijos que contiene. La información se mostrará en
forma de lista en varios niveles.

-->

<!--A-->

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html>
            <head>
                <title>Ejemplo XSLT</title>
            </head>
            <body>
                <ul>
                    <xsl:for-each select="//dia">
                        <li><xsl:value-of select="numdia"/> Dia</li>
                    </xsl:for-each>
                    
                </ul>
            </body>
        </html>
        
    </xsl:template>
    

</xsl:stylesheet>

<!--B-->

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html>
            <head>
                <title>Ejemplo XSLT</title>
            </head>
            <body>                    
                    <xsl:for-each select="//dia">
                        <xsl:if test="numdia &gt; 3">
                            <h2><xsl:value-of select="numdia"/> Dia</h2>
                            <ul>
                                    <xsl:for-each select="tarea">
                                       <li> <xsl:value-of select="nombre"/></li>
                                    </xsl:for-each>        
                            </ul>
                            <hr/>                   
                        </xsl:if>
                    </xsl:for-each>     
            </body>
        </html>    
    </xsl:template>
</xsl:stylesheet>

<!--C-->

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html>
            <head>
                <title>Ejemplo XSLT</title>
            </head>
            <body>                    
                    <xsl:for-each select="//dia">
                        <ul>
                            <li><strong><xsl:value-of select="position()"/> Dia</strong> - Hijos <xsl:value-of select="count(child::*)"/></li>
                            
                                <ul>
                                    <xsl:for-each select="*">
                                        <li><strong><xsl:value-of select="position()"/><xsl:text> </xsl:text><xsl:value-of select="local-name()"/> </strong> - Hijos <xsl:value-of select="count(child::*)"/></li>
                                        <xsl:if test="child::*">
                                            <ul>
                                                <xsl:for-each select="child::*">
                                                    <li><xsl:value-of select="position()"/><xsl:text> </xsl:text><xsl:value-of select="local-name()"/> - Hijos <xsl:value-of select="count(child::*)"/></li>
                                                </xsl:for-each>
                                            </ul>
                                        </xsl:if>
                                    </xsl:for-each>
                                </ul>
                        </ul>
                    </xsl:for-each>     
            </body>
        </html>    
    </xsl:template>
</xsl:stylesheet>
