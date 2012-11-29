<?xml version="1.0" encoding="UTF-16" standalone="yes"?>
<xsl:stylesheet doc:dummy-for-xmlns="" cac:dummy-for-xmlns="" cbc:dummy-for-xmlns="" ccts:dummy-for-xmlns="" sdt:dummy-for-xmlns="" udt:dummy-for-xmlns="" ext:dummy-for-xmlns="" xs:dummy-for-xmlns="" version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:doc="urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:ccts="urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2" xmlns:sdt="urn:oasis:names:specification:ubl:schema:xsd:SpecializedDatatypes-2" xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:xs="http://www.w3.org/2001/XMLSchema">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->


<!--PHASES-->


<!--PROLOG-->
<xsl:output method="html" encoding="UTF-8"/>

<!--KEYS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-FULL-PATH-->

<xsl:template match="*" mode="schematron-get-full-path">
<xsl:apply-templates select="parent::*" mode="schematron-get-full-path" />
<xsl:text>/</xsl:text>
<xsl:choose>
<xsl:when test="namespace-uri()=''"><xsl:value-of select="name()" /></xsl:when>
<xsl:otherwise>
<xsl:text>*:</xsl:text>
<xsl:value-of select="local-name()" />
<xsl:text>[namespace-uri()='</xsl:text>
<xsl:value-of select="namespace-uri()" />
<xsl:text>']</xsl:text>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())&#xA;	  		                             and namespace-uri() = namespace-uri(current())])" />
<xsl:text>[</xsl:text>
<xsl:value-of select="1+ $preceding" />
<xsl:text>]</xsl:text>
</xsl:template>
<xsl:template match="@*" mode="schematron-get-full-path">
<xsl:apply-templates select="parent::*" mode="schematron-get-full-path" />
<xsl:text>/</xsl:text>
<xsl:choose>
<xsl:when test="namespace-uri()=''">@sch:schema</xsl:when>
<xsl:otherwise>
<xsl:text>@*[local-name()='</xsl:text>
<xsl:value-of select="local-name()" />
<xsl:text>' and namespace-uri()='</xsl:text>
<xsl:value-of select="namespace-uri()" />
<xsl:text>']</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
<xsl:for-each select="ancestor-or-self::*">
<xsl:text>/</xsl:text>
<xsl:value-of select="name(.)" />
<xsl:if test="preceding-sibling::*[name(.)=name(current())]">
<xsl:text>[</xsl:text>
<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
<xsl:text>]</xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:if test="not(self::*)">
<xsl:text />/@<xsl:value-of select="name(.)" />
</xsl:if>
</xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path" />
<xsl:template match="text()" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path" />
<xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
</xsl:template>
<xsl:template match="comment()" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path" />
<xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
</xsl:template>
<xsl:template match="processing-instruction()" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path" />
<xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
</xsl:template>
<xsl:template match="@*" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path" />
<xsl:value-of select="concat('.@', name())" />
</xsl:template>
<xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path" />
<xsl:text>.</xsl:text>
<xsl:choose>
<xsl:when test="count(. | ../namespace::*) = count(../namespace::*)">
<xsl:value-of select="concat('.namespace::-',1+count(namespace::*),'-')" />
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
<xsl:template match="*" mode="generate-id-2" priority="2">
<xsl:text>U</xsl:text>
<xsl:number level="multiple" count="*" />
</xsl:template>
<xsl:template match="node()" mode="generate-id-2">
<xsl:text>U.</xsl:text>
<xsl:number level="multiple" count="*" />
<xsl:text>n</xsl:text>
<xsl:number count="node()" />
</xsl:template>
<xsl:template match="@*" mode="generate-id-2">
<xsl:text>U.</xsl:text>
<xsl:number level="multiple" count="*" />
<xsl:text>_</xsl:text>
<xsl:value-of select="string-length(local-name(.))" />
<xsl:text>_</xsl:text>
<xsl:value-of select="translate(name(),':','.')" />
</xsl:template>
<!--Strip characters-->
<xsl:template match="text()" priority="-1" />

<!--SCHEMA METADATA-->
<xsl:template match="/">
<Schematron>
<Information><p>** Validation of EHF Catalogue, Version 1.0 ** Validerer EHF katalog, version 1.0 **</p> </Information>
<xsl:apply-templates select="/" mode="M10" /><xsl:apply-templates select="/" mode="M12" /><xsl:apply-templates select="/" mode="M13" /><xsl:apply-templates select="/" mode="M14" /><xsl:apply-templates select="/" mode="M15" /><xsl:apply-templates select="/" mode="M16" /><xsl:apply-templates select="/" mode="M17" /><xsl:apply-templates select="/" mode="M18" /><xsl:apply-templates select="/" mode="M19" /><xsl:apply-templates select="/" mode="M20" /><xsl:apply-templates select="/" mode="M21" /><xsl:apply-templates select="/" mode="M22" /><xsl:apply-templates select="/" mode="M23" /><xsl:apply-templates select="/" mode="M24" />
</Schematron>
</xsl:template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN abstracts2-->
<xsl:variable name="AccountType" select="',1,2,3,'" />
<xsl:variable name="AccountType_listID" select="'urn:ubl:codelist:accounttypecode-1.1'" />
<xsl:variable name="AccountType_agencyID" select="'320'" />
<xsl:variable name="UN_AddressFormat" select="',1,2,3,4,5,6,7,8,9,'" />
<xsl:variable name="UN_AddressFormat_listID" select="'UN/ECE 3477'" />
<xsl:variable name="UN_AddressFormat_agencyID" select="'6'" />
<xsl:variable name="AddressFormat" select="',StructuredNO,StructuredID,StructuredLax,StructuredRegion,Unstructured,'" />
<xsl:variable name="AddressFormat_listID" select="'urn:ubl:codelist:addressformatcode-1.1'" />
<xsl:variable name="AddressFormat_agencyID" select="'320'" />
<xsl:variable name="AddressType" select="',Home,Business,'" />
<xsl:variable name="AddressType_listID" select="'urn:ubl:codelist:addresstypecode-1.1'" />
<xsl:variable name="AddressType_agencyID" select="'320'" />
<xsl:variable name="Allowance" select="',1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,ZZZ,'" />
<xsl:variable name="Allowance_listID" select="'UN/ECE 4465'" />
<xsl:variable name="Allowance_agencyID" select="'6'" />
<xsl:variable name="CatDocType" select="',Brochure,Drawing,Picture,ProductSheet,'" />
<xsl:variable name="CatDocType_listID" select="'urn:ubl:codelist:cataloguedocumenttypecode-1.1'" />
<xsl:variable name="CatDocType_agencyID" select="'320'" />
<xsl:variable name="CatAction" select="',Update,Delete,Add,'" />
<xsl:variable name="CatAction_listID" select="'urn:ubl:codelist:catalogueactioncode-1.1'" />
<xsl:variable name="CatAction_agencyID" select="'320'" />
<xsl:variable name="CountryCode" select="',AF,AD,AE,AG,AI,AL,AM,AN,AO,AQ,AR,AS,AT,AU,AW,AX,AZ,BA,BB,BD,BE,BF,BG,BH,BI,BJ,BL,BM,BN,BO,BR,BS,BT,BV,BW,BY,BZ,CA,CC,CD,CF,CG,CH,CI,CK,CL,CM,CN,CO,CR,CU,CV,CX,CY,CZ,DE,DJ,DK,DM,DO,DZ,EC,EE,EG,EH,ER,ES,ET,FI,FJ,FK,FM,FO,FR,GA,GB,GD,GE,GF,GG,GH,GI,GL,GM,GN,GP,GQ,GR,GS,GT,GU,GW,GY,HK,HM,HN,HR,HT,HU,ID,IE,IL,IM,IN,IO,IQ,IR,IS,IT,JE,JM,JO,JP,KE,KG,KH,KI,KM,KN,KP,KR,KW,KY,KZ,LA,LB,LC,LI,LK,LR,LS,LT,LU,LV,LY,MA,MC,MD,ME,MF,MG,MH,MK,ML,MM,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,MZ,NA,NC,NE,NF,NG,NI,NL,NO,NP,NR,NU,NZ,OM,PA,PE,PF,PG,PH,PK,PL,PM,PN,PR,PS,PT,PW,PY,QA,RE,RO,RS,RU,RW,SA,SB,SC,SD,SE,SG,SH,SI,SJ,SK,SL,SM,SN,SO,SR,ST,SV,SY,SZ,TC,TD,TF,TG,TH,TJ,TK,TL,TM,TN,TO,TR,TT,TV,TW,TZ,UA,UG,UM,US,UY,UZ,VA,VC,VE,VG,VI,VN,VU,WF,WS,YE,YT,ZA,ZM,ZW,'" />
<xsl:variable name="CountryCode_listID" select="'ISO3166-1'" />
<xsl:variable name="CountryCode_agencyID" select="'6'" />
<xsl:variable name="CountrySub" select="',DK-81,'" />
<xsl:variable name="CountrySub_listID" select="'ISO 3166-2'" />
<xsl:variable name="CountrySub_agencyID" select="'6'" />
<xsl:variable name="CurrencyCode" select="',EUR,AFA,DZD,ADP,ARS,AMD,AWG,AUD,AZM,BSD,BHD,THB,PAB,BBD,BYB,BYR,BEF,BZD,BMD,VEB,BOB,BRL,BND,BGN,BIF,CAD,CVE,KYD,GHC,XOF,XAF,XPF,CLP,COP,KMF,BAM,NIO,CRC,HRK,CUP,CYP,CZK,GMD,DKK,MKD,DEM,DJF,STD,DOP,VND,GRD,XCD,EGP,SVC,ETB,FKP,FJD,HUF,CDF,FRF,GIP,HTG,PYG,GNF,GWP,GYD,HKD,UAH,ISK,INR,IRR,IQD,IEP,ITL,JMD,JOD,KES,PGK,LAK,EEK,KWD,MWK,ZMK,AOA,MMK,GEL,LVL,LBP,ALL,HNL,SLL,ROL,BGL,LRD,LYD,SZL,LTL,LSL,LUF,MGF,MYR,MTL,TMM,FIM,MUR,MZM,MXN,MXV,MDL,MAD,BOV,NGN,ERN,NAD,NPR,ANG,NLG,ILS,TWD,NZD,BTN,KPW,NOK,PEN,MRO,TOP,PKR,MOP,UYU,PHP,PTE,GBP,BWP,QAR,GTQ,ZAR,OMR,KHR,MVR,IDR,RUB,RUR,RWF,SHP,SAR,ATS,XDR,SCR,SGD,SKK,SBD,KGS,SOS,ESP,LKR,SDD,SRG,SEK,CHF,SYP,TJR,BDT,WST,TZS,KZT,TPE,SIT,TTD,MNT,TND,TRL,AED,UGX,CLF,USD,UZS,VUV,KRW,YER,JPY,CNY,YUM,ZWD,PLN,AFA,DZD,ADP,ARS,AMD,AWG,AUD,AZM,BSD,BHD,THB,PAB,BBD,BYB,BYR,BEF,BZD,BMD,VEB,BOB,BRL,BND,BGN,'" />
<xsl:variable name="CurrencyCode_listID" select="'ISO 4217 Alpha'" />
<xsl:variable name="CurrencyCode_agencyID" select="'6'" />
<xsl:variable name="Discrepancy" select="',Billing1,Billing2,Billing3,Condition1,Condition2,Condition3,Condition4,Condition5,Condition6,Delivery1,Delivery2,Delivery3,Quality1,Quality2,ZZZ,'" />
<xsl:variable name="Discrepancy_listID" select="'urn:ubl:codelist:discrepancyresponsecode-1.1'" />
<xsl:variable name="Discrepancy_agencyID" select="'320'" />
<xsl:variable name="DocTypeCode" select="'rule'" />
<xsl:variable name="DocTypeCode_listID" select="'UN/ECE 1001'" />
<xsl:variable name="DocTypeCode_agencyID" select="'6'" />
<xsl:variable name="InvTypeCode" select="',325,380,393,'" />
<xsl:variable name="InvTypeCode_listID" select="'urn:ubl:codelist:invoicetypecode-1.1'" />
<xsl:variable name="InvTypeCode_agencyID" select="'320'" />
<xsl:variable name="UNSPSC" select="'rule'" />
<xsl:variable name="UNSPSC_listID" select="'UNSPSC'" />
<xsl:variable name="UNSPSC_agencyID" select="'113'" />
<xsl:variable name="LifeCycle" select="',Available,DeletedAnnouncement,ItemDeleted,NewAnnouncement,NewAvailable,ItemTemporarilyUnavailable,'" />
<xsl:variable name="LifeCycle_listID" select="'urn:ubl:codelist:lifecyclestatuscode-1.1'" />
<xsl:variable name="LifeCycle_agencyID" select="'320'" />
<xsl:variable name="LineResponse" select="',BusinessAccept,BusinessReject,'" />
<xsl:variable name="LineResponse_listID" select="'urn:ubl:codelist:lineresponsecode-1.1'" />
<xsl:variable name="LineResponse_agencyID" select="'320'" />
<xsl:variable name="LineStatus" select="',Added,Cancelled,Disputed,NoStatus,Revised,'" />
<xsl:variable name="LineStatus_listID" select="'urn:ubl:codelist:linestatuscode-1.1'" />
<xsl:variable name="LineStatus_agencyID" select="'320'" />
<xsl:variable name="LossRisk" select="',FOB,'" />
<xsl:variable name="LossRisk_listID" select="'urn:ubl:codelist:lossriskresponsibilitycode-1.1'" />
<xsl:variable name="LossRisk_agencyID" select="'320'" />
<xsl:variable name="PaymentChannel" select="',BBAN,DK:BANK,DK:FIK,DK:GIRO,DK:NEMKONTO,FI:BANK,FI:GIRO,GB:BACS,GB:BANK,GB:GIRO,IBAN,IS:BANK,IS:GIRO,IS:IK66,IS:RB,NO:BANK,SE:BANKGIRO,SE:PLUSGIRO,SWIFTUS,ZZZ,'" />
<xsl:variable name="PaymentChannel_listID" select="'urn:ubl:codelist:paymentchannelcode-1.1'" />
<xsl:variable name="PaymentChannel_agencyID" select="'320'" />
<xsl:variable name="PriceType" select="',AAA,AAB,AAC,AAD,AAE,AAF,AAG,AAH,AAI,AAJ,AAK,AAL,AAM,AAN,AAO,AAP,AAQ,AAR,AAS,AAT,AAU,AAV,AAW,AAX,AAY,AAZ,ABA,ABB,ABC,ABD,ABE,ABF,ABG,ABH,ABI,ABJ,ABK,ABL,ABM,ABN,ABO,ABP,ABQ,ABR,ABS,ABT,ABU,ABV,AI,ALT,AP,BR,CAT,CDV,CON,CP,CU,CUP,CUS,DAP,DIS,DPR,DR,DSC,EC,ES,EUP,FCR,GRP,INV,LBL,MAX,MIN,MNR,MSR,MXR,NE,NQT,NTP,NW,OCR,OFR,PAQ,PBQ,PPD,PPR,PRO,PRP,PW,QTE,RES,RTP,SHD,SRP,SW,TB,TRF,TU,TW,WH,'" />
<xsl:variable name="PriceType_listID" select="'UN/ECE 5387'" />
<xsl:variable name="PriceType_agencyID" select="'6'" />
<xsl:variable name="PriceListStat" select="',Original,Copy,Revision,Cancellation,'" />
<xsl:variable name="PriceListStat_listID" select="'urn:ubl.codelist:priceliststatuscode-1.1,urn:ubl:codelist:priceliststatuscode-1.1'" />
<xsl:variable name="PriceListStat_agencyID" select="'320'" />
<xsl:variable name="RemType" select="',Reminder,Advis,'" />
<xsl:variable name="RemType_listID" select="',urn:ubl.codelist:remindertypecode-1.1,urn:ubl:codelist:remindertypecode-1.1,'" />
<xsl:variable name="RemType_agencyID" select="'320'" />
<xsl:variable name="RemAlc" select="',PenaltyFee,PenaltyRate,'" />
<xsl:variable name="RemAlc_listID" select="'urn:ubl:codelist:reminderallowancechargereasoncode-1.0'" />
<xsl:variable name="RemAlc_agencyID" select="'320'" />
<xsl:variable name="Response" select="',BusinessAccept,BusinessReject,ProfileAccept,ProfileReject,TechnicalAccept,TechnicalReject,'" />
<xsl:variable name="Response_listID" select="'urn:ubl:codelist:responsecode-1.1'" />
<xsl:variable name="Response_agencyID" select="'320'" />
<xsl:variable name="ResponseDocType" select="',ApplicationResponse,Catalogue,CatalogueDeletion,CatalogueItemSpecificationUpdate,CatalogueItemUpdate,CataloguePricingUpdate,CataloguePriceUpdate,CatalogueRequest,CreditNote,Invoice,Order,OrderCancellation,OrderChange,OrderResponse,OrderResponseSimple,Reminder,Statement,Payment,PersonalSecure,ZZZ,'" />
<xsl:variable name="ResponseDocType_listID" select="'urn:ubl:codelist:responsedocumenttypecode-1.1'" />
<xsl:variable name="ResponseDocType_agencyID" select="'320'" />
<xsl:variable name="ResponseDocType2" select="',ApplicationResponse,Catalogue,CatalogueDeletion,CatalogueItemSpecificationUpdate,CatalogueItemUpdate,CataloguePricingUpdate,CataloguePriceUpdate,CatalogueRequest,CreditNote,Invoice,Order,OrderCancellation,OrderChange,OrderResponse,OrderResponseSimple,Reminder,Statement,Payment,UtilityStatement,PersonalSecure,ZZZ,'" />
<xsl:variable name="ResponseDocType2_listID" select="'urn:ubl:codelist:responsedocumenttypecode-1.2'" />
<xsl:variable name="ResponseDocType2_agencyID" select="'320'" />
<xsl:variable name="SubStatus" select="',DeliveryDateChanged,DeliveryDateNotPossible,DeliveryPartyUnknown,ItemDeleted,ItemNotFound,ItemNotInAssortment,ItemReplaced,ItemTemporarilyUnavailable,NewAnnouncement,OrderedQuantityChanged,OrderLineRejected,Original,SeasonalItemUnavailable,Substitution,'" />
<xsl:variable name="SubStatus_listID" select="'urn:ubl:codelist:substitutionstatuscode-1.1'" />
<xsl:variable name="SubStatus_agencyID" select="'320'" />
<xsl:variable name="TaxExemption" select="',AAA,AAB,AAC,AAE,AAF,AAG,AAH,AAI,AAJ,AAK,AAL,AAM,AAN,AAO,'" />
<xsl:variable name="TaxExemption_listID" select="'CWA 15577'" />
<xsl:variable name="TaxExemption_agencyID" select="'CEN'" />
<xsl:variable name="TaxType" select="',StandardRated,ZeroRated,'" />
<xsl:variable name="TaxType_listID" select="'urn:ubl:codelist:taxtypecode-1.1'" />
<xsl:variable name="TaxType_agencyID" select="'320'" />
<xsl:variable name="UnitMeasure" select="'xsd'" />
<xsl:variable name="UnitMeasure_listID" select="'UN/ECE rec 20'" />
<xsl:variable name="UnitMeasure_agencyID" select="'6'" />
<xsl:variable name="Delivery_1" select="',EXW,FCA,FAS,FOB,CFR,CIF,CPT,CIP,DAF,DES,DEQ,DDU,DDP,'" />
<xsl:variable name="Delivery_1_schemeID" select="'INCOTERMS 2000'" />
<xsl:variable name="Delivery_1_agencyID" select="'NES'" />
<xsl:variable name="Delivery_2" select="',001 EXW,002 FCA,003 FAS,004 FOB,005 FCA,006 CPT,007 CIP,008 CFR,009 CIF,010 CPT,011 CIP,012 CPT,013 CIP,014 CPT,015 CIP,016 DES,017 DRQ,018 DAF,019 DDU,021 DDP,022 DDU,023 DDP,'" />
<xsl:variable name="Delivery_2_schemeID" select="'COMBITERMS 2000'" />
<xsl:variable name="Delivery_2_agencyID" select="'NES'" />
<xsl:variable name="Dimension" select="',A,AAA,AAB,AAC,AAD,AAE,AAF,AAJ,AAK,AAL,AAM,AAN,AAO,AAP,AAQ,AAR,AAS,AAT,AAU,AAV,AAW,AAX,AAY,AAZ,ABA,ABB,ABC,ABD,ABE,ABJ,ABS,ABX,ABY,ABZ,ACA,ACE,ACG,ACN,ACP,ACS,ACV,ACW,ACX,ADR,ADS,ADT,ADU,ADV,ADW,ADX,ADY,ADZ,AEA,AEB,AEC,AED,AEE,AEF,AEG,AEH,AEI,AEJ,AEK,AEM,AEN,AEO,AEP,AEQ,AER,AET,AEU,AEV,AEW,AEX,AEY,AEZ,AF,AFA,AFB,AFC,AFD,AFE,AFF,AFG,AFH,AFI,AFJ,AFK,B,BL,BMY,BMZ,BNA,BNB,BNC,BND,BNE,BNF,BNG,BNH,BNI,BNJ,BNK,BNL,BNM,BNN,BNO,BNP,BNQ,BNR,BNS,BNT,BR,BRA,BRE,BS,BSW,BW,CHN,CM,CT,CV,CZ,D,DI,DL,DN,DP,DR,DS,DW,E,EA,F,FI,FL,FN,FV,G,GG,GW,HF,HM,HT,IB,ID,L,LM,LN,LND,M,MO,MW,N,OD,PRS,PTN,RA,RF,RJ,RMW,RP,RUN,RY,SQ,T,TC,TH,TN,TT,U,VH,VW,WA,WD,WM,WT,WU,XH,XQ,XZ,YS,ZAL,ZAS,ZB,ZBI,ZC,ZCA,ZCB,ZCE,ZCL,ZCO,ZCR,ZCU,ZFE,ZFS,ZGE,ZH,ZK,ZMG,ZMN,ZMO,ZN,ZNA,ZNB,ZNI,ZO,ZP,ZPB,ZS,ZSB,ZSE,ZSI,ZSL,ZSN,ZTA,ZTE,ZTI,ZV,ZW,ZWA,ZZN,ZZR,ZZZ,'" />
<xsl:variable name="Dimension_schemeID" select="'UN/ECE 6313'" />
<xsl:variable name="Dimension_agencyID" select="'6'" />
<xsl:variable name="BIC" select="'rule'" />
<xsl:variable name="BIC_schemeID" select="'BIC'" />
<xsl:variable name="BIC_agencyID" select="'17'" />
<xsl:variable name="IBAN" select="'rule'" />
<xsl:variable name="IBAN_schemeID" select="'IBAN'" />
<xsl:variable name="IBAN_agencyID" select="'17'" />
<xsl:variable name="LocID" select="'rule'" />
<xsl:variable name="LocID_schemeID" select="'UN/ECE rec 16'" />
<xsl:variable name="LocID_agencyID" select="'6'" />
<xsl:variable name="Profile1" select="',NONE,Procurement-BilSim-1.0,Procurement-BilSimR-1.0,Procurement-PayBas-1.0,Procurement-PayBasR-1.0,Procurement-OrdSim-BilSim-1.0,Procurement-OrdSimR-BilSim-1.0,Procurement-OrdSim-BilSimR-1.0,Procurement-OrdSimR-BilSimR-1.0,Procurement-OrdAdv-BilSim-1.0,Procurement-OrdAdv-BilSimR-1.0,Procurement-OrdAdvR-BilSim-1.0,Procurement-OrdAdvR-BilSimR-1.0,Procurement-OrdSel-BilSim-1.0,Procurement-OrdSel-BilSimR-1.0,Catalogue-CatBas-1.0,Catalogue-CatBasR-1.0,Catalogue-CatSim-1.0,Catalogue-CatSimR-1.0,Catalogue-CatExt-1.0,Catalogue-CatExtR-1.0,Catalogue-CatAdv-1.0,Catalogue-CatAdvR-1.0,urn:www.nesubl.eu:profiles:profile1:ver1.0,urn:www.nesubl.eu:profiles:profile2:ver1.0,urn:www.nesubl.eu:profiles:profile5:ver1.0,urn:www.nesubl.eu:profiles:profile7:ver1.0,urn:www.nesubl.eu:profiles:profile8:ver1.0,'" />
<xsl:variable name="Profile1_schemeID" select="'urn:ubl:id:profileid-1.1'" />
<xsl:variable name="Profile1_agencyID" select="'320'" />
<xsl:variable name="Profile2" select="',NONE,Procurement-BilSim-1.0,Procurement-BilSimR-1.0,Procurement-PayBas-1.0,Procurement-PayBasR-1.0,Procurement-OrdSim-BilSim-1.0,Procurement-OrdSimR-BilSim-1.0,Procurement-OrdSim-BilSimR-1.0,Procurement-OrdSimR-BilSimR-1.0,Procurement-OrdAdv-BilSim-1.0,Procurement-OrdAdv-BilSimR-1.0,Procurement-OrdAdvR-BilSim-1.0,Procurement-OrdAdvR-BilSimR-1.0,Procurement-OrdSel-BilSim-1.0,Procurement-OrdSel-BilSimR-1.0,Catalogue-CatBas-1.0,Catalogue-CatBasR-1.0,Catalogue-CatSim-1.0,Catalogue-CatSimR-1.0,Catalogue-CatExt-1.0,Catalogue-CatExtR-1.0,Catalogue-CatAdv-1.0,Catalogue-CatAdvR-1.0,urn:www.nesubl.eu:profiles:profile1:ver1.0,urn:www.nesubl.eu:profiles:profile2:ver1.0,urn:www.nesubl.eu:profiles:profile5:ver1.0,urn:www.nesubl.eu:profiles:profile7:ver1.0,urn:www.nesubl.eu:profiles:profile8:ver1.0,urn:www.nesubl.eu:profiles:profile1:ver2.0,urn:www.nesubl.eu:profiles:profile2:ver2.0,urn:www.nesubl.eu:profiles:profile5:ver2.0,urn:www.nesubl.eu:profiles:profile7:ver2.0,urn:www.nesubl.eu:profiles:profile8:ver2.0,'" />
<xsl:variable name="Profile2_schemeID" select="'urn:ubl:id:profileid-1.2'" />
<xsl:variable name="Profile2_agencyID" select="'320'" />
<xsl:variable name="Profile3" select="',NONE,Procurement-BilSim-1.0,Procurement-BilSimR-1.0,Procurement-PayBas-1.0,Procurement-PayBasR-1.0,Procurement-OrdSim-BilSim-1.0,Procurement-OrdSimR-BilSim-1.0,Procurement-OrdSim-BilSimR-1.0,Procurement-OrdSimR-BilSimR-1.0,Procurement-OrdAdv-BilSim-1.0,Procurement-OrdAdv-BilSimR-1.0,Procurement-OrdAdvR-BilSim-1.0,Procurement-OrdAdvR-BilSimR-1.0,Procurement-OrdSel-BilSim-1.0,Procurement-OrdSel-BilSimR-1.0,Catalogue-CatBas-1.0,Catalogue-CatBasR-1.0,Catalogue-CatSim-1.0,Catalogue-CatSimR-1.0,Catalogue-CatExt-1.0,Catalogue-CatExtR-1.0,Catalogue-CatAdv-1.0,Catalogue-CatAdvR-1.0,urn:www.nesubl.eu:profiles:profile1:ver1.0,urn:www.nesubl.eu:profiles:profile2:ver1.0,urn:www.nesubl.eu:profiles:profile5:ver1.0,urn:www.nesubl.eu:profiles:profile7:ver1.0,urn:www.nesubl.eu:profiles:profile8:ver1.0,urn:www.nesubl.eu:profiles:profile1:ver2.0,urn:www.nesubl.eu:profiles:profile2:ver2.0,urn:www.nesubl.eu:profiles:profile5:ver2.0,urn:www.nesubl.eu:profiles:profile7:ver2.0,urn:www.nesubl.eu:profiles:profile8:ver2.0,Reference-Utility-1.0,Reference-UtilityR-1.0,'" />
<xsl:variable name="Profile3_schemeID" select="'urn:ubl:id:profileid-1.3'" />
<xsl:variable name="Profile3_agencyID" select="'320'" />
<xsl:variable name="TaxCategory1" select="',ZeroRated,StandardRated,ReverseCharge,Excise,3010,3020,3021,3022,3023,3024,3025,3030,3040,3041,3048,3049,3050,3051,3052,3053,3054,3055,3056,3057,3058,3059,3060,3061,3062,3063,3064,3065,3066,3067,3068,3070,3071,3072,3073,3075,3080,3081,3082,3083,3084,3085,3086,3090,3091,3092,3093,3094,3095,3096,3100,3101,3102,3120,3121,3122,3123,3130,3140,3141,3160,3161,3162,3163,3170,3171,3240,3241,3242,3245,3246,3247,3250,3251,3260,3271,3272,3273,3276,3277,3280,3281,3282,3283,3290,3291,3292,3293,3294,3295,3296,3297,3300,3301,3302,3303,3304,3305,3310,3311,3320,3321,3330,3331,3340,3341,3350,3351,3360,3370,3380,3400,3403,3404,3405,3406,3410,3420,3430,3440,3441,3451,3452,3453,3500,3501,3502,3503,3600,3620,3621,3622,3623,3624,3630,3631,3632,3633,3634,3635,3636,3637,3638,3640,3641,3645,3650,3660,3661,3670,3671,'" />
<xsl:variable name="TaxCategory1_schemeID" select="'urn:ubl:id:taxcategoryid-1.1'" />
<xsl:variable name="TaxCategory1_agencyID" select="'320'" />
<xsl:variable name="TaxCategory2" select="',ZeroRated,StandardRated,ReverseCharge,Excise,3010,3020,3021,3022,3023,3024,3025,3030,3040,3041,3048,3049,3050,3051,3052,3053,3054,3055,3056,3057,3058,3059,3060,3061,3062,3063,3064,3065,3066,3067,3068,3070,3071,3072,3073,3075,3077,3080,3081,3082,3083,3084,3085,3086,3090,3091,3092,3093,3094,3095,3096,3100,3101,3102,3104,3120,3121,3122,3123,3130,3140,3141,3160,3161,3162,3163,3170,3171,3240,3241,3242,3245,3246,3247,3250,3251,3260,3271,3272,3273,3276,3277,3280,3281,3282,3283,3290,3291,3292,3293,3294,3295,3296,3297,3300,3301,3302,3303,3304,3305,3310,3311,3320,3321,3330,3331,3340,3341,3350,3351,3360,3370,3380,3400,3403,3404,3405,3406,3410,3420,3430,3440,3441,3451,3452,3453,3500,3501,3502,3503,3600,3620,3621,3622,3623,3624,3630,3631,3632,3633,3634,3635,3636,3637,3638,3640,3641,3645,3650,3660,3661,3670,3671,310301,310302,310303,310304,310305,310306,310307,'" />
<xsl:variable name="TaxCategory2_schemeID" select="'urn:ubl:id:taxcategoryid-1.2'" />
<xsl:variable name="TaxCategory2_agencyID" select="'320'" />
<xsl:variable name="TaxScheme" select="',9,10,11,16,17,18,19,21,24,25,27,28,30,31,32,33,39,40,41,53,54,56,57,61,62,63,69,70,71,72,75,76,77,79,85,86,87,91,94,95,97,98,99,100,108,109,110,111,127,128,130,133,134,135,136,137,138,139,140,142,146,151,152,VAT,0,'" />
<xsl:variable name="TaxScheme_schemeID" select="'urn:ubl:id:taxschemeid-1.1'" />
<xsl:variable name="TaxScheme_agencyID" select="'320'" />
<xsl:variable name="TaxScheme2" select="',9,10,11,16,17,18,19,21,21a,21b,21c,21d,21e,21f,24,25,27,28,30,31,32,33,39,40,41,53,54,56,57,61,61a,62,63,69,70,71,72,75,76,77,79,85,86,87,91,94,94a,95,97,98,99,99a,100,108,109,110,110a,110b,110c,111,112,112a,112b,112c,112d,112e,112f,127,127a,127b,127c,128,130,133,134,135,136,137,138,139,140,142,146,151,152,VAT,0,'" />
<xsl:variable name="TaxScheme2_schemeID" select="'urn:ubl:id:taxschemeid-1.2'" />
<xsl:variable name="TaxScheme2_agencyID" select="'320'" />
<xsl:variable name="EndpointID_schemeID" select="',,DUNS,GLN,IBAN,ISO 6523,DK:CPR,DK:CVR,DK:P,DK:SE,DK:VANS,FR:SIRET,SE:ORGNR,FI:OVT,IT:FTI,IT:SIA,IT:SECETI,IT:VAT,IT:CF,NO:ORGNR,NO:VAT,HU:VAT,EU:VAT,EU:REID,AT:VAT,AT:GOV,AT:CID,IS:KT,AT:KUR,ES:VAT,IT:IPA,AD:VAT,AL:VAT,BA:VAT,BE:VAT,BG:VAT,CH:VAT,CY:VAT,CZ:VAT,DE:VAT,EE:VAT,GB:VAT,GR:VAT,HR:VAT,IE:VAT,LI:VAT,LT:VAT,LU:VAT,LV:VAT,MC:VAT,ME:VAT,MK:VAT,MT:VAT,NL:VAT,PL:VAT,PT:VAT,RO:VAT,RS:VAT,SI:VAT,SK:VAT,SM:VAT,TR:VAT,VA:VAT,'" />
<xsl:variable name="PartyID_schemeID" select="',,DUNS,GLN,IBAN,ISO 6523,ZZZ,DK:CPR,DK:CVR,DK:P,DK:SE,DK:TELEFON,FI:ORGNR,IS:KT,IS:VSKNR,NO:EFO,NO:NOBB,NO:NODI,NO:ORGNR,NO:VAT,SE:ORGNR,SE:VAT,FR:SIRET,FI:OVT,IT:FTI,IT:SIA,IT:SECETI,IT:VAT,IT:CF,HU:VAT,EU:VAT,EU:REID,AT:VAT,AT:GOV,AT:CID,IS:KT,AT:KUR,ES:VAT,IT:IPA,AD:VAT,AL:VAT,BA:VAT,BE:VAT,BG:VAT,CH:VAT,CY:VAT,CZ:VAT,DE:VAT,EE:VAT,GB:VAT,GR:VAT,HR:VAT,IE:VAT,LI:VAT,LT:VAT,LU:VAT,LV:VAT,MC:VAT,ME:VAT,MK:VAT,MT:VAT,NL:VAT,PL:VAT,PT:VAT,RO:VAT,RS:VAT,SI:VAT,SK:VAT,SM:VAT,TR:VAT,VA:VAT,'" />
<xsl:variable name="PartyLegalID" select="',DK:CVR,DK:CPR,ZZZ,'" />
<xsl:variable name="PartyTaxID" select="',DK:SE,ZZZ,'" />
<xsl:template match="text()" priority="-1" mode="M10" />
<xsl:template match="@*|node()" priority="-2" mode="M10">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M10" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M10" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN abstracts-->
<xsl:template match="text()" priority="-1" mode="M12" />
<xsl:template match="@*|node()" priority="-2" mode="M12">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M12" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M12" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN ublextensions-->


	<!--RULE -->
<xsl:template match="doc:Catalogue" priority="3999" mode="M13">

		<!--REPORT -->
<xsl:if test="ext:UBLExtensions/ext:UBLExtension/ext:ExtensionAgencyID = 'Digitaliseringsstyrelsen' and (ext:UBLExtensions/ext:UBLExtension/cbc:ID &lt; '1001' or ext:UBLExtensions/ext:UBLExtension/cbc:ID &gt; '1999')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>ext:UBLExtensions/ext:UBLExtension/ext:ExtensionAgencyID = 'Digitaliseringsstyrelsen' and (ext:UBLExtensions/ext:UBLExtension/cbc:ID &lt; '1001' or ext:UBLExtensions/ext:UBLExtension/cbc:ID &gt; '1999')</Pattern>
<Description>[F-LIB313] Invalid UBLExtension/ID when UBLExtension/ExtensionAgencyID is equal to 'Digitaliseringsstyrelsen'. ID must be an assigned value between '1001' and '1999'.</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M13" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M13" />
<xsl:template match="@*|node()" priority="-2" mode="M13">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M13" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M13" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN profile-->



	<!--RULE -->
<xsl:template match="doc:Catalogue" priority="3998" mode="M14">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:UBLVersionID = '2.1'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:UBLVersionID = '2.1'</Pattern>
<Description>[F-LIB001] Invalid UBLVersionID. Must be '2.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="contains(cbc:CustomizationID,'BiiCoreTrdm019') and contains(cbc:CustomizationID,'ver1.0')"/>
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>contains(cbc:CustomizationID,'BiiCoreTrdm019') and contains(cbc:CustomizationID,'ver1.0')</Pattern>
<Description>[F-LIB002] Invalid CustomizationID. Must contain 'BiiCoreTrdm019' and 'ver1.0'</Description>
<Description>[F-LIB002] Feil CustomizationID. Må inneholde 'BiiCoreTrdm019' og 'ver1.0'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ProfileID/@schemeID = $Profile1_schemeID or cbc:ProfileID/@schemeID = $Profile2_schemeID or cbc:ProfileID/@schemeID = $Profile3_schemeID or not(cbc:ProfileID/@schemeID)"/>
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ProfileID/@schemeID = $Profile1_schemeID or cbc:ProfileID/@schemeID = $Profile2_schemeID or cbc:ProfileID/@schemeID = $Profile3_schemeID</Pattern>
<Description>[W-LIB003] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$Profile1_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$Profile2_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$Profile3_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(cbc:ProfileID/@schemeAgencyID) or cbc:ProfileID/@schemeAgencyID = $Profile1_agencyID " />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ProfileID/@schemeAgencyID = $Profile1_agencyID</Pattern>
<Description>[W-LIB203] Invalid schemeAgencyID. Must be '<xsl:text />
<xsl:value-of select="$Profile1_agencyID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:ProfileID/@schemeID = $Profile1_schemeID and not (contains($Profile1, concat(',',cbc:ProfileID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ProfileID/@schemeID = $Profile1_schemeID and not (contains($Profile1, concat(',',cbc:ProfileID,',')))</Pattern>
<Description>[F-LIB004] Invalid ProfileID: '<xsl:text />
<xsl:value-of select="cbc:ProfileID" />
<xsl:text />'. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ProfileID/@schemeID = $Profile2_schemeID and not (contains($Profile2, concat(',',cbc:ProfileID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ProfileID/@schemeID = $Profile2_schemeID and not (contains($Profile2, concat(',',cbc:ProfileID,',')))</Pattern>
<Description>[F-LIB302] Invalid ProfileID: '<xsl:text />
<xsl:value-of select="cbc:ProfileID" />
<xsl:text />'. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ProfileID/@schemeID = $Profile3_schemeID and not (contains($Profile3, concat(',',cbc:ProfileID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ProfileID/@schemeID = $Profile3_schemeID and not (contains($Profile3, concat(',',cbc:ProfileID,',')))</Pattern>
<Description>[F-LIB308] Invalid ProfileID: '<xsl:text />
<xsl:value-of select="cbc:ProfileID" />
<xsl:text />'. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M14" />
<xsl:template match="@*|node()" priority="-2" mode="M14">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M14" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M14" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN catalogue-->


	<!--RULE -->
<xsl:template match="doc:Catalogue" priority="3999" mode="M15">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:LineCountNumeric) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:LineCountNumeric) = 0</Pattern>
<Description>[F-CAT004] LineCountNumeric element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:VersionID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:VersionID != ''</Pattern>
<Description>[F-CAT003] Invalid VersionID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:ValidityPeriod) = 1" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:ValidityPeriod) = 1</Pattern>
<Description>[F-CAT005] One ValidityPeriod class must be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:SellerSupplierParty) = 1" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:SellerSupplierParty) = 1</Pattern>
<Description>[F-CAT006] One SellerSupplierParty class must be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT002] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:ContractorCustomerParty and cac:ReceiverParty/cac:PartyIdentification/cbc:ID = cac:ContractorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:ContractorCustomerParty and cac:ReceiverParty/cac:PartyIdentification/cbc:ID = cac:ContractorCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID</Pattern>
<Description>[F-CAT007] ContractorCustomerParty must be different from ReceiverParty</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:ReferencedContract) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:ReferencedContract) &gt; 1</Pattern>
<Description>[F-CAT008] No more than one ReferencedContract class must be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cbc:UUID" priority="3998" mode="M15">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="string-length(string(.)) = 36" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>string-length(string(.)) = 36</Pattern>
<Description>[F-LIB006] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cbc:Note" priority="3997" mode="M15">

		<!--REPORT -->
<xsl:if test="count(../cbc:Note) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Note) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB011] The attribute languageID should be used when more than one <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text /> element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB012] Multilanguage error. Replicated <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text /> elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cbc:Description" priority="3996" mode="M15">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M15" />
<xsl:template match="@*|node()" priority="-2" mode="M15">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M15" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M15" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN validityperiod-->


	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ValidityPeriod" priority="3999" mode="M16">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ValidityPeriod/cbc:Description" priority="3998" mode="M16">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M16" />
<xsl:template match="@*|node()" priority="-2" mode="M16">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M16" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M16" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN referencedcontract-->


	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReferencedContract" priority="3999" mode="M17">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT020] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:ContractType and cbc:ContractTypeCode">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ContractType and cbc:ContractTypeCode</Pattern>
<Description>[F-CAT021] Use either ContractType or ContractTypeCode</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:ContractDocumentReference) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:ContractDocumentReference) &gt; 1</Pattern>
<Description>[F-CAT022] No more than one ContractDocumentReference class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReferencedContract/cac:ValidityPeriod" priority="3998" mode="M17">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReferencedContract/cac:ValidityPeriod/cbc:Description" priority="3997" mode="M17">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReferencedContract/cac:ContractDocumentReference" priority="3996" mode="M17">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DocumentType) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DocumentType) = 0</Pattern>
<Description>[Warning-LIB170] DocumentType element scould have a value </Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DocumentTypeCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DocumentTypeCode) = 0</Pattern>
<Description>[F-LIB172] DocumentTypeCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment and cbc:XPath</Pattern>
<Description>[F-LIB169] Use either Attachment or XPath</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference</Pattern>
<Description>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:UUID and not(string-length(string(cbc:UUID)) = 36)</Pattern>
<Description>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')</Pattern>
<Description>[F-LIB174] Attribute mimeCode must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')</Pattern>
<Description>[F-LIB096] When using ExternalReference, URI is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M17" />
<xsl:template match="@*|node()" priority="-2" mode="M17">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M17" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M17" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN signature-->


	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature" priority="3999" mode="M18">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT030] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty" priority="3998" mode="M18">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkCareIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkCareIndicator) = 0</Pattern>
