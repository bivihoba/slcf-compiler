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

	<!--<xsl:template match="*" mode="clean-decl"/>-->

	<xsl:template match="*[
							@type = 'block' and
							not(preceding-sibling::node()[@type='block' and @block=current()/@block])
							]" mode="clean-decl">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="*[
							@type = 'element' and
							not(preceding-sibling::node()[@type='element' and @block=current()/@block and @element=current()/@element])
							]" mode="clean-decl">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="*[
							@type = 'modifier' and
							@modifier-value and
							not(@element) and
							not(preceding-sibling::node()[
															@type='modifier' and
															@block=current()/@block and
															@modifier=current()/@modifier and
															@modifier-value=current()/@modifier-value
															])
							]" mode="clean-decl">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="*[
							@type = 'modifier' and
							not(@modifier-value) and
							not(@element) and
							not(preceding-sibling::node()[
															@type='modifier' and
															@block=current()/@block and
															@modifier=current()/@modifier and
															not(@modifier-value)
															])
							]" mode="clean-decl">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="*[
							@type = 'modifier' and
							@modifier-value and
							@element and
							not(preceding-sibling::node()[
															@type='modifier' and
															@block=current()/@block and
															@element=current()/@element and
															@modifier=current()/@modifier and
															@modifier-value=current()/@modifier-value
															])
							]" mode="clean-decl">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="*[
							@type = 'modifier' and
							not(@modifier-value) and
							@element and
							not(preceding-sibling::node()[
															@type='modifier' and
															@block=current()/@block and
															@element=current()/@element and
															@modifier=current()/@modifier and
															not(@modifier-value)
															])
							]" mode="clean-decl">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="* | text()" mode="decl"/>

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

		<xsl:template match="e:* | m:*[@element] | a:*[@block-of]" mode="decl__self">
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
				<xsl:attribute name="modifier">
					<xsl:apply-templates select="." mode="decl__modifier-name"/>
				</xsl:attribute>
			</xsl:template>

			<xsl:template match="m:*[@val]" mode="decl__self-attrs">
				<xsl:attribute name="modifier">
					<xsl:apply-templates select="." mode="decl__modifier-name"/>
				</xsl:attribute>
				<xsl:attribute name="modifier-value">
					<xsl:apply-templates select="." mode="decl__modifier-value"/>
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
					<xsl:value-of select="'modifier'"/>
				</xsl:template>

				<xsl:template match="a:*" mode="decl__block-type">
					<xsl:value-of select="'block'"/>
				</xsl:template>

				<xsl:template match="a:*[@block-of]" mode="decl__block-type">
					<xsl:value-of select="'element'"/>
				</xsl:template>

				<xsl:template match="*" mode="decl__block-name"/>

				<xsl:template match="b:* | a:*" mode="decl__block-name">
					<xsl:value-of select="local-name()"/>
				</xsl:template>

				<xsl:template match="*" mode="decl__element-name"/>

				<xsl:template match="e:*" mode="decl__element-name">
					<xsl:value-of select="local-name()"/>
				</xsl:template>

				<xsl:template match="a:*" mode="decl__element-name">
					<xsl:value-of select="local-name()"/>
				</xsl:template>

				<xsl:template match="m:*" mode="decl__element-name">
					<xsl:value-of select="@element"/>
				</xsl:template>

				<xsl:template match="e:* | m:*" mode="decl__block-name">
					<xsl:value-of select="@block"/>
				</xsl:template>
				<xsl:template match="a:*[@block-of]" mode="decl__block-name">
					<xsl:value-of select="@block-of"/>
				</xsl:template>

				<xsl:template match="*" mode="decl__modifier-name"/>
				<xsl:template match="m:*" mode="decl__modifier-name">
					<xsl:value-of select="local-name()"/>
				</xsl:template>

				<xsl:template match="*" mode="decl__modifier-value"/>
				<xsl:template match="m:*" mode="decl__modifier-value">
					<xsl:value-of select="@val"/>
				</xsl:template>


</xsl:stylesheet>
