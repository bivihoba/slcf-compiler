<!DOCTYPE xsl:stylesheet [
<!ENTITY % core SYSTEM "s.dtd"> %core;
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
				xmlns:un="http://slcf/templates/settings/bem-scheme/unknown-namespace"
				xmlns:alxc="http://slcf/templates/settings/bem-scheme/additional-legacy-xhtml-class"
				xmlns:exsl="http://exslt.org/common"
				exclude-result-prefixes="a b e x d p m t alxc un"
				extension-element-prefixes="exsl">

	<xsl:import href="template.xsl" />

	<xsl:import href="cdata.xsl"/>
	<xsl:import href="comments.xsl" />
	<xsl:import href="content.xsl" />
	<xsl:import href="tests.xsl" />

<xsl:output method="xml"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
	omit-xml-declaration="yes"
	encoding="UTF-8"
	indent="yes"
	/>
<xsl:template match="page" xml:space="preserve"><xsl:apply-templates select="page-canvas" /></xsl:template>

</xsl:stylesheet>