<Description>[F-LIB166] MarkCareIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkAttentionIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkAttentionIndicator) = 0</Pattern>
<Description>[F-LIB167] MarkAttentionIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:AgentParty) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:AgentParty) = 0</Pattern>
<Description>[F-LIB168] AgentParty class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')</Pattern>
<Description>[F-LIB022-1] PartyName/Name is mandatory if PartyIdentification/ID is not found</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->

<xsl:if test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))</Pattern>
<Description>[F-LIB179] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:EndpointID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$EndpointID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB180] schemeID = DK:CVR, EndpointID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)</Pattern>
<Description>[F-LIB215] schemeID = DK:CPR, EndpointID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB181] schemeID = GLN, EndpointID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB216] schemeID = EAN, EndpointID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:PartyLegalEntity) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PartyLegalEntity) &gt; 1</Pattern>
<Description>[F-CAT031] No more than one PartyLegalEntity class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:PartyIdentification" priority="3997" mode="M18">

		<!--REPORT -->
<xsl:if test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))</Pattern>
<Description>[F-LIB183] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:ID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$PartyID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB184] schemeID = DK:CVR, ID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB217] schemeID = DK:CPR, ID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB185] schemeID = GLN, ID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB218] schemeID = EAN, ID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB287] schemeID = DK:P, ID must be a valid P number (1234567890)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:PartyName" priority="3996" mode="M18">

		<!--REPORT -->
<xsl:if test="count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)</Pattern>
<Description>[W-LIB219] The attribute Name@languageID should be used when more than one PartyName class is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID</Pattern>
<Description>[W-LIB220] Multilanguage error. Replicated PartyName classes with same Name@languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:PostalAddress" priority="3995" mode="M18">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:AddressFormatCode) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:AddressFormatCode) != ''</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:oioubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID  or cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID  or cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-1] Invalid listID. Must be either 'urn:oioubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID  or cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID  or cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID  or cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID  or cbc:AddressFormatCode/@listID = 'urn:oioubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation" priority="3994" mode="M18">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)</Pattern>
<Description>[F-LIB221] If ID not specified, Address is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation/cac:ValidityPeriod" priority="3993" mode="M18">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" priority="3992" mode="M18">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:PhysicalLocation/cac:Address" priority="3991" mode="M18">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))"/>
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:oioubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:oioubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID or cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-2] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:PartyTaxScheme" priority="3990" mode="M18">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TaxLevelCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TaxLevelCode) = 0</Pattern>
<Description>[F-LIB192] TaxLevelCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB193] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:PartyTaxScheme/cac:TaxScheme" priority="3989" mode="M18">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:ID) = 0</Pattern>
<Description>[F-LIB041] ID element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0</Pattern>
<Description>[F-LIB042] AddressTypeCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0</Pattern>
<Description>[F-LIB043] Postbox element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Floor) = 0</Pattern>
<Description>[F-LIB044] Floor element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Room) = 0</Pattern>
<Description>[F-LIB045] Room element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0</Pattern>
<Description>[F-LIB046] StreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0</Pattern>
<Description>[F-LIB047] AdditionalStreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0</Pattern>
<Description>[F-LIB048] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0</Pattern>
<Description>[F-LIB049] BuildingName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0</Pattern>
<Description>[F-LIB050] BuildingNumber element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0</Pattern>
<Description>[F-LIB051] InhouseMail element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Department) = 0</Pattern>
<Description>[F-LIB052] Department element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0</Pattern>
<Description>[F-LIB053] MarkAttention element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0</Pattern>
<Description>[F-LIB054] MarkCare element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0</Pattern>
<Description>[F-LIB055] PlotIdentification element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0</Pattern>
<Description>[F-LIB056] CitySubdivisionName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CityName) = 0</Pattern>
<Description>[F-LIB057] CityName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0</Pattern>
<Description>[F-LIB058] PostalZone element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0</Pattern>
<Description>[F-LIB059] CountrySubentity element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0</Pattern>
<Description>[F-LIB060] CountrySubentityCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB063] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0</Pattern>
<Description>[F-LIB234] AddressLine class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB064] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:TaxTypeCode</Pattern>
<Description>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[F-LIB065] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:Name) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:Name) != ''</Pattern>
<Description>[F-LIB066] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and not(cbc:TaxTypeCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and not(cbc:TaxTypeCode)</Pattern>
<Description>[F-LIB197] TaxTypeCode is mandatory when TaxScheme/ID is different from '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID</Pattern>
<Description>[F-LIB070] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$TaxScheme_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$TaxScheme2_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')</Pattern>
<Description>[F-LIB071] Invalid listID. Must be 'urn:ubl:codelist:taxtypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:Name != 'Moms'</Pattern>
<Description>[F-LIB198] Name must equal 'Moms' when  TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and cbc:Name = 'Moms'</Pattern>
<Description>[F-LIB199] Name must correspond to the value of TaxScheme/ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'</Pattern>
<Description>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:PartyLegalEntity" priority="3988" mode="M18">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:CorporateRegistrationScheme) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:CorporateRegistrationScheme) = 0</Pattern>
<Description>[F-LIB186] CorporateRegistrationScheme class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB187] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB189] Invalid schemeID. Must be a valid scheme for PartyLegalEntity/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB190] schemeID = DK:CVR, CompanyID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)</Pattern>
<Description>[F-LIB191] schemeID = DK:CPR, CompanyID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:Contact" priority="3987" mode="M18">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-1] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:SignatoryParty/cac:Person" priority="3986" mode="M18">

		<!--REPORT -->
