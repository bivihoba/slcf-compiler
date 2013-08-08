<xsl:stylesheet version="1.0"
				xmlns="http://www.w3.org/1999/xhtml"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="cdata">
	<xsl:value-of select="." disable-output-escaping="yes" />
</xsl:template>

<xsl:template match="cdata[@type = 'comment']">
	<xsl:comment>
		<xsl:value-of select="." disable-output-escaping="yes" />
	</xsl:comment>
</xsl:template>

<xsl:template match="*" mode="cdata">
	<xsl:value-of select="." disable-output-escaping="yes" />
</xsl:template>
	
</xsl:stylesheet>