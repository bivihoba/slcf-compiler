<!DOCTYPE xsl:stylesheet [
<!ENTITY % core SYSTEM "../../settings/s.dtd"> %core;
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

		<xsl:template match="test-inline-xmlns | test-gds-xmlns" mode="data" xml:space="preserve">
			<xsl:apply-templates select="." mode="data_tests"/>
		</xsl:template>

		<xsl:template match="test-inline-xmlns" mode="data_tests" xml:space="preserve">
			<b:test-block xmlns:v="http://rdf.data-vocabulary.org/#">
				Inline dynamic xmlns
			</b:test-block>
		</xsl:template>

		<xsl:template match="test-gds-xmlns" mode="data_tests" xml:space="preserve">
			<b:test-block-with-xmlns>
				GDS dynamic xmlns
			</b:test-block-with-xmlns>
		</xsl:template>


</xsl:stylesheet>