<xsl:if test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')</Pattern>
<Description>[F-LIB024] There must be a FirstName if the FamilyName is not present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:DigitalSignatureAttachment" priority="3985" mode="M18">

		<!--REPORT -->
<xsl:if test="cbc:EmbeddedDocumentBinaryObject and cac:ExternalReference">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:EmbeddedDocumentBinaryObject and cac:ExternalReference</Pattern>
<Description>[F-LIB284] Use either EmbeddedDocumentBinaryObject or ExternalReference</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:EmbeddedDocumentBinaryObject and not(cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:EmbeddedDocumentBinaryObject and not(cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')</Pattern>
<Description>[F-LIB285] Attribute mimeCode must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:ExternalReference and not(cac:ExternalReference/cbc:URI != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:ExternalReference and not(cac:ExternalReference/cbc:URI != '')</Pattern>
<Description>[F-LIB286] When using ExternalReference, URI is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:Signature/cac:OriginalDocumentReference" priority="3984" mode="M18">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:DocumentType or cbc:DocumentTypeCode" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:DocumentType or cbc:DocumentTypeCode</Pattern>
<Description>[F-LIB092] Use either DocumentType or DocumentTypeCode</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment and cbc:XPath</Pattern>
<Description>[F-LIB093] Use either Attachment or XPath</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:DocumentType and cbc:DocumentTypeCode != 'ZZZ'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:DocumentType and cbc:DocumentTypeCode != 'ZZZ'</Pattern>
<Description>[F-LIB094] Use either DocumentType or DocumentTypeCode</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference</Pattern>
<Description>[F-LIB095] Use either EmbeddedDocumentBinaryObject or ExternalReference</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:UUID and not(string-length(string(cbc:UUID)) = 36)</Pattern>
<Description>[F-LIB097] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')</Pattern>
<Description>[F-LIB098] Attribute mimeCode must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')</Pattern>
<Description>[F-LIB279] When using ExternalReference, URI is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M18" />
<xsl:template match="@*|node()" priority="-2" mode="M18">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M18" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M18" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN providerparty-->


	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty" priority="3999" mode="M19">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkCareIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkCareIndicator) = 0</Pattern>
<Description>[F-LIB166] MarkCareIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkAttentionIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkAttentionIndicator) = 0</Pattern>
<Description>[F-LIB167] MarkAttentionIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:AgentParty) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:AgentParty) = 0</Pattern>
<Description>[F-LIB168] AgentParty class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:EndpointID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:EndpointID != ''</Pattern>
<Description>[F-CAT040] Invalid EndpointID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:PartyLegalEntity) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PartyLegalEntity) = 1</Pattern>
<Description>[F-CAT041] One PartyLegalEntity class must be present</Description>
<Description>[F-CAT041] En PartyLegalEntity class må benyttes</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')</Pattern>
<Description>[F-LIB022-2] PartyName/Name is mandatory if PartyIdentification/ID is not found</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:choose>
<xsl:when test="not(cbc:EndpointID/@schemeID)" />
<xsl:otherwise>
<xsl:if test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))</Pattern>
<Description>[F-LIB179] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:EndpointID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$EndpointID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB180] schemeID = DK:CVR, EndpointID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)</Pattern>
<Description>[F-LIB215] schemeID = DK:CPR, EndpointID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB181] schemeID = GLN, EndpointID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB216] schemeID = EAN, EndpointID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:PartyIdentification" priority="3998" mode="M19">

		<!--REPORT -->
<xsl:if test="cbc:ID/@schemeID or not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))</Pattern>
<Description>[F-LIB183] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:ID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$PartyID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB184] schemeID = DK:CVR, ID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB217] schemeID = DK:CPR, ID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB185] schemeID = GLN, ID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB218] schemeID = EAN, ID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB287] schemeID = DK:P, ID must be a valid P number (1234567890)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:PartyName" priority="3997" mode="M19">

		<!--REPORT -->
<xsl:if test="count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)</Pattern>
<Description>[W-LIB219] The attribute Name@languageID should be used when more than one PartyName class is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID</Pattern>
<Description>[W-LIB220] Multilanguage error. Replicated PartyName classes with same Name@languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:PostalAddress" priority="3996" mode="M19">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-3] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:PhysicalLocation" priority="3995" mode="M19">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)</Pattern>
<Description>[F-LIB221] If ID not specified, Address is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:PhysicalLocation/cac:ValidityPeriod" priority="3994" mode="M19">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" priority="3993" mode="M19">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:PhysicalLocation/cac:Address" priority="3992" mode="M19">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-4] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:PartyTaxScheme" priority="3991" mode="M19">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TaxLevelCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TaxLevelCode) = 0</Pattern>
<Description>[F-LIB192] TaxLevelCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB193] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:PartyTaxScheme/cac:TaxScheme" priority="3990" mode="M19">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:ID) = 0</Pattern>
<Description>[F-LIB041] ID element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0</Pattern>
<Description>[F-LIB042] AddressTypeCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0</Pattern>
<Description>[F-LIB043] Postbox element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Floor) = 0</Pattern>
<Description>[F-LIB044] Floor element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Room) = 0</Pattern>
<Description>[F-LIB045] Room element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0</Pattern>
<Description>[F-LIB046] StreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0</Pattern>
<Description>[F-LIB047] AdditionalStreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0</Pattern>
<Description>[F-LIB048] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0</Pattern>
<Description>[F-LIB049] BuildingName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0</Pattern>
<Description>[F-LIB050] BuildingNumber element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0</Pattern>
<Description>[F-LIB051] InhouseMail element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Department) = 0</Pattern>
<Description>[F-LIB052] Department element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0</Pattern>
<Description>[F-LIB053] MarkAttention element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0</Pattern>
<Description>[F-LIB054] MarkCare element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0</Pattern>
<Description>[F-LIB055] PlotIdentification element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0</Pattern>
<Description>[F-LIB056] CitySubdivisionName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CityName) = 0</Pattern>
<Description>[F-LIB057] CityName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0</Pattern>
<Description>[F-LIB058] PostalZone element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0</Pattern>
<Description>[F-LIB059] CountrySubentity element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0</Pattern>
<Description>[F-LIB060] CountrySubentityCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB063] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0</Pattern>
<Description>[F-LIB234] AddressLine class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB064] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:TaxTypeCode</Pattern>
<Description>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[F-LIB065] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:Name) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:Name) != ''</Pattern>
<Description>[F-LIB066] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and not(cbc:TaxTypeCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and not(cbc:TaxTypeCode)</Pattern>
<Description>[F-LIB197] TaxTypeCode is mandatory when TaxScheme/ID is different from '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID</Pattern>
<Description>[F-LIB070] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$TaxScheme_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$TaxScheme2_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')</Pattern>
<Description>[F-LIB071] Invalid listID. Must be 'urn:ubl:codelist:taxtypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:Name != 'Moms'</Pattern>
<Description>[F-LIB198] Name must equal 'Moms' when  TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and cbc:Name = 'Moms'</Pattern>
<Description>[F-LIB199] Name must correspond to the value of TaxScheme/ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'</Pattern>
<Description>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:PartyLegalEntity" priority="3989" mode="M19">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:CorporateRegistrationScheme) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:CorporateRegistrationScheme) = 0</Pattern>
<Description>[F-LIB186] CorporateRegistrationScheme class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB187] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB189] Invalid schemeID. Must be a valid scheme for PartyLegalEntity/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB190] schemeID = DK:CVR, CompanyID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)</Pattern>
<Description>[F-LIB191] schemeID = DK:CPR, CompanyID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:Contact" priority="3988" mode="M19">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-2] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ProviderParty/cac:Person" priority="3987" mode="M19">

		<!--REPORT -->
<xsl:if test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')</Pattern>
<Description>[F-LIB024] There must be a FirstName if the FamilyName is not present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M19" />
<xsl:template match="@*|node()" priority="-2" mode="M19">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M19" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M19" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN receiverparty-->


	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty" priority="3999" mode="M20">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkCareIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkCareIndicator) = 0</Pattern>
<Description>[F-LIB166] MarkCareIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkAttentionIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkAttentionIndicator) = 0</Pattern>
<Description>[F-LIB167] MarkAttentionIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:AgentParty) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:AgentParty) = 0</Pattern>
<Description>[F-LIB168] AgentParty class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:EndpointID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:EndpointID != ''</Pattern>
<Description>[F-CAT050] Invalid EndpointID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')</Pattern>
<Description>[F-LIB022-4] PartyName/Name is mandatory if PartyIdentification/ID is not found</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',') or cbc:EndpointID/@schemeID =''))</Pattern>
<Description>[F-LIB179] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:EndpointID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$EndpointID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB180] schemeID = DK:CVR, EndpointID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)</Pattern>
<Description>[F-LIB215] schemeID = DK:CPR, EndpointID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB181] schemeID = GLN, EndpointID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB216] schemeID = EAN, EndpointID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:PartyLegalEntity) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PartyLegalEntity) &gt; 1</Pattern>
<Description>[F-CAT051] No more than one PartyLegalEntity class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:PartyIdentification" priority="3998" mode="M20">

		<!--REPORT -->
<xsl:if test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))</Pattern>
<Description>[F-LIB183] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:ID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:text />'. Må være en kode fra kodelista: '<xsl:text />
<xsl:value-of select="$PartyID_schemeID" /><xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB184] schemeID = DK:CVR, ID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB217] schemeID = DK:CPR, ID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB185] schemeID = GLN, ID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB218] schemeID = EAN, ID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB287] schemeID = DK:P, ID must be a valid P number (1234567890)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:PartyName" priority="3997" mode="M20">

		<!--REPORT -->
<xsl:if test="count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)</Pattern>
<Description>[W-LIB219] The attribute Name@languageID should be used when more than one PartyName class is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID</Pattern>
<Description>[W-LIB220] Multilanguage error. Replicated PartyName classes with same Name@languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:PostalAddress" priority="3996" mode="M20">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-5] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:PhysicalLocation" priority="3995" mode="M20">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)</Pattern>
<Description>[F-LIB221] If ID not specified, Address is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:PhysicalLocation/cac:ValidityPeriod" priority="3994" mode="M20">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" priority="3993" mode="M20">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:PhysicalLocation/cac:Address" priority="3992" mode="M20">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-6] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:PartyTaxScheme" priority="3991" mode="M20">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TaxLevelCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TaxLevelCode) = 0</Pattern>
<Description>[F-LIB192] TaxLevelCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB193] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:PartyTaxScheme/cac:TaxScheme" priority="3990" mode="M20">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:ID) = 0</Pattern>
<Description>[F-LIB041] ID element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0</Pattern>
<Description>[F-LIB042] AddressTypeCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0</Pattern>
<Description>[F-LIB043] Postbox element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Floor) = 0</Pattern>
<Description>[F-LIB044] Floor element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Room) = 0</Pattern>
<Description>[F-LIB045] Room element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0</Pattern>
<Description>[F-LIB046] StreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0</Pattern>
<Description>[F-LIB047] AdditionalStreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0</Pattern>
<Description>[F-LIB048] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0</Pattern>
<Description>[F-LIB049] BuildingName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0</Pattern>
<Description>[F-LIB050] BuildingNumber element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0</Pattern>
<Description>[F-LIB051] InhouseMail element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Department) = 0</Pattern>
<Description>[F-LIB052] Department element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0</Pattern>
<Description>[F-LIB053] MarkAttention element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0</Pattern>
<Description>[F-LIB054] MarkCare element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0</Pattern>
<Description>[F-LIB055] PlotIdentification element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0</Pattern>
<Description>[F-LIB056] CitySubdivisionName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CityName) = 0</Pattern>
<Description>[F-LIB057] CityName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0</Pattern>
<Description>[F-LIB058] PostalZone element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0</Pattern>
<Description>[F-LIB059] CountrySubentity element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0</Pattern>
<Description>[F-LIB060] CountrySubentityCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB063] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0</Pattern>
<Description>[F-LIB234] AddressLine class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB064] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:TaxTypeCode</Pattern>
<Description>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[F-LIB065] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:Name) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:Name) != ''</Pattern>
<Description>[F-LIB066] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and not(cbc:TaxTypeCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and not(cbc:TaxTypeCode)</Pattern>
<Description>[F-LIB197] TaxTypeCode is mandatory when TaxScheme/ID is different from '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID</Pattern>
<Description>[F-LIB070] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$TaxScheme_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$TaxScheme2_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')</Pattern>
<Description>[F-LIB071] Invalid listID. Must be 'urn:ubl:codelist:taxtypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:Name != 'Moms'</Pattern>
<Description>[F-LIB198] Name must equal 'Moms' when  TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and cbc:Name = 'Moms'</Pattern>
<Description>[F-LIB199] Name must correspond to the value of TaxScheme/ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'</Pattern>
<Description>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:PartyLegalEntity" priority="3989" mode="M20">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:CorporateRegistrationScheme) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:CorporateRegistrationScheme) = 0</Pattern>
<Description>[F-LIB186] CorporateRegistrationScheme class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB187] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB189] Invalid schemeID. Must be a valid scheme for PartyLegalEntity/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB190] schemeID = DK:CVR, CompanyID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)</Pattern>
<Description>[F-LIB191] schemeID = DK:CPR, CompanyID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:Contact" priority="3988" mode="M20">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-3] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ReceiverParty/cac:Person" priority="3987" mode="M20">

		<!--REPORT -->
<xsl:if test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')</Pattern>
<Description>[F-LIB024] There must be a FirstName if the FamilyName is not present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M20" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M20" />
<xsl:template match="@*|node()" priority="-2" mode="M20">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M20" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M20" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN sellersupplierparty-->


	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty" priority="3999" mode="M21">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DataSendingCapability) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DataSendingCapability) = 0</Pattern>
