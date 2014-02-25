<!DOCTYPE xsl:stylesheet [
<!ENTITY % core SYSTEM "s.dtd"> %core;
]>
<xsl:stylesheet version="1.0"
				xmlns="http://www.w3.org/1999/xhtml"
				xmlns:html="http://www.w3.org/1999/xhtml"
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
				xmlns:temp="http://slcf/templates/settings/bem-scheme/temp-namespace"
				xmlns:alxc="http://slcf/templates/settings/bem-scheme/additional-legacy-xhtml-class"
				xmlns:exsl="http://exslt.org/common"
				exclude-result-prefixes="a b e x d p m t alxc"
				extension-element-prefixes="exsl">

	<!--
	Thanks to Dimitre Novatchev for the example http://stackoverflow.com/a/4616250
	-->

	<xsl:param name="pBEM_entityAttributes">
		<temp:name>type</temp:name>
		<temp:name>block</temp:name>
		<temp:name>element</temp:name>
		<temp:name>modifier</temp:name>
		<temp:name>modifier-value</temp:name>
	</xsl:param>

	<xsl:variable name="vBEM_entityAttributes" select="document('')/*/xsl:param[@name='pBEM_entityAttributes']"/>

	<xsl:key name="kRecByAtts" match="temp:bem-entity" use="@___bem_key"/>

	<xsl:template match="/" mode="clean-decl">

		<xsl:variable name="vrtdPass1">
			<temp:index>
				<xsl:apply-templates mode="pre-clean-decl"/>
			</temp:index>
		</xsl:variable>
		<xsl:variable name="vPass1" select="exsl:node-set($vrtdPass1)/*"/>

		<xsl:apply-templates select="$vPass1/temp:bem-entity" mode="clean-decl"/>

	</xsl:template>

	<xsl:template match="*" mode="pre-clean-decl">
		<xsl:element name="temp:bem-entity">
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="___bem_key">
				<xsl:for-each select="@*[name()=$vBEM_entityAttributes/temp:name]">
					<xsl:sort select="name()"/>
					<xsl:value-of select="concat('___Attrib___',name(),'___Value___',.,'+++')"/>
				</xsl:for-each>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>

	<xsl:template match="temp:bem-entity " mode="clean-decl">
		<xsl:element name="bem-entity">
		   <xsl:apply-templates select="@*" mode="clean-decl"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="temp:bem-entity[not(generate-id() = generate-id(key('kRecByAtts', @___bem_key)[1]))]"  mode="clean-decl" />
	
	<xsl:template match="@*" mode="clean-decl" >
		<xsl:copy-of select="."/>
	</xsl:template>
	
	<xsl:template match="@___bem_key" mode="clean-decl" />
		
	<!--
		Thanks again :)
	-->	

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
			<xsl:element name="temp:bem-entity">
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
			<xsl:element name="temp:bem-entity">
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
