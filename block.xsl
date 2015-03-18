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
				xmlns:p="http://slcf/templates/settings/bem-scheme/pointer"
				xmlns:m="http://slcf/templates/settings/bem-scheme/modification"
				xmlns:t="http://slcf/templates/settings/bem-scheme/template"
				xmlns:x="http://slcf/templates/settings/bem-scheme/xhtml"
				xmlns:c="child"
				xmlns:un="http://slcf/templates/settings/bem-scheme/unknown-namespace"
				xmlns:alxc="http://slcf/templates/settings/bem-scheme/additional-legacy-xhtml-class"
				xmlns:xlink="http://www.w3.org/1999/xlink"
				xmlns:exsl="http://exslt.org/common"
				exclude-result-prefixes="a b c e x d p m t alxc un"
				extension-element-prefixes="exsl"
		>

	<xsl:variable name="block-namespace" select="'http://slcf/templates/settings/bem-scheme/block'"/>
	<xsl:variable name="element-namespace" select="'http://slcf/templates/settings/bem-scheme/element'"/>
	<xsl:variable name="additional-namespace" select="'http://slcf/templates/settings/bem-scheme/additional'"/>
	<xsl:variable name="xhtml-namespace" select="'&xhtml-namespace;'"/>
	<xsl:variable name="unknown-namespace" select="'&unknown-namespace;'"/>
	<xsl:variable name="prefix" select="'b-'"/>
	<xsl:variable name="s-child" select="'-'"/>
	<xsl:variable name="s-element" select="'__'"/>
	<xsl:variable name="s-mode" select="'_'"/>
	<xsl:variable name="base-path" select="'../../sandbox/code/production/blocks/'"/>
	<xsl:variable name="base-folder" select="'blocks/'"/>

	<xsl:key name="semantic-tag" match="//default-semantic/*" use="local-name()"/>
	<xsl:key name="semantic" match="//default-semantic/*" use="name()"/>

	<xsl:template match="b:* | e:* | a:* | m:* | alxc:*"/>

	<xsl:template match="b:* | e:*">
		<xsl:apply-templates select="." mode="default"/>
	</xsl:template>

	<xsl:template match="b:* | e:*" mode="default">
		<xsl:apply-templates select="." mode="comment"/>
	</xsl:template>

	<xsl:template match="b:* | e:*" mode="comment">
		<xsl:apply-templates select="." mode="tag"/>
	</xsl:template>

	<xsl:template match="b:*[@comment] | e:*[@comment]" mode="comment" xml:space="preserve">
		<xsl:param name="begin-sign" select="' &gt; '"/>
		<xsl:param name="end-sign" select="' &lt; '"/>
		<xsl:comment><xsl:value-of select="concat(' ', @comment, ' ', $begin-sign)" /></xsl:comment>
		<xsl:apply-templates select="." mode="tag"/>
		<xsl:comment><xsl:value-of select="concat(' ', @comment, ' ', $end-sign)" /></xsl:comment>
	</xsl:template>

	<xsl:template match="b:*[ancestor::node()/@tag='a'] |
	 					 e:*[ancestor::node()/@tag='a'] |
	 					 b:*[ancestor::node()[a:*/@tag='a']] |
	 					 e:*[ancestor::node()[a:*/@tag='a']] |
	 					 b:*[ancestor::node()/@tag='span'] |
	 					 e:*[ancestor::node()/@tag='span'] |
	 					 b:*[ancestor::node()/@tag='strong'] |
	 					 e:*[ancestor::node()/@tag='strong'] |
	 					 b:*[ancestor::node()/@tag='small'] |
	 					 e:*[ancestor::node()/@tag='small'] |
	 					 b:*[ancestor::node()/@tag='label'] |
	 					 e:*[ancestor::node()/@tag='label'] |
	 					 b:*[ancestor::node()/@tag='p'] |
	 					 e:*[ancestor::node()/@tag='p'] |
	 					 b:*[ancestor::node()/@tag='h1'] |
	 					 e:*[ancestor::node()/@tag='h1'] |
	 					 b:*[ancestor::node()/@tag='h2'] |
	 					 e:*[ancestor::node()/@tag='h2'] |
	 					 b:*[ancestor::node()/@tag='h3'] |
	 					 e:*[ancestor::node()/@tag='h3'] |
	 					 b:*[ancestor::node()/@tag='h4'] |
	 					 e:*[ancestor::node()/@tag='h4'] |
	 					 b:*[ancestor::node()/@tag='h5'] |
	 					 e:*[ancestor::node()/@tag='h5'] |
	 					 b:*[ancestor::node()/@tag='h6'] |
	 					 e:*[ancestor::node()/@tag='h6'] |
	 					 b:*[ancestor::node()/@tag='dt'] |
	 					 e:*[ancestor::node()/@tag='dt'] |
	 					 b:*[ancestor::node()/@tag='abbr'] |
	 					 e:*[ancestor::node()/@tag='abbr'] |
	 					 e:*[ancestor::node()/@tag='button'] |
	 					 e:*[ancestor::node()/@tag='cite']
	 					 " mode="default">
		<xsl:apply-templates select="." mode="tag">
			<xsl:with-param name="tag" select="'span'" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="b:*[@tag] | e:*[@tag]" mode="default">
		<xsl:apply-templates select="." mode="tag">
			<xsl:with-param name="tag" select="@tag"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="b:*[parent::node()/@tag='ul' or parent::node()/@tag='ol'] |
						 e:*[parent::node()/@tag='ul' or parent::node()/@tag='ol']
						" mode="default">
		<xsl:apply-templates select="." mode="tag">
			<xsl:with-param name="tag" select="'li'" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="e:image[not(@tag)]" mode="default">
		<xsl:apply-templates select="." mode="tag">
			<xsl:with-param name="tag" select="'img'" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="b:* | e:*" mode="tag">
		<xsl:param name="tag" select="'div'"/>
		<xsl:element name="{$tag}">
			<xsl:apply-templates select="." mode="namespace" />
			<xsl:apply-templates select="." mode="attr" />
			<xsl:apply-templates select="." mode="content" />
		</xsl:element>
	</xsl:template>

	<xsl:template match="*" mode="namespace">
		<xsl:copy-of select="namespace::*[not(local-name() = 'b') and not(local-name() = 'e') and not(local-name() = 'm') and not(local-name() = 'x') and not(local-name() = 'alxc')]"/>
		<xsl:copy-of select="a:*/namespace::*[not(local-name() = 'a') and not(local-name() = 'b') and not(local-name() = 'e') and not(local-name() = 'm') and not(local-name() = 'x') and not(local-name() = 'alxc')]"/>
		<xsl:copy-of select="@*[name() = 'xlink:href']"/> <!-- TT -->
	</xsl:template>

	<xsl:template match="*" mode="content"/>

	<xsl:template match="*[not(b:* or e:*) and not(string-length(normalize-space(.)) = 0)]" mode="content"><xsl:value-of select="normalize-space()" disable-output-escaping="yes"/></xsl:template>

	<xsl:template match="*[b:* or e:*]" mode="content">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="b:* | e:*" mode="attr">
		<xsl:apply-templates select="." mode="attr_class"/>
		<xsl:apply-templates select="." mode="attr_inline"/>
	</xsl:template>

	<xsl:template match="b:* | e:*" mode="attr_class">
		<xsl:attribute name="class">
			<xsl:apply-templates select="." mode="class"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="*[@noclass]" mode="attr_class"/>

	<xsl:template match="*[@nobem]" mode="attr_class"><xsl:attribute name="class"><xsl:apply-templates select="alxc:*" mode="class"/></xsl:attribute></xsl:template>

	<xsl:template match="b:* | e:*" mode="attr_inline">
		<xsl:apply-templates select="@*[namespace-uri() = $xhtml-namespace]" mode="attr_inline-self"/>
		<xsl:apply-templates select="a:*/@*[namespace-uri() = $xhtml-namespace]" mode="attr_inline-self"/>
	</xsl:template>

	<xsl:template match="e:image" mode="attr_inline">
		<xsl:apply-templates select="@src" mode="attr_inline-self"/>
		<xsl:apply-templates select="@src" mode="attr_inline-self">
			<xsl:with-param name="attr-name" select="'alt'"/>
			<xsl:with-param name="attr-value" select="''"/>
		</xsl:apply-templates>
		<xsl:apply-templates select="@*[namespace-uri() = $xhtml-namespace]" mode="attr_inline-self"/>
	</xsl:template>

	<xsl:template match="@*" mode="attr_inline-self">
		<xsl:param name="attr-name" select="local-name()"/>
		<xsl:param name="attr-value" select="."/>
		<xsl:attribute name="{$attr-name}">
			<xsl:value-of select="$attr-value"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template match="b:* | e:*" mode="class">
		<xsl:apply-templates select="." mode="class_self"/>
		<xsl:apply-templates select="." mode="class_self-mode"/>
		<xsl:apply-templates select="m:*" mode="class"/>
		<xsl:apply-templates select="a:*" mode="class"/>
		<xsl:apply-templates select="alxc:*" mode="class"/>
	</xsl:template>

	<xsl:template match="a:*" mode="class">
		<xsl:apply-templates select="." mode="position"/>
		<xsl:apply-templates select="." mode="class_self"/>
		<xsl:apply-templates select="." mode="class_self-mode"/>
		<xsl:apply-templates select="m:*" mode="class"/>
	</xsl:template>

	<xsl:template match="a:*[@noblock='true']" mode="class"/>

	<xsl:template match="alxc:*" mode="class">
		<xsl:apply-templates select="." mode="position"/>
		<xsl:apply-templates select="." mode="class_self"/>
	</xsl:template>

	<xsl:template match="a:* | alxc:*" mode="position">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="b:*[@nobem]/alxc:*[not(preceding-sibling::alxc:*)] | e:*[@nobem]/alxc:*[not(preceding-sibling::alxc:*)]" mode="position"/>

	<xsl:template match="b:* | a:*" mode="class_self">
		<xsl:param name="class-name" select="concat($prefix,local-name())"/>
		<xsl:value-of select="$class-name"/>
	</xsl:template>

	<xsl:template match="a:*[@block-of]" mode="class_self">
		<xsl:param name="block-name" select="@block-of" />
		<xsl:param name="element-name" select="local-name()"/>
		<xsl:param name="class-name" select="concat($prefix,$block-name,$s-element,$element-name)"/>
		<xsl:value-of select="$class-name"/>
	</xsl:template>

	<xsl:template match="alxc:*" mode="class_self">
		<xsl:param name="class-name" select="local-name()"/>
		<xsl:value-of select="$class-name"/>
	</xsl:template>

	<xsl:template match="e:*" mode="class_self">
		<xsl:param name="block-name" select="@block" />
		<xsl:param name="element-name" select="local-name()"/>
		<xsl:param name="class-name" select="concat($prefix,$block-name,$s-element,$element-name)"/>
		<xsl:value-of select="$class-name"/>
	</xsl:template>

	<xsl:template match="b:* | e:* | a:*" mode="class_self-mode">
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="." mode="class_self"/>
		<xsl:value-of select="concat($s-mode,@mode)"/>
	</xsl:template>

	<xsl:template match="b:*[not(@mode)] | e:*[not(@mode)] | a:*[not(@mode)]" mode="class_self-mode"/>

	<xsl:template match="m:*" mode="class">
		<xsl:param name="block-name" select="@block" />
		<xsl:param name="mode-name" select="local-name()"/>
		<xsl:param name="mode-value" select="@val"/>
		<xsl:param name="class-name" select="concat($prefix,$block-name,$s-mode,$mode-name,$s-mode,$mode-value)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$class-name"/>
	</xsl:template>

	<xsl:template match="m:*[not(@val)]" mode="class">
		<xsl:param name="block-name" select="@block" />
		<xsl:param name="mode-name" select="local-name()"/>
		<xsl:param name="class-name" select="concat($prefix,$block-name,$s-mode,$mode-name)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$class-name"/>
	</xsl:template>

	<xsl:template match="m:*[@element]" mode="class">
		<xsl:param name="block-name" select="@block" />
		<xsl:param name="element-name" select="@element" />
		<xsl:param name="mode-name" select="local-name()"/>
		<xsl:param name="mode-value" select="@val"/>
		<xsl:param name="class-name" select="concat($prefix,$block-name,$s-element,$element-name,$s-mode,$mode-name,$s-mode,$mode-value)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$class-name"/>
	</xsl:template>

	<xsl:template match="m:*[@element and not(@val)]" mode="class">
		<xsl:param name="block-name" select="@block" />
		<xsl:param name="element-name" select="@element" />
		<xsl:param name="mode-name" select="local-name()"/>
		<xsl:param name="class-name" select="concat($prefix,$block-name,$s-element,$element-name,$s-mode,$mode-name)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$class-name"/>
	</xsl:template>

</xsl:stylesheet>
