<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" version="2.0">
	<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. 	
	Oppdatert 04.02.2014 GuS-->
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
		<svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="BIIRULES  T58 bound to UBL" schemaVersion="">
			<axsl:comment>
				<axsl:value-of select="$archiveDirParameter"/>   
		 <axsl:value-of select="$archiveNameParameter"/>  
		 <axsl:value-of select="$fileNameParameter"/>  
		 <axsl:value-of select="$fileDirParameter"/>
			</axsl:comment>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
			<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" prefix="ubl"/>
			<svrl:active-pattern>
				<axsl:attribute name="id">UBL-T58</axsl:attribute>
				<axsl:attribute name="name">UBL-T58</axsl:attribute>
				<axsl:apply-templates/>
			</svrl:active-pattern>
			<axsl:apply-templates select="/" mode="M5"/>
		</svrl:schematron-output>
	</axsl:template>
	<!--SCHEMATRON PATTERNS-->
	<axsl:variable name="EndpointID_schemeID" select="',DUNS,GLN,IBAN,ISO 6523,DK:CPR,DK:CVR,DK:P,DK:SE,DK:VANS,FR:SIRET,SE:ORGNR,FI:OVT,IT:FTI,IT:SIA,IT:SECETI,IT:VAT,IT:CF,NO:ORGNR,NO:VAT,HU:VAT,EU:VAT,EU:REID,AT:VAT,AT:GOV,AT:CID,IS:KT,AT:KUR,ES:VAT,IT:IPA,AD:VAT,AL:VAT,BA:VAT,BE:VAT,BG:VAT,CH:VAT,CY:VAT,CZ:VAT,DE:VAT,EE:VAT,GB:VAT,GR:VAT,HR:VAT,IE:VAT,LI:VAT,LT:VAT,LU:VAT,LV:VAT,MC:VAT,ME:VAT,MK:VAT,MT:VAT,NL:VAT,PL:VAT,PT:VAT,RO:VAT,RS:VAT,SI:VAT,SK:VAT,SM:VAT,TR:VAT,VA:VAT,'"/>
	<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BIIRULES  T58 bound to UBL</svrl:text>
	<!--PATTERN UBL-T58-->
	<!--RULE -->
	<axsl:template match="/ubl:ApplicationResponse" priority="1002" mode="M5">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:ApplicationResponse"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="string-length(cbc:ProfileID) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:ProfileID) &gt;0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T58-R001]-En katalogbekreftelse må ha en profil ID -- A catalogue response MUST have a profile identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="string-length(cbc:CustomizationID) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:CustomizationID) &gt; 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T58-R002]-En katalogbekreftelse må ha en "customization ID" -- A catalogue response MUST have a customization identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="string-length(string(cbc:IssueDate)) &gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(string(cbc:IssueDate)) &gt;0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T58-R003]-En katalogbekreftelse må ha utstedelses dato -- A catalogue response MUST contain the date of issue</svrl:text>
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
					<svrl:text>[BII2-T58-R004]-En katalogbekreftelse må ha en ID for bekreftelsen -- A catalogue response MUST contain the response identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(cac:SenderParty)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:SenderParty)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T58-R005]-Utsteder må være spesifisert -- The party sending the catalogue response MUST be specified</svrl:text>
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
					<svrl:text>[BII2-T58-R006]-En katalogbekreftelse må spesifisere en mottaker -- The party receiving the catalogue response MUST be specified</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(cac:DocumentResponse/cac:Response/cbc:ResponseCode)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:DocumentResponse/cbc:ResponseCode)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T58-R009]-En katalogbekreftelse må ha en respons kode -- A catalogue response MUST contain a response code</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(cac:DocumentResponse/cac:DocumentReference/cbc:ID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:DocumentReference/cbc:ID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T58-R010]-En katalogbekreftelse må ha en dokument referanse -- A catalogue response MUST contain a document reference</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="//cac:SenderParty" priority="1001" mode="M5">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:SenderParty"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PartyName/cbc:Name) or (cac:PartyIdentification/cbc:ID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T58-R008]-Utsteder må være identifisert med fullt navn eller ID -- A catalogue response receiving party MUST contain the full name or an identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="not(cbc:EndpointID) or contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,','))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not cbc:EndpointID or contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,','))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T58-R001]-Endepunkt ID må inneholde gyldig attributt schemeID -- An endpoint identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T58-R002]-Aktør ID må inneholde gyldig attributt schemeID -- A party identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="//cac:ReceiverParty" priority="1000" mode="M5">
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
					<svrl:text>[BII2-T58-R007]-Mottaker må være identifisert med fullt navn eller ID --- A catalogue response sending party MUST contain the full name or an identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:choose>
			<!--ASSERT -->
			<axsl:when test="not(cbc:EndpointID) or contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,','))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not cbc:EndpointID or contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,','))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T58-R001]-Endepunkt ID må inneholde gyldig attributt schemeID -- An endpoint identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T58-R002]-Aktør ID må inneholde gyldig attributt schemeID -- A party identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
	</axsl:template>
	<axsl:template match="text()" priority="-1" mode="M5"/>
	<axsl:template match="@*|node()" priority="-2" mode="M5">
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M5"/>
	</axsl:template>
</axsl:stylesheet>
