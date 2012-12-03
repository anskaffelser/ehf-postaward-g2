<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                 xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" version="2.0">
	<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

	<axsl:param name="archiveDirParameter" tunnel="no"/>
	<axsl:param name="archiveNameParameter" tunnel="no"/>
	<axsl:param name="fileNameParameter" tunnel="no"/>
	<axsl:param name="fileDirParameter" tunnel="no"/>

	<!--PHASES-->


	<!--PROLOG-->

	<axsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>

	<!--XSD TYPES-->


	<!--KEYS AND FUCNTIONS-->


	<!--DEFAULT RULES-->


	<!--MODE: SCHEMATRON-FULL-PATH-->
	<!--This mode can be used to generate an ugly though full XPath for locators-->

	<axsl:template match="*" mode="schematron-get-full-path">
		<axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
		<axsl:text>/</axsl:text>
		<axsl:choose>
			<axsl:when test="namespace-uri()=''">
				<axsl:value-of select="name()"/>
			</axsl:when>
			<axsl:otherwise>
				<axsl:text>*:</axsl:text>
				<axsl:value-of select="local-name()"/>
				<axsl:text>[namespace-uri()='</axsl:text>
				<axsl:value-of select="namespace-uri()"/>
				<axsl:text>']</axsl:text>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
		<axsl:text>[</axsl:text>
		<axsl:value-of select="1+ $preceding"/>
		<axsl:text>]</axsl:text>
	</axsl:template>
	<axsl:template match="@*" mode="schematron-get-full-path">
		<axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
		<axsl:text>/</axsl:text>
		<axsl:choose>
			<axsl:when test="namespace-uri()=''">@<axsl:value-of select="name()"/></axsl:when>
			<axsl:otherwise>
				<axsl:text>@*[local-name()='</axsl:text>
				<axsl:value-of select="local-name()"/>
				<axsl:text>' and namespace-uri()='</axsl:text>
				<axsl:value-of select="namespace-uri()"/>
				<axsl:text>']</axsl:text>
			</axsl:otherwise>
		</axsl:choose>
	</axsl:template>

	<!--MODE: SCHEMATRON-FULL-PATH-2-->
	<!--This mode can be used to generate prefixed XPath for humans-->

	<axsl:template match="node() | @*" mode="schematron-get-full-path-2">
		<axsl:for-each select="ancestor-or-self::*">
			<axsl:text>/</axsl:text>
			<axsl:value-of select="name(.)"/>
			<axsl:if test="preceding-sibling::*[name(.)=name(current())]">
				<axsl:text>[</axsl:text>
				<axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
				<axsl:text>]</axsl:text>
			</axsl:if>
		</axsl:for-each>
		<axsl:if test="not(self::*)">
			<axsl:text/>/@<axsl:value-of select="name(.)"/></axsl:if>
	</axsl:template>
	<!--MODE: SCHEMATRON-FULL-PATH-3-->
	<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

	<axsl:template match="node() | @*" mode="schematron-get-full-path-3">
		<axsl:for-each select="ancestor-or-self::*">
			<axsl:text>/</axsl:text>
			<axsl:value-of select="name(.)"/>
			<axsl:if test="parent::*">
				<axsl:text>[</axsl:text>
				<axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
				<axsl:text>]</axsl:text>
			</axsl:if>
		</axsl:for-each>
		<axsl:if test="not(self::*)">
			<axsl:text/>/@<axsl:value-of select="name(.)"/></axsl:if>
	</axsl:template>

	<!--MODE: GENERATE-ID-FROM-PATH -->

	<axsl:template match="/" mode="generate-id-from-path"/>
	<axsl:template match="text()" mode="generate-id-from-path">
		<axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<axsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
	</axsl:template>
	<axsl:template match="comment()" mode="generate-id-from-path">
		<axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<axsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
	</axsl:template>
	<axsl:template match="processing-instruction()" mode="generate-id-from-path">
		<axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<axsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
	</axsl:template>
	<axsl:template match="@*" mode="generate-id-from-path">
		<axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<axsl:value-of select="concat('.@', name())"/>
	</axsl:template>
	<axsl:template match="*" mode="generate-id-from-path" priority="-0.5">
		<axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
		<axsl:text>.</axsl:text>
		<axsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
	</axsl:template>

	<!--MODE: GENERATE-ID-2 -->

	<axsl:template match="/" mode="generate-id-2">U</axsl:template>
	<axsl:template match="*" mode="generate-id-2" priority="2">
		<axsl:text>U</axsl:text>
		<axsl:number level="multiple" count="*"/>
	</axsl:template>
	<axsl:template match="node()" mode="generate-id-2">
		<axsl:text>U.</axsl:text>
		<axsl:number level="multiple" count="*"/>
		<axsl:text>n</axsl:text>
		<axsl:number count="node()"/>
	</axsl:template>
	<axsl:template match="@*" mode="generate-id-2">
		<axsl:text>U.</axsl:text>
		<axsl:number level="multiple" count="*"/>
		<axsl:text>_</axsl:text>
		<axsl:value-of select="string-length(local-name(.))"/>
		<axsl:text>_</axsl:text>
		<axsl:value-of select="translate(name(),':','.')"/>
	</axsl:template>
	<!--Strip characters-->
	<axsl:template match="text()" priority="-1"/>

	<!--SCHEMA METADATA-->

	<axsl:template match="/">
		<svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="BIIRULES  T19 bound to UBL" schemaVersion="">
			<axsl:comment>
				<axsl:value-of select="$archiveDirParameter"/>
				<axsl:value-of select="$archiveNameParameter"/>
				<axsl:value-of select="$fileNameParameter"/>
				<axsl:value-of select="$fileDirParameter"/>
			</axsl:comment>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" prefix="ubl"/>
			<svrl:active-pattern>
				<axsl:attribute name="id">UBL-T19</axsl:attribute>
				<axsl:attribute name="name">UBL-T19</axsl:attribute>
				<axsl:apply-templates/>
			</svrl:active-pattern>
			<axsl:apply-templates select="/" mode="M6"/>
			<svrl:active-pattern>
				<axsl:attribute name="id">CodesT19</axsl:attribute>
				<axsl:attribute name="name">CodesT19</axsl:attribute>
				<axsl:apply-templates/>
			</svrl:active-pattern>
			<axsl:apply-templates select="/" mode="M7"/>
		</svrl:schematron-output>
	</axsl:template>

	<!--SCHEMATRON PATTERNS-->

	<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BIIRULES  T19 bound to UBL</svrl:text>

	<!--PATTERN UBL-T19-->


	<!--RULE -->

	<axsl:template match="/ubl:Catalogue" priority="1010" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Catalogue"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:CustomizationID) >0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CustomizationID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R001]-A catalogue MUST have a customization identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:ProfileID) >0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ProfileID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R002]-A catalogue MUST have a profile identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cbc:IssueDate)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:IssueDate)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R003]-A catalogue MUST contain the date of issue</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cbc:ID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R004]-A catalogue MUST contain the catalogue document identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!-- ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:ActionCode) >0">
			</axsl:when>			
			<axsl:when test="not(cac:CatalogueLine[cbc:ActionCode =''])">
			</axsl:when>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ActionCode ='' and cac:CatalogueLine[cbc:Actioncode !='']">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T19-R001]-A Catalogue must contain ActionCode on either Header or Line level</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cbc:VersionID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:VersionID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R005]-A catalogue version MUST be always specified</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:ProviderParty)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:ProviderParty)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R007]-The party providing the catalogue MUST be specified</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:ReceiverParty)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:ReceiverParty)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R008]-The party receiving the catalogue MUST be specified</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="count(cac:SellerSupplierParty) &lt;= 1"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:SellerSupplierParty) &lt;= 1">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R009]-A catalogue MUST have maximum one catalogue supplier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:CatalogueLine)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:CatalogueLine)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R023]-A catalogue MUST have at least one catalogue line</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:ContractorCustomerParty" priority="1009" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:ContractorCustomerParty"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R013]-A catalogue customer MUST contain the full name or an identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:CatalogueLine" priority="1008" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:CatalogueLine"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:LineValidityPeriod/cbc:StartDate and cac:LineValidityPeriod/cbc:EndDate) and (number(translate(string(cac:LineValidityPeriod/cbc:StartDate),'-','')) &gt;= number(translate(string(//cac:ValidityPeriod/cbc:StartDate),'-',''))) and (number(translate(string(cac:LineValidityPeriod/cbc:EndDate),'-','')) &lt;= number(translate(string(//cac:ValidityPeriod/cbc:EndDate),'-','')))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="(cac:LineValidityPeriod/cbc:StartDate and cac:LineValidityPeriod/cbc:EndDate) and (number(translate(string(cac:LineValidityPeriod/cbc:StartDate),'-','')) &gt;= number(translate(string(//cac:ValidityPeriod/cbc:StartDate),'-',''))) and (number(translate(string(cac:LineValidityPeriod/cbc:EndDate),'-','')) &lt;= number(translate(string(//cac:ValidityPeriod/cbc:EndDate),'-','')))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R017]-Catalogue line validity period MUST be within the range of the whole catalogue validity period</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(//cac:UsabilityPeriod/cbc:StartDate and //cac:UsabilityPeriod/cbc:EndDate) and (number(translate(//cac:UsabilityPeriod/cbc:StartDate,'-','')) &gt;= number(translate(//cac:LineValidityPeriod/cbc:StartDate,'-',''))) and (number(translate(//cac:UsabilityPeriod/cbc:EndDate,'-','')) &lt;= number(translate(//cac:LineValidityPeriod/cbc:EndDate,'-','')))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="(//cac:UsabilityPeriod/cbc:StartDate and //cac:UsabilityPeriod/cbc:EndDate) and (number(translate(//cac:UsabilityPeriod/cbc:StartDate,'-','')) &gt;= number(translate(//cac:LineValidityPeriod/cbc:StartDate,'-',''))) and (number(translate(//cac:UsabilityPeriod/cbc:EndDate,'-','')) &lt;= number(translate(//cac:LineValidityPeriod/cbc:EndDate,'-','')))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R018]-Price validity period MUST be within the range of the whole catalogue line validity period</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cbc:ID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R024]-A catalogue line MUST contain a unique line identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="number(cbc:OrderableUnit) &gt;= 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:OrderableUnit) &gt;= 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R026]-Orderable quantitites MUST be greater than zero</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="number(cbc:MaximumOrderQuantity) &gt;= 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:MaximumOrderQuantity) &gt;= 0">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R029]-Maximum quantity MUST be greater than zero</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="number(cbc:MinimumOrderQuantity) &gt;= 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:MinimumOrderQuantity) &gt;= 0">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R030]-Minimum quantity MUST be greater than zero</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="number(cbc:MaximumOrderQuantity) &gt;= number(cbc:MinimumOrderQuantity)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:MaximumOrderQuantity) &gt;= number(cbc:MinimumOrderQuantity)">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R031]-Maximum quantity MUST be greater or equal to the Minimum quantity</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:ProviderParty" priority="1007" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:ProviderParty"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R010]-A catalogue provider MUST contain the full name or an identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:ReceiverParty" priority="1006" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:ReceiverParty"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R011]-A catalogue receiver MUST contain the full name or an identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:SellerSupplierParty" priority="1005" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:SellerSupplierParty"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Party/cac:PartyName/cbc:Name) or (cac:Party/cac:PartyIdentification/cbc:ID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R012]-A catalogue supplier MUST contain the full name or an identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:SellerSupplierParty/cac:Party/cac:PostalAddress" priority="1004" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:SellerSupplierParty/cac:Party/cac:PostalAddress"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cbc:StreetName) and (cbc:CityName) and (cbc:PostalZone) and (cac:Country/cbc:IdentificationCode) "/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:StreetName) and (cbc:CityName) and (cbc:PostalZone) and (cac:Country/cbc:IdentificationCode)">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R014]-A catalogue supplier postal address SHOULD  have at least all of the following:
- Address line
- City
- Post code
- Country code</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:Item" priority="1003" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Item"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cbc:Name)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:Name)">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R019]-An item in a catalogue line SHOULD have a name</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:StandardItemIdentification/cbc:ID) or (cac:SellersItemIdentification/cbc:ID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:StandardItemIdentification/cbc:ID) or (cac:SellersItemIdentification/cbc:ID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R020]-An item in a catalogue line MUST be uniquely identifiable by at least one of the following:
- Catalogue Provider identifier
- Standard identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:StandardItemIdentification/cbc:ID/@schemeID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:StandardItemIdentification/cbc:ID/@schemeID)">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R021]-Standard Identifiers SHOULD contain the Schema Identifier (e.g. GTIN)</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:CommodityClassification/cbc:ItemClassificationCode/@listID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:CommodityClassification/cbc:ItemClassificationCode/@listID)">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R022]-Classification codes SHOULD contain the Classification scheme Identifier (e.g. CPV or UNSPSC)</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:RequiredItemLocationQuantity/cac:Price" priority="1002" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:RequiredItemLocationQuantity/cac:Price"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="number(cbc:PriceAmount) &gt;=0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:PriceAmount) &gt;=0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R015]-Prices of items MUST not be negative</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:AdditionalItemProperty" priority="1001" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AdditionalItemProperty"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cbc:Value)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:Value)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R027]-An item property data name  MUST specify a data value</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:ValidityPeriod" priority="1000" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:ValidityPeriod"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cbc:StartDate and cbc:EndDate) and (number(translate(string(cbc:StartDate),'-','')) &lt;= number(translate(string(cbc:EndDate),'-','')))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,'-','')) &lt;= number(translate(cbc:EndDate,'-','')))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R006]-A validity period end date MUST be later or equal to a validity period start date if both validity period end date and validaty period start date are present</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	<axsl:template match="text()" priority="-1" mode="M6"/>
	<axsl:template match="@*|node()" priority="-2" mode="M6">
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--PATTERN CodesT19-->


	<!--RULE -->

	<axsl:template match="cac:CatalogueLine//cbc:ActionCode" priority="1000" mode="M7">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:CatalogueLine//cbc:ActionCode"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="( (.='') or ( not(contains(normalize-space(.),' ')) and contains( ' Add Delete Update ',concat(' ',normalize-space(.),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' Add Delete Update ',concat(' ',normalize-space(.),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[CL-019-001]-The line action code for a catalogue line MUST be add, update or delete if present</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
	</axsl:template>
	<axsl:template match="text()" priority="-1" mode="M7"/>
	<axsl:template match="@*|node()" priority="-2" mode="M7">
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
	</axsl:template>
</axsl:stylesheet>