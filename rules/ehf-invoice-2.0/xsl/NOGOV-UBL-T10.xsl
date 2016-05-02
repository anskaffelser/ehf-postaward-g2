<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:fn="http://www.w3.org/2005/xpath-functions"
   xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:schold="http://www.ascc.net/xml/schematron"
   xmlns:iso="http://purl.oclc.org/dsdl/schematron"
   xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
   xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
   xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" version="2.0">
   <!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

   <axsl:param name="archiveDirParameter" tunnel="no"/>
   <axsl:param name="archiveNameParameter" tunnel="no"/>
   <axsl:param name="fileNameParameter" tunnel="no"/>
   <axsl:param name="fileDirParameter" tunnel="no"/>

   <!--PHASES-->


   <!--PROLOG-->

   <axsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no"
      standalone="yes" indent="yes"/>

   <!--XSD TYPES-->


   <!--KEYS AND FUCNTIONS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->

   <axsl:template match="*" mode="schematron-get-full-path">
      <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <axsl:text>/</axsl:text>
      <axsl:choose>
         <axsl:when test="namespace-uri() = ''">
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
      <axsl:variable name="preceding"
         select="count(preceding-sibling::*[local-name() = local-name(current()) and namespace-uri() = namespace-uri(current())])"/>
      <axsl:text>[</axsl:text>
      <axsl:value-of select="1 + $preceding"/>
      <axsl:text>]</axsl:text>
   </axsl:template>
   <axsl:template match="@*" mode="schematron-get-full-path">
      <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <axsl:text>/</axsl:text>
      <axsl:choose>
         <axsl:when test="namespace-uri() = ''">@<axsl:value-of select="name()"/>
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
         <axsl:if test="preceding-sibling::*[name(.) = name(current())]">
            <axsl:text>[</axsl:text>
            <axsl:value-of select="count(preceding-sibling::*[name(.) = name(current())]) + 1"/>
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
            <axsl:value-of select="count(preceding-sibling::*[name(.) = name(current())]) + 1"/>
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
      <axsl:value-of select="concat('.text-', 1 + count(preceding-sibling::text()), '-')"/>
   </axsl:template>
   <axsl:template match="comment()" mode="generate-id-from-path">
      <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <axsl:value-of select="concat('.comment-', 1 + count(preceding-sibling::comment()), '-')"/>
   </axsl:template>
   <axsl:template match="processing-instruction()" mode="generate-id-from-path">
      <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <axsl:value-of
         select="concat('.processing-instruction-', 1 + count(preceding-sibling::processing-instruction()), '-')"
      />
   </axsl:template>
   <axsl:template match="@*" mode="generate-id-from-path">
      <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <axsl:value-of select="concat('.@', name())"/>
   </axsl:template>
   <axsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <axsl:text>.</axsl:text>
      <axsl:value-of
         select="concat('.', name(), '-', 1 + count(preceding-sibling::*[name() = name(current())]), '-')"
      />
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
      <axsl:value-of select="translate(name(), ':', '.')"/>
   </axsl:template>
   <!--Strip characters-->
   <axsl:template match="text()" priority="-1"/>

   <!--SCHEMA METADATA-->

   <axsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         title="Sjekk mot norske nasjonale regler" schemaVersion="">
         <axsl:comment>
            <axsl:value-of select="$archiveDirParameter"/>
            <axsl:value-of select="$archiveNameParameter"/>
            <axsl:value-of select="$fileNameParameter"/>
            <axsl:value-of select="$fileDirParameter"/>
         </axsl:comment>
         <svrl:ns-prefix-in-attribute-values
            uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
         <svrl:ns-prefix-in-attribute-values
            uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
            prefix="cac"/>
         <svrl:ns-prefix-in-attribute-values
            uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl"/>
         <svrl:active-pattern>
            <axsl:attribute name="id">NOGOVUBL-T10</axsl:attribute>
            <axsl:attribute name="name">NOGOVUBL-T10</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M17"/>
      </svrl:schematron-output>
   </axsl:template>

   <!--SCHEMATRON PATTERNS-->

   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Sjekk mot norske nasjonale
      regler</svrl:text>

   <!--PATTERN NOGOVUBL-T10-->

   <!--RULE -->

   <axsl:template match="//cbc:ProfileID" priority="1001" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:ProfileID"/>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when
            test=". = 'urn:www.cenbii.eu:profile:bii04:ver2.0' or . = 'urn:www.cenbii.eu:profile:bii05:ver2.0' or . = 'urn:www.cenbii.eu:profile:biixy:ver2.0'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test=". = 'urn:www.cenbii.eu:profile:bii04:ver2.0' or . = 'urn:www.cenbii.eu:profile:bii05:ver2.0' or . = 'urn:www.cenbii.eu:profile:biixy:ver2.0'">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFPROFILE-T10-R001]-An invoice transaction T10 must only be used in Profiles 4, 5 or xy.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party" priority="1006"
      mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party"/>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:Contact/cbc:ID != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:Contact/cbc:ID != '')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R001]-A contact reference identifier SHOULD be provided for AccountingSupplierParty according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="//cac:PaymentMeans" priority="1005" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans"/>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PayeeFinancialAccount/cbc:ID != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:PayeeFinancialAccount/cbc:ID != '')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R011]-PayeeFinancialAccount MUST be provided according EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:PaymentID != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cbc:PaymentID != '')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R012]-Payment Identifier (KID number) SHOULD be used according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template
      match="//cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID[attribute::schemeID = 'BBAN']"
      priority="1005" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="//cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID[attribute::schemeID = 'BBAN']"/>
      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(string(.) castable as xs:integer)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(string(.) castable as xs:integer)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R032]-Only numbers are allowed as bank account number if scheme is BBAN.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template
      match="//cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID[attribute::schemeID = 'IBAN']"
      priority="1005" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="//cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID[attribute::schemeID = 'IBAN']"/>
      <!--ASSERT -->

      <axsl:choose>
         <axsl:when
            test="(matches(., 'NO') = true()) and (substring(., 3) castable as xs:integer)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(matches(.,'NO')= true()) and (substring(.,3) castable as xs:integer)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R033]- IBAN number is not for a norwegain bank account</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>
   <!--RULE -->

   <axsl:template match="//cac:OrderReference" priority="1004" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:OrderReference"/>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(child::cbc:ID != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(child::cbc:ID != '')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R013]-An association to Order Reference SHOULD be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="//cac:Item" priority="1003" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Item"/>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:SellersItemIdentification/cbc:ID != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:SellersItemIdentification/cbc:ID != '')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R002]-The sellers ID for the item SHOULD be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>
   <!--RULE -->

   <axsl:template match="//cac:InvoiceLine" priority="1002" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine"/>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:AccountingCost)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cbc:AccountingCost)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R003]-The buyer's accounting code applied to the Invoice Line SHOULD be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:OrderLineReference/cbc:LineID != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:OrderLineReference/cbc:LineID != '')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R004]-An association to Order Line Reference SHOULD be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>



   <!--RULE -->

   <axsl:template match="//cac:InvoiceLine/cac:Item/cac:OriginCountry" priority="1002" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="//cac:InvoiceLine/cac:Item/cac:OriginCountry"/>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:IdentificationCode != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cbc:IdentificationCode !='')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R022]-Identification code MUST be specified when describing origin country.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>


   <!--RULE -->

   <axsl:template match="//cac:InvoiceLine/cac:Item/cac:ManufacturerParty" priority="1002"
      mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="//cac:InvoiceLine/cac:Item/cac:ManufacturerParty"/>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PartyName/cbc:Name != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:PartyName/cbc:Name !='')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R024]-Name MUST be specified when describing a manufacturer party.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="//cac:InvoiceLine/cac:Item/cac:CommodityClassification" priority="1002"
      mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="//cac:InvoiceLine/cac:Item/cac:CommodityClassification"/>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:ItemClassificationCode != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cbc:ItemClassificationCode !='')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R023]-Item classification code MUST be specified when describing commodity classification.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="/ubl:Invoice" priority="1001" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>

      <!--ASSERT -->



      <axsl:choose>
         <!-- 2013-02-21 EG Test if TaxAmount not equals 0 -->
         <axsl:when
            test="
               ((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount != 0)
               and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or (cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount = 0)
               or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount != 0) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or (cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount = 0) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R014]-If the VAT total amount in an invoice exists it MUST contain the suppliers VAT number.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>


      <axsl:choose>
         <axsl:when
            test="
               ((cac:AllowanceCharge[cbc:ChargeIndicator = 'true'])
               and (cac:LegalMonetaryTotal/cbc:ChargeTotalAmount != '')
               or not(cac:AllowanceCharge[cbc:ChargeIndicator = 'true']))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="((cac:AllowanceCharge[cbc:ChargeIndicator = 'true']) and (cac:LegalMonetaryTotal/cbc:ChargeTotalAmount != '') or not(cac:AllowanceCharge[cbc:ChargeIndicator = 'true']) )">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R034]-If charge is present on document level, total charge must be stated.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:choose>
         <axsl:when
            test="
               ((cac:AllowanceCharge[cbc:ChargeIndicator = 'false'])
               and (cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount != '')
               or not(cac:AllowanceCharge[cbc:ChargeIndicator = 'false']))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="((cac:AllowanceCharge[cbc:ChargeIndicator = 'false']) and (cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount != '') or not(cac:AllowanceCharge[cbc:ChargeIndicator = 'false']) )">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R035]-If allowance is present on document level, total allowance must be stated.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:ContractDocumentReference/cbc:ID != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:ContractDocumentReference/cbc:ID != '')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R005]-ContractDocumentReference SHOULD be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:InvoiceTypeCode != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cbc:InvoiceTypeCode != '')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R016]- An EHF invoice MUST have an invoice type code.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PaymentMeans)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:PaymentMeans)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R019]- An invoice MUST have payment means information.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>




   <!--RULE-->
   <axsl:template match="//cac:PartyTaxScheme/cbc:CompanyID" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="//cac:PartyTaxScheme/cbc:CompanyID"/>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when
            test="(string-length(.) = 12) and (substring(., 1, 9) castable as xs:integer) and (substring(., 10, 12) = 'MVA')"/>

         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(string-length(.) = 12) and (substring(.,1,9) castable as xs:integer) and (substring(.,10,12)='MVA')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R030]- A VAT number MUST be nine numbers followed by the letters MVA.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>


   <!--RULE-->
   <axsl:template match="//cac:PartyLegalEntity/cbc:CompanyID" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="//cac:PartyLegalEntity/cbc:CompanyID"/>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="(string-length(.) = 9) and (string(.) castable as xs:integer)"/>

         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(string-length(.) = 9) and (string(.) castable as xs:integer)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R031]- An organisational number for seller, buyer and payee MUST be nine numbers..</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>


   <!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:PaymentTerms" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="/ubl:Invoice/cac:PaymentTerms"/>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="(cbc:Note != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:Note !='')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R020]- Note MUST be specified when describing Payment terms.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>
   <!--
   
	<axsl:template match="//cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']" priority="1000" mode="M17">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']"/>
			<axsl:choose>
			<axsl:when test="((cbc:TaxableAmount) and (cac:TaxCategory/cbc:Percent) and (number(cbc:TaxAmount - 1) &lt; number(cbc:TaxableAmount * (cac:TaxCategory/cbc:Percent div 100))) and (number(cbc:TaxAmount + 1) &gt; number(cbc:TaxableAmount * (cac:TaxCategory/cbc:Percent div 100)))) or not(cac:TaxCategory/cbc:Percent) or not(cbc:TaxableAmount)"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cbc:TaxableAmount) and (cac:TaxCategory/cbc:Percent) and (number(cbc:TaxAmount - 1) &lt; number(cbc:TaxableAmount * (cac:TaxCategory/cbc:Percent div 100))) and (number(cbc:TaxAmount + 1) &gt; number(cbc:TaxableAmount * (cac:TaxCategory/cbc:Percent div 100)))) or not(cac:TaxCategory/cbc:Percent) or not(cbc:TaxableAmount)">
					<axsl:attribute name="flag">fatal</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[NOGOV-T10-R029]-Taxable Amount for each TaxSubTotal MUST be equal to the line amount for the lines with the same VAT category.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
 
     <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17"/>
   </axsl:template>
   -->
   <!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:TaxRepresentativeParty" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="/ubl:Invoice/cac:TaxRepresentativeParty"/>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="(cac:PartyName/cbc:Name != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:PartyName/cbc:Name !='')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R017]- Name MUST be specified when describing a Tax Representative</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>


      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="(cac:PartyTaxScheme/cbc:CompanyID != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:PartyTaxScheme/cbc:CompanyID !='')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R018]- Company identifier MUST be specified when describing a Tax Representative</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>


   <!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:TaxTotal" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="/ubl:Invoice/cac:TaxTotal"/>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="(cac:TaxSubtotal)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:TaxSubtotal)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R021]- An invoice MUST have Tax Subtotal specifications.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="//*[contains(name(), 'Amount') and not(contains(name(), 'Transaction'))]"
      priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="//*[contains(name(),'Amount') and not(contains(name(),'Transaction'))]"/>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when
            test="not(attribute::currencyID) or (attribute::currencyID and attribute::currencyID = /ubl:Invoice/cbc:DocumentCurrencyCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="not(attribute::currencyID) or (attribute::currencyID and attribute::currencyID = /ubl:Invoice/cbc:DocumentCurrencyCode)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R025]- The attribute currencyID must have the same value as DocumentCurrencyCode, except the attribute for TransactionCurrencyTaxAmount.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="//*[contains(name(), 'Date')]" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="//*[contains(name(),'Date')]"/>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="(string(.) castable as xs:date) and (string-length(.) = 10)"/>

         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(string(.) castable as xs:date) and (string-length(.) = 10)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R028]- A date must be formatted YYYY-MM-DD.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="*/@mimeCode" priority="1001" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*/@mimeCode"/>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when
            test="((. = 'application/pdf' or . = 'image/gif' or . = 'image/tiff' or . = 'image/jpeg' or . = 'image/png' or . = 'text/plain'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(( . = 'application/pdf' or . = 'image/gif' or . = 'image/tiff' or . = 'image/jpeg' or . = 'image/png' or . = 'text/plain' ))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R010]-Attachment is not a recommended MIMEType.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>



   <!--RULE -->
   <axsl:template match="//cac:Party/cbc:EndpointID" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:EndpointID"/>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="@schemeID = 'NO:ORGNR'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="@schemeID = 'NO:ORGNR' ">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R027]-An endpoint identifier scheme MUST have the value 'NO:ORGNR'.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="(string(.) castable as xs:integer) and (string-length(.) = 9)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(string(.) castable as xs:integer) and (string-length(.) = 9)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R026]- MUST be a norwegian organizational number. Only numerical value allowed</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party" priority="1000"
      mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party"/>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PartyIdentification/cbc:ID != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:PartyIdentification/cbc:ID != '')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R006]-A customer number for AccountingCustomerParty SHOULD be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:Contact/cbc:ID != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:Contact/cbc:ID != '')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R007]-A contact reference identifier MUST be provided for AccountingCustomerParty according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <!--ASSERT -->
      <!-- 2013-05-10 EG Test on AdditionalDocumentReference/DocumentType = 'elektroniskB2Cfaktura', indicates B2C  -->
      <axsl:choose>
         <axsl:when
            test="(cac:PartyLegalEntity/cbc:CompanyID != '') or (//cac:AdditionalDocumentReference/cbc:DocumentType = 'elektroniskB2Cfaktura')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:PartyLegalEntity/cbc:CompanyID != '')or (//cac:AdditionalDocumentReference/cbc:DocumentType = 'elektroniskB2Cfaktura')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R009]-PartyLegalEntity for AccountingCustomerParty MUST be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <!--ASSERT -->
      <!-- 2013-05-10 EG Changed from warning to Fatal 
								Test on AdditionalDocumentReference/DocumentType = 'elektroniskB2Cfaktura', indicates B2C-->
      <axsl:choose>
         <axsl:when
            test="(cac:PartyLegalEntity/cbc:RegistrationName != '') or (//cac:AdditionalDocumentReference/cbc:DocumentType = 'elektroniskB2Cfaktura')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(cac:PartyLegalEntity/cbc:RegistrationName != '') or 
             (//cac:AdditionalDocumentReference/cbc:DocumentType = 'elektroniskB2Cfaktura')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R015]-Registration name for AccountingCustomerParty MUST be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="//cac:PartyIdentification/cbc:ID[@schemeID = 'NO:ORGNR']" priority="1000"
      mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="/cac:PartyIdentification/cbc:ID[@schemeID='NO:ORGNR']"/>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="(string(.) castable as xs:integer) and (string-length(.) = 9)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="(string(.) castable as xs:integer) and (string-length(.) = 9)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R036]- When scheme is NO:ORGNR, a norwegian organizational number must be used. Only numerical value allowed</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="//cac:LegalMonetaryTotal" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="//cac:LegalMonetaryTotal"/>

      <xsl:for-each select="child::*">
         <!--ASSERT -->
         <axsl:choose>
            <axsl:when test="string-length(substring-after(., '.')) &lt;= 2"/>
            <axsl:otherwise>
               <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                  test="string-length(substring-after(., '.')) &lt;= 2">
                  <axsl:attribute name="flag">fatal</axsl:attribute>
                  <axsl:attribute name="location">
                     <axsl:apply-templates select="." mode="schematron-get-full-path"/>
                  </axsl:attribute>
                  <svrl:text>[NOGOV-T10-R037]- Document level amounts cannot have more than 2 decimals</svrl:text>
               </svrl:failed-assert>
            </axsl:otherwise>
         </axsl:choose>
      </xsl:for-each>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:TaxTotal" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="/ubl:Invoice/cac:TaxTotal"/>


      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="string-length(substring-after(cbc:TaxAmount, '.')) &lt;= 2"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="string-length(substring-after(cbc:TaxAmount, '.')) &lt;= 2">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R038]- Total tax amount cannot have more than 2 decimals</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="count(distinct-values(cac:TaxSubtotal/cac:TaxCategory/cbc:ID/text())) = count(cac:TaxSubtotal)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="count(distinct-values(cac:TaxSubtotal/cac:TaxCategory/cbc:ID/text())) = count(cac:TaxSubtotal)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R041]- Multiple tax subtotals per tax category is not allowed.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>
   <!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal"/>


      <axsl:choose>
         <axsl:when test="string-length(substring-after(cbc:TaxableAmount, '.')) &lt;= 2"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="string-length(substring-after(., '.')) &lt;= 2">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R039]- Tax subtotal amounts cannot have more than 2 decimals</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:choose>
         <axsl:when test="string-length(substring-after(cbc:TaxAmount, '.')) &lt;= 2"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="string-length(substring-after(., '.')) &lt;= 2">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R039]- Tax subtotal amounts cannot have more than 2 decimals</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:AllowanceCharge" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
         context="/ubl:Invoice/cac:AllowanceCharge"/>

      <!--ASSERT -->
      <axsl:choose>
         <axsl:when test="string-length(substring-after(cbc:Amount, '.')) &lt;= 2"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               test="string-length(substring-after(cbc:Amount, '.')) &lt;= 2">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R040]- Allowance or charge amounts on document level cannot have more than 2 decimals</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>

   <axsl:template match="text()" priority="-1" mode="M17"/>
   <axsl:template match="@* | node()" priority="-2" mode="M17">
      <axsl:apply-templates select="@* | * | comment() | processing-instruction()" mode="M17"/>
   </axsl:template>
</axsl:stylesheet>