<Description>[F-CAT060] DataSendingCapability element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:Party) = 1" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:Party) = 1</Pattern>
<Description>[F-CAT061] One Party class must be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party" priority="3998" mode="M21">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkCareIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkCareIndicator) = 0</Pattern>
<Description>[F-LIB166] MarkCareIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkAttentionIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkAttentionIndicator) = 0</Pattern>
<Description>[F-LIB167] MarkAttentionIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:AgentParty) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:AgentParty) = 0</Pattern>
<Description>[F-LIB168] AgentParty class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')</Pattern>
<Description>[F-LIB022-5] PartyName/Name is mandatory if PartyIdentification/ID is not found</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))</Pattern>
<Description>[F-LIB179] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:EndpointID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$EndpointID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB180] schemeID = DK:CVR, EndpointID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)</Pattern>
<Description>[F-LIB215] schemeID = DK:CPR, EndpointID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB181] schemeID = GLN, EndpointID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB216] schemeID = EAN, EndpointID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:PartyLegalEntity) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PartyLegalEntity) &gt; 1</Pattern>
<Description>[F-CAT062] No more than one PartyLegalEntity class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" priority="3997" mode="M21">

		<!--REPORT -->
<xsl:if test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))</Pattern>
<Description>[F-LIB183] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:ID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$PartyID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB184] schemeID = DK:CVR, ID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB217] schemeID = DK:CPR, ID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB185] schemeID = GLN, ID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB218] schemeID = EAN, ID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB287] schemeID = DK:P, ID must be a valid P number (1234567890)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyName" priority="3996" mode="M21">

		<!--REPORT -->
<xsl:if test="count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)</Pattern>
<Description>[W-LIB219] The attribute Name@languageID should be used when more than one PartyName class is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID</Pattern>
<Description>[W-LIB220] Multilanguage error. Replicated PartyName classes with same Name@languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" priority="3995" mode="M21">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(cbc:AddressFormatCode/@listID) or cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-7] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PhysicalLocation" priority="3994" mode="M21">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)</Pattern>
<Description>[F-LIB221] If ID not specified, Address is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod" priority="3993" mode="M21">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" priority="3992" mode="M21">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PhysicalLocation/cac:Address" priority="3991" mode="M21">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-8] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyTaxScheme" priority="3990" mode="M21">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TaxLevelCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TaxLevelCode) = 0</Pattern>
<Description>[F-LIB192] TaxLevelCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB193] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" priority="3989" mode="M21">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:ID) = 0</Pattern>
<Description>[F-LIB041] ID element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0</Pattern>
<Description>[F-LIB042] AddressTypeCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0</Pattern>
<Description>[F-LIB043] Postbox element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Floor) = 0</Pattern>
<Description>[F-LIB044] Floor element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Room) = 0</Pattern>
<Description>[F-LIB045] Room element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0</Pattern>
<Description>[F-LIB046] StreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0</Pattern>
<Description>[F-LIB047] AdditionalStreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0</Pattern>
<Description>[F-LIB048] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0</Pattern>
<Description>[F-LIB049] BuildingName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0</Pattern>
<Description>[F-LIB050] BuildingNumber element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0</Pattern>
<Description>[F-LIB051] InhouseMail element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Department) = 0</Pattern>
<Description>[F-LIB052] Department element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0</Pattern>
<Description>[F-LIB053] MarkAttention element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0</Pattern>
<Description>[F-LIB054] MarkCare element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0</Pattern>
<Description>[F-LIB055] PlotIdentification element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0</Pattern>
<Description>[F-LIB056] CitySubdivisionName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CityName) = 0</Pattern>
<Description>[F-LIB057] CityName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0</Pattern>
<Description>[F-LIB058] PostalZone element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0</Pattern>
<Description>[F-LIB059] CountrySubentity element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0</Pattern>
<Description>[F-LIB060] CountrySubentityCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB063] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0</Pattern>
<Description>[F-LIB234] AddressLine class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB064] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:TaxTypeCode</Pattern>
<Description>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[F-LIB065] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:Name) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:Name) != ''</Pattern>
<Description>[F-LIB066] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and not(cbc:TaxTypeCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and not(cbc:TaxTypeCode)</Pattern>
<Description>[F-LIB197] TaxTypeCode is mandatory when TaxScheme/ID is different from '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID</Pattern>
<Description>[F-LIB070] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$TaxScheme_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$TaxScheme2_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')</Pattern>
<Description>[F-LIB071] Invalid listID. Must be 'urn:ubl:codelist:taxtypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:Name != 'Moms'</Pattern>
<Description>[F-LIB198] Name must equal 'Moms' when  TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and cbc:Name = 'Moms'</Pattern>
<Description>[F-LIB199] Name must correspond to the value of TaxScheme/ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'</Pattern>
<Description>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity" priority="3988" mode="M21">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:CorporateRegistrationScheme) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:CorporateRegistrationScheme) = 0</Pattern>
<Description>[F-LIB186] CorporateRegistrationScheme class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB187] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'NO:ORGNR' or cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB189] Invalid schemeID. Must be a valid scheme for PartyLegalEntity/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB190] schemeID = DK:CVR, CompanyID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)</Pattern>
<Description>[F-LIB191] schemeID = DK:CPR, CompanyID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Contact" priority="3987" mode="M21">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-4] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:Party/cac:Person" priority="3986" mode="M21">

		<!--REPORT -->
<xsl:if test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')</Pattern>
<Description>[F-LIB024] There must be a FirstName if the FamilyName is not present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:DespatchContact" priority="3985" mode="M21">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-5] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:AccountingContact" priority="3984" mode="M21">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-6] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:SellerSupplierParty/cac:SellerContact" priority="3983" mode="M21">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-7] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M21" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M21" />
<xsl:template match="@*|node()" priority="-2" mode="M21">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M21" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M21" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN ContractorCustomerParty-->


	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty" priority="3999" mode="M22">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:Party) = 1" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:Party) = 1</Pattern>
<Description>[F-CAT070] Party class must be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party" priority="3998" mode="M22">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkCareIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkCareIndicator) = 0</Pattern>
<Description>[F-LIB166] MarkCareIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkAttentionIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkAttentionIndicator) = 0</Pattern>
<Description>[F-LIB167] MarkAttentionIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:AgentParty) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:AgentParty) = 0</Pattern>
<Description>[F-LIB168] AgentParty class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT kan være tom
<xsl:if test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or not(cac:PartyName/cbc:Name))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')</Pattern>
<Description>[F-LIB022-6] PartyName/Name is mandatory if PartyIdentification/ID is not found</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
-->
		<!--REPORT -->
<xsl:if test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))</Pattern>
<Description>[F-LIB179] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:EndpointID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$EndpointID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB180] schemeID = DK:CVR, EndpointID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)</Pattern>
<Description>[F-LIB215] schemeID = DK:CPR, EndpointID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB181] schemeID = GLN, EndpointID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB216] schemeID = EAN, EndpointID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:PartyLegalEntity) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PartyLegalEntity) &gt; 1</Pattern>
<Description>[F-CAT071] No more than one PartyLegalEntity class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyIdentification" priority="3997" mode="M22">

		<!--REPORT -->
<xsl:if test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))</Pattern>
<Description>[F-LIB183] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:ID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$PartyID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB184] schemeID = DK:CVR, ID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB217] schemeID = DK:CPR, ID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB185] schemeID = GLN, ID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB218] schemeID = EAN, ID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB287] schemeID = DK:P, ID must be a valid P number (1234567890)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyName" priority="3996" mode="M22">

		<!--REPORT -->
<xsl:if test="count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)</Pattern>
<Description>[W-LIB219] The attribute Name@languageID should be used when more than one PartyName class is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID</Pattern>
<Description>[W-LIB220] Multilanguage error. Replicated PartyName classes with same Name@languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress" priority="3995" mode="M22">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(cbc:AddressFormatCode/@listID) or cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-17] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PhysicalLocation" priority="3994" mode="M22">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)</Pattern>
<Description>[F-LIB221] If ID not specified, Address is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod" priority="3993" mode="M22">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" priority="3992" mode="M22">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PhysicalLocation/cac:Address" priority="3991" mode="M22">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-9] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyTaxScheme" priority="3990" mode="M22">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TaxLevelCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TaxLevelCode) = 0</Pattern>
<Description>[F-LIB192] TaxLevelCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB193] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" priority="3989" mode="M22">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:ID) = 0</Pattern>
<Description>[F-LIB041] ID element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0</Pattern>
<Description>[F-LIB042] AddressTypeCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0</Pattern>
<Description>[F-LIB043] Postbox element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Floor) = 0</Pattern>
<Description>[F-LIB044] Floor element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Room) = 0</Pattern>
<Description>[F-LIB045] Room element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0</Pattern>
<Description>[F-LIB046] StreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0</Pattern>
<Description>[F-LIB047] AdditionalStreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0</Pattern>
<Description>[F-LIB048] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0</Pattern>
<Description>[F-LIB049] BuildingName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0</Pattern>
<Description>[F-LIB050] BuildingNumber element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0</Pattern>
<Description>[F-LIB051] InhouseMail element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Department) = 0</Pattern>
<Description>[F-LIB052] Department element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0</Pattern>
<Description>[F-LIB053] MarkAttention element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0</Pattern>
<Description>[F-LIB054] MarkCare element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0</Pattern>
<Description>[F-LIB055] PlotIdentification element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0</Pattern>
<Description>[F-LIB056] CitySubdivisionName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CityName) = 0</Pattern>
<Description>[F-LIB057] CityName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0</Pattern>
<Description>[F-LIB058] PostalZone element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0</Pattern>
<Description>[F-LIB059] CountrySubentity element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0</Pattern>
<Description>[F-LIB060] CountrySubentityCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB063] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0</Pattern>
<Description>[F-LIB234] AddressLine class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB064] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:TaxTypeCode</Pattern>
<Description>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[F-LIB065] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:Name) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:Name) != ''</Pattern>
<Description>[F-LIB066] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and not(cbc:TaxTypeCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and not(cbc:TaxTypeCode)</Pattern>
<Description>[F-LIB197] TaxTypeCode is mandatory when TaxScheme/ID is different from '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID</Pattern>
<Description>[F-LIB070] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$TaxScheme_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$TaxScheme2_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')</Pattern>
<Description>[F-LIB071] Invalid listID. Must be 'urn:ubl:codelist:taxtypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:Name != 'Moms'</Pattern>
<Description>[F-LIB198] Name must equal 'Moms' when  TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and cbc:Name = 'Moms'</Pattern>
<Description>[F-LIB199] Name must correspond to the value of TaxScheme/ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'</Pattern>
<Description>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:PartyLegalEntity" priority="3988" mode="M22">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:CorporateRegistrationScheme) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:CorporateRegistrationScheme) = 0</Pattern>
<Description>[F-LIB186] CorporateRegistrationScheme class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB187] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB189] Invalid schemeID. Must be a valid scheme for PartyLegalEntity/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB190] schemeID = DK:CVR, CompanyID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)</Pattern>
<Description>[F-LIB191] schemeID = DK:CPR, CompanyID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Contact" priority="3987" mode="M22">

		<!--REPORT kan være tom
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-8] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
-->
		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:Party/cac:Person" priority="3986" mode="M22">

		<!--REPORT -->
<xsl:if test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')</Pattern>
<Description>[F-LIB024] There must be a FirstName if the FamilyName is not present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:DeliveryContact" priority="3985" mode="M22">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-9] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:AccountingContact" priority="3984" mode="M22">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-10] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:ContractorCustomerParty/cac:BuyerContact" priority="3983" mode="M22">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-11] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M22" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M22" />
<xsl:template match="@*|node()" priority="-2" mode="M22">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M22" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M22" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN tradingterms-->


	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:TradingTerms" priority="3999" mode="M23">
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M23" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:TradingTerms/cac:ApplicableAddress" priority="3998" mode="M23">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-10] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M23" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M23" />
<xsl:template match="@*|node()" priority="-2" mode="M23">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M23" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M23" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--PATTERN catalogueline-->


	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine" priority="3999" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:DocumentReference) > 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:DocumentReference) = 0</Pattern>
<Description>[F-CAT114] DocumentReference class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ActionCode != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ActionCode != ''</Pattern>
<Description>[F-CAT101] Invalid ActionCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:OrderableIndicator" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:OrderableIndicator != ''</Pattern>
<Description>[F-CAT106] Invalid OrderableIndicator. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ContentUnitQuantity !=0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ContentUnitQuantity != ''</Pattern>
<Description>[F-CAT108] Invalid ContentUnitQuantity. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT100] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="./cbc:ID = ./following-sibling::*/cbc:ID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>./cbc:ID = ./following-sibling::*/cbc:ID</Pattern>
<Description>[F-CAT248] ID must be unique within the document instance</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(cbc:ActionCode/@listID) or cbc:ActionCode/@listID = $CatAction_listID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ActionCode/@listID = $CatAction_listID</Pattern>
<Description>[F-CAT102] Invalid listID. Must be '<xsl:text />
<xsl:value-of select="$CatAction_listID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(cbc:ActionCode/@listID) or cbc:ActionCode/@listAgencyID = $CatAction_agencyID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ActionCode/@listAgencyID = $CatAction_agencyID</Pattern>
<Description>[F-CAT103] Invalid listAgencyID. Must be '<xsl:text />
<xsl:value-of select="$CatAction_agencyID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="contains($CatAction, concat(',',cbc:ActionCode,','))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>contains($CatAction, concat(',',cbc:ActionCode,','))</Pattern>
<Description>[F-CAT111] Invalid ActionCode: '<xsl:text />
<xsl:value-of select="cbc:ActionCode" />
<xsl:text />'. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:OrderableIndicator and not(cbc:OrderableUnit)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:OrderableIndicator = 'true' and not(cbc:OrderableUnit)</Pattern>
<Description>[F-CAT115] When OrderableIndicator equals 'true' the element OrderableUnit must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:ItemComparison) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:ItemComparison) &gt; 1</Pattern>
<Description>[F-CAT113] No more than one ItemComparison class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cbc:LifeCycleStatusCode" priority="3998" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="./@listID = $LifeCycle_listID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>./@listID = $LifeCycle_listID</Pattern>
<Description>[F-CAT104] Invalid listID. Must be '<xsl:text />
<xsl:value-of select="$LifeCycle_listID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="./@listAgencyID = $LifeCycle_agencyID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>./@listAgencyID = $LifeCycle_agencyID</Pattern>
<Description>[F-CAT105] Invalid listAgencyID. Must be '<xsl:text />
<xsl:value-of select="$LifeCycle_agencyID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="contains($LifeCycle, concat(',',.,','))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>contains($LifeCycle, concat(',',.,','))</Pattern>
<Description>[F-CAT112] Invalid LifeCycleStatusCode: '<xsl:text />
<xsl:value-of select="." />
<xsl:text />'. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cbc:Note" priority="3997" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Note) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Note) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB011] The attribute languageID should be used when more than one <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text /> element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB012] Multilanguage error. Replicated <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text /> elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cbc:OrderableUnit" priority="3996" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="string-length(.) &gt; 1" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>string-length(.) &gt; 1</Pattern>
<Description>[F-CAT107] The value of unitCode attribute should be a valid UOM measure</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cbc:ContentUnitQuantity" priority="3995" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="not(./@unitCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(./@unitCode)</Pattern>
<Description>[F-LIB007] Attribute unitCode must be used for <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />
</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="string-length(./@unitCode)&gt;1" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>string-length(./@unitCode)&gt;1</Pattern>
<Description>[W-LIB008] The value of unitCode attribute should be a valid UOM measure</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cbc:OrderQuantityIncrementNumeric" priority="3994" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cbc:MinimumOrderQuantity" priority="3993" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cbc:MaximumOrderQuantity" priority="3992" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cbc:WarrantyInformation" priority="3991" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:WarrantyInformation) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:WarrantyInformation) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-CAT109] The attribute languageID should be used when more than one WarrantyInformation element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-CAT110] Multilanguage error. Replicated WarrantyInformation elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty" priority="3990" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:Party) = 1" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:Party) = 1</Pattern>
<Description>[F-CAT120] Party class must be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party" priority="3989" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkCareIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkCareIndicator) = 0</Pattern>
<Description>[F-LIB166] MarkCareIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkAttentionIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkAttentionIndicator) = 0</Pattern>
<Description>[F-LIB167] MarkAttentionIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:AgentParty) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:AgentParty) = 0</Pattern>
<Description>[F-LIB168] AgentParty class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')</Pattern>
<Description>[F-LIB022-7] PartyName/Name is mandatory if PartyIdentification/ID is not found</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))</Pattern>
<Description>[F-LIB179] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:EndpointID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$EndpointID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB180] schemeID = DK:CVR, EndpointID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)</Pattern>
<Description>[F-LIB215] schemeID = DK:CPR, EndpointID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB181] schemeID = GLN, EndpointID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB216] schemeID = EAN, EndpointID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:PartyLegalEntity) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PartyLegalEntity) &gt; 1</Pattern>
<Description>[F-CAT121] No more than one PartyLegalEntity class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:PartyIdentification" priority="3988" mode="M24">

		<!--REPORT -->
