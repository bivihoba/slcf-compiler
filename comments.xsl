<xsl:stylesheet version="1.0"
				xmlns="http://www.w3.org/1999/xhtml"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- Example -->
<!-- .b-header -->
<!-- /.b-header -->

<xsl:template name="html-comment_open">
	<xsl:param name="name" select="''" />
	<xsl:comment><xsl:value-of select="concat(' .',$name,' ')"/></xsl:comment>
</xsl:template>
<xsl:template name="html-comment_close">
	<xsl:param name="name" select="''" />
	<xsl:comment><xsl:value-of select="concat(' /.',$name,' ')"/></xsl:comment>
</xsl:template>
</xsl:stylesheet>