<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" version="2.0">
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
			<axsl:when test="namespace-uri()=''">@<axsl:value-of select="name()"/>
			</axsl:when>
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
			<axsl:text/>/@<axsl:value-of select="name(.)"/>
		</axsl:if>
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
			<axsl:text/>/@<axsl:value-of select="name(.)"/>
		</axsl:if>
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
		<svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Sjekk mot norsk bokf.lov" schemaVersion="">
			<axsl:comment>
				<axsl:value-of select="$archiveDirParameter"/>   
		 <axsl:value-of select="$archiveNameParameter"/>  
		 <axsl:value-of select="$fileNameParameter"/>  
		 <axsl:value-of select="$fileDirParameter"/>
			</axsl:comment>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl"/>
			<svrl:active-pattern>
				<axsl:attribute name="id">NONATUBL-T10</axsl:attribute>
				<axsl:attribute name="name">NONATUBL-T10</axsl:attribute>
				<axsl:apply-templates/>
			</svrl:active-pattern>
			<axsl:apply-templates select="/" mode="M16"/>
		</svrl:schematron-output>
	</axsl:template>
	<!--SCHEMATRON PATTERNS-->
	<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Sjekk mot norsk bokf.lov</svrl:text>
	<!--PATTERN NONATUBL-T10-->
	<!--RULE -->
	<axsl:template match="//cac:AccountingSupplierParty/cac:Party" priority="1003" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(cac:PartyLegalEntity/cbc:CompanyID != '')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PartyLegalEntity/cbc:CompanyID != '')">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R001]-The Norwegian legal registration ID for the supplier MUST be provided according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 2"</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<!-- 2013-05-10 EG Changed from warning to Fatal -->
		<axsl:choose>
			<axsl:when test="(cac:PartyLegalEntity/cbc:RegistrationName != '')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PartyLegalEntity/cbc:RegistrationName != '')">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R008]-The Norwegian legal registration name for the supplier MUST be provided according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 2"</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="((cac:PostalAddress/cbc:CityName !='') and (cac:PostalAddress/cbc:PostalZone != '') and (cac:PostalAddress/cac:Country/cbc:IdentificationCode != ''))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:PostalAddress/cbc:CityName !='') and (cac:PostalAddress/cbc:PostalZone != '') and (cac:PostalAddress/cac:Country/cbc:IdentificationCode != ''))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R006]-A supplier postal address in an invoice MUST contain at least city name, zip code and country code.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="/ubl:Invoice" priority="1001" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="not(count(//*[not(text()) and count(*) = 0]) &gt; 0)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(count(//*[not(text())]) &gt; 0)">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R025]-An invoice SHOULD not contain empty elements.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="cac:TaxTotal"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:TaxTotal">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R012]-An invoice MUST contain tax information</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="//cac:PaymentMeans/cbc:PaymentDueDate"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//cac:PaymentMeans/cbc:PaymentDueDate">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R002]-Payment due date MUST be provided in the invoice according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 5" </svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name != '')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R013]-If payee information is provided then the payee name MUST be specified.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(cbc:UBLVersionID != '')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:UBLVersionID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R019]-An invoice MUST have a syntax identifier.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<!-- 2013-05-10 EG Check Issue date against todays date -->
			<axsl:when test="(cbc:IssueDate) and current-date() &gt;= cbc:IssueDate or (not(cbc:IssueDate))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:IssueDate) and current-date() &gt;= cbc:IssueDate or (not(cbc:IssueDate))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R009]-Issue date of an invoice should be today or earlier.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="//cac:Delivery/cbc:ActualDeliveryDate"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//cac:Delivery/cbc:ActualDeliveryDate">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R003]-The actual delivery date SHOULD be provided in the invoice according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 4 and § 5-1-4", see also “NOU 2002:20, point 9.4.1.4”" </svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="//cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName and //cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone and //cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName and //cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone and //cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R004]-A Delivery address in an invoice SHOULD contain at least, city, zip code and country code according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 4 and § 5-1-4", see also “NOU 2002:20, point 9.4.1.4”</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="cbc:UBLVersionID" priority="1008" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:UBLVersionID"/>
		<!--ASSERT -->
		<!-- 2013-09-09 EG Added test regarding UBL version -->
		<axsl:choose>
			<axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 2.1  ',concat(' ',normalize-space(.),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' 2.1 ',concat(' ',normalize-space(.),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R020]-UBL version  must be 2.1</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="//cac:AccountingCustomerParty/cac:Party" priority="1000" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingCustomerParty/cac:Party"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R007]-A customer postal address in an invoice MUST contain at least city name, zip code and country code.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<!--2013-05-14 EG Added GSRN as possible location identifier -->
	<axsl:template match="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID" priority="1004" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN GSRN ',concat(' ',normalize-space(.),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN GSRN ',concat(' ',normalize-space(.),' ') ) ) )">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R010]-Location identifiers SHOULD be GLN or GSRN</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="//cac:PartyLegalEntity" priority="1009" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyLegalEntity"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(cbc:CompanyID != '')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CompanyID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R018]-Company identifier MUST be specified when describing a company legal entity.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="cac:PayeeFinancialAccount/cbc:ID//@schemeID" priority="1005" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:PayeeFinancialAccount/cbc:ID//@schemeID"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' IBAN BBAN LOCAL ',concat(' ',normalize-space(.),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' IBAN BBAN LOCAL ',concat(' ',normalize-space(.),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R024]-A payee account identifier scheme MUST be either IBAN, BBAN or LOCAL</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="cac:TaxCategory//cbc:ID" priority="1000" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory//cbc:ID"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AA E H K R S Z ',concat(' ',normalize-space(.),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AA E H K R S Z ',concat(' ',normalize-space(.),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R021]- Invoice tax categories MUST be one of the follwoing codes:  AA E H K R S Z</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="//cac:TaxScheme" priority="1012" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxScheme"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="cbc:ID"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[ NONAT-T10-R017]-Every tax scheme MUST be defined through an identifier.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="cac:TaxScheme//cbc:ID" priority="1001" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxScheme//cbc:ID"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' VAT ',concat(' ',normalize-space(.),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' VAT ',concat(' ',normalize-space(.),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R014]- Invoice tax schemes MUST be 'VAT'</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="//cac:LegalMonetaryTotal" priority="1000" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:LegalMonetaryTotal"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="number(cbc:TaxInclusiveAmount) &gt;= 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:TaxInclusiveAmount) &gt;= 0">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[ NONAT-T10-R023]-Tax inclusive amount in an invoice SHOULD NOT be negative</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="number(cbc:PayableAmount) &gt;= 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:PayableAmount) &gt;= 0">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[ NONAT-T10-R022]-Total payable amount in an invoice SHOULD NOT be negative</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="//cac:AllowanceCharge" priority="1009" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AllowanceCharge"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(cbc:AllowanceChargeReason)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:AllowanceChargeReason)">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[ NONAT-T10-R011]-AllowanceChargeReason text SHOULD be specified for all allowances and charges</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="//cac:InvoiceLine" priority="1004" mode="M16">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(cac:Item/cbc:Name)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Item/cbc:Name)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[ NONAT-T10-R016]-Each invoice line MUST contain the product/service name</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="cac:Price/cbc:PriceAmount"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:Price/cbc:PriceAmount">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R015]-Invoice lines MUST contain the item price</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
	<!--ASSERT Test if LineExtensionAmount is less than 0.  Separate logic due to problems with rounding of negative values -->

      <axsl:choose>
         <axsl:when test="not(cbc:InvoicedQuantity) or 
                                   not(cac:Price/cbc:PriceAmount) or 
                                   number(cbc:LineExtensionAmount) &gt; 0 
                                   or (cbc:InvoicedQuantity) &gt; 0 
                                   or 
                                   (not(cac:Price/cbc:BaseQuantity)  and abs(number(cbc:LineExtensionAmount)) = 
         round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * abs(xs:decimal(cbc:InvoicedQuantity))) div 100) + 
         ((round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - 
         (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 )) * -1 ) * 10 * 10) div 100) or
          ((cac:Price/cbc:BaseQuantity) and 
          abs(number(cbc:LineExtensionAmount)) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity)) * abs(xs:decimal(cbc:InvoicedQuantity))) div 100) +
           ((round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) -
           (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) * -1) *10 *10) div 100)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" 
            	test="not(cbc:InvoicedQuantity) or 
            	not(cac:Price/cbc:PriceAmount) or 
            	number(cbc:LineExtensionAmount) &gt; 0 
            	or (cbc:InvoicedQuantity) &gt; 0 
            	or 
            	(not(cac:Price/cbc:BaseQuantity)  and abs(number(cbc:LineExtensionAmount)) = 
            	round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * abs(xs:decimal(cbc:InvoicedQuantity))) div 100) + 
            	((round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - 
            	(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 )) * -1 ) * 10 * 10) div 100) or
            	((cac:Price/cbc:BaseQuantity) and 
            	abs(number(cbc:LineExtensionAmount)) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity)) * abs(xs:decimal(cbc:InvoicedQuantity))) div 100) +
            	((round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) -
            	(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) * -1) *10 *10) div 100)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NONAT-T10-R026]-Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      
      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:InvoicedQuantity) or 
                                   not(cac:Price/cbc:PriceAmount) or 
                                   number(cbc:LineExtensionAmount) &lt; 0 
                                   or
                                   (not(cac:Price/cbc:BaseQuantity) and (number(cbc:LineExtensionAmount)) = 
         round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:InvoicedQuantity)) div 100) + 
         (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - 
         (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) * 10 * 10) div 100) or 
         ((cac:Price/cbc:BaseQuantity) and 
         number(cbc:LineExtensionAmount) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity) * xs:decimal(cbc:InvoicedQuantity))) div 100) +
         (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) -
         (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) *10 *10) div 100)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" 
            	test="not(cbc:InvoicedQuantity) or 
            	not(cac:Price/cbc:PriceAmount) or 
            	number(cbc:LineExtensionAmount) &lt; 0 
            	or
            	(not(cac:Price/cbc:BaseQuantity) and (number(cbc:LineExtensionAmount)) = 
            	round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:InvoicedQuantity)) div 100) + 
            	(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - 
            	(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) * 10 * 10) div 100) or 
            	((cac:Price/cbc:BaseQuantity) and 
            	number(cbc:LineExtensionAmount) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity) * xs:decimal(cbc:InvoicedQuantity))) div 100) +
            	(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) -
            	(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) *10 *10) div 100)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NONAT-T10-R026]-Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
		
	<axsl:choose>
			<axsl:when test="not(cbc:InvoicedQuantity) or 
				not(cac:Price/cbc:PriceAmount) or 
				number(cbc:LineExtensionAmount) &gt; 0 
				or (cbc:InvoicedQuantity) &lt; 0 
				or 				
				(not(cac:Price/cbc:BaseQuantity) and (number(cbc:LineExtensionAmount)) = 
				round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:InvoicedQuantity)) div 100) + 
				(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - 
				(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) * 10 * 10) div 100) or 
				((cac:Price/cbc:BaseQuantity) and 
				number(cbc:LineExtensionAmount) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity) * xs:decimal(cbc:InvoicedQuantity))) div 100) +
				(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) -
				(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) *10 *10) div 100)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" 
					test="not(cbc:InvoicedQuantity) or 
					not(cac:Price/cbc:PriceAmount) or 
					number(cbc:LineExtensionAmount) &gt; 0 
					or (cbc:InvoicedQuantity) &lt; 0 
					or 				
					(not(cac:Price/cbc:BaseQuantity) and (number(cbc:LineExtensionAmount)) = 
					round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:InvoicedQuantity)) div 100) + 
					(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - 
					(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) * 10 * 10) div 100) or 
					((cac:Price/cbc:BaseQuantity) and 
					number(cbc:LineExtensionAmount) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity) * xs:decimal(cbc:InvoicedQuantity))) div 100) +
					(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) -
					(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) *10 *10) div 100)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NONAT-T10-R026]-Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
	<axsl:template match="text()" priority="-1" mode="M16"/>
	<axsl:template match="@*|node()" priority="-2" mode="M16">
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
	</axsl:template>
</axsl:stylesheet>