<xsl:if test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))</Pattern>
<Description>[F-LIB183] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:ID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$PartyID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB184] schemeID = DK:CVR, ID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB217] schemeID = DK:CPR, ID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB185] schemeID = GLN, ID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB218] schemeID = EAN, ID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB287] schemeID = DK:P, ID must be a valid P number (1234567890)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:PartyName" priority="3987" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)</Pattern>
<Description>[W-LIB219] The attribute Name@languageID should be used when more than one PartyName class is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID</Pattern>
<Description>[W-LIB220] Multilanguage error. Replicated PartyName classes with same Name@languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:PostalAddress" priority="3986" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-11] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:PhysicalLocation" priority="3985" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)</Pattern>
<Description>[F-LIB221] If ID not specified, Address is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod" priority="3984" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" priority="3983" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:PhysicalLocation/cac:Address" priority="3982" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-12] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:PartyTaxScheme" priority="3981" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TaxLevelCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TaxLevelCode) = 0</Pattern>
<Description>[F-LIB192] TaxLevelCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB193] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" priority="3980" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:ID) = 0</Pattern>
<Description>[F-LIB041] ID element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0</Pattern>
<Description>[F-LIB042] AddressTypeCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0</Pattern>
<Description>[F-LIB043] Postbox element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Floor) = 0</Pattern>
<Description>[F-LIB044] Floor element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Room) = 0</Pattern>
<Description>[F-LIB045] Room element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0</Pattern>
<Description>[F-LIB046] StreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0</Pattern>
<Description>[F-LIB047] AdditionalStreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0</Pattern>
<Description>[F-LIB048] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0</Pattern>
<Description>[F-LIB049] BuildingName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0</Pattern>
<Description>[F-LIB050] BuildingNumber element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0</Pattern>
<Description>[F-LIB051] InhouseMail element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Department) = 0</Pattern>
<Description>[F-LIB052] Department element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0</Pattern>
<Description>[F-LIB053] MarkAttention element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0</Pattern>
<Description>[F-LIB054] MarkCare element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0</Pattern>
<Description>[F-LIB055] PlotIdentification element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0</Pattern>
<Description>[F-LIB056] CitySubdivisionName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CityName) = 0</Pattern>
<Description>[F-LIB057] CityName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0</Pattern>
<Description>[F-LIB058] PostalZone element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0</Pattern>
<Description>[F-LIB059] CountrySubentity element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0</Pattern>
<Description>[F-LIB060] CountrySubentityCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB063] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0</Pattern>
<Description>[F-LIB234] AddressLine class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB064] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:TaxTypeCode</Pattern>
<Description>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[F-LIB065] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:Name) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:Name) != ''</Pattern>
<Description>[F-LIB066] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and not(cbc:TaxTypeCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and not(cbc:TaxTypeCode)</Pattern>
<Description>[F-LIB197] TaxTypeCode is mandatory when TaxScheme/ID is different from '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID</Pattern>
<Description>[F-LIB070] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$TaxScheme_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$TaxScheme2_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')</Pattern>
<Description>[F-LIB071] Invalid listID. Must be 'urn:ubl:codelist:taxtypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:Name != 'Moms'</Pattern>
<Description>[F-LIB198] Name must equal 'Moms' when  TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and cbc:Name = 'Moms'</Pattern>
<Description>[F-LIB199] Name must correspond to the value of TaxScheme/ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'</Pattern>
<Description>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:PartyLegalEntity" priority="3979" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:CorporateRegistrationScheme) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:CorporateRegistrationScheme) = 0</Pattern>
<Description>[F-LIB186] CorporateRegistrationScheme class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB187] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB189] Invalid schemeID. Must be a valid scheme for PartyLegalEntity/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB190] schemeID = DK:CVR, CompanyID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)</Pattern>
<Description>[F-LIB191] schemeID = DK:CPR, CompanyID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:Contact" priority="3978" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-12] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:Party/cac:Person" priority="3977" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')</Pattern>
<Description>[F-LIB024] There must be a FirstName if the FamilyName is not present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:DeliveryContact" priority="3976" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-13] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:AccountingContact" priority="3975" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-14] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ContractorCustomerParty/cac:BuyerContact" priority="3974" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-15] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty" priority="3973" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DataSendingCapability) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DataSendingCapability) = 0</Pattern>
<Description>[F-CAT130] DataSendingCapability element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:Party) = 1" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:Party) = 1</Pattern>
<Description>[F-CAT131] Party class must be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party" priority="3972" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkCareIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkCareIndicator) = 0</Pattern>
<Description>[F-LIB166] MarkCareIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:MarkAttentionIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:MarkAttentionIndicator) = 0</Pattern>
<Description>[F-LIB167] MarkAttentionIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:AgentParty) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:AgentParty) = 0</Pattern>
<Description>[F-LIB168] AgentParty class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cac:PartyIdentification) or cac:PartyIdentification/cbc:ID = '') and (not(cac:PartyName) or cac:PartyName/cbc:Name = '')</Pattern>
<Description>[F-LIB022-8] PartyName/Name is mandatory if PartyIdentification/ID is not found</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:EndpointID and not(contains($EndpointID_schemeID, concat(',',cbc:EndpointID/@schemeID,',')))</Pattern>
<Description>[F-LIB179] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:EndpointID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$EndpointID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CVR') and (string-length(cbc:EndpointID) != 10 or substring(cbc:EndpointID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB180] schemeID = DK:CVR, EndpointID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'DK:CPR') and not(string-length(cbc:EndpointID) = 10)</Pattern>
<Description>[F-LIB215] schemeID = DK:CPR, EndpointID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'GLN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB181] schemeID = GLN, EndpointID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndpointID/@schemeID = 'EAN') and not(string-length(cbc:EndpointID) = 13)</Pattern>
<Description>[F-LIB216] schemeID = EAN, EndpointID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:PartyLegalEntity) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PartyLegalEntity) &gt; 1</Pattern>
<Description>[F-CAT132] No more than one PartyLegalEntity class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:PartyIdentification" priority="3971" mode="M24">

		<!--REPORT -->
<xsl:if test="not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(contains($PartyID_schemeID, concat(',',cbc:ID/@schemeID,',')))</Pattern>
<Description>[F-LIB183] Invalid schemeID: '<xsl:text />
<xsl:value-of select="cbc:ID/@schemeID" />
<xsl:text />'. Must be a value from the codelist: '<xsl:text />
<xsl:value-of select="$PartyID_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CVR') and (string-length(cbc:ID) != 10 or substring(cbc:ID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB184] schemeID = DK:CVR, ID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:CPR') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB217] schemeID = DK:CPR, ID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'GLN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB185] schemeID = GLN, ID must be a valid GLN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'EAN') and not(string-length(cbc:ID) = 13)</Pattern>
<Description>[F-LIB218] schemeID = EAN, ID must be a valid EAN number (1234567890123)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = 'DK:P') and not(string-length(cbc:ID) = 10)</Pattern>
<Description>[F-LIB287] schemeID = DK:P, ID must be a valid P number (1234567890)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:PartyName" priority="3970" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cac:PartyName) &gt; 1 and not(./cbc:Name/@languageID)</Pattern>
<Description>[W-LIB219] The attribute Name@languageID should be used when more than one PartyName class is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/cbc:Name/@languageID = self::*/cbc:Name/@languageID</Pattern>
<Description>[W-LIB220] Multilanguage error. Replicated PartyName classes with same Name@languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:PostalAddress" priority="3969" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-13] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:PhysicalLocation" priority="3968" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (count(cac:Address) = 0)</Pattern>
<Description>[F-LIB221] If ID not specified, Address is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod" priority="3967" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:PhysicalLocation/cac:ValidityPeriod/cbc:Description" priority="3966" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:PhysicalLocation/cac:Address" priority="3965" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-14] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:PartyTaxScheme" priority="3964" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TaxLevelCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TaxLevelCode) = 0</Pattern>
<Description>[F-LIB192] TaxLevelCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB193] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ' " />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:SE' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB195] Invalid schemeID. Must be a valid scheme for PartyTaxScheme/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:SE') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB196] schemeID = DK:SE, CompanyID must be a valid SE number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme" priority="3963" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:ID) = 0</Pattern>
<Description>[F-LIB041] ID element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0</Pattern>
<Description>[F-LIB042] AddressTypeCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0</Pattern>
<Description>[F-LIB043] Postbox element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Floor) = 0</Pattern>
<Description>[F-LIB044] Floor element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Room) = 0</Pattern>
<Description>[F-LIB045] Room element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0</Pattern>
<Description>[F-LIB046] StreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0</Pattern>
<Description>[F-LIB047] AdditionalStreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0</Pattern>
<Description>[F-LIB048] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0</Pattern>
<Description>[F-LIB049] BuildingName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0</Pattern>
<Description>[F-LIB050] BuildingNumber element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0</Pattern>
<Description>[F-LIB051] InhouseMail element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Department) = 0</Pattern>
<Description>[F-LIB052] Department element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0</Pattern>
<Description>[F-LIB053] MarkAttention element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0</Pattern>
<Description>[F-LIB054] MarkCare element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0</Pattern>
<Description>[F-LIB055] PlotIdentification element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0</Pattern>
<Description>[F-LIB056] CitySubdivisionName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CityName) = 0</Pattern>
<Description>[F-LIB057] CityName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0</Pattern>
<Description>[F-LIB058] PostalZone element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0</Pattern>
<Description>[F-LIB059] CountrySubentity element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0</Pattern>
<Description>[F-LIB060] CountrySubentityCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB063] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0</Pattern>
<Description>[F-LIB234] AddressLine class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB064] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:TaxTypeCode</Pattern>
<Description>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[F-LIB065] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:Name) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:Name) != ''</Pattern>
<Description>[F-LIB066] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and not(cbc:TaxTypeCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and not(cbc:TaxTypeCode)</Pattern>
<Description>[F-LIB197] TaxTypeCode is mandatory when TaxScheme/ID is different from '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID</Pattern>
<Description>[F-LIB070] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$TaxScheme_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$TaxScheme2_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')</Pattern>
<Description>[F-LIB071] Invalid listID. Must be 'urn:ubl:codelist:taxtypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:Name != 'Moms'</Pattern>
<Description>[F-LIB198] Name must equal 'Moms' when  TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and cbc:Name = 'Moms'</Pattern>
<Description>[F-LIB199] Name must correspond to the value of TaxScheme/ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'</Pattern>
<Description>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:PartyLegalEntity" priority="3962" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:CorporateRegistrationScheme) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:CorporateRegistrationScheme) = 0</Pattern>
<Description>[F-LIB186] CorporateRegistrationScheme class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:CompanyID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:CompanyID) != ''</Pattern>
<Description>[F-LIB187] Invalid CompanyID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:CompanyID/@schemeID = 'DK:CVR' or cbc:CompanyID/@schemeID = 'DK:CPR' or cbc:CompanyID/@schemeID = 'ZZZ'</Pattern>
<Description>[F-LIB189] Invalid schemeID. Must be a valid scheme for PartyLegalEntity/CompanyID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CVR') and (string-length(normalize-space(cbc:CompanyID)) != 10 or substring(cbc:CompanyID, 1, 2) != 'DK')</Pattern>
<Description>[F-LIB190] schemeID = DK:CVR, CompanyID must be a valid CVR number (DK12345678)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:CompanyID/@schemeID = 'DK:CPR') and not(string-length(cbc:CompanyID) = 10)</Pattern>
<Description>[F-LIB191] schemeID = DK:CPR, CompanyID must be a valid CPR number (1234560000)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:Contact" priority="3961" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-16] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:Party/cac:Person" priority="3960" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:FamilyName) or cbc:FamilyName = '') and (not(cbc:FirstName) or cbc:FirstName = '')</Pattern>
<Description>[F-LIB024] There must be a FirstName if the FamilyName is not present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:DespatchContact" priority="3959" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-17] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:AccountingContact" priority="3958" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-18] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:SellerSupplierParty/cac:SellerContact" priority="3957" mode="M24">

		<!--REPORT -->
<xsl:if test="(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(not(cbc:ID) or cbc:ID = '') and (not(cbc:Name) or cbc:Name = '') and (not(cbc:Telephone) or cbc:Telephone = '') and (not(cbc:Telefax) or cbc:Telefax = '') and (not(cbc:ElectronicMail) or cbc:ElectronicMail = '') and (not(cbc:Note) or cbc:Note = '') and not(cac:OtherCommunication)</Pattern>
<Description>[F-LIB235-19] At least one field should be specified</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication/cbc:ChannelCode and cac:OtherCommunication/cbc:Channel</Pattern>
<Description>[F-LIB236] Use either ChannelCode or Channel</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:OtherCommunication and not(normalize-space(cac:OtherCommunication/cbc:Value) != '')</Pattern>
<Description>[F-LIB237] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:WarrantyValidityPeriod" priority="3956" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:WarrantyValidityPeriod/cbc:Description" priority="3955" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:LineValidityPeriod" priority="3954" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:LineValidityPeriod/cbc:Description" priority="3953" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ItemComparison" priority="3952" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:PriceAmount != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:PriceAmount != ''</Pattern>
<Description>[F-CAT140] Invalid PriceAmount. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:Quantity != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Quantity != ''</Pattern>
<Description>[F-CAT141] Invalid Quantity. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ComponentRelatedItem" priority="3951" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT150] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ComponentRelatedItem/cbc:Description" priority="3950" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:AccessoryRelatedItem" priority="3949" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT160] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:AccessoryRelatedItem/cbc:Description" priority="3948" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredRelatedItem" priority="3947" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[Warning-CAT170] No ID. Schould contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredRelatedItem/cbc:Description" priority="3946" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ReplacementRelatedItem" priority="3945" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT180] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ReplacementRelatedItem/cbc:Description" priority="3944" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ComplementaryRelatedItem" priority="3943" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT190] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:ComplementaryRelatedItem/cbc:Description" priority="3942" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity" priority="3941" mode="M24">

		<!--REPORT -->
<xsl:if test="count(cbc:TradingRestrictions) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TradingRestrictions) &gt; 1</Pattern>
<Description>[F-CAT200] No more than one TradingRestrictions element may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cbc:MinimumQuantity" priority="3940" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cbc:MaximumQuantity" priority="3939" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTerritoryAddress" priority="3938" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(cbc:AddressFormatCode/@listID) or cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-15] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price" priority="3937" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:PriceAmount != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:PriceAmount != ''</Pattern>
<Description>[F-CAT201] Invalid PriceAmount. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="count(cac:ValidityPeriod) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:ValidityPeriod) &gt; 1</Pattern>
<Description>[F-CAT207] No more than one ValidityPeriod class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:PriceAmount" priority="3936" mode="M24">

		<!--REPORT -->
