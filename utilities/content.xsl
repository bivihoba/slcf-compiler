<!DOCTYPE xsl:stylesheet [
<!ENTITY % core SYSTEM "../settings/s.dtd"> %core;
]>
<xsl:stylesheet version="1.0"
				xmlns="http://www.w3.org/1999/xhtml"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:a="http://slcf/templates/settings/bem-scheme/additional"
				xmlns:b="http://slcf/templates/settings/bem-scheme/block"
				xmlns:d="http://slcf/templates/settings/bem-scheme/data"
				xmlns:e="http://slcf/templates/settings/bem-scheme/element"
				xmlns:m="http://slcf/templates/settings/bem-scheme/modification"
				xmlns:p="http://slcf/templates/settings/bem-scheme/pointer"
				xmlns:t="http://slcf/templates/settings/bem-scheme/template"
				xmlns:x="http://slcf/templates/settings/bem-scheme/xhtml"
				xmlns:alxc="http://slcf/templates/settings/bem-scheme/additional-legacy-xhtml-class"
				xmlns:exsl="http://exslt.org/common"
				exclude-result-prefixes="a b e x d p m t alxc"
				extension-element-prefixes="exsl">

	<xsl:import href="content/tests.xsl"/>

	<xsl:template match="d:*" mode="data" xml:space="preserve">
		<xsl:apply-templates select="//data[not(following-sibling::data/*[local-name() = local-name(current())])]/*[local-name() = local-name(current())]" mode="data"/>
	</xsl:template>
	<xsl:template match="*" mode="data"><xsl:apply-imports/></xsl:template>

</xsl:stylesheet>
