<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                 xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Order-2" version="2.0">
	<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. v1.2 14.4.2014 -->

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
		<axsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current()) and namespace-uri() = namespace-uri(current())])"/>
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
		<svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Norwegian rules for EHF Order" schemaVersion="">
			<axsl:comment>
				<axsl:value-of select="$archiveDirParameter"/>
				<axsl:value-of select="$archiveNameParameter"/>
				<axsl:value-of select="$fileNameParameter"/>
				<axsl:value-of select="$fileDirParameter"/>
			</axsl:comment>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:Order-2" prefix="ubl"/>
			<svrl:active-pattern>
				<axsl:attribute name="id">EHF-T01</axsl:attribute>
				<axsl:attribute name="name">EHF-T01</axsl:attribute>
				<axsl:apply-templates/>
			</svrl:active-pattern>
			<axsl:apply-templates select="/" mode="M6"/>
			<svrl:active-pattern>
				<axsl:attribute name="id">EHFProfiles_T01</axsl:attribute>
				<axsl:attribute name="name">EHFProfiles_T01</axsl:attribute>
				<axsl:apply-templates/>
			</svrl:active-pattern>
			<axsl:apply-templates select="/" mode="M7"/>
		</svrl:schematron-output>
	</axsl:template>

	<!--SCHEMATRON PATTERNS-->

	<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Norwegian rules for EHF Order</svrl:text>

	<!--PATTERN EHF-T01-->
	<!--RULE-->
	<axsl:template match="/ubl:Order" priority="1007" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order"/>
		
		
		
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="cac:BuyerCustomerParty/cac:Party"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:BuyerCustomerParty/cac:Party">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R002]- An order MUST contain buyer information</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="cac:SellerSupplierParty/cac:Party"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:BuyerCustomerParty/cac:Party">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R018]- An order MUST contain seller information</svrl:text>
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
					<svrl:text>[NOGOV-T01-R012]-An order MUST have a syntax identifier.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		

			<!--ASSERT -->
			<axsl:choose>
				<!--check that node is not empty, or only contains comments-->
				<axsl:when test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"/>
				<axsl:otherwise>
					<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)">
						<axsl:attribute name="flag">fatal</axsl:attribute>
						<axsl:attribute name="location">
							<axsl:apply-templates select="." mode="schematron-get-full-path"/>
						</axsl:attribute>
						<svrl:text>[NOGOV-T01-R006]-An order MUST not contain empty elements.</svrl:text>
					</svrl:failed-assert>
				</axsl:otherwise>
			</axsl:choose>
		
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	
	<axsl:template match="//cac:OrderLine/cac:LineItem" priority="1007" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:OrderLine/cac:LineItem"/>
		
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="cbc:Quantity"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:Quantity">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R005]- An order line item MUST have a quantity</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		

		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	<!--RULE-->
	<axsl:template match="//cac:BuyerCustomerParty" priority="1007" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:BuyerCustomerParty"/>
	
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="string-length(cac:Party/cac:Contact/cbc:ID) &gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cac:Party/cac:Contact/cbc:ID) &gt;0">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R001]-Kundens referanse BØR fylles ut i henhold til norske krav -- Customer reference SHOULD have a value</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	<!--RULE -->
	
	<axsl:template match="//*[contains(name(),'Date')]" priority="1000" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//*[contains(name(),'Date')]"/>
		
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(string(.) castable as xs:date) and (string-length(.) = 10)"/>
			
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(string(.) castable as xs:date) and (string-length(.) = 10)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R007]- A date must be formatted YYYY-MM-DD.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	<!--RULE-->
	<axsl:template match="//cac:PartyLegalEntity/cbc:CompanyID" priority="1000" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyLegalEntity/cbc:CompanyID"/>
		
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(string-length(.) = 9) and (string(.) castable as xs:integer)"/>
			
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(string-length(.) = 9) and (string(.) castable as xs:integer)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R010]- An organisational number MUST be nine numbers.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	<!--RULE-->
	<axsl:template match="//cac:PartyTaxScheme/cbc:CompanyID" priority="1000" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyTaxScheme/cbc:CompanyID"/>
		
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(string-length(.) = 12) and (substring(.,1,9) castable as xs:integer) and (substring(.,10,12)='MVA')"/>
			
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(string-length(.) = 12) and (substring(.,1,9) castable as xs:integer) and (substring(.,10,12)='MVA')">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R011]- A VAT number MUST be nine numbers followed by the letters MVA.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->
	<axsl:template match="//cac:Party/cbc:EndpointID" priority="1000" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Party/cbc:EndpointID"/>
		
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="@schemeID = 'NO:ORGNR'"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@schemeID = 'NO:ORGNR' ">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R008]-An endpoint identifier scheme MUST have the value 'NO:ORGNR'.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(string(.) castable as xs:integer) and (string-length(.) = 9)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(string(.) castable as xs:integer) and (string-length(.) = 9)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R009]- MUST be a norwegian organizational number. Only numerical value allowed</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	<!--RULE -->
	
	<axsl:template match="//cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference" priority="1002" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference"/>
		
		<!--ASSERT -->
		
		<axsl:choose>
			<axsl:when test="(cbc:URI !='')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:URI !='')">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R013]- URI MUST be specified when describing external reference documents.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	
	
	<!--RULE -->
	
	<axsl:template match="//cac:Contract" priority="1002" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Contract"/>
		
		<!--ASSERT -->
		
		<axsl:choose>
			<axsl:when test="(cbc:ID !='')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID !='')">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R014]- Contract ID MUST be specified when referencing contracts.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	
	<!--RULE -->
	
	<axsl:template match="//cac:PartyTaxScheme" priority="1002" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyTaxScheme"/>
		
		<!--ASSERT -->
		
		<axsl:choose>
			<axsl:when test="(cbc:CompanyID !='')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CompanyID !='')">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R016]- VAT identifier MUST be specified when VAT information is present</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	<!--RULE -->
	<axsl:template match="//cac:TaxScheme" priority="1012" mode="M6">
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
					<svrl:text>[NOGOV-T01-R017]-Every tax scheme MUST be defined through an identifier.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	<!--RULE -->
	
	<axsl:template match="//cac:Country" priority="1002" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Country"/>
		
		<!--ASSERT -->
		
		<axsl:choose>
			<axsl:when test="(cbc:IdentificationCode !='')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:IdentificationCode !='')">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R015]-Identification code MUST be specified when describing a country.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	<!--RULE -->

	<axsl:template match="//cac:OriginatorCustomerParty" priority="1002" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:OriginatorCustomerParty"/>
		
		<!--ASSERT -->
		
		<axsl:choose>
			<axsl:when test="(cac:Party !='')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Party !='')">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R019]-If originator element is present, party must be specified</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	<!--RULE -->

	<axsl:template match="//cac:AccountingCustomerParty" priority="1002" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingCustomerParty"/>
		
		<!--ASSERT -->
		
		<axsl:choose>
			<axsl:when test="(cac:Party !='')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Party !='')">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R020]-If invoicee element is present, party must be specified</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	<!--RULE -->
	
	<axsl:template match="@mimeCode" priority="1001" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@mimeCode"/>
		
		<!--ASSERT -->
		
		<axsl:choose>
			<axsl:when test="(( . = 'application/pdf' or . = 'image/gif' or . = 'image/tiff' or . = 'image/jpeg' or . = 'image/png' or . = 'text/plain' ))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(( . = 'application/pdf' or . = 'image/gif' or . = 'image/tiff' or . = 'image/jpeg' or . = 'image/png' or . = 'text/plain' ))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R021]-Attachment is not a recommended MIMEType.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	

	<!--RULE -->
	
	<axsl:template match="//cac:ClassifiedTaxCategory" priority="1002" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:ClassifiedTaxCategory"/>
		
		<!--ASSERT -->
		
		<axsl:choose>
			<axsl:when test="(cbc:ID !='')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID !='')">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R004]-If classified tax category is present, VAT category code must be specified</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	
	<!--RULE -->
	
	<axsl:template match="//cac:CommodityClassification" priority="1002" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:CommodityClassification"/>
		
		<!--ASSERT -->
		
		<axsl:choose>
			<axsl:when test="(cbc:ItemClassificationCode !='')"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ItemClassificationCode !='')">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R003]-If product classification element is present, classification code must be specified</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	
	<axsl:template match="text()" priority="-1" mode="M6"/>
	<axsl:template match="@*|node()" priority="-2" mode="M6">
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	
	<!--PATTERN EHFProfiles_T01 -->
	
	<!--RULE -->
	
	<axsl:template match="//cbc:ProfileID" priority="1001" mode="M7">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:ProfileID"/>
		
		<!--ASSERT -->
		
		<axsl:choose>
			<axsl:when test=". = 'urn:www.cenbii.eu:profile:bii28:ver2.0'"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
					test=". = 'urn:www.cenbii.eu:profile:bii01:ver2.0'">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
					</axsl:attribute>
					<svrl:text>[EHFPROFILE-T01-R001]-An order must only be used in profile 28</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
	</axsl:template>
	<axsl:template match="text()" priority="-1" mode="M7"/>
	<axsl:template match="@*|node()" priority="-2" mode="M7">
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/>
	</axsl:template>
	</axsl:stylesheet>