<xsl:if test="string-length(substring-after(., '.')) &lt; 2">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>string-length(substring-after(., '.')) &lt; 2</Pattern>
<Description>[F-CAT202] Invalid PriceAmount. Must have at least 2 decimals</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-'))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-'))</Pattern>
<Description>[F-CAT203] Invalid PriceAmount. Must not be negative</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:BaseQuantity" priority="3935" mode="M24">

		<!--REPORT -->
<xsl:if test="not(./@unitCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(./@unitCode)</Pattern>
<Description>[F-LIB007] Attribute unitCode must be used for <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />
</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="string-length(./@unitCode)&gt;1" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>string-length(./@unitCode)&gt;1</Pattern>
<Description>[W-LIB008] The value of unitCode attribute should be a valid UOM measure</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:PriceChangeReason" priority="3934" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:PriceChangeReason) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:PriceChangeReason) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-CAT204] The attribute languageID should be used when more than one PriceChangeReason element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-CAT205] Multilanguage error. Replicated PriceChangeReason elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:PriceTypeCode" priority="3933" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="./@listID = 'UN/ECE 5387'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>./@listID = 'UN/ECE 5387'</Pattern>
<Description>[F-CAT206] Invalid listID. Must be 'UN/ECE 5387'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cbc:OrderableUnitFactorRate" priority="3932" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod" priority="3931" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:ValidityPeriod/cbc:Description" priority="3930" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:PriceList" priority="3929" mode="M24">
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:PriceList/cac:ValidityPeriod" priority="3928" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:PriceList/cac:ValidityPeriod/cbc:Description" priority="3927" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:PriceList/cac:PreviousPriceList" priority="3926" mode="M24">
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:PriceList/cac:PreviousPriceList/cac:ValidityPeriod" priority="3925" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:PriceList/cac:PreviousPriceList/cac:ValidityPeriod/cbc:Description" priority="3924" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:AllowanceCharge" priority="3923" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:TaxTotal) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:TaxTotal) = 0</Pattern>
<Description>[F-LIB224] TaxTotal class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:PaymentMeans) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PaymentMeans) = 0</Pattern>
<Description>[F-LIB225] PaymentMeans class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:TaxCategory) = 1" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:TaxCategory) = 1</Pattern>
<Description>[F-LIB226] One TaxCategory class must be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:MultiplierFactorNumeric and not(cbc:BaseAmount != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:MultiplierFactorNumeric and not(cbc:BaseAmount != '')</Pattern>
<Description>[F-LIB248] When MultiplierFactorNumeric is used, BaseAmount is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="starts-with(cbc:MultiplierFactorNumeric,'-')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>starts-with(cbc:MultiplierFactorNumeric,'-')</Pattern>
<Description>[F-LIB227] MultiplierFactorNumeric must be a positive number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:MultiplierFactorNumeric and ((cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) &lt; '-1.00') or (cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) &gt; '1.00'))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:MultiplierFactorNumeric and ((cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) &lt; '-1.00') or (cbc:Amount - (cbc:BaseAmount * cbc:MultiplierFactorNumeric) &gt; '1.00'))</Pattern>
<Description>[F-LIB228] Amount must equal BaseAmount * MultiplierFactorNumeric</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AccountingCost and cbc:AccountingCostCode">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AccountingCost and cbc:AccountingCostCode</Pattern>
<Description>[F-LIB021] Use either AccountingCost or AccountingCostCode</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric" priority="3922" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-'))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-'))</Pattern>
<Description>[F-LIB020] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:AllowanceCharge/cbc:Amount" priority="3921" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:AllowanceCharge/cbc:BaseAmount" priority="3920" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:AllowanceCharge/cac:TaxCategory" priority="3919" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TierRange) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TierRange) = 0</Pattern>
<Description>[F-LIB072] TierRange element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TierRatePercent) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TierRatePercent) = 0</Pattern>
<Description>[F-LIB073] TierRatePercent element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[F-LIB074] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID</Pattern>
<Description>[F-LIB075] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$TaxCategory1_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$TaxCategory2_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeAgencyID = $TaxCategory2_agencyID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeAgencyID = $TaxCategory2_agencyID</Pattern>
<Description>[W-LIB229] Invalid schemeAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID) and not (contains($TaxCategory2, concat(',',cbc:ID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID) and not (contains($TaxCategory2, concat(',',cbc:ID,',')))</Pattern>
<Description>[F-LIB309] Invalid ID: '<xsl:text />
<xsl:value-of select="cbc:ID" />
<xsl:text />'. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:Name != '') and not(contains(/doc:Invoice/cbc:ProfileID, 'nesubl.eu'))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:Name != '') and not(contains(/doc:Invoice/cbc:ProfileID, 'nesubl.eu'))</Pattern>
<Description>[W-LIB230] Name should only be used within NES profiles</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PerUnitAmount and cbc:Percent">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:PerUnitAmount and cbc:Percent</Pattern>
<Description>[F-LIB231] Use either PerUnitAmount or Percent</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PerUnitAmount and not(cbc:BaseUnitMeasure != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:PerUnitAmount and not(cbc:BaseUnitMeasure != '')</Pattern>
<Description>[F-LIB232] When PerUnitAmount is used, BaseUnitMeasure is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme" priority="3918" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:ID) = 0</Pattern>
<Description>[F-LIB041] ID element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0</Pattern>
<Description>[F-LIB042] AddressTypeCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0</Pattern>
<Description>[F-LIB043] Postbox element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Floor) = 0</Pattern>
<Description>[F-LIB044] Floor element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Room) = 0</Pattern>
<Description>[F-LIB045] Room element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0</Pattern>
<Description>[F-LIB046] StreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0</Pattern>
<Description>[F-LIB047] AdditionalStreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0</Pattern>
<Description>[F-LIB048] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0</Pattern>
<Description>[F-LIB049] BuildingName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0</Pattern>
<Description>[F-LIB050] BuildingNumber element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0</Pattern>
<Description>[F-LIB051] InhouseMail element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Department) = 0</Pattern>
<Description>[F-LIB052] Department element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0</Pattern>
<Description>[F-LIB053] MarkAttention element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0</Pattern>
<Description>[F-LIB054] MarkCare element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0</Pattern>
<Description>[F-LIB055] PlotIdentification element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0</Pattern>
<Description>[F-LIB056] CitySubdivisionName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CityName) = 0</Pattern>
<Description>[F-LIB057] CityName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0</Pattern>
<Description>[F-LIB058] PostalZone element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0</Pattern>
<Description>[F-LIB059] CountrySubentity element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0</Pattern>
<Description>[F-LIB060] CountrySubentityCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB063] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0</Pattern>
<Description>[F-LIB234] AddressLine class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB064] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:TaxTypeCode</Pattern>
<Description>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[F-LIB065] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:Name) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:Name) != ''</Pattern>
<Description>[F-LIB066] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and not(cbc:TaxTypeCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and not(cbc:TaxTypeCode)</Pattern>
<Description>[F-LIB197] TaxTypeCode is mandatory when TaxScheme/ID is different from '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID</Pattern>
<Description>[F-LIB070] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$TaxScheme_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$TaxScheme2_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')</Pattern>
<Description>[F-LIB071] Invalid listID. Must be 'urn:ubl:codelist:taxtypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:Name != 'Moms'</Pattern>
<Description>[F-LIB198] Name must equal 'Moms' when  TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and cbc:Name = 'Moms'</Pattern>
<Description>[F-LIB199] Name must correspond to the value of TaxScheme/ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'</Pattern>
<Description>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:DeliveryUnit" priority="3917" mode="M24">
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:DeliveryUnit/cbc:BatchQuantity" priority="3916" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:DeliveryUnit/cbc:ConsumerUnitQuantity" priority="3915" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTaxCategory" priority="3914" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TierRange) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TierRange) = 0</Pattern>
<Description>[F-LIB072] TierRange element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TierRatePercent) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TierRatePercent) = 0</Pattern>
<Description>[F-LIB073] TierRatePercent element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[F-LIB074] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID</Pattern>
<Description>[F-LIB075] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$TaxCategory1_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$TaxCategory2_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeAgencyID = $TaxCategory2_agencyID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeAgencyID = $TaxCategory2_agencyID</Pattern>
<Description>[W-LIB229] Invalid schemeAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID) and not (contains($TaxCategory2, concat(',',cbc:ID,',')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID/@schemeID = $TaxCategory1_schemeID or cbc:ID/@schemeID = $TaxCategory2_schemeID) and not (contains($TaxCategory2, concat(',',cbc:ID,',')))</Pattern>
<Description>[F-LIB309] Invalid ID: '<xsl:text />
<xsl:value-of select="cbc:ID" />
<xsl:text />'. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:Name != '') and not(contains(/doc:Invoice/cbc:ProfileID, 'nesubl.eu'))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:Name != '') and not(contains(/doc:Invoice/cbc:ProfileID, 'nesubl.eu'))</Pattern>
<Description>[W-LIB230] Name should only be used within NES profiles</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PerUnitAmount and cbc:Percent">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:PerUnitAmount and cbc:Percent</Pattern>
<Description>[F-LIB231] Use either PerUnitAmount or Percent</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:PerUnitAmount and not(cbc:BaseUnitMeasure != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:PerUnitAmount and not(cbc:BaseUnitMeasure != '')</Pattern>
<Description>[F-LIB232] When PerUnitAmount is used, BaseUnitMeasure is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:RequiredItemLocationQuantity/cac:ApplicableTaxCategory/cac:TaxScheme" priority="3913" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:ID) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:ID) = 0</Pattern>
<Description>[F-LIB041] ID element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AddressTypeCode) = 0</Pattern>
<Description>[F-LIB042] AddressTypeCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Postbox) = 0</Pattern>
<Description>[F-LIB043] Postbox element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Floor) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Floor) = 0</Pattern>
<Description>[F-LIB044] Floor element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Room) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Room) = 0</Pattern>
<Description>[F-LIB045] Room element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:StreetName) = 0</Pattern>
<Description>[F-LIB046] StreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:AdditionalStreetName) = 0</Pattern>
<Description>[F-LIB047] AdditionalStreetName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BlockName) = 0</Pattern>
<Description>[F-LIB048] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingName) = 0</Pattern>
<Description>[F-LIB049] BuildingName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:BuildingNumber) = 0</Pattern>
<Description>[F-LIB050] BuildingNumber element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:InhouseMail) = 0</Pattern>
<Description>[F-LIB051] InhouseMail element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:Department) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:Department) = 0</Pattern>
<Description>[F-LIB052] Department element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkAttention) = 0</Pattern>
<Description>[F-LIB053] MarkAttention element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:MarkCare) = 0</Pattern>
<Description>[F-LIB054] MarkCare element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PlotIdentification) = 0</Pattern>
<Description>[F-LIB055] PlotIdentification element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CitySubdivisionName) = 0</Pattern>
<Description>[F-LIB056] CitySubdivisionName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CityName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CityName) = 0</Pattern>
<Description>[F-LIB057] CityName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:PostalZone) = 0</Pattern>
<Description>[F-LIB058] PostalZone element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentity) = 0</Pattern>
<Description>[F-LIB059] CountrySubentity element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:CountrySubentityCode) = 0</Pattern>
<Description>[F-LIB060] CountrySubentityCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB063] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:AddressLine) = 0</Pattern>
<Description>[F-LIB234] AddressLine class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:JurisdictionRegionAddress/cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB064] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:TaxTypeCode">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:TaxTypeCode</Pattern>
<Description>[F-LIB067] TaxTypeCode is not allowed when TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[F-LIB065] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:Name) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:Name) != ''</Pattern>
<Description>[F-LIB066] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and not(cbc:TaxTypeCode)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and not(cbc:TaxTypeCode)</Pattern>
<Description>[F-LIB197] TaxTypeCode is mandatory when TaxScheme/ID is different from '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID/@schemeID = $TaxScheme_schemeID or cbc:ID/@schemeID = $TaxScheme2_schemeID</Pattern>
<Description>[F-LIB070] Invalid schemeID. Must be '<xsl:text />
<xsl:value-of select="$TaxScheme_schemeID" />
<xsl:text />' or '<xsl:text />
<xsl:value-of select="$TaxScheme2_schemeID" />
<xsl:text />'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:TaxTypeCode) and not(cbc:TaxTypeCode/@listID = 'urn:ubl:codelist:taxtypecode-1.1')</Pattern>
<Description>[F-LIB071] Invalid listID. Must be 'urn:ubl:codelist:taxtypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID = '63') and cbc:Name != 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID = '63') and cbc:Name != 'Moms'</Pattern>
<Description>[F-LIB198] Name must equal 'Moms' when  TaxScheme/ID equals '63' (Moms)</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:ID != '63') and cbc:Name = 'Moms'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:ID != '63') and cbc:Name = 'Moms'</Pattern>
<Description>[F-LIB199] Name must correspond to the value of TaxScheme/ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cac:JurisdictionRegionAddress) and cac:JurisdictionRegionAddress/cbc:AddressFormatCode != 'StructuredRegion'</Pattern>
<Description>[F-LIB233] The AddressFormatCode under JurisdictionRegionAddress must always equal 'StructuredRegion'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item" priority="3912" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:CatalogueIndicator) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:CatalogueIndicator) = 0</Pattern>
<Description>[F-CAT220] CatalogueIndicator element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:OriginCountry) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:OriginCountry) = 0</Pattern>
<Description>[F-CAT241] OriginCountry class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:ClassifiedTaxCategory) > 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:ClassifiedTaxCategory) = 0</Pattern>
<Description>[F-CAT234] ClassifiedTaxCategory class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:Name != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Name != ''</Pattern>
<Description>[F-CAT221] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:SellersItemIdentification) = 1" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:SellersItemIdentification) = 1</Pattern>
<Description>[F-CAT223] One SellersItemIdentification class must be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:CommodityClassification) &gt; 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:CommodityClassification) &gt; 0</Pattern>
<Description>[F-CAT230] At least one CommodityClassification class must be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="string-length(cbc:Name) &gt; 40">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>string-length(cbc:Name) &gt; 40</Pattern>
<Description>[W-CAT222] Invalid Name. Should not exceed 40 characters</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:ManufacturersItemIdentification) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:ManufacturersItemIdentification) &gt; 1</Pattern>
<Description>[F-CAT228] No more than one ManufacturersItemIdentification class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:AdditionalItemIdentification) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:AdditionalItemIdentification) &gt; 1</Pattern>
<Description>[F-CAT229] No more than one AdditionalItemIdentification class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="count(cac:OriginAddress) &gt; 1">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:OriginAddress) &gt; 1</Pattern>
<Description>[F-CAT244] No more than one OriginAddress class may be present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cbc:Description" priority="3911" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cbc:PackQuantity" priority="3910" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cbc:PackSizeNumeric" priority="3909" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(starts-with(.,'-')) and . != 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(starts-with(.,'-')) and . != 0</Pattern>
<Description>[F-LIB019] Invalid <xsl:text />
<xsl:value-of select="name(.)" />
<xsl:text />. Must not be negative or zero</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:BuyersItemIdentification" priority="3908" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:PhysicalAttribute) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PhysicalAttribute) = 0</Pattern>
<Description>[F-LIB175] PhysicalAttribute class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:MeasurementDimension) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:MeasurementDimension) = 0</Pattern>
<Description>[F-LIB176] MeasurementDimension class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[Warning-LIB177] No ID. Should contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:SellersItemIdentification" priority="3907" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT224] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:SellersItemIdentification/cac:PhysicalAttribute" priority="3906" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:PositionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:PositionCode) = 0</Pattern>
<Description>[F-CAT242] PositionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-CAT243] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:Description != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Description != ''</Pattern>
<Description>[F-CAT226] Invalid Description. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AttributeID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AttributeID != ''</Pattern>
<Description>[F-CAT225] Invalid AttributeID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:SellersItemIdentification/cac:PhysicalAttribute/cbc:Description" priority="3905" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:SellersItemIdentification/cac:MeasurementDimension" priority="3904" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AttributeID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AttributeID != ''</Pattern>
<Description>[F-CAT227] Invalid AttributeID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:SellersItemIdentification/cac:MeasurementDimension/cbc:Description" priority="3903" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturersItemIdentification" priority="3902" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:PhysicalAttribute) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PhysicalAttribute) = 0</Pattern>
<Description>[F-LIB175] PhysicalAttribute class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:MeasurementDimension) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:MeasurementDimension) = 0</Pattern>
<Description>[F-LIB176] MeasurementDimension class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[Warning-LIB177] No ID. Should contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:StandardItemIdentification" priority="3901" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:PhysicalAttribute) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PhysicalAttribute) = 0</Pattern>
<Description>[F-LIB175] PhysicalAttribute class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:MeasurementDimension) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:MeasurementDimension) = 0</Pattern>
<Description>[F-LIB176] MeasurementDimension class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[Warning-LIB177] No ID. Should contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:CatalogueItemIdentification" priority="3900" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:PhysicalAttribute) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PhysicalAttribute) = 0</Pattern>
<Description>[F-LIB175] PhysicalAttribute class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:MeasurementDimension) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:MeasurementDimension) = 0</Pattern>
<Description>[F-LIB176] MeasurementDimension class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[Warning-LIB177] No ID. Should contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemIdentification" priority="3899" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:PhysicalAttribute) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:PhysicalAttribute) = 0</Pattern>
<Description>[F-LIB175] PhysicalAttribute class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:MeasurementDimension) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:MeasurementDimension) = 0</Pattern>
<Description>[F-LIB176] MeasurementDimension class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="normalize-space(cbc:ID) != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>normalize-space(cbc:ID) != ''</Pattern>
<Description>[Warning-LIB177] No ID. Should contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:CatalogueDocumentReference" priority="3898" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DocumentType) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DocumentType) = 0</Pattern>
<Description>[F-LIB170] DocumentType element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DocumentTypeCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DocumentTypeCode) = 0</Pattern>
<Description>[F-LIB172] DocumentTypeCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment and cbc:XPath</Pattern>
<Description>[F-LIB169] Use either Attachment or XPath</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference</Pattern>
<Description>[F-LIB171] Use either EmbeddedDocumentBinaryObject or ExternalReference</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:UUID and not(string-length(string(cbc:UUID)) = 36)</Pattern>
<Description>[F-LIB173] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')</Pattern>
<Description>[F-LIB174] Attribute mimeCode must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')</Pattern>
<Description>[F-LIB096] When using ExternalReference, URI is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemSpecificationDocumentReference" priority="3897" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:DocumentType or cbc:DocumentTypeCode" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:DocumentType or cbc:DocumentTypeCode</Pattern>
<Description>[F-LIB092] Use either DocumentType or DocumentTypeCode</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment and cbc:XPath</Pattern>
<Description>[F-LIB093] Use either Attachment or XPath</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:DocumentType and cbc:DocumentTypeCode != 'ZZZ'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:DocumentType and cbc:DocumentTypeCode != 'ZZZ'</Pattern>
<Description>[F-LIB094] Use either DocumentType or DocumentTypeCode</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference</Pattern>
<Description>[F-LIB095] Use either EmbeddedDocumentBinaryObject or ExternalReference</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:UUID and not(string-length(string(cbc:UUID)) = 36)</Pattern>
<Description>[F-LIB097] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')</Pattern>
<Description>[F-LIB098] Attribute mimeCode must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')</Pattern>
<Description>[F-LIB279] When using ExternalReference, URI is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:CommodityClassification" priority="3896" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ItemClassificationCode != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ItemClassificationCode != ''</Pattern>
<Description>[F-CAT231] Invalid ItemClassificationCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ItemClassificationCode/@listID = 'UNSPSC'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ItemClassificationCode/@listID = 'UNSPSC'</Pattern>
<Description>[F-CAT232] Invalid listID. Must be 'UNSPSC'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(cbc:ItemClassificationCode/@listAgencyID) or cbc:ItemClassificationCode/@listAgencyID = '113'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ItemClassificationCode/@listAgencyID = '113'</Pattern>
<Description>[F-CAT233] Invalid listAgencyID. Must be '113'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:TransactionConditions" priority="3895" mode="M24">
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:TransactionConditions/cbc:Description" priority="3894" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:TransactionConditions/cac:DocumentReference" priority="3893" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:DocumentType or cbc:DocumentTypeCode" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:DocumentType or cbc:DocumentTypeCode</Pattern>
<Description>[F-LIB092] Use either DocumentType or DocumentTypeCode</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cac:Attachment and cbc:XPath">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment and cbc:XPath</Pattern>
<Description>[F-LIB093] Use either Attachment or XPath</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:DocumentType and cbc:DocumentTypeCode != 'ZZZ'">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:DocumentType and cbc:DocumentTypeCode != 'ZZZ'</Pattern>
<Description>[F-LIB094] Use either DocumentType or DocumentTypeCode</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cbc:EmbeddedDocumentBinaryObject and cac:Attachment/cac:ExternalReference</Pattern>
<Description>[F-LIB095] Use either EmbeddedDocumentBinaryObject or ExternalReference</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:UUID and not(string-length(string(cbc:UUID)) = 36)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:UUID and not(string-length(string(cbc:UUID)) = 36)</Pattern>
<Description>[F-LIB097] Invalid UUID. Must be of this form '6E09886B-DC6E-439F-82D1-7CCAC7F4E3B1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cbc:EmbeddedDocumentBinaryObject and not(cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/tiff' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/png' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/jpeg' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='image/gif' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='application/pdf' or cac:Attachment/cbc:EmbeddedDocumentBinaryObject/@mimeCode='text/xml')</Pattern>
<Description>[F-LIB098] Attribute mimeCode must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Attachment/cac:ExternalReference and not(cac:Attachment/cac:ExternalReference/cbc:URI != '')</Pattern>
<Description>[F-LIB279] When using ExternalReference, URI is mandatory</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:HazardousItem" priority="3892" mode="M24">
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty" priority="3891" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:Name != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Name != ''</Pattern>
<Description>[Warning-CAT235] No name. Schould contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:Value != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Value != ''</Pattern>
<Description>[Warning-CAT236] No value. Schould contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cac:UsabilityPeriod" priority="3890" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:AdditionalItemProperty/cac:ItemPropertyGroup" priority="3889" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT237] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ManufacturerParty" priority="3888" mode="M24">
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:InformationContentProviderParty" priority="3887" mode="M24">
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:OriginAddress" priority="3886" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:BlockName) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:BlockName) = 0</Pattern>
<Description>[F-LIB210] BlockName element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:TimezoneOffset) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:TimezoneOffset) = 0</Pattern>
<Description>[F-LIB211] TimezoneOffset element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cac:LocationCoordinate) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cac:LocationCoordinate) = 0</Pattern>
<Description>[F-LIB212] LocationCoordinate class must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(normalize-space(cbc:AddressFormatCode))" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>not(normalize-space(cbc:AddressFormatCode))</Pattern>
<Description>[F-LIB025] Invalid AddressFormatCode. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listID = 'urn:ubl:codelist:addresstypecode-1.1')</Pattern>
<Description>[F-LIB204] Invalid listID. Must be 'urn:ubl:codelist:addresstypecode-1.1'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB205] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressTypeCode and not(cbc:AddressTypeCode = 'Home' or cbc:AddressTypeCode = 'Business' )</Pattern>
<Description>[F-LIB206] Invalid AddressTypeCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' or cbc:AddressFormatCode/@listID = 'UN/ECE 3477'</Pattern>
<Description>[F-LIB026-16] Invalid listID. Must be either 'urn:ubl:codelist:addressformatcode-1.1' or 'UN/ECE 3477'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode/@listAgencyID = '320')</Pattern>
<Description>[F-LIB207] Invalid listAgencyID. Must be '320'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'urn:ubl:codelist:addressformatcode-1.1' and not(cbc:AddressFormatCode = 'StructuredDK' or cbc:AddressFormatCode = 'StructuredLax' or cbc:AddressFormatCode = 'StructuredID' or cbc:AddressFormatCode = 'StructuredRegion' or cbc:AddressFormatCode = 'Unstructured')</Pattern>
<Description>[F-LIB027] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode/@listAgencyID = '6')</Pattern>
<Description>[F-LIB208] Invalid listAgencyID. Must be '6'</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:AddressFormatCode/@listID = 'UN/ECE 3477' and not(cbc:AddressFormatCode = '1' or cbc:AddressFormatCode = '2' or cbc:AddressFormatCode = '3' or cbc:AddressFormatCode = '4' or cbc:AddressFormatCode = '5' or cbc:AddressFormatCode = '6' or cbc:AddressFormatCode = '7' or cbc:AddressFormatCode = '8' or cbc:AddressFormatCode = '9')</Pattern>
<Description>[F-LIB209] Invalid AddressFormatCode. Must be a value from the codelist</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cac:Country and not(cac:Country/cbc:IdentificationCode != '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cac:Country and not(cac:Country/cbc:IdentificationCode != '')</Pattern>
<Description>[F-LIB213] When Country is used the element Country/IdentificationCode must be filled out</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'Unstructured') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB031] An Unstructured address is only allowed to have AddressLine elements</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and cac:AddressLine</Pattern>
<Description>[F-LIB032] AddressLine elements not allowed for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and (not(cbc:PostalZone) or normalize-space(cbc:PostalZone) = '')</Pattern>
<Description>[F-LIB033] PostalZone is mandatory for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:StreetName) or normalize-space(cbc:StreetName) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB034] There should be either a StreetName or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredDK') and ((not(cbc:BuildingNumber) or normalize-space(cbc:BuildingNumber) = '') and (not(cbc:Postbox) or normalize-space(cbc:Postbox) = ''))</Pattern>
<Description>[F-LIB035] There should be either a BuildingNumber or a Postbox for a StructuredDK address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredLax') and cac:AddressLine</Pattern>
<Description>[F-LIB036] AddressLine elements not allowed for a StructuredLax address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (not(cbc:ID) or cbc:ID = '')</Pattern>
<Description>[F-LIB037] ID is required for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredID') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0' or count(cac:Country) != '0')</Pattern>
<Description>[F-LIB038] Only the ID is used for a StructuredID address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and ((not(cac:Country/cbc:IdentificationCode) or cac:Country/cbc:IdentificationCode = '') and (not(cbc:Region) or cbc:Region = '') and (not(cbc:District) or cbc:District = ''))</Pattern>
<Description>[F-LIB039] Region or District or Country/IdentificationCode is required for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:AddressFormatCode = 'StructuredRegion') and (count(cbc:StreetName) != '0' or count(cbc:BuildingNumber) != '0' or count(cbc:CityName) != '0' or count(cbc:PostalZone) != '0')</Pattern>
<Description>[F-LIB040] Only Region, District, and/or Country/IdentificationCode can be used for a StructuredRegion address type</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(string-length(cbc:ID/@schemeID)&gt;0)</Pattern>
<Description>[F-LIB028] When ID is used under Address the attribute schemeID is used to give an addressregister</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:ID and not(cbc:ID/@schemeID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID and not(cbc:ID/@schemeID)</Pattern>
<Description>[F-LIB029] schemeID attribute must be present on an address ID</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Postbox and not(number(cbc:Postbox)=((cbc:Postbox + 1)-1))</Pattern>
<Description>[F-LIB030] The value of Postbox must always be a number</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance" priority="3885" mode="M24">
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:AdditionalItemProperty" priority="3884" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:Name != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Name != ''</Pattern>
<Description>[F-CAT245] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:Value != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Value != ''</Pattern>
<Description>[F-CAT246] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:AdditionalItemProperty/cac:UsabilityPeriod" priority="3883" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:AdditionalItemProperty/cac:UsabilityPeriod/cbc:Description" priority="3882" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:AdditionalItemProperty/cac:ItemPropertyGroup" priority="3881" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT247] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:LotIdentification" priority="3880" mode="M24">
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cac:AdditionalItemProperty" priority="3879" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:Name != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Name != ''</Pattern>
<Description>[F-CAT238] Invalid Name. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:Value != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:Value != ''</Pattern>
<Description>[F-CAT239] Invalid Value. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cac:AdditionalItemProperty/cac:UsabilityPeriod" priority="3878" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DurationMeasure) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DurationMeasure) = 0</Pattern>
<Description>[F-LIB076] DurationMeasure element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(cbc:DescriptionCode) = 0" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(cbc:DescriptionCode) = 0</Pattern>
<Description>[F-LIB077] DescriptionCode element must be excluded</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime) and (not(cbc:StartDate) or cbc:StartDate = '')</Pattern>
<Description>[F-LIB078] There must be a StartDate if you have a StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:EndTime) and (not(cbc:EndDate) or cbc:EndDate = '')</Pattern>
<Description>[F-LIB079] There must be a EndDate if you have a EndTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartDate and cbc:EndDate) and not(number(translate(cbc:EndDate,'-','')) &gt; number(translate(cbc:StartDate,'-','')) or number(translate(cbc:EndDate,'-','')) = number(translate(cbc:StartDate,'-','')))</Pattern>
<Description>[F-LIB080] The EndDate must be greater or equal to the startdate</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>(cbc:StartTime and cbc:EndTime) and not(number(translate(cbc:EndTime,':','')) &gt; number(translate(cbc:StartTime,':','')) or number(translate(cbc:EndTime,':','')) = number(translate(cbc:StartTime,':','')))</Pattern>
<Description>[F-LIB081] EndTime must be greater or equal to StartTime</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cac:AdditionalItemProperty/cac:UsabilityPeriod/cbc:Description" priority="3877" mode="M24">

		<!--REPORT -->
