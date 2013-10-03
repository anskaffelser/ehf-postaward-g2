<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                 xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" version="2.0">
	<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. 	
	Oppdatert 02.10.2013 GuS-->

	<axsl:param name="archiveDirParameter" tunnel="no"/>
	<axsl:param name="archiveNameParameter" tunnel="no"/>
	<axsl:param name="fileNameParameter" tunnel="no"/>
	<axsl:param name="fileDirParameter" tunnel="no"/>

	<!--PHASES-->


	<!--PROLOG-->

	<axsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes" encoding="UTF-8"/>

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

	<axsl:variable name="CountryCode"
	               select="',AF,AD,AE,AG,AI,AL,AM,AN,AO,AQ,AR,AS,AT,AU,AW,AX,AZ,BA,BB,BD,BE,BF,BG,BH,BI,BJ,BL,BM,BN,BO,BR,BS,BT,BV,BW,BY,BZ,CA,CC,CD,CF,CG,CH,CI,CK,CL,CM,CN,CO,CR,CU,CV,CX,CY,CZ,DE,DJ,DK,DM,DO,DZ,EC,EE,EG,EH,ER,ES,ET,FI,FJ,FK,FM,FO,FR,GA,GB,GD,GE,GF,GG,GH,GI,GL,GM,GN,GP,GQ,GR,GS,GT,GU,GW,GY,HK,HM,HN,HR,HT,HU,ID,IE,IL,IM,IN,IO,IQ,IR,IS,IT,JE,JM,JO,JP,KE,KG,KH,KI,KM,KN,KP,KR,KW,KY,KZ,LA,LB,LC,LI,LK,LR,LS,LT,LU,LV,LY,MA,MC,MD,ME,MF,MG,MH,MK,ML,MM,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,MZ,NA,NC,NE,NF,NG,NI,NL,NO,NP,NR,NU,NZ,OM,PA,PE,PF,PG,PH,PK,PL,PM,PN,PR,PS,PT,PW,PY,QA,RE,RO,RS,RU,RW,SA,SB,SC,SD,SE,SG,SH,SI,SJ,SK,SL,SM,SN,SO,SR,ST,SV,SY,SZ,TC,TD,TF,TG,TH,TJ,TK,TL,TM,TN,TO,TR,TT,TV,TW,TZ,UA,UG,UM,US,UY,UZ,VA,VC,VE,VG,VI,VN,VU,WF,WS,YE,YT,ZA,ZM,ZW,'"/>
	<axsl:variable name="CountryCode_listID" select="'ISO3166 - 1:Alpha2'"/>
	<axsl:variable name="CatAction_listID" select="'ACTIONCODE:PEPPOL'"/>
	<axsl:variable name="EndpointID_schemeID"
	               select="',DUNS,GLN,IBAN,ISO 6523,DK:CPR,DK:CVR,DK:P,DK:SE,DK:VANS,FR:SIRET,SE:ORGNR,FI:OVT,IT:FTI,IT:SIA,IT:SECETI,IT:VAT,IT:CF,NO:ORGNR,NO:VAT,HU:VAT,EU:VAT,EU:REID,AT:VAT,AT:GOV,AT:CID,IS:KT,AT:KUR,ES:VAT,IT:IPA,AD:VAT,AL:VAT,BA:VAT,BE:VAT,BG:VAT,CH:VAT,CY:VAT,CZ:VAT,DE:VAT,EE:VAT,GB:VAT,GR:VAT,HR:VAT,IE:VAT,LI:VAT,LT:VAT,LU:VAT,LV:VAT,MC:VAT,ME:VAT,MK:VAT,MT:VAT,NL:VAT,PL:VAT,PT:VAT,RO:VAT,RS:VAT,SI:VAT,SK:VAT,SM:VAT,TR:VAT,VA:VAT,'"/>

	<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BIIRULES  T19 bound to UBL</svrl:text>

	<!--PATTERN UBL-T19-->


	<!--RULE -->

	<axsl:template match="/ubl:Catalogue" priority="1010" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Catalogue"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:CustomizationID) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CustomizationID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R001]- Katlogen må ha en "customization ID" -- A catalogue MUST have a customization identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:ProfileID) &gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ProfileID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R002]-Katalogen må ha en profilidentifikator *** A catalogue MUST have a profile identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(string(cbc:IssueDate)) &gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:IssueDate) &gt;0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R003]-En Katalog må ha en utstedelses dato -- A catalogue MUST contain the date of issue</svrl:text>
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
					<svrl:text>[BII2-T19-R004]-En Katalog må ha katalog dokument identifikator -- A catalogue MUST contain the catalogue document identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!-- ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:ActionCode) &gt;0">
			</axsl:when>
			<axsl:when test="not(cac:CatalogueLine[cbc:ActionCode =''])">
			</axsl:when>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ActionCode ='' and cac:CatalogueLine[cbc:Actioncode !='']">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T19-R001]-En katalog må ha aksjonskode enten på hode- eller linjenivå -- A Catalogue must contain ActionCode on either Header or Line level</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="string-length(cbc:ActionCode) &gt;0">
				<axsl:choose>
					<axsl:when test="cbc:ActionCode/@listID = $CatAction_listID">
					</axsl:when>
					<axsl:otherwise>
						<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ActionCode/@listID = $CatAction_listID">
							<axsl:attribute name="flag">fatal</axsl:attribute>
							<axsl:attribute name="location">
								<axsl:apply-templates select="." mode="schematron-get-full-path"/>
							</axsl:attribute>
							<svrl:text>[EUGEN-T19-R046]- Aksjonskode på hodenivå MÅ ha en lovlig listID attributt -- A catalogue header action code MUST have a list identifier attribute</svrl:text>
							<axsl:value-of select="$CatAction_listID"/>
						</svrl:failed-assert>
					</axsl:otherwise>
				</axsl:choose>
			</axsl:when>
		</axsl:choose>


		<!-- ASSERT -->

		<axsl:choose>
			<axsl:when test="number(translate(substring-before(string(current-date()),'+'),'-','')) &lt;= number(translate(string(//cac:ValidityPeriod/cbc:EndDate),'-',''))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(translate(substring-before(string(current-date()),'+'),'-','')) &lt;= number(translate(string(//cac:ValidityPeriod/cbc:EndDate),'-',''))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T19-R002]- Katalogens gyldighetsperiode må ha en sluttdato som er etter eller lik dagens dato -- A Catalogue must have a validity period enddate grater or equal to the current date</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:VersionID) &gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:VersionID) &gt;0">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R005]-En katalogversjon BØR alltid være spesifisert -- A catalogue version SHOULD always be specified</svrl:text>
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
					<svrl:text>[BII2-T19-R007]-Katalogutsteder må spesifiseres  -- The party providing the catalogue MUST be specified</svrl:text>
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
					<svrl:text>[BII2-T19-R008]-Katalogmottaker må spesifiseres -- The party receiving the catalogue MUST be specified</svrl:text>
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
					<svrl:text>[BII2-T19-R009]- Katalogen MÅ ha maksimum en leverandør -- A catalogue MUST have maximum one catalogue supplier</svrl:text>
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
					<svrl:text>[BII2-T19-R023]- Katalogen MÅ ha minst EN kataloglinje -- A catalogue MUST have at least one catalogue line</svrl:text>
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
			<axsl:when test="string-length(cac:Party/cac:PartyName/cbc:Name)&gt;0 or string-length(cac:Party/cac:PartyIdentification/cbc:ID)&gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cac:Party/cac:PartyName/cbc:Name)&gt;0 or string-length(cac:Party/cac:PartyIdentification/cbc:ID)&gt;0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R013]- Kjøper må spesifiseres med fullt navn eller med en idenifikator -- A catalogue customer MUST contain the full name or an identifier</svrl:text>
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
			<axsl:when test="not ((cac:LineValidityPeriod/cbc:StartDate) and (cac:LineValidityPeriod/cbc:EndDate)) or ((cac:LineValidityPeriod/cbc:StartDate and cac:LineValidityPeriod/cbc:EndDate) and (number(translate(string(cac:LineValidityPeriod/cbc:StartDate),'-','')) &gt;= number(translate(string(//cac:ValidityPeriod/cbc:StartDate),'-',''))) and (number(translate(string(cac:LineValidityPeriod/cbc:EndDate),'-','')) &lt;= number(translate(string(//cac:ValidityPeriod/cbc:EndDate),'-',''))))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="not ((cac:LineValidityPeriod/cbc:StartDate) and (cac:LineValidityPeriod/cbc:EndDate)) or ((cac:LineValidityPeriod/cbc:StartDate and cac:LineValidityPeriod/cbc:EndDate) and (number(translate(string(cac:LineValidityPeriod/cbc:StartDate),'-','')) &gt;= number(translate(string(//cac:ValidityPeriod/cbc:StartDate),'-',''))) and (number(translate(string(cac:LineValidityPeriod/cbc:EndDate),'-','')) &lt;= number(translate(string(//cac:ValidityPeriod/cbc:EndDate),'-',''))))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R017]- Gyldighetsperioden på linjenivå MÅ være innenfor gyldighetsperioden på hodenivå -- Catalogue line validity period MUST be within the range of the whole catalogue validity period</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cac:Price/cac:ValidityPeriod/cbc:StartDate and cac:Price/cac:ValidityPeriod/cbc:EndDate)"/>
			<axsl:when test="(number(translate(string(cac:Price/cac:ValidityPeriod/cbc:StartDate),'-','')) &gt;= number(translate(string(//cac:ValidityPeriod/cbc:StartDate),'-',''))) and (number(translate(string(cac:Price/cac:ValidityPeriod/cbc:EndDate),'-','')) &lt;= number(translate(string(//cac:ValidityPeriod/cbc:EndDate),'-','')))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="(//cac:UsabilityPeriod/cbc:StartDate and //cac:UsabilityPeriod/cbc:EndDate) and (number(translate(//cac:UsabilityPeriod/cbc:StartDate,'-','')) &gt;= number(translate(//cac:LineValidityPeriod/cbc:StartDate,'-',''))) and (number(translate(//cac:UsabilityPeriod/cbc:EndDate,'-','')) &lt;= number(translate(//cac:LineValidityPeriod/cbc:EndDate,'-','')))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R018]-Prisperioden bør være innenfor katalogens gyldighetsperiode -- Price validity period SHOULD be within the range of the whole catalogue line validity period</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:ID) &gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:ID) &gt;0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R024]- Kataloglinjen MÅ ha en unik linjeidentidikator -- A catalogue line MUST contain a unique line identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>



		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string(cbc:OrderableIndicator) ='false' or number(cbc:ContentUnitQuantity) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:ContentUnitQuantity) &gt; 0 or cbc:OrderableIndicator ='false'">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R026]-Bestillbar kvantum MÅ være større enn null -- Orderable quantitites MUST be greater than zero</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>



		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cbc:MaximumOrderQuantity)"/>
			<axsl:when test="number(cbc:MaximumOrderQuantity) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:MaximumOrderQuantity) &gt; 0">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R029]- Største bestillbare kvantum bør være større enn null -- Maximum quantity SHOULD be greater than zero</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cbc:MinimumOrderQuantity)"/>
			<axsl:when test="number(cbc:MinimumOrderQuantity) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:MinimumOrderQuantity) &gt; 0">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R030]-Minimum bestillingsantall bør være større enn null -- Minimum quantity SHOULD be greater than zero</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cbc:MinimumOrderQuantity) or not(cbc:MaximumOrderQuantity)"/>
			<axsl:when test="number(cbc:MinimumOrderQuantity) &lt;= number(cbc:MaximumOrderQuantity)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:MaximumOrderQuantity) &gt;= number(cbc:MinimumOrderQuantity)">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R031]-Maksimum kvantitet BØR være større eller lik Minimum kvantitet -- Maximum quantity SHOULD be greater or equal to the Minimum quantity</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(number(cbc:ContentUnitQuantity) &gt;= 0) or ((cbc:ContentUnitQuantity/@unitCode) and (cbc:ContentUnitQuantity/@unitCodeListID ='UNECERec20'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(number(cbc:ContentUnitQuantity) &gt;= 0) or ((cbc:ContentUnitQuantity/@unitCode) and (cbc:ContentUnitQuantity/@unitCodeListID ='UNECERec20'))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R048 OP-T19-002]-Et enhetskode attributt (unitCode) MÅ ha et tilhørende unitCodeListID med verdi “UNECERec20” og enhetskoden MÅ være i henhold til kodelisten  -- A unit code attribute MUST have a unit code list identifier attribute “UNECERec20” and the unit code MUST be according to the code list</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(number(cbc:MinimumOrderQuantity) &gt;= 0) or ((cbc:MinimumOrderQuantity/@unitCode) and (cbc:MinimumOrderQuantity/@unitCodeListID ='UNECERec20'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(number(cbc:MinimumOrderQuantity) &gt;= 0) or ((cbc:MinimumOrderQuantity/@unitCode) and (cbc:MinimumOrderQuantity/@unitCodeListID ='UNECERec20'))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R048 OP-T19-002]-Et enhetskode attributt (unitCode) MÅ ha et tilhørende unitCodeListID med verdi “UNECERec20” og enhetskoden MÅ være i henhold til kodelisten  -- A unit code attribute MUST have a unit code list identifier attribute “UNECERec20” and the unit code MUST be according to the code list</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(number(cbc:MaximumOrderQuantity) &gt;= 0) or ((cbc:MaximumOrderQuantity/@unitCode) and (cbc:MaximumOrderQuantity/@unitCodeListID ='UNECERec20'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(number(cbc:MaximumOrderQuantity) &gt;= 0) or ((cbc:MaximumOrderQuantity/@unitCode) and (cbc:MaximumOrderQuantity/@unitCodeListID ='UNECERec20'))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R048 OP-T19-002]-Et enhetskode attributt (unitCode) MÅ ha et tilhørende unitCodeListID med verdi “UNECERec20” og enhetskoden MÅ være i henhold til kodelisten  -- A unit code attribute MUST have a unit code list identifier attribute “UNECERec20” and the unit code MUST be according to the code list</svrl:text>
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
					<svrl:text>[BII2-T19-R010]-En katalogutsteder MÅ ha fullt navn eller en ID -- A catalogue provider MUST contain the full name or an identifier</svrl:text>
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
					<svrl:text>[EUGEN-T19-R043]-Endepunkt ID må inneholde attributt schemeID -- An endpoint identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R043]-Aktør ID må inneholde attributt schemeID -- A party identifier MUST have a scheme identifier attribute</svrl:text>
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
					<svrl:text>[BII2-T19-R011]-Katalog mottaker MÅ ha fullt navn eller en ID -- A catalogue receiver MUST contain the full name or an identifier</svrl:text>
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
					<svrl:text>[EUGEN-T19-R043]-Endepunkt ID må inneholde attributt schemeID -- An endpoint identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R043]-Aktør ID må inneholde attributt schemeID -- A party identifier MUST have a scheme identifier attribute</svrl:text>
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
					<svrl:text>[BII2-T19-R012]-Leverandør MÅ ha fullt navn eller en ID -- A catalogue supplier MUST contain the full name or an identifier</svrl:text>
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
					<svrl:text>[EUGEN-T19-R043]-Endepunkt ID må inneholde attributt schemeID -- An endpoint identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R043]-Aktør ID må inneholde attributt schemeID -- A party identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>


	<!--RULE -->

	<axsl:template match="//cac:ContractorCustomerParty" priority="1004" mode="M6">
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
					<svrl:text>[BII2-T19-R013]-Kjøper MÅ ha fullt navn eller en ID -- A catalogue customer MUST contain the full name or an identifier</svrl:text>
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
					<svrl:text>[EUGEN-T19-R043]-Endepunkt ID må inneholde attributt schemeID -- An endpoint identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R043]-Aktør ID må inneholde attributt schemeID -- A party identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!-- R014 tatt bort i 1.0 versjon -->


	<!--RULE -->

	<axsl:template match="//cac:Item" priority="1003" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Item"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:Name) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:Name) &gt; 0">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R019]-En artikkel (item) BØR ha et navn -- An item in a catalogue line SHOULD have a name</svrl:text>
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
					<svrl:text>[BII2-T19-R020]-En artikkel(item) i en kataloglinje MÅ kunne identifiseres med enten "Catalogue Provider identifier" eller "Standard identifier" -- An item in a catalogue line MUST be uniquely identifiable by at least one of the following:
