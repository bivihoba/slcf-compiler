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
				exclude-result-prefixes="a b e x d p m t alxc"
				extension-element-prefixes="exsl">

	<!--<xsl:template match="*" mode="blocks-index">-->
		<!--<xsl:apply-templates select="//page-canvas" mode="decl"/>-->
	<!--</xsl:template>-->

	<xsl:template match="*" mode="decl"/>

	<xsl:template match="b:* | e:* | a:*" mode="decl">
		<xsl:apply-templates select="." mode="decl__self"/>
		<xsl:apply-templates mode="decl"/>
	</xsl:template>

	<xsl:template match="m:*" mode="decl">
		<xsl:apply-templates select="." mode="decl__self"/>
	</xsl:template>

		<xsl:template match="*" mode="decl__self"/>

		<xsl:template match="b:* | m:* | a:*" mode="decl__self">
			<xsl:element name="bem-entity">
				<xsl:attribute name="type">
					<xsl:apply-templates select="." mode="decl__block-type"/>
				</xsl:attribute>
				<xsl:attribute name="block">
					<xsl:apply-templates select="." mode="decl__block-name"/>
				</xsl:attribute>
				<xsl:apply-templates select="." mode="decl__self-attrs"/>
			</xsl:element>
		</xsl:template>

		<xsl:template match="e:* | m:*[@element]" mode="decl__self">
			<xsl:element name="bem-entity">
				<xsl:attribute name="type">
					<xsl:apply-templates select="." mode="decl__block-type"/>
				</xsl:attribute>
				<xsl:attribute name="block">
					<xsl:apply-templates select="." mode="decl__block-name"/>
				</xsl:attribute>
				<xsl:attribute name="element">
					<xsl:apply-templates select="." mode="decl__element-name"/>
				</xsl:attribute>
				<xsl:apply-templates select="." mode="decl__self-attrs"/>
			</xsl:element>
		</xsl:template>

			<xsl:template match="*" mode="decl__self-attrs">
			</xsl:template>

			<xsl:template match="m:*" mode="decl__self-attrs">
				<xsl:attribute name="modificator">
					<xsl:apply-templates select="." mode="decl__modificator-name"/>
				</xsl:attribute>
			</xsl:template>

			<xsl:template match="m:*[@val]" mode="decl__self-attrs">
				<xsl:attribute name="modificator">
					<xsl:apply-templates select="." mode="decl__modificator-name"/>
				</xsl:attribute>
				<xsl:attribute name="modificator-value">
					<xsl:apply-templates select="." mode="decl__modificator-value"/>
				</xsl:attribute>
			</xsl:template>

				<xsl:template match="*" mode="decl__block-type"/>

				<xsl:template match="b:*" mode="decl__block-type">
					<xsl:value-of select="'block'"/>
				</xsl:template>

				<xsl:template match="e:*" mode="decl__block-type">
					<xsl:value-of select="'element'"/>
				</xsl:template>

				<xsl:template match="m:*" mode="decl__block-type">
					<xsl:value-of select="'modificator'"/>
				</xsl:template>

				<xsl:template match="a:*" mode="decl__block-type">
					<xsl:value-of select="'block'"/>
				</xsl:template>

				<xsl:template match="a:*[@block-of]" mode="decl__block-type">
					<xsl:value-of select="'element'"/>
				</xsl:template>

				<xsl:template match="*" mode="decl__block-name"/>

				<xsl:template match="b:*" mode="decl__block-name">
					<xsl:value-of select="local-name()"/>
				</xsl:template>

				<xsl:template match="*" mode="decl__element-name"/>

				<xsl:template match="e:*" mode="decl__element-name">
					<xsl:value-of select="local-name()"/>
				</xsl:template>

				<xsl:template match="m:*" mode="decl__element-name">
					<xsl:value-of select="@element"/>
				</xsl:template>

				<xsl:template match="e:* | m:* | a:*" mode="decl__block-name">
					<xsl:value-of select="@block"/>
				</xsl:template>

				<xsl:template match="*" mode="decl__modificator-name"/>
				<xsl:template match="m:*" mode="decl__modificator-name">
					<xsl:value-of select="local-name()"/>
				</xsl:template>

				<xsl:template match="*" mode="decl__modificator-value"/>
				<xsl:template match="m:*" mode="decl__modificator-value">
					<xsl:value-of select="@val"/>
				</xsl:template>


</xsl:stylesheet>