<xsl:if test="count(../cbc:Description) &gt; 1 and not(./@languageID)">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>count(../cbc:Description) &gt; 1 and not(./@languageID)</Pattern>
<Description>[W-LIB222] The attribute languageID should be used when more than one Description element is present</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>

		<!--REPORT -->
<xsl:if test="local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID">
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>local-name(following-sibling::*) = local-name(current()) and following-sibling::*/@languageID = self::*/@languageID</Pattern>
<Description>[W-LIB223] Multilanguage error. Replicated Description elements with same languageID attribute value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:if>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>

	<!--RULE -->
<xsl:template match="doc:Catalogue/cac:CatalogueLine/cac:Item/cac:ItemInstance/cac:LotIdentification/cac:AdditionalItemProperty/cac:ItemPropertyGroup" priority="3876" mode="M24">

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="cbc:ID != ''" />
<xsl:otherwise>
<Error>
<xsl:attribute name="context"><xsl:value-of select="concat(name(parent::*),'/',name())" /></xsl:attribute>
<Pattern>cbc:ID != ''</Pattern>
<Description>[F-CAT240] Invalid ID. Must contain a value</Description>
<Xpath><xsl:for-each select="ancestor-or-self::*">/<xsl:value-of select="name()" />[<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />]</xsl:for-each>
</Xpath>
</Error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M24" />
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M24" />
<xsl:template match="@*|node()" priority="-2" mode="M24">
<xsl:choose>
<!--Housekeeping: SAXON warns if attempting to find the attribute
                           of an attribute-->
<xsl:when test="not(@*)">
<xsl:apply-templates select="node()" mode="M24" />
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()" mode="M24" />
</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
