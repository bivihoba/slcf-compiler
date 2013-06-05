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
				xmlns:un="http://slcf/templates/settings/bem-scheme/unknown-namespace"
				xmlns:alxc="http://slcf/templates/settings/bem-scheme/additional-legacy-xhtml-class"
				xmlns:exsl="http://exslt.org/common"
				exclude-result-prefixes="a b e x d p m t alxc"
				extension-element-prefixes="exsl">
	<xsl:import href="block.xsl" />

	<xsl:variable name="data-namespace" select="'&data-namespace;'"/>
	<xsl:variable name="template-namespace" select="'&template-namespace;'"/>
	<xsl:variable name="pointer-namespace" select="'&pointer-namespace;'"/>
	<xsl:variable name="block-namespace" select="'&block-namespace;'"/>
	<xsl:variable name="element-namespace" select="'&element-namespace;'"/>
	<xsl:variable name="additional-namespace" select="'&additional-namespace;'"/>
	<xsl:variable name="modification-namespace" select="'&modification-namespace;'"/>
	<xsl:variable name="xhtml-namespace" select="'&xhtml-namespace;'"/>
	<xsl:variable name="legacy-xhtml-namespace" select="'&legacy-xhtml-namespace;'"/>
	<xsl:variable name="unknown-namespace" select="'&unknown-namespace;'"/>

	<!--<xsl:key name="this" match="e:*[not(@block)]" use="current()"/>-->
	<xsl:key name="template" match="//project/settings/templates/t:*[not(@type)]" use="local-name()"/>
	<xsl:key name="template_type" match="//project/settings/templates/t:*[@type]" use="local-name()"/>
	<xsl:key name="template-callback" match="//p:*[not(local-name() = 'content')][not(@type)]" use="generate-id(.)"/>
	<xsl:key name="template-callback_type" match="//p:*[not(local-name() = 'content')][@type]" use="generate-id(.)"/>
	<xsl:key name="template-local" match="//page/templates/t:*[not(@type)]" use="local-name()"/>
	<xsl:key name="template-local_type" match="//page/templates/t:*[@type]" use="local-name()"/>
	<xsl:key name="content-local" match="//page/templates/p:*[not(@type)]" use="local-name()"/>
	<xsl:key name="content-local_type" match="//page/templates/p:*[@type]" use="local-name()"/>

	<xsl:key name="semantic-tag" match="//default-semantic/*" use="local-name()"/>
	<xsl:key name="semantic" match="//default-semantic/*" use="name()"/>
	<xsl:key name="semantic-local" match="//default-semantic/*" use="local-name()"/>

	<xsl:variable name="rendering-tree">
		<xsl:apply-templates select="//page-canvas" mode="pre" />
		<xsl:copy-of select="//default-semantic"/>
	</xsl:variable>

	<xsl:variable name="block-bem-tree">
		<xsl:apply-templates select="exsl:node-set($rendering-tree)" mode="blockable" />
	</xsl:variable>

	<xsl:variable name="canonical-bem-tree">
		<xsl:apply-templates select="exsl:node-set($block-bem-tree)" mode="canonical" />
	</xsl:variable>

	<xsl:template match="page/page-canvas" xml:space="preserve"><xsl:apply-templates select="exsl:node-set($canonical-bem-tree)" /></xsl:template>
	<!--<xsl:template match="page/page-canvas" xml:space="preserve"><xsl:apply-templates select="exsl:node-set($canonical-bem-tree)" mode="pre" /></xsl:template>-->
	<!--<xsl:template match="page/page-canvas" xml:space="preserve"><xsl:apply-templates select="exsl:node-set($block-bem-tree)" /></xsl:template>-->
	<!--<xsl:template match="page/page-canvas" xml:space="preserve"><xsl:apply-templates select="exsl:node-set($block-bem-tree)" mode="pre" /></xsl:template>-->
	<!--<xsl:template match="page/page-canvas" xml:space="preserve"><xsl:apply-templates select="exsl:node-set($rendering-tree)" /></xsl:template>-->
	<!--<xsl:template match="page/page-canvas" xml:space="preserve"><xsl:apply-templates select="exsl:node-set($rendering-tree)" mode="pre" /></xsl:template>-->

	<!--Собираем дерево всей страницы > -->

	<xsl:template match="page/page-canvas" mode="pre" xml:space="preserve"><xsl:apply-templates mode="pre"/></xsl:template>

		<xsl:template match="p:*[not(@type)][not(local-name() = 'content')][not(key('template-local',local-name()))]" mode="pre">
			<xsl:param name="id" select="generate-id(.)"/>
			<!--Вызываем шаблон, запоминаем id = <xsl:value-of select="$id"/>-->
			<xsl:apply-templates select="key('template',local-name())[not(../following-sibling::templates/*[local-name() = local-name(current())])][not(../../following-sibling::settings/templates/*[local-name() = local-name(current())])]" mode="template">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</xsl:template>

		<xsl:template match="p:*[not(@type)][not(local-name() = 'content')][key('template-local',local-name())]" mode="pre">
			<xsl:param name="id" select="generate-id(.)"/>
			<!--Вызываем локально-переопределенный шаблон, запоминаем id = <xsl:value-of select="$id"/>-->
			<xsl:apply-templates select="key('template-local',local-name())[not(../following-sibling::templates/*[local-name() = local-name(current())])][not(../../following-sibling::settings/templates/*[local-name() = local-name(current())])]" mode="template">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</xsl:template>

		<xsl:template match="p:*[not(local-name() = 'content')][@type and key('template-local_type',local-name())[@type = current()/@type]]" mode="pre">
			<xsl:param name="id" select="generate-id(.)"/>
			<!--Вызываем локально-переопределенный шаблон, запоминаем id = <xsl:value-of select="$id"/>-->
			<!--<xsl:value-of select="key('template-local_type',local-name())/@type"/>-->
			<!--<xsl:value-of select="@type"/>-->
			<xsl:apply-templates select="key('template-local_type',local-name())[@type = current()/@type]" mode="template">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</xsl:template>

		<xsl:template match="p:*[not(local-name() = 'content')][@type and not(@type = key('template-local_type',local-name())/@type)]" mode="pre">
			<xsl:param name="id" select="generate-id(.)"/>
			<!--Вызываем шаблон, запоминаем id = <xsl:value-of select="$id"/>-->
			<xsl:apply-templates select="key('template_type',local-name())[@type = current()/@type]" mode="template">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</xsl:template>

		<xsl:template match="page/templates | page/templates/p:* | t:*" mode="pre">
			<!-- режем все прямые вызовы шаблонов в page-canvas -->
		</xsl:template>

		<xsl:template match="t:*" mode="template">
			<xsl:param name="id"/>
			<!--render template <xsl:value-of select="name()"/>, remember client id <xsl:value-of select="$id"/>-->
			<xsl:apply-templates mode="pre_in">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</xsl:template>

		<!--<xsl:template match="p:*[not(key('template-local',local-name()))]" mode="pre_in">-->
		<xsl:template match="p:*" mode="pre_in">
			<xsl:apply-templates select="." mode="pre"/>
		</xsl:template>

		<xsl:template match="p:content[not(ancestor::t:*/@type)]" mode="pre_in">
			<xsl:param name="id"/>
			<!--1-->
			<xsl:apply-templates select="key('template-callback',$id)" mode="back"/>
		</xsl:template>

		<xsl:template match="p:content[ancestor::t:*/@type]" mode="pre_in">
			<xsl:param name="id"/>
			<!--2-->
			<xsl:apply-templates select="key('template-callback_type',$id)[@type = current()/ancestor::t:*/@type]" mode="back"/>
		</xsl:template>

		<xsl:template match="p:content[not(ancestor::t:*/@type)][key('content-local',local-name(ancestor::t:*))]" mode="pre_in">
			<xsl:param name="id"/>
			<!--3-->
			<xsl:apply-templates select="key('content-local',local-name(ancestor::t:*))" mode="back"/>
		</xsl:template>


		<xsl:template match="p:content[ancestor::t:*/@type][key('content-local',local-name(ancestor::t:*))]" mode="pre_in">
			<xsl:param name="id"/>
			<!--4-->
			<xsl:apply-templates select="key('content-local_type',local-name(ancestor::t:*))[@type = current()/ancestor::t:*/@type]" mode="back"/>
		</xsl:template>

		<xsl:template match="p:*" mode="back">
			<xsl:apply-templates mode="pre" />
		</xsl:template>

	<xsl:template match="*" mode="pre_in">
		<xsl:param name="id"/>
		<xsl:copy>
			<xsl:apply-templates select="." mode="copy-attr"/>
			<xsl:apply-templates mode="pre_in">
				<xsl:with-param name="id" select="$id"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*" mode="pre">
		<xsl:copy>
			<xsl:apply-templates select="." mode="copy-attr"/>
			<xsl:apply-templates mode="pre" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="d:*" mode="pre">
		<xsl:apply-templates select="." mode="data"/>
	</xsl:template>
	<xsl:template match="d:*" mode="pre_in">
		<xsl:apply-templates select="." mode="data"/>
	</xsl:template>

	<xsl:template match="default-semantic"/>

	<!--Собираем дерево всей страницы < -->

	<!-- block bem tree -->

	<xsl:template match="*" mode="blockable">
		<xsl:copy>
			<xsl:apply-templates select="." mode="copy-attr"/>
			<xsl:apply-templates select="." mode="set-block"/>
			<xsl:apply-templates mode="blockable" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="default-semantic" mode="blockable">
		<xsl:apply-templates select="." mode="pre" />
	</xsl:template>

	<!--set block > -->

	<xsl:template match="*" mode="set-block"/>

	<xsl:template match="e:*[@block]" mode="set-block">
		<xsl:param name="block-name" select="@block" />
		<xsl:attribute name="block">
			<xsl:value-of select="$block-name"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="e:*[not(@block)]" mode="set-block">
		<xsl:param name="block-name" select="local-name(ancestor::node()[namespace-uri() = $block-namespace][not(@noblock)][1])" />
		<xsl:attribute name="block">
			<xsl:value-of select="$block-name"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="e:*[not(@block) and (ancestor::node()[child::node()[namespace-uri() = '&additional-namespace;' and @block]])]" mode="set-block">
		<xsl:param name="this" select="generate-id()"/>
		<xsl:param name="closest_block" select="ancestor::node()[namespace-uri() = $block-namespace and not(@noblock)][1]"/>
		<xsl:param name="closest_block_distance" select="$closest_block/descendant::node()[descendant-or-self::node()[generate-id() = $this]]"/>
		<xsl:param name="closest_block_distance_length" select="count($closest_block_distance)"/>
		<xsl:param name="closest_additional_block" select="ancestor::node()[child::node()[namespace-uri() = $additional-namespace and @block]][1]"/>
		<xsl:param name="closest_additional_block_distance" select="$closest_additional_block/descendant::node()[descendant-or-self::node()[generate-id() = $this]]"/>
		<xsl:param name="closest_additional_block_distance_length" select="count($closest_additional_block_distance)"/>
				<xsl:attribute name="pre-block">
					<xsl:value-of select="$closest_block_distance_length"/>
					<xsl:value-of select="$closest_additional_block_distance_length"/>
				</xsl:attribute>
		<xsl:choose>
			<xsl:when test="$closest_additional_block_distance_length &lt;= $closest_block_distance_length">
				<xsl:variable name="block-name" select="local-name($closest_additional_block/child::node()[namespace-uri() = $additional-namespace and @block and not(following-sibling::node()[namespace-uri() = $additional-namespace and @block])])" />
				<xsl:attribute name="block">
					<xsl:value-of select="$block-name"/>
				</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="block-name" select="local-name($closest_block)" />
				<xsl:attribute name="block">
					<xsl:value-of select="$block-name"/>
				</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="m:*[namespace-uri(parent::node()) = '&block-namespace;']" mode="set-block">
		<xsl:param name="block-name" select="local-name(parent::node())" />
		<xsl:attribute name="block">
			<xsl:value-of select="$block-name"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="m:*[namespace-uri(parent::node()) = '&additional-namespace;']" mode="set-block">
		<xsl:param name="block-name" select="local-name(parent::node())" />
		<xsl:attribute name="block">
			<xsl:value-of select="$block-name"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="m:*[namespace-uri(parent::node()) = '&additional-namespace;' and parent::node()/@block-of]" mode="set-block">
		<xsl:param name="block-name" select="parent::node()/@block-of" />
		<xsl:param name="element-name" select="local-name(parent::node())" />
		<xsl:attribute name="block">
			<xsl:value-of select="$block-name"/>
		</xsl:attribute>
		<xsl:attribute name="element">
			<xsl:value-of select="$element-name"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="m:*[namespace-uri(parent::node()) = '&element-namespace;']" mode="set-block">
		<xsl:param name="element-name" select="local-name(parent::node())" />
		<xsl:apply-templates select="parent::node()" mode="set-block"/>
		<xsl:attribute name="element">
			<xsl:value-of select="$element-name"/>
		</xsl:attribute>
	</xsl:template>

	<!--set block < -->

	<!-- block bem tree < -->

	<!--canonical tree -->

	<xsl:template match="*" mode="canonical">
		<xsl:copy>
			<xsl:apply-templates select="." mode="copy-spec-attr"/>
			<xsl:apply-templates select="." mode="set-semantics"/>
			<xsl:apply-templates mode="canonical" />
		</xsl:copy>
	</xsl:template>

		<xsl:template match="default-semantic" mode="canonical">
			<xsl:apply-templates select="." mode="pre" />
		</xsl:template>

	<!--set semantics > -->

		<!--Ищем сущность, которая определяет тег узла > -->

		<xsl:template match="*" mode="set-semantics"/>

		<xsl:template match="b:* | e:*" mode="set-semantics">

			<xsl:apply-templates select="." mode="set-semantics__tail"/>
		</xsl:template>

			<xsl:template match="*" mode="set-semantics__tail">
				<xsl:apply-templates select="." mode="set-semantics__tail_control_inline-add-mode-with-value"/>
			</xsl:template>

				<xsl:template match="*" mode="set-semantics__tail_control_inline-add-mode-with-value">
					<xsl:apply-templates select="." mode="set-semantics__tail_control_inline-add-mode-without-value"/>
				</xsl:template>

				<xsl:template match="*[a:*/m:*[@val and @tag]]" mode="set-semantics__tail_control_inline-add-mode-with-value">
					<xsl:apply-templates select="a:*/m:*[@val and @tag]" mode="set-semantic__tag-index__inline"/>
				</xsl:template>

					<xsl:template match="*" mode="set-semantics__tail_control_inline-add-mode-without-value">
						<xsl:apply-templates select="." mode="set-semantics__tail_control_inline-add"/>
					</xsl:template>

					<xsl:template match="*[a:*/m:*[not(@val) and @tag]]" mode="set-semantics__tail_control_inline-add-mode-without-value">
						<xsl:apply-templates select="a:*/m:*[not(@val) and @tag]" mode="set-semantic__tag-index__inline"/>
					</xsl:template>

						<xsl:template match="*" mode="set-semantics__tail_control_inline-add">
							<xsl:apply-templates select="." mode="set-semantics__tail_control_inline-mode"/>
						</xsl:template>

						<xsl:template match="*[a:*[@tag]]" mode="set-semantics__tail_control_inline-add">
							<xsl:apply-templates select="a:*[@tag]" mode="set-semantic__tag-index__inline"/>
						</xsl:template>

							<xsl:template match="*" mode="set-semantics__tail_control_inline-mode">
								<xsl:apply-templates select="." mode="set-semantics__tail_control_inline-block"/>
							</xsl:template>

							<xsl:template match="*[m:*[@tag]]" mode="set-semantics__tail_control_inline-mode">
								<xsl:apply-templates select="m:*[@tag]" mode="set-semantic__tag-index__inline"/>
							</xsl:template>

								<xsl:template match="*" mode="set-semantics__tail_control_inline-block">
									<xsl:apply-templates select="." mode="set-semantics__tail_control_gds-add-mode-with-value"/>
								</xsl:template>

								<xsl:template match="*[@tag]" mode="set-semantics__tail_control_inline-block">
									<xsl:apply-templates select="." mode="set-semantic__tag-index__inline"/>
								</xsl:template>

									<xsl:template match="*" mode="set-semantics__tail_control_gds-add-mode-with-value">
										<xsl:apply-templates select="." mode="set-semantics__tail_control_gds-add-mode-without-value"/>
									</xsl:template>

									<xsl:template match="*[a:*/m:*[@val and key('semantic',name())[@tag and not(@element) and (@block = current()/a:*/m:*/@block) and (@val = current()/a:*/m:*/@val)]]]" mode="set-semantics__tail_control_gds-add-mode-with-value">
										<xsl:apply-templates select="a:*/m:*[@val and @block]" mode="set-semantic__tag-index"/>
									</xsl:template>

										<xsl:template match="*" mode="set-semantics__tail_control_gds-add-mode-without-value">
											<xsl:apply-templates select="." mode="set-semantics__tail_control_gds-add"/>
										</xsl:template>

										<xsl:template match="*[a:*/m:*[not(@val) and key('semantic',name())[@tag and not(@val) and not(@element) and (@block = current()/a:*/m:*/@block)]]]" mode="set-semantics__tail_control_gds-add-mode-without-value">
											<xsl:apply-templates select="a:*/m:*[not(@val) and @block]" mode="set-semantic__tag-index"/>

										</xsl:template>

											<xsl:template match="*" mode="set-semantics__tail_control_gds-add">
												<xsl:apply-templates select="." mode="set-semantics__tail_control_gds-mode-with-value"/>
											</xsl:template>

											<xsl:template match="*[a:*[key('semantic-local',local-name())[namespace-uri() = '&block-namespace;' and @tag]]]" mode="set-semantics__tail_control_gds-add">
												<xsl:apply-templates select="a:*[key('semantic-local',local-name())[@tag]]" mode="set-semantic__tag-index"/>
											</xsl:template>

												<xsl:template match="*" mode="set-semantics__tail_control_gds-mode-with-value">
													<xsl:apply-templates select="." mode="set-semantics__tail_control_gds-mode-without-value"/>
												</xsl:template>

												<xsl:template match="b:*[m:*[@val and key('semantic',name())[@tag and not(@element) and (@block = current()/m:*/@block) and (@val = current()/m:*/@val)]]]" mode="set-semantics__tail_control_gds-mode-with-value">
													<xsl:apply-templates select="m:*[@val and key('semantic',name())[@tag and not(@element) and (@block = current()/m:*/@block) and (@val = current()/m:*/@val)]]" mode="set-semantic__tag-index"/>
												</xsl:template>

												<xsl:template match="e:*[m:*[@val and key('semantic',name())[@tag and (@element = current()/m:*/@element) and (@block = current()/m:*/@block) and (@val = current()/m:*/@val)]]]" mode="set-semantics__tail_control_gds-mode-with-value">
													<xsl:apply-templates select="m:*[@val and key('semantic',name())[@tag and (@element = current()/m:*/@element) and (@block = current()/m:*/@block) and (@val = current()/m:*/@val)]]" mode="set-semantic__tag-index"/>
												</xsl:template>

													<xsl:template match="*" mode="set-semantics__tail_control_gds-mode-without-value">
														<xsl:apply-templates select="." mode="set-semantics__tail_control_gds-block"/>
													</xsl:template>

													<xsl:template match="b:*[m:*[not(@val) and key('semantic',name())[@tag and not(@element) and not(@val) and (@block = current()/m:*/@block)]]]" mode="set-semantics__tail_control_gds-mode-without-value">

														<xsl:apply-templates select="m:*[not(@val) and key('semantic',name())[@tag and not(@element) and not(@val) and (@block = current()/m:*/@block)]]" mode="set-semantic__tag-index"/>
													</xsl:template>

													<xsl:template match="e:*[m:*[not(@val) and key('semantic',name())[@tag and (@element = current()/m:*/@element) and not(@val) and (@block = current()/m:*/@block)]]]" mode="set-semantics__tail_control_gds-mode-without-value">
														<xsl:apply-templates select="m:*[not(@val) and key('semantic',name())[@tag and (@element = current()/m:*/@element) and not(@val) and (@block = current()/m:*/@block)]]" mode="set-semantic__tag-index"/>
													</xsl:template>

														<xsl:template match="*" mode="set-semantics__tail_control_gds-block">



															<xsl:apply-templates select="." mode="set-semantics__node-callback"/>
														</xsl:template>

														<xsl:template match="b:*[key('semantic',name())[@tag][namespace-uri() = '&block-namespace;']]" mode="set-semantics__tail_control_gds-block">
															<xsl:apply-templates select="." mode="set-semantic__tag-index"/>
														</xsl:template>

														<xsl:template match="e:*[key('semantic',name())[@tag][namespace-uri() = '&element-namespace;' and @block = current()/@block]]" mode="set-semantics__tail_control_gds-block">
															<xsl:apply-templates select="." mode="set-semantic__tag-index"/>
														</xsl:template>

		<!--Ищем сущность, которая определяет тег узла > -->

		<!-- Возврат к узловой сущности, после прохода в поисках индекса > -->
		<xsl:template match="*" mode="__set-semantics__node-callback">
			<xsl:param name="high-priority-tag" select="'0'"/>
			<xsl:apply-templates select="ancestor-or-self::node()[(namespace-uri() = '&block-namespace;') or (namespace-uri() = '&element-namespace;')][1]" mode="set-semantics__node-callback">
				<xsl:with-param name="high-priority-tag" select="$high-priority-tag"/>
			</xsl:apply-templates>
		</xsl:template>
		<!-- Возврат к узловой сущности, после прохода в поисках индекса < -->

		<!-- Индексируем тег, указанный инлайново > -->
		<xsl:template match="*" mode="semantic__tag-index__inline"/>

			<xsl:template match="b:*[@tag] | e:*[@tag] | m:*[@tag and not(following-sibling::m:*[@tag])] | a:*[@tag and not(following-sibling::a:*[@tag])] |
								 a:*/m:*[not(@val) and @tag and not(following-sibling::m:*[@tag])] |
								 a:*/m:*[@val and @tag and not(following-sibling::m:*[@tag])]" mode="set-semantic__tag-index__inline">
				<xsl:param name="high-priority-tag" select="generate-id()"/>
				<xsl:apply-templates select="." mode="__set-semantics__node-callback">
					<xsl:with-param name="high-priority-tag" select="$high-priority-tag"/>
				</xsl:apply-templates>
			</xsl:template>
		<!-- Индексируем тег, указанный инлайново < -->

		<!-- Индексируем тег, указанный в глобальном конфиге > -->
		<xsl:template match="*" mode="semantic__tag-index"/>

			<xsl:template match="b:*[key('semantic',name())[@tag and namespace-uri() = '&block-namespace;']]" mode="set-semantic__tag-index">
				<xsl:param name="high-priority-tag" select="generate-id(key('semantic',name())[@tag and namespace-uri() = '&block-namespace;'])"/>
				<xsl:apply-templates select="." mode="__set-semantics__node-callback">
					<xsl:with-param name="high-priority-tag" select="$high-priority-tag"/>
				</xsl:apply-templates>
			</xsl:template>

			<xsl:template match="e:*[key('semantic',name())[@tag and namespace-uri() = '&element-namespace;']]" mode="set-semantic__tag-index">
				<xsl:param name="high-priority-tag" select="generate-id(key('semantic',name())[@tag and @block = current()/@block and namespace-uri() = '&element-namespace;'])"/>
				<xsl:apply-templates select="." mode="__set-semantics__node-callback">
					<xsl:with-param name="high-priority-tag" select="$high-priority-tag"/>
				</xsl:apply-templates>
			</xsl:template>

			<xsl:template match="m:*[not(@val) and key('semantic',name())[@tag and not(@element) and (@block = current()/@block) and not(@val)]]" mode="set-semantic__tag-index">
				<xsl:param name="high-priority-tag" select="generate-id(key('semantic',name())[@tag and not(@element) and (@block = current()/@block) and not(@val)])"/>
				<xsl:apply-templates select="." mode="__set-semantics__node-callback">
					<xsl:with-param name="high-priority-tag" select="$high-priority-tag"/>
				</xsl:apply-templates>
			</xsl:template>

			<xsl:template match="m:*[@element and not(@val) and key('semantic',name())[@tag and (@element = current()/@element) and (@block = current()/@block) and not(@val)]]" mode="set-semantic__tag-index">
				<xsl:param name="high-priority-tag" select="generate-id(key('semantic',name())[@tag and (@element = current()/@element) and (@block = current()/@block) and not(@val)])"/>
				<xsl:apply-templates select="." mode="__set-semantics__node-callback">
					<xsl:with-param name="high-priority-tag" select="$high-priority-tag"/>
				</xsl:apply-templates>
			</xsl:template>

			<xsl:template match="m:*[@val and key('semantic',name())[@tag and not(@element) and (@block = current()/@block) and (@val = current()/@val)]]" mode="set-semantic__tag-index">
				<xsl:param name="high-priority-tag" select="generate-id(key('semantic',name())[@tag and not(@element) and (@block = current()/@block) and (@val = current()/@val)])"/>
				<xsl:apply-templates select="." mode="__set-semantics__node-callback">
					<xsl:with-param name="high-priority-tag" select="$high-priority-tag"/>
				</xsl:apply-templates>
			</xsl:template>

			<xsl:template match="m:*[@element and @val and key('semantic',name())[@tag and (@element = current()/@element) and (@block = current()/@block) and (@val = current()/@val)]]" mode="set-semantic__tag-index">
				<xsl:param name="high-priority-tag" select="generate-id(key('semantic',name())[@tag and (@element = current()/@element) and (@block = current()/@block) and (@val = current()/@val)])"/>
				<xsl:apply-templates select="." mode="__set-semantics__node-callback">
					<xsl:with-param name="high-priority-tag" select="$high-priority-tag"/>
				</xsl:apply-templates>
			</xsl:template>

			<xsl:template match="a:*[key('semantic-local',local-name())[namespace-uri() = '&block-namespace;' and @tag]]" mode="set-semantic__tag-index">
				<xsl:param name="high-priority-tag" select="generate-id(key('semantic-local',local-name())[namespace-uri() = '&block-namespace;' and @tag])"/>
				<xsl:apply-templates select="." mode="__set-semantics__node-callback">
					<xsl:with-param name="high-priority-tag" select="$high-priority-tag"/>
				</xsl:apply-templates>
			</xsl:template>
		<!-- Индексируем тег, указанный в глобальном конфиге < -->

		<!-- Проходим по всем сущностям на узле для назначения ему тега и html-атрибутов > -->
		<xsl:template match="*" mode="set-semantics__node-callback">
			<xsl:param name="high-priority-tag"/>

			<xsl:apply-templates select="self::node()" mode="set-semantic__check"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>
			<xsl:apply-templates select="m:*[not(@val) and @block]" mode="set-semantic__check"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>
			<xsl:apply-templates select="m:*[@val and @block]" mode="set-semantic__check"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>
			<xsl:apply-templates select="a:*[key('semantic-local',local-name())[namespace-uri() = '&block-namespace;']]" mode="set-semantic__check"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>
			<xsl:apply-templates select="a:*/m:*[not(@val) and @block]" mode="set-semantic__check"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>
			<xsl:apply-templates select="a:*/m:*[@val and @block]" mode="set-semantic__check"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>

			<xsl:apply-templates select="self::node()" mode="set-semantic__check__inline"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>
			<xsl:apply-templates select="m:*[not(@val)]" mode="set-semantic__check__inline"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>
			<xsl:apply-templates select="m:*[@val]" mode="set-semantic__check__inline"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>
			<xsl:apply-templates select="a:*" mode="set-semantic__check__inline"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>
			<xsl:apply-templates select="a:*/m:*[not(@val)]" mode="set-semantic__check__inline"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>
			<xsl:apply-templates select="a:*/m:*[@val]" mode="set-semantic__check__inline"><xsl:with-param name="high-priority-tag" select="$high-priority-tag"/></xsl:apply-templates>

		</xsl:template>

			<!-- Идем по сущностям у которых тег, если и указан, то инлайново > -->
			<xsl:template match="*" mode="set-semantic__check__inline"/>

				<xsl:template match="b:* | e:*" mode="set-semantic__check__inline">
					<xsl:param name="high-priority-tag" select="0"/>
					<xsl:apply-templates select="self::node()[(not(@tag) or generate-id(.) = $high-priority-tag)]" mode="set-semantics__transfer"/>
				</xsl:template>

				<xsl:template match="m:*[not(@val)]" mode="set-semantic__check__inline">
					<xsl:param name="high-priority-tag" select="0"/>
					<xsl:apply-templates select="self::node()[(not(@tag) or generate-id(.) = $high-priority-tag)]" mode="set-semantics__transfer"/>
				</xsl:template>

				<xsl:template match="m:*[@val]" mode="set-semantic__check__inline">
					<xsl:param name="high-priority-tag" select="0"/>
					<xsl:apply-templates select="self::node()[(not(@tag) or generate-id(.) = $high-priority-tag)]" mode="set-semantics__transfer"/>
				</xsl:template>

				<xsl:template match="a:*" mode="set-semantic__check__inline">
					<xsl:param name="high-priority-tag" select="0"/>
					<xsl:apply-templates select="self::node()[(not(@tag) or generate-id(.) = $high-priority-tag)]" mode="set-semantics__transfer"/>
				</xsl:template>
			<!-- Идем по сущностям у которых тег, если и указан, то инлайново < -->

			<!-- Идем по сущностям у которых тег, если и указан, то в глобальном конфиге > -->
			<xsl:template match="*" mode="set-semantic__check"/>

				<xsl:template match="b:*[key('semantic',name())]" mode="set-semantic__check">
					<xsl:param name="high-priority-tag" select="0"/>
					<xsl:apply-templates select="key('semantic',name())[(not(@tag) or generate-id(.) = $high-priority-tag)]" mode="set-semantics__transfer"/>
				</xsl:template>

				<xsl:template match="e:*[key('semantic',name())[@block= current()/@block]]" mode="set-semantic__check">
					<xsl:param name="high-priority-tag" select="0"/>
					<xsl:apply-templates select="key('semantic',name())[@block= current()/@block and (not(@tag) or generate-id(.) = $high-priority-tag)]" mode="set-semantics__transfer"/>
				</xsl:template>

				<xsl:template match="m:*[not(@val) and key('semantic',name())[not(@element) and (@block = current()/@block) and (not(@val))]]" mode="set-semantic__check">
					<xsl:param name="high-priority-tag" select="0"/>
					<xsl:apply-templates select="key('semantic',name())[(not(@element)) and (@block = current()/@block) and (not(@val)) and (not(@tag) or generate-id(.) = $high-priority-tag)]" mode="set-semantics__transfer"/>
				</xsl:template>

				<xsl:template match="m:*[@element and not(@val) and key('semantic',name())[(@element = current()/@element) and (@block = current()/@block) and (not(@val))]]" mode="set-semantic__check">
					<xsl:param name="high-priority-tag" select="0"/>
					<xsl:apply-templates select="key('semantic',name())[(@element = current()/@element) and (@block = current()/@block) and (not(@val)) and (not(@tag) or generate-id(.) = $high-priority-tag)]" mode="set-semantics__transfer"/>
				</xsl:template>

				<xsl:template match="m:*[@val and key('semantic',name())[not(@element) and (@block = current()/@block) and (@val = current()/@val)]]" mode="set-semantic__check">
					<xsl:param name="high-priority-tag" select="0"/>
					<xsl:apply-templates select="key('semantic',name())[(not(@element)) and (@block = current()/@block) and (@val = current()/@val) and (not(@tag) or generate-id(.) = $high-priority-tag)]" mode="set-semantics__transfer"/>
				</xsl:template>

				<xsl:template match="m:*[@element and @val and key('semantic',name())[(@element = current()/@element) and (@block = current()/@block) and (@val = current()/@val)]]" mode="set-semantic__check">
					<xsl:param name="high-priority-tag" select="0"/>
					<xsl:apply-templates select="key('semantic',name())[(@element = current()/@element) and (@block = current()/@block) and (@val = current()/@val) and (not(@tag) or generate-id(.) = $high-priority-tag)]" mode="set-semantics__transfer"/>
				</xsl:template>

				<xsl:template match="a:*[key('semantic-local',local-name())[(namespace-uri() = '&block-namespace;')]]" mode="set-semantic__check">
					<xsl:param name="high-priority-tag" select="0"/>
					<xsl:apply-templates select="key('semantic-local',local-name())[(namespace-uri() = '&block-namespace;') and (not(@tag) or generate-id(.) = $high-priority-tag)]" mode="set-semantics__transfer"/>
				</xsl:template>
			<!-- Идем по сущностям у которых тег, если и указан, то в глобальном конфиге < -->

		<!-- Проходим по всем сущностям на узле для назначения ему тега и html-атрибутов < -->

		<xsl:template match="*" mode="set-semantics__transfer">
			<xsl:apply-templates select="." mode="create-namespaces__helper"/>
			<xsl:apply-templates select="." mode="create-attrs__helper"/>
			<xsl:apply-templates select="@noclass" mode="create-attr"/>
		</xsl:template>

		<xsl:template match="*[@tag]" mode="set-semantics__transfer">
			<xsl:apply-templates select="." mode="create-tag__helper"/>
			<xsl:apply-templates select="." mode="create-namespaces__helper"/>
			<xsl:apply-templates select="." mode="create-attrs__helper"/>
			<xsl:apply-templates select="@noclass" mode="create-attr"/>
		</xsl:template>

	<!--set semantics < -->

	<!--canonical tree FIN -->

	<!--helpers > -->

	<xsl:template match="*[@tag]" mode="create-tag__helper">
		<xsl:apply-templates select="." mode="create-tag">
			<xsl:with-param name="tag" select="@tag" />
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="*" mode="create-tag">
		<xsl:param name="tag" select="'div'"/>
		<xsl:attribute name="tag">
			<xsl:value-of select="$tag"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="*" mode="create-namespaces__helper">
		<xsl:apply-templates select="." mode="copy-inline-xmlns"/>
	</xsl:template>

	<xsl:template match="*" mode="copy-inline-xmlns">
		<xsl:copy-of select="namespace::*[
										  not(. = $data-namespace or
											  . = $template-namespace or
											  . = $pointer-namespace or
											  . = $block-namespace or
											  . = $element-namespace or
											  . = $modification-namespace or
											  . = $additional-namespace or
											  . = $unknown-namespace or
											  . = $xhtml-namespace or
											  . = $legacy-xhtml-namespace
											 )
										 ]"/>
	</xsl:template>

	<xsl:template match="*" mode="create-attrs__helper">
		<xsl:apply-templates select="@*[namespace-uri() = '&xhtml-namespace;']" mode="create-attr"/>
	</xsl:template>

	<xsl:template match="*" mode="delete-semantic-attr">
		<xsl:apply-templates select="@*[namespace-uri() = '&xhtml-namespace;']" mode="delete"/>
	</xsl:template>

	<xsl:template match="@*" mode="create-attr">
		<xsl:param name="attr-name" select="name()"/>
		<xsl:param name="attr-value" select="."/>
		<xsl:attribute name="{$attr-name}">
			<xsl:value-of select="$attr-value"/>
		</xsl:attribute>
	</xsl:template>

	<xsl:template match="*" mode="delete"/>

	<xsl:template match="*" mode="copy-attr">
		<xsl:copy-of select="@*"/>
	</xsl:template>

	<xsl:template match="*" mode="copy-spec-attr">
		<xsl:copy-of select="@*[not(namespace-uri() = $xhtml-namespace)]"/>
	</xsl:template>

	<!--helpers < -->

</xsl:stylesheet>