- Catalogue Provider identifier
- Standard identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(string-length(cac:StandardItemIdentification/cbc:ID) = 0) or ((string-length(cac:StandardItemIdentification/cbc:ID) &gt; 0) and (string-length(cac:StandardItemIdentification/cbc:ID/@schemeID) &gt; 0))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="(string-length(cac:StandardItemIdentification/cbc:ID) = 0) or ((string-length(cac:StandardItemIdentification/cbc:ID) &gt; 0) and (string-length(cac:StandardItemIdentification/cbc:ID/@schemeID) &gt; 0))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R021]- "Standard Identifiers" BØR referere til en skjemaidentifikator som f eks GTIN -- Standard Identifiers SHOULD contain the Schema Identifier (e.g. GTIN)</svrl:text>
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
					<svrl:text>[BII2-T19-R022]- Kategorikoder BØR referere til en skjemaidentifikator (f.eks. CPV or UNSPSC) -- Classification codes SHOULD contain the Classification scheme Identifier (e.g. CPV or UNSPSC)</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(number(cbc:PackQuantity) &gt;= 0) or ((cbc:PackQuantity/@unitCode) and (cbc:PackQuantity/@unitCodeListID ='UNECERec20'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(number(cbc:PackQuantity) &gt;= 0) or ((cbc:PackQuantity/@unitCode) and (cbc:PackQuantity/@unitCodeListID ='UNECERec20'))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R048 OP-T19-002]-Et enhetskode attributt (unitCode) MÅ ha et tilhørende unitCodeListID med verdi “UNECERec20” og enhetskoden MÅ være i henhold til kodelisten  -- A unit code attribute MUST have a unit code list identifier attribute “UNECERec20” and the unit code MUST be according to the code list</svrl:text>
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
					<svrl:text>[BII2-T19-R015]-Prisen på en artikkel MÅ ikke være negativ -- Prices of items MUST not be negative</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(number(cbc:BaseQuantity) &gt;= 0) or ((cbc:BaseQuantity/@unitCode) and (cbc:BaseQuantity/@unitCodeListID ='UNECERec20'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(number(cbc:BaseQuantity) &gt;= 0) or ((cbc:BaseQuantity/@unitCode) and (cbc:BaseQuantity/@unitCodeListID ='UNECERec20'))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R048 OP-T19-002]-Et enhetskode attributt (unitCode) MÅ ha et tilhørende unitCodeListID med verdi “UNECERec20” og enhetskoden MÅ være i henhold til kodelisten  -- A unit code attribute MUST have a unit code list identifier attribute “UNECERec20” and the unit code MUST be according to the code list</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:RequiredItemLocationQuantity" priority="1014" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:RequiredItemLocationQuantity"/>


		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(number(cbc:MinimumQuantity) &gt;= 0) or ((cbc:MinimumQuantity/@unitCode) and (cbc:MinimumQuantity/@unitCodeListID ='UNECERec20'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(number(cbc:MinimumQuantity) &gt;= 0) or ((cbc:MinimumQuantity/@unitCode) and (cbc:MinimumQuantity/@unitCodeListID ='UNECERec20'))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R048 OP-T19-002]-Et enhetskode attributt (unitCode) MÅ ha et tilhørende unitCodeListID med verdi “UNECERec20” og enhetskoden MÅ være i henhold til kodelisten  -- A unit code attribute MUST have a unit code list identifier attribute “UNECERec20” and the unit code MUST be according to the code list</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(number(cbc:MaximumQuantity) &gt;= 0) or ((cbc:MaximumQuantity/@unitCode) and (cbc:MaximumQuantity/@unitCodeListID ='UNECERec20'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(number(cbc:MaximumOrderQuantity) &gt;= 0) or ((cbc:MaximumOrderQuantity/@unitCode) and (cbc:MaximumOrderQuantity/@unitCodeListID ='UNECERec20'))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R048 OP-T19-002]-Et enhetskode attributt (unitCode) MÅ ha et tilhørende unitCodeListID med verdi “UNECERec20” og enhetskoden MÅ være i henhold til kodelisten  -- A unit code attribute MUST have a unit code list identifier attribute “UNECERec20” and the unit code MUST be according to the code list</svrl:text>
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
			<axsl:when test="(string-length(cbc:Name ) =0) or (string-length(cbc:Value) &gt;0)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(string-length(cbc:Name ) =0) or (string-length(cbc:Value) &gt;0)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T19-R027]-Tilleggsegenskaper MÅ spesifisere en verdi -- An item property data name MUST specify a data value</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(number(cbc:ValueQuantity) &gt;= 0) or ((cbc:ValueQuantity/@unitCode) and (cbc:ValueQuantity/@unitCodeListID ='UNECERec20'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(number(cbc:ValueQuantity) &gt;= 0) or ((cbc:ValueQuantity/@unitCode) and (cbc:ValueQuantity/@unitCodeListID ='UNECERec20'))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R048 OP-T19-002]-Et enhetskode attributt (unitCode) MÅ ha et tilhørende unitCodeListID med verdi “UNECERec20” og enhetskoden MÅ være i henhold til kodelisten  -- A unit code attribute MUST have a unit code list identifier attribute “UNECERec20” and the unit code MUST be according to the code list</svrl:text>
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
					<svrl:text>[BII2-T19-R006]- Sluttdatoen for en gyldighetsperiode MÅ være større eller lik startdatoen når den er benyttet -- A validity period end date MUST be later or equal to a validity period start date if both validity period end date and validaty period start date are present</svrl:text>
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

	<axsl:template match="cac:PartyIdentification/cbc:ID//@schemeID" priority="1001" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:PartyIdentification/cbc:ID//@schemeID"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ',concat(' ',normalize-space(.),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ',concat(' ',normalize-space(.),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[PCL-010-008]-Party Identifiers MUST use the PEPPOL PartyID list</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cbc:Quantity" priority="1012" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:Quantity"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(number(.) &gt;= 0) or ((./@unitCode) and (./@unitCodeListID ='UNECERec20'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(number(.) &gt;= 0) or ((./@unitCode) and (./@unitCodeListID ='UNECERec20'))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T19-R048 OP-T19-002]-Et enhetskode attributt (unitCode) MÅ ha et tilhørende unitCodeListID med verdi “UNECERec20” og enhetskoden MÅ være i henhold til kodelisten  -- A unit code attribute MUST have a unit code list identifier attribute “UNECERec20” and the unit code MUST be according to the code list</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="cac:CatalogueLine//cbc:ActionCode" priority="1012" mode="M7">
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
					<svrl:text>[CL-019-001]- Aksjonskode på linjenivå må være Add, Delete eller Update hvis den er tilstede -- The line action code for a catalogue line MUST be Add, Update or Delete if present</svrl:text>
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