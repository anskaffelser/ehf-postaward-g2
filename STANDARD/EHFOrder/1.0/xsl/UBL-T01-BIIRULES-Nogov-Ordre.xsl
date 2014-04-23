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
		<svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="BIIRULES  T01 bound to UBL" schemaVersion="">
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
				<axsl:attribute name="id">UBL-T01</axsl:attribute>
				<axsl:attribute name="name">UBL-T01</axsl:attribute>
				<axsl:apply-templates/>
			</svrl:active-pattern>
			<axsl:apply-templates select="/" mode="M6"/>
			<svrl:active-pattern>
				<axsl:attribute name="id">CodesT01</axsl:attribute>
				<axsl:attribute name="name">CodesT01</axsl:attribute>
				<axsl:apply-templates/>
			</svrl:active-pattern>
			<axsl:apply-templates select="/" mode="M7"/>
		</svrl:schematron-output>
	</axsl:template>

	<!--SCHEMATRON PATTERNS-->

	<svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">BIIRULES  T01 bound to UBL</svrl:text>

	<!--PATTERN UBL-T01-->


	<!--RULE -->

	<axsl:template match="//cac:AllowanceCharge" priority="1008" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AllowanceCharge"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:AllowanceChargeReason) &gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:AllowanceChargeReason) &gt; 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R007]-Rabatter eller gebyrer/tillegg MÅ ha en årsak -- Allowances and charges MUST have a reason</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:BuyerCustomerParty" priority="1007" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:BuyerCustomerParty"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cac:Party/cac:PartyName/cbc:Name) &gt;0 or string-length(cac:Party/cac:PartyIdentification/cbc:ID) &gt;0 "/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cac:Party/cac:PartyName/cbc:Name) &gt;0 or string-length(cac:Party/cac:PartyIdentification/cbc:ID) &gt;0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R021]-En ordre må ha en "buyer party name" eller "buyer party" idenitifikator -- An order MUST have the buyer party name or a buyer party identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

	
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="string-length(cac:Party/cac:Contact/cbc:ID) &gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cac:Party/cac:Contact/cbc:ID) &gt;0">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T01-R001]-Kundens referanse BØR fylles ut i henhold til norske krav -- Customer reference SHOULD have a value</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		<!--ASSERT -->
		
				<axsl:choose>
			<axsl:when test="not(cbc:EndpointID) or contains(' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ', concat(',',cbc:EndpointID/@schemeID,','))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="not cbc:EndpointID or contains(' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ', concat(',',cbc:EndpointID/@schemeID,','))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T01-R011]-Endepunkt ID må inneholde attributt schemeID med gyldig verdi -- An endpoint identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cac:PartyIdentification/cbc:ID) or (not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) "/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T01-R012]-Aktør ID må inneholde attributt schemeID med gyldig verdi -- A party identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

						<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or (normalize-space(cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/@listID)='ISO3166-1:Alpha2') and  (contains(',AF,AD,AE,AG,AI,AL,AM,AN,AO,AQ,AR,AS,AT,AU,AW,AX,AZ,BA,BB,BD,BE,BF,BG,BH,BI,BJ,BL,BM,BN,BO,BR,BS,BT,BV,BW,BY,BZ,CA,CC,CD,CF,CG,CH,CI,CK,CL,CM,CN,CO,CR,CU,CV,CX,CY,CZ,DE,DJ,DK,DM,DO,DZ,EC,EE,EG,EH,ER,ES,ET,FI,FJ,FK,FM,FO,FR,GA,GB,GD,GE,GF,GG,GH,GI,GL,GM,GN,GP,GQ,GR,GS,GT,GU,GW,GY,HK,HM,HN,HR,HT,HU,ID,IE,IL,IM,IN,IO,IQ,IR,IS,IT,JE,JM,JO,JP,KE,KG,KH,KI,KM,KN,KP,KR,KW,KY,KZ,LA,LB,LC,LI,LK,LR,LS,LT,LU,LV,LY,MA,MC,MD,ME,MF,MG,MH,MK,ML,MM,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,MZ,NA,NC,NE,NF,NG,NI,NL,NO,NP,NR,NU,NZ,OM,PA,PE,PF,PG,PH,PK,PL,PM,PN,PR,PS,PT,PW,PY,QA,RE,RO,RS,RU,RW,SA,SB,SC,SD,SE,SG,SH,SI,SJ,SK,SL,SM,SN,SO,SR,ST,SV,SY,SZ,TC,TD,TF,TG,TH,TJ,TK,TL,TM,TN,TO,TR,TT,TV,TW,TZ,UA,UG,UM,US,UY,UZ,VA,VC,VE,VG,VI,VN,VU,WF,WS,YE,YT,ZA,ZM,ZW,', concat(',',normalize-space(cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode),',')))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/@listID='ISO3166-1:Alpha2') and contains(',AF,AD,AE,AG,AI,AL,AM,AN,AO,AQ,AR,AS,AT,AU,AW,AX,AZ,BA,BB,BD,BE,BF,BG,BH,BI,BJ,BL,BM,BN,BO,BR,BS,BT,BV,BW,BY,BZ,CA,CC,CD,CF,CG,CH,CI,CK,CL,CM,CN,CO,CR,CU,CV,CX,CY,CZ,DE,DJ,DK,DM,DO,DZ,EC,EE,EG,EH,ER,ES,ET,FI,FJ,FK,FM,FO,FR,GA,GB,GD,GE,GF,GG,GH,GI,GL,GM,GN,GP,GQ,GR,GS,GT,GU,GW,GY,HK,HM,HN,HR,HT,HU,ID,IE,IL,IM,IN,IO,IQ,IR,IS,IT,JE,JM,JO,JP,KE,KG,KH,KI,KM,KN,KP,KR,KW,KY,KZ,LA,LB,LC,LI,LK,LR,LS,LT,LU,LV,LY,MA,MC,MD,ME,MF,MG,MH,MK,ML,MM,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,MZ,NA,NC,NE,NF,NG,NI,NL,NO,NP,NR,NU,NZ,OM,PA,PE,PF,PG,PH,PK,PL,PM,PN,PR,PS,PT,PW,PY,QA,RE,RO,RS,RU,RW,SA,SB,SC,SD,SE,SG,SH,SI,SJ,SK,SL,SM,SN,SO,SR,ST,SV,SY,SZ,TC,TD,TF,TG,TH,TJ,TK,TL,TM,TN,TO,TR,TT,TV,TW,TZ,UA,UG,UM,US,UY,UZ,VA,VC,VE,VG,VI,VN,VU,WF,WS,YE,YT,ZA,ZM,ZW,' , concat(',',normalize-space(cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode),',')))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T01-R013]-Landkode må ha en listID attributt med verdi "ISO3166-1:Alpha2" -- A country ID code MUST have a lisID attribute "ISO3166-1:Alpha2" and the code ID MUST be according to the codelist</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>



	<!--RULE 
	 1.10 fjernet regel om leveringsadresse. Tidligere endret fra //cac:Delivery til /ubl:Order/cac:Delivery for de den tok med seg delivery på linje-->

	

	<!--RULE -->

	<axsl:template match="//cac:AnticipatedMonetaryTotal" priority="1005" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AnticipatedMonetaryTotal"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="number(cbc:PayableAmount) &gt;= 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:PayableAmount) &gt;= 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R012]-Forventet totalbeløp for betaling, MÅ IKKE være negativt -- Expected total amount for payment MUST NOT be negative, if expected total amount for payment is provided</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="number(cbc:LineExtensionAmount) &gt;= 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:LineExtensionAmount) &gt;= 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R013]-Totalt linjebeløp MÅ IKKE være negativ -- Expected total sum of line amounts MUST NOT be negative, if expected total sum of line amounts is provided</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cbc:AllowanceTotalAmount and format-number(cbc:AllowanceTotalAmount,'##.00') = format-number(sum(../cac:AllowanceCharge[string(cbc:ChargeIndicator)='false']/cbc:Amount),'##.00')) or not(cbc:AllowanceTotalAmount)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="(cbc:AllowanceTotalAmount and format-number(cbc:AllowanceTotalAmount,'##.00') = format-number(sum(../cac:AllowanceCharge[string(cbc:ChargeIndicator)='false']/cbc:Amount),'##.00')) or not(cbc:AllowanceTotalAmount)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
							<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<axsl:value-of select =  "sum(/ubl:Order/cac:AllowanceCharge[cbc:ChargeIndicator=false]/cbc:Amount)"/>
					<svrl:text>[BII2-T01-R015]-Totalsum av rabatter/fratrekk  på linjenivå MÅ være lik sum av rabatter/fratrekk på hodenivå hvis dette er benyttet --  Expected total sum of allowance at line level MUST be equal to the sum of allowance amounts at document level, if expected total sum of allowance at document level is provided</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cbc:ChargeTotalAmount and format-number(cbc:ChargeTotalAmount,'##.00') = format-number(sum(../cac:AllowanceCharge[string(cbc:ChargeIndicator)='true']/cbc:Amount),'##.00')) or not(cbc:ChargeTotalAmount)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="(cbc:ChargeTotalAmount and format-number(cbc:ChargeTotalAmount,'##.00') = format-number(sum(../cac:AllowanceCharge[string(cbc:ChargeIndicator)='true']/cbc:Amount),'##.00')) or not(cbc:ChargeTotalAmount)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R016]- Forventet totalsum av tillegg på hodenivå MÅ være lik sum av enkelt-tillegg på hodenivå -- Expected total sum of charges at document level MUST be equal to the sum of charges at document level, if expected total sum of charges at document level is provided</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT 
		 Her var ikke Taxamount med-->

		<axsl:choose>
			<axsl:when test="(/ubl:Order/cac:TaxTotal/cbc:TaxAmount) and ((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and ( format-number(cbc:PayableAmount,'##.00') =format-number(number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount) + number(/ubl:Order/cac:TaxTotal/cbc:TaxAmount),'##.00')))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount)  - number(cbc:AllowanceTotalAmount) + number(/ubl:Order/cac:TaxTotal/cbc:TaxAmount),'##.00'))) or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount) + number(/ubl:Order/cac:TaxTotal/cbc:TaxAmount)  - number(cbc:AllowanceTotalAmount),'##.00'))) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount) + number(/ubl:Order/cac:TaxTotal/cbc:TaxAmount)  + number(cbc:ChargeTotalAmount),'##.00'))) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount) + number(/ubl:Order/cac:TaxTotal/cbc:TaxAmount),'##.00'))) or not(/ubl:Order/cac:TaxTotal/cbc:TaxAmount) and ((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and  (format-number(cbc:PayableAmount,'##.00') = (format-number(number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount),'##.00')))) or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount)  - number(cbc:AllowanceTotalAmount),'##.00'))) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount)  + number(cbc:ChargeTotalAmount),'##.00'))) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(cbc:LineExtensionAmount,'##.00')))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                   test="(/ubl:Order/cac:TaxTotal/cbc:TaxAmount) and ((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and ( format-number(cbc:PayableAmount,'##.00') =format-number(number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount) + number(/ubl:Order/cac:TaxTotal/cbc:TaxAmount),'##.00')))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount)  - number(cbc:AllowanceTotalAmount) + number(/ubl:Order/cac:TaxTotal/cbc:TaxAmount),'##.00'))) or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount) + number(/ubl:Order/cac:TaxTotal/cbc:TaxAmount)  - number(cbc:AllowanceTotalAmount),'##.00'))) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount) + number(/ubl:Order/cac:TaxTotal/cbc:TaxAmount)  + number(cbc:ChargeTotalAmount),'##.00'))) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount) + number(/ubl:Order/cac:TaxTotal/cbc:TaxAmount),'##.00'))) or not(/ubl:Order/cac:TaxTotal/cbc:TaxAmount) and ((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and  (format-number(cbc:PayableAmount,'##.00') = (format-number(number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount),'##.00')))) or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount)  - number(cbc:AllowanceTotalAmount),'##.00'))) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(number(cbc:LineExtensionAmount)  + number(cbc:ChargeTotalAmount),'##.00'))) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (format-number(cbc:PayableAmount,'##.00') = format-number(cbc:LineExtensionAmount,'##.00')))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R017]-Dersom ordretotal er angitt MÅ denne være lik sum linjebeløp minus sum rabatter/fratrekk pluss sum gebyrer/tillegg og sum MVA-beløp -- Expected total amount for payment MUST be equal to the sum of line amounts minus sum of allowances at document level plus sum of charges at document level  and VAT total amount, if expected total amount for payment is provided</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:Item/cac:AdditionalItemProperty" priority="1004" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Item"/>


		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:Name) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:Name)) &gt; 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R019]- Dersom tilleggsegenskaper er angitt MÅ hver av disse identifiseres med et navn -- Each item property MUST have a data name, if item property is provided</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:Value) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(string-length(bc:Value) &gt; 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R020]-En tilleggsegenskap MÅ ha en verdi, hvis tilleggsegenskap er benyttet -- Each item property MUST have a data value, if item property is provided</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="/ubl:Order" priority="1002" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Order"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:CustomizationID) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:CustomizationID) &gt; 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R001]- Ordren MÅ inneholde en tilpasningsidentifikator (customization identifier) -- An order MUST have a customization identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:ProfileID) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:ProfileID) &gt; 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R002]- Ordren MÅ inneholde en profilidentifikator -- An order MUST have a profile identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(string(cbc:IssueDate)) &gt; 5"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:IssueDate)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R004]- Ordren MÅ inneholde en ordredato -- An order MUST have a document issue date</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(string(cac:ValidityPeriod/cbc:EndDate)) &gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:ValidityPeriod/cbc:EndDate)">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R005]- Ordrens gyldighets sluttdato BØR oppgis -- An order SHOULD provide information about its validity end date</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:ID) &gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R006]- Orden MÅ ha en dokumentID -- An order MUST have a document identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cbc:DocumentCurrencyCode) &gt;0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cbc:DocumentCurrencyCode) &gt;0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R009]-Ordren MÅ ha en valutakode -- An order MUST be stated in a single currency</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
				<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="not(string-length(cbc:DocumentCurrencyCode) &gt;0) or contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ', concat(' ',normalize-space(cbc:DocumentCurrencyCode),' '))"/>
<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(string-length(cbc:DocumentCurrencyCode) &gt;0) or contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ', concat(' ',normalize-space(cbc:DocumentCurrencyCode),' '))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[OP-T76-003]-Valuttakoden MÅ være i henhold til ISO 4217 -- DocumentCurrencyCode MUST be coded according to ISO code list 4217</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->
		<!--her var det feil ref: cbc:LineExtensionAmount -->
		<axsl:choose>
			<axsl:when test="round(number(cac:AnticipatedMonetaryTotal/cbc:LineExtensionAmount)) = round(number(sum(/ubl:Order/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount) * 10 * 10) div 100)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:LineExtensionAmount) = number(round(sum(/ubl:Order/cac:OrderLine/cac:LineItem/cbc:LineExtensionAmount) * 10 * 10) div 100)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R014]-Hvis totalsum på linjenivå er benyttet, så MÅ totalsummen av linjebeløpene være lik summen av alle ordrelinje beløpene -- Expected total sum of line amounts MUST equal the sum of the order line amounts at order line level, if expected total sum of line amounts is provided</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:TaxTotal and cac:TaxTotal/cbc:TaxAmount = (round(sum(/ubl:Order/cac:OrderLine/cac:LineItem/cbc:TotalTaxAmount) * 10 * 10) div 100)) or not(cac:TaxTotal)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:TaxTotal and cac:TaxTotal/cbc:TaxAmount = (round(sum(/ubl:Order/cac:OrderLine/cac:LineItem/cbc:TotalTaxAmount) * 10 * 10) div 100)) or not(cac:TaxTotal)">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R018]- MVA totalbeløp BØR være summen av alle MVA beløpene på linjenivå -- VAT total amount SHOULD be the sum of order line tax amounts, if order line tax amounts are provided</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
			<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not (cbc:OrderTypeCode) or (cbc:OrderTypeCode/@listID)  = 'UNCL1001'"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not (cbc:OrderTypeCode) or (cbc:OrderTypeCode/@listID)  = 'UNCL1001">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R004]- Ordren MÅ inneholde en ordredato -- An order MUST have a document issue date</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
	<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:OrderLine" priority="1001" mode="M6">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:OrderLine"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="string-length(cac:LineItem/cbc:ID) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(cac:LineItem/cbc:ID) &gt; 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R003]-Hver ordrelinje MÅ inneholde en identifikator som er unik innen ordren -- Each order line MUST have a document line identifier that is unique within the order</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="number(cac:LineItem/cbc:Quantity) &gt;= 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cac:LineItem/cbc:Quantity) &gt;= 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R010]-Antall bestilte enheter på linjenivå MÅ ikke være negative -- Each order line ordered quantity MUST not be negative</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

			<axsl:choose>
			<axsl:when test="not(number(cac:LineItem/cbc:Quantity) &gt;= 0) or ((cac:LineItem/cbc:Quantity/@unitCode) and (cac:LineItem/cbc:Quantity/@unitCodeListID ='UNECERec20'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(number(cac:LineItem/cbc:Quantity) &gt;= 0) or ((cac:LineItem/cbc:Quantity/@unitCode) and (cac:LineItem/cbc:Quantity/@unitCodeListID ='UNECERec20'))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T01-R016 OP-T01-009]-Et enhetskode attributt MÅ ha et tilhørende unitCodeListID med verdi “UNECERec20” og enhetskoden MÅ være i henhold til kodelisten  -- A unit code attribute MUST have a unit code list identifier attribute “UNECERec20” and the unit code MUST be according to the code list</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

			<axsl:choose>
			<axsl:when test="not(number(cac:LineItem/cac:Price/cbc:BaseQuantity) &gt;= 0) or ((cac:LineItem/cac:Price/cbc:BaseQuantity/@unitCode) and (cac:LineItem/cac:Price/cbc:BaseQuantity/@unitCodeListID ='UNECERec20'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(number(cac:LineItem/cbc:Quantity) &gt;= 0) or ((cac:LineItem/cbc:Quantity/@unitCode) and (cac:LineItem/cbc:Quantity/@unitCodeListID ='UNECERec20'))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T01-R016 OP-T01-009]-Et enhetskode attributt MÅ ha et tilhørende unitCodeListID med verdi “UNECERec20” og enhetskoden MÅ være i henhold til kodelisten  -- A unit code attribute MUST have a unit code list identifier attribute “UNECERec20” and the unit code MUST be according to the code list</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>




		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="number(cac:LineItem/cac:Price/cbc:PriceAmount) &gt;= 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cac:LineItem/cac:Price/cbc:PriceAmount) &gt;= 0">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R011]- En ordrelinje nettopris MÅ IKKE være negativ --* MÅ Each order line item net price MUST not be negative</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="number(cac:LineItem/cbc:Quantity) &gt; 0"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cac:LineItem/cbc:Quantity) &gt; 0">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R029]-Hver ordrelinje BØR ha et ordrekvantum -- Each order line SHOULD have an ordered quantity</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:LineItem/cbc:Quantity/@unitCode)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:LineItem/cbc:Quantity/@unitCode)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R030]-En ordrelinjes ordevolum MÅ ha være tilordnet en UOM- kode -- Each order line ordered quantity  MUST have an associated unit of measure</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="(cac:LineItem/cac:Item/cbc:Name) or (cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID) or (cac:LineItem/cac:Item/cac:SellersItemIdentification/cbc:ID)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:LineItem/cac:Item/cbc:Name) or (cac:LineItem/cac:Item/cac:StandardItemIdentification/cbc:ID) or (cac:LineItem/cac:Item/cac:SellersItemIdentification/cbc:ID)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[BII2-T01-R031]-Hver ordrelinje MÅ ha en artikkel identifikator og/eller eller et artikkelnavn -- Each order line MUST have an item identifier and/or an item name</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--RULE -->

	<axsl:template match="//cac:SellerSupplierParty" priority="1000" mode="M6">
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
					<svrl:text>[BII2-T01-R022]-Ordren MÅ inneholde selgers partner identifikator --* An order MUST have the seller party name or a seller party identifier</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
				<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or (normalize-space(cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/@listID)='ISO3166-1:Alpha2') and  (contains(',AF,AD,AE,AG,AI,AL,AM,AN,AO,AQ,AR,AS,AT,AU,AW,AX,AZ,BA,BB,BD,BE,BF,BG,BH,BI,BJ,BL,BM,BN,BO,BR,BS,BT,BV,BW,BY,BZ,CA,CC,CD,CF,CG,CH,CI,CK,CL,CM,CN,CO,CR,CU,CV,CX,CY,CZ,DE,DJ,DK,DM,DO,DZ,EC,EE,EG,EH,ER,ES,ET,FI,FJ,FK,FM,FO,FR,GA,GB,GD,GE,GF,GG,GH,GI,GL,GM,GN,GP,GQ,GR,GS,GT,GU,GW,GY,HK,HM,HN,HR,HT,HU,ID,IE,IL,IM,IN,IO,IQ,IR,IS,IT,JE,JM,JO,JP,KE,KG,KH,KI,KM,KN,KP,KR,KW,KY,KZ,LA,LB,LC,LI,LK,LR,LS,LT,LU,LV,LY,MA,MC,MD,ME,MF,MG,MH,MK,ML,MM,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,MZ,NA,NC,NE,NF,NG,NI,NL,NO,NP,NR,NU,NZ,OM,PA,PE,PF,PG,PH,PK,PL,PM,PN,PR,PS,PT,PW,PY,QA,RE,RO,RS,RU,RW,SA,SB,SC,SD,SE,SG,SH,SI,SJ,SK,SL,SM,SN,SO,SR,ST,SV,SY,SZ,TC,TD,TF,TG,TH,TJ,TK,TL,TM,TN,TO,TR,TT,TV,TW,TZ,UA,UG,UM,US,UY,UZ,VA,VC,VE,VG,VI,VN,VU,WF,WS,YE,YT,ZA,ZM,ZW,', concat(',',normalize-space(cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode),',')))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode/@listID='ISO3166-1:Alpha2') and contains(',AF,AD,AE,AG,AI,AL,AM,AN,AO,AQ,AR,AS,AT,AU,AW,AX,AZ,BA,BB,BD,BE,BF,BG,BH,BI,BJ,BL,BM,BN,BO,BR,BS,BT,BV,BW,BY,BZ,CA,CC,CD,CF,CG,CH,CI,CK,CL,CM,CN,CO,CR,CU,CV,CX,CY,CZ,DE,DJ,DK,DM,DO,DZ,EC,EE,EG,EH,ER,ES,ET,FI,FJ,FK,FM,FO,FR,GA,GB,GD,GE,GF,GG,GH,GI,GL,GM,GN,GP,GQ,GR,GS,GT,GU,GW,GY,HK,HM,HN,HR,HT,HU,ID,IE,IL,IM,IN,IO,IQ,IR,IS,IT,JE,JM,JO,JP,KE,KG,KH,KI,KM,KN,KP,KR,KW,KY,KZ,LA,LB,LC,LI,LK,LR,LS,LT,LU,LV,LY,MA,MC,MD,ME,MF,MG,MH,MK,ML,MM,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,MZ,NA,NC,NE,NF,NG,NI,NL,NO,NP,NR,NU,NZ,OM,PA,PE,PF,PG,PH,PK,PL,PM,PN,PR,PS,PT,PW,PY,QA,RE,RO,RS,RU,RW,SA,SB,SC,SD,SE,SG,SH,SI,SJ,SK,SL,SM,SN,SO,SR,ST,SV,SY,SZ,TC,TD,TF,TG,TH,TJ,TK,TL,TM,TN,TO,TR,TT,TV,TW,TZ,UA,UG,UM,US,UY,UZ,VA,VC,VE,VG,VI,VN,VU,WF,WS,YE,YT,ZA,ZM,ZW,' , concat(',',normalize-space(cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode),',')))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T01-R013]-Landkode må ha en listID attributt med verdi "ISO3166-1:Alpha2" -- A country ID code MUST have a lisID attribute "ISO3166-1:Alpha2" and the code ID MUST be according to the codelist</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
		
			<!--ASSERT -->
			
				<axsl:choose>
			<axsl:when test="not(cbc:EndpointID) or contains(' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ', concat(',',cbc:EndpointID/@schemeID,','))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="not cbc:EndpointID or contains(' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ', concat(',',cbc:EndpointID/@schemeID,','))">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T76-R001]-Endepunkt ID må inneholde attributt schemeID -- An endpoint identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="not(cac:PartyIdentification/cbc:ID) or (not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) "/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
				                    test="not(cac:PartyIdentification/cbc:ID) or ( ( not(contains(normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ZZZ ',concat(' ',normalize-space(cac:PartyIdentification/cbc:ID//@schemeID),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EUGEN-T76-R002]-Aktør ID må inneholde attributt schemeID -- A party identifier MUST have a scheme identifier attribute</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>

		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>
	<axsl:template match="text()" priority="-1" mode="M6"/>
	<axsl:template match="@*|node()" priority="-2" mode="M6">
		<axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
	</axsl:template>

	<!--PATTERN CodesT01-->


	<!--RULE -->

	<axsl:template match="cac:TaxCategory/cbc:ID" priority="1000" mode="M7">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory/cbc:ID"/>

		<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE E S Z ',concat(' ',normalize-space(.),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AE E S Z ',concat(' ',normalize-space(.),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[OP-T0-008]- Avgiftskategorier MÅ kodes i henhold til "'UNCL305" kodeliste -- Tax categories MUST be coded using "'UNCL305" code list</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		
				<!--ASSERT -->

		<axsl:choose>
			<axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( 'UNCL305',concat(' ',normalize-space(./@listID),' ') ) ) )"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( 'UNCL305',concat(' ',normalize-space(./@listID),' ') ) ) )">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[OP-T0-008]- Avgiftskategorier MÅ kodes i henhold til "'UNCL305" kodeliste -- Tax categories MUST be coded using "'UNCL305" code list</svrl:text>
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