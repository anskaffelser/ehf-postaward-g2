<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
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
   </axsl:template><!--MODE: SCHEMATRON-FULL-PATH-3-->
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
   </axsl:template><!--Strip characters-->
   <axsl:template match="text()" priority="-1"/>

<!--SCHEMA METADATA-->

   <axsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Norsk faktura binding til UBL" schemaVersion="">
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
            <axsl:attribute name="id">BIICOREUBL-T10</axsl:attribute>
            <axsl:attribute name="name">BIICOREUBL-T10</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <axsl:attribute name="id">BIIPROFILESUBL-T10</axsl:attribute>
            <axsl:attribute name="name">BIIPROFILESUBL-T10</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <axsl:attribute name="id">BIIRULESUBL-T10</axsl:attribute>
            <axsl:attribute name="name">BIIRULESUBL-T10</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <axsl:attribute name="id">EUGENUBL-T10</axsl:attribute>
            <axsl:attribute name="name">EUGENUBL-T10</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <axsl:attribute name="id">NONATUBL-T10</axsl:attribute>
            <axsl:attribute name="name">NONATUBL-T10</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <axsl:attribute name="id">NOGOVUBL-T10</axsl:attribute>
            <axsl:attribute name="name">NOGOVUBL-T10</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <axsl:attribute name="id">BIIRULESCodesT10</axsl:attribute>
            <axsl:attribute name="name">BIIRULESCodesT10</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <axsl:attribute name="id">EUGENCodesT10</axsl:attribute>
            <axsl:attribute name="name">EUGENCodesT10</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M19"/>
      </svrl:schematron-output>
   </axsl:template>

<!--SCHEMATRON PATTERNS-->

   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Norsk faktura binding til UBL</svrl:text>

<!--PATTERN BIICOREUBL-T10-->


	<!--RULE -->

   <axsl:template match="/ubl:Invoice" priority="1008" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R000]-This XML instance is NOT a core BiiTrdm010 transaction</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(count(//*[not(text())]) &gt; 0)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(count(//*[not(text())]) &gt; 0)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R001]-An invoice SHOULD not contain empty elements.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:CopyIndicator)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R002]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:UUID)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R003]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:IssueTime)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:IssueTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R004]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:TaxCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:TaxCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R005]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:PricingCurrencyCode)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PricingCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R006]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:PaymentCurrencyCode)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PaymentCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R007]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:PaymentAlternativeCurrencyCode)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PaymentAlternativeCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R008]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:AccountingCostCode)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R009]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:LineCountNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:LineCountNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R010]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:BillingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R011]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:DespatchDocumentReference)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R012]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ReceiptDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R013]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OriginatorDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R014]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Signature) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Signature) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R015]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:BuyerCustomerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:BuyerCustomerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R016]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:SellerSupplierParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:SellerSupplierParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R017]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxRepresentativeParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxRepresentativeParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R018]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:DeliveryTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:DeliveryTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R019]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PrepaidPayment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PrepaidPayment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R020]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R021]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PricingExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PricingExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R022]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R023]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentAlternativeExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentAlternativeExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R024]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoicePeriod/cbc:StartTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:StartTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R025]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoicePeriod/cbc:EndTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:EndTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R026]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoicePeriod/cbc:DurationMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:DurationMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R027]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoicePeriod/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R028]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoicePeriod/cbc:DescriptionCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoicePeriod/cbc:DescriptionCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R029]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:SalesOrderID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:SalesOrderID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R030]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:CopyIndicator)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R031]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:UUID)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R032]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:IssueDate)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R033]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:IssueTime)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:IssueTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R034]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:CustomerReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:CustomerReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R035]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R036]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ContractDocumentReference/cbc:CooyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:CooyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R037]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ContractDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R038]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ContractDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R039]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ContractDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R040]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ContractDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R041]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ContractDocumentReference/cac:Attachment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cac:Attachment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R042]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R043]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R044]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R045]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R046]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R047]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R048]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R049]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R050]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R051]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R052]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cbc:DataSendingCapability) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:DataSendingCapability) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R053]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:DespatchContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:DespatchContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R054]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R055]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:SellerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:SellerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R056]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R057]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R058]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R059]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R060]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R061]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R062]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R063]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R064]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R065]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R066]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R067]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R068]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R069]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R070]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R071]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R072]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R073]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R074]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R075]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R076]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R077]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R078]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R079]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R080]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R081]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R082]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R083]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R084]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R085]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R086]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R087]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R088]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R089]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R090]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R091]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R092]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R093]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R094]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R095]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R096]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R097]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R098]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R099]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R100]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R101]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R102]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R103]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R104]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R105]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R106]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R107]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R108]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R109]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R110]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R111]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R112]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R113]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R115]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R116]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R117]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R118]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R119]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R120]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R121]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R122]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R123]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R124]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:DeliveryContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:DeliveryContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R125]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R126]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:BuyerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:BuyerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R127]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R128]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R129]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R130]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R131]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R132]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R133]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R134]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R135]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R136]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R137]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R138]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R139]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R140]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R141]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R142]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R143]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R144]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R145]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R146]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R147]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R148]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R149]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R150]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R151]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R152]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R153]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R154]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R155]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R156]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R157]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R158]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R159]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R160]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R161]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R162]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R163]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R164]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R165]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R166]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R167]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R168]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R169]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R170]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R171]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R172]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R173]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R174]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R175]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R176]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R177]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R178]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R179]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R180]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R181]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R182]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R183]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R184]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R186]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R187]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R188]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R189]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R190]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R191]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R192]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R193]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R194]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R195]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R196]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R197]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PostalAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PostalAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R198]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R199]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PartyTaxScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyTaxScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R200]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R201]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R202]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R203]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:Contact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Contact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R204]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:Person) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Person) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R205]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R206]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R207]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:Quantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:Quantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R208]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:MinimumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:MinimumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R209]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:MaximumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:MaximumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R210]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:ActualDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:ActualDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R211]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:LatestDeliveryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:LatestDeliveryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R212]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:LatestDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:LatestDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R213]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:TrackingID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:TrackingID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R214]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R215]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R216]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R217]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R218]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R219]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R220]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R221]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R222]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R223]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R224]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R225]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R226]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R227]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R228]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R229]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R230]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R231]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R232]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R233]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R234]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R235]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R236]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R237]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R238]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R239]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:RequestedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:RequestedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R240]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:PromisedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:PromisedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R241]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:EstimatedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:EstimatedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R242]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R243]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Despatch) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Despatch) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R244]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R245]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cbc:InstructionID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:InstructionID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R246]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cbc:InstructionNote) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:InstructionNote) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R247]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:CardAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CardAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R248]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayerFinancialAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayerFinancialAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R249]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:CreditAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CreditAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R250]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R251]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R252]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R253]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R254]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R255]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R256]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R257]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R258]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R259]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:PaymentMeansID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PaymentMeansID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R260]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R261]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:ReferenceEventCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:ReferenceEventCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R262]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:SettlementDiscountPercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:SettlementDiscountPercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R263]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:PenaltySurchargePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PenaltySurchargePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R264]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:Amount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:Amount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R265]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cac:SettlementPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cac:SettlementPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R266]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cac:PenaltyPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cac:PenaltyPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R267]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R268]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R269]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R270]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R271]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R272]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R273]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R274]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R275]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R276]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R277]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R278]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R279]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R280]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R281]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TransactionCurrencyTaxAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R282]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R283]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R284]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R285]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R286]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R287]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R288]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R289]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R290]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R291]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R292]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R293]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R294]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R295]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R296]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R297]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cbc:TaxPointDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cbc:TaxPointDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R298]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R299]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cbc:FreeOfChargeIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cbc:FreeOfChargeIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R300]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:SalesOrderLineID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:SalesOrderLineID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R301]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:DespatchLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:DespatchLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R302]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:ReceiptLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:ReceiptLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R303]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:BillingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:BillingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R304]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R305]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:PricingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:PricingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R306]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:OriginatorParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:OriginatorParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R307]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Delivery) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Delivery) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R308]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:PaymentTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:PaymentTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R309]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R310]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R311]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R312]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R313]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R314]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R315]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R316]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R317]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R318]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R319]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R320]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R321]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R322]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R323]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:PackQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:PackQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R324]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:PackSizeNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:PackSizeNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R325]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:CatalogueIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:CatalogueIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R326]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:HazardousRiskIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:HazardousRiskIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R327]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:AdditionalInformation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:AdditionalInformation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R328]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:Keyword) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:Keyword) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R329]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:BrandName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:BrandName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R330]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cbc:ModelName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cbc:ModelName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R331]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R332]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R333]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R334]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:SellersItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R335]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R336]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R337]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R338]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:StandardItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R339]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:BuyersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R340]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:NatureCargo) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:NatureCargo) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R341]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R342]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CommodityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:CommodityClassification/cbc:CommodityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R343]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:ManufacturersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:ManufacturersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R344]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:CatalogueItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:CatalogueItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R345]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:AdditionalItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:AdditionalItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R346]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:CatalogueDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:CatalogueDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R347]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:ItemSpecificationDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:ItemSpecificationDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R348]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:OriginCountry) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:OriginCountry) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R349]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TransactionConditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TransactionConditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R350]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:HazardousItem) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:HazardousItem) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R351]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:ManufacturerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:ManufacturerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R352]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:InformationContentProviderParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:InformationContentProviderParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R353]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:OriginAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:OriginAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R354]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:ItemInstance) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:ItemInstance) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R355]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R356]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R357]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbcPerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbcPerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R358]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R359]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R360]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R361]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R362]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R363]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R364]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R365]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R366]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:UsabilityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:UsabilityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R367]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:ItemPropertyGroup) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:ItemPropertyGroup) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R368]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cbc:PriceChangeReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cbc:PriceChangeReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R369]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cbc:PriceTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cbc:PriceTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R370]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cbc:PriceType) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cbc:PriceType) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R371]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cbc:OrderableUnitFactorRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cbc:OrderableUnitFactorRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R372]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R373]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:PriceList) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:PriceList) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R374]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R375]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R376]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R377]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R378]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R379]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R380]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R381]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R382]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:Price/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R383]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R384]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:LineStatusCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:OrderLineReference/cbc:LineStatusCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R385]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:InvoiceLine/cac:OrderLineReference/cac:OrderReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:InvoiceLine/cac:OrderLineReference/cac:OrderReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R386]-A conformant CEN BII invoice core data model SHOULD not have data elements not in the core.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party" priority="1007" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R387]-Element 'PartyIdentification' may occur at maximum 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R388]-Element 'PartyName' must occur exactly 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R389]-Element 'PartyTaxScheme' may occur at maximum 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party" priority="1006" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R390]-Element 'PartyIdentification' may occur at maximum 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R391]-Element 'PartyName' must occur exactly 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:PostalAddress)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PostalAddress)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R392]-Element 'PostalAddress' must occur exactly 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R393]-Element 'PartyTaxScheme' may occur at maximum 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:InvoiceLine" priority="1005" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:InvoiceLine"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:TaxTotal)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:TaxTotal)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R394]-Element 'TaxTotal' may occur at maximum 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:Price)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:Price)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R395]-Element 'Price' must occur exactly 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Item" priority="1004" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:InvoiceLine/cac:Item"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cbc:Description)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:Description)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R396]-Element 'Description' may occur at maximum 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cbc:Name)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:Name)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R397]-Element 'Name' must occur exactly 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:ClassifiedTaxCategory)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:ClassifiedTaxCategory)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R398]-Element 'ClassifiedTaxCategory' may occur at maximum 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:InvoiceLine/cac:Price" priority="1003" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:InvoiceLine/cac:Price"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:AllowanceCharge)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:AllowanceCharge)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R399]-Element 'AllowanceCharge' may occur at maximum 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:LegalMonetaryTotal" priority="1002" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:LegalMonetaryTotal"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cbc:TaxExclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:TaxExclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R400]-Element 'TaxExclusiveAmount' must occur exactly 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cbc:TaxInclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:TaxInclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R401]-Element 'TaxInclusiveAmount' must occur exactly 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:PayeeParty" priority="1001" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:PayeeParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R402]-Element 'PartyIdentification' may occur at maximum 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:PartyName)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyName)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R403]-Element 'PartyName' may occur at maximum 1 times</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:PaymentMeans/cac:PayeeFinancialAccount"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cbc:ID)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:ID)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biicoretrdm010:ver1.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIICORE-T10-R404]-Element 'ID' must occur exactly 1 times.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M12"/>
   <axsl:template match="@*|node()" priority="-2" mode="M12">
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>

<!--PATTERN BIIPROFILESUBL-T10-->


	<!--RULE -->

   <axsl:template match="//cbc:ProfileID" priority="1001" mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:ProfileID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test=". = 'urn:www.cenbii.eu:profile:bii04:ver1.0' or . = 'urn:www.cenbii.eu:profile:bii05:ver1.0' or . = 'urn:www.cenbii.eu:profile:bii06:ver1.0'"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=". = 'urn:www.cenbii.eu:profile:bii04:ver1.0' or . = 'urn:www.cenbii.eu:profile:bii05:ver1.0' or . = 'urn:www.cenbii.eu:profile:bii06:ver1.0'">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIPROFILE-T10-R001]-An invoice transaction T10 must only be used in Profiles 4, 5 or 6.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M13"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice" priority="1000" mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="local-name(/*) = 'Invoice' and (//cac:OrderReference/cbc:ID) and //cbc:ProfileID = 'urn:www.cenbii.eu:profile:bii06:ver1.0' or not(//cbc:ProfileID = 'urn:www.cenbii.eu:profile:bii06:ver1.0')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="local-name(/*) = 'Invoice' and (//cac:OrderReference/cbc:ID) and //cbc:ProfileID = 'urn:www.cenbii.eu:profile:bii06:ver1.0' or not(//cbc:ProfileID = 'urn:www.cenbii.eu:profile:bii06:ver1.0')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIPROFILE-T10-R002]-An invoice transaction T10 in Profile 6 MUST have an order reference identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M13"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M13"/>
   <axsl:template match="@*|node()" priority="-2" mode="M13">
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M13"/>
   </axsl:template>

<!--PATTERN BIIRULESUBL-T10-->


	<!--RULE -->

   <axsl:template match="//cac:LegalMonetaryTotal" priority="1015" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:LegalMonetaryTotal"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="number(cbc:LineExtensionAmount) = number(round(sum(//cac:InvoiceLine/cbc:LineExtensionAmount) * 10 * 10) div 100)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:LineExtensionAmount) = number(round(sum(//cac:InvoiceLine/cbc:LineExtensionAmount) * 10 * 10) div 100)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R011]-Invoice total line extension amount MUST equal the sum of the line totals</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 ))  or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = number(cbc:LineExtensionAmount)))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10) div 100 )) or (not(cbc:ChargeTotalAmount) and (cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) - number(cbc:AllowanceTotalAmount)) * 10 * 10 ) div 100)) or ((cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = round((number(cbc:LineExtensionAmount) + number(cbc:ChargeTotalAmount)) * 10 * 10 ) div 100)) or (not(cbc:ChargeTotalAmount) and not(cbc:AllowanceTotalAmount) and (number(cbc:TaxExclusiveAmount) = number(cbc:LineExtensionAmount)))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R012]-Invoice tax exclusive amount MUST equal the sum of lines plus allowances and charges on header level.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="((cbc:PayableRoundingAmount) and (number(cbc:TaxInclusiveAmount) = (round((number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount)) + number(cbc:PayableRoundingAmount)) *10 * 10) div 100))) or (number(cbc:TaxInclusiveAmount) = round(( number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount))) * 10 * 10) div 100)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cbc:PayableRoundingAmount) and (number(cbc:TaxInclusiveAmount) = (round((number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount)) + number(cbc:PayableRoundingAmount)) *10 * 10) div 100))) or (number(cbc:TaxInclusiveAmount) = round(( number(cbc:TaxExclusiveAmount) + number(sum(/ubl:Invoice/cac:TaxTotal/cbc:TaxAmount))) * 10 * 10) div 100)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R013]-Invoice tax inclusive amount MUST equal the tax exclusive amount plus all tax total amounts and the rounding amount.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="number(cbc:TaxInclusiveAmount) &gt;= 0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:TaxInclusiveAmount) &gt;= 0">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R014]-Tax inclusive amount in an invoice MUST NOT be negative</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:AllowanceTotalAmount) and number(cbc:AllowanceTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=&#34;false&#34;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:AllowanceTotalAmount)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:AllowanceTotalAmount) and number(cbc:AllowanceTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=&#34;false&#34;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:AllowanceTotalAmount)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R015]-Total allowance MUST be equal to the sum of allowances at document level</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:ChargeTotalAmount) and number(cbc:ChargeTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=&#34;true&#34;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:ChargeTotalAmount)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ChargeTotalAmount) and number(cbc:ChargeTotalAmount) = (round(sum(/ubl:Invoice/cac:AllowanceCharge[cbc:ChargeIndicator=&#34;true&#34;]/cbc:Amount) * 10 * 10) div 100) or not(cbc:ChargeTotalAmount)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R016]-Total charges MUST be equal to the sum of document level charges.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:PrepaidAmount) and (number(cbc:PayableAmount) = (round((cbc:TaxInclusiveAmount - cbc:PrepaidAmount) * 10 * 10) div 100)) or number(cbc:PayableAmount) = number(cbc:TaxInclusiveAmount)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:PrepaidAmount) and (number(cbc:PayableAmount) = (round((cbc:TaxInclusiveAmount - cbc:PrepaidAmount) * 10 * 10) div 100)) or number(cbc:PayableAmount) = number(cbc:TaxInclusiveAmount)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R017]-Amount due is the tax inclusive amount minus what has been prepaid.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:TaxTotal" priority="1014" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:TaxTotal"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="count(cac:TaxSubtotal/*/*/cbc:ID) = count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) or count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) = 0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:TaxSubtotal/*/*/cbc:ID) = count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) or count(cac:TaxSubtotal/*/*/cbc:ID[. = 'VAT']) = 0">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R009]-An invoice MUST have a tax total refering to a single tax scheme</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="number(cbc:TaxAmount) = number(round(sum(cac:TaxSubtotal/cbc:TaxAmount) * 10 * 10) div 100)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:TaxAmount) = number(round(sum(cac:TaxSubtotal/cbc:TaxAmount) * 10 * 10) div 100)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R010]-Each tax total MUST equal the sum of the tax subcategory amounts.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal" priority="1013" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:TaxTotal/cac:TaxSubtotal"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxableAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxableAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R046]-An invoice MUST specify the taxable amount per VAT subtotal.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="boolean(self::node()[cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) or (cac:TaxCategory/cac:TaxScheme/cbc:ID != 'VAT')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R047]-An invoice MUST specify the tax amount per VAT subtotal.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:TaxScheme" priority="1012" mode="M14">
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
               <svrl:text>[BIIRULE-T10-R049]-Every tax scheme MUST be defined through an identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:TaxCategory" priority="1011" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxCategory"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R048]-Every tax category MUST be defined through an identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:AccountingSupplierParty" priority="1010" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R002]-A supplier address in an invoice SHOULD contain at least the city name and a zip code or have an address identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((following::cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R003]-In cross border trade the VAT identifier for the supplier SHOULD be prefixed with country code.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:PaymentMeans" priority="1009" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:PaymentDueDate and /ubl:Invoice/cbc:IssueDate) and (number(translate(cbc:PaymentDueDate,'-','')) &gt;= number(translate(/ubl:Invoice/cbc:IssueDate,'-',''))) or (not(cbc:PaymentDueDate))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:PaymentDueDate and /ubl:Invoice/cbc:IssueDate) and (number(translate(cbc:PaymentDueDate,'-','')) &gt;= number(translate(/ubl:Invoice/cbc:IssueDate,'-',''))) or (not(cbc:PaymentDueDate))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R006]-Payment means due date in an invoice SHOULD be later or equal than issue date.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:PaymentMeansCode = '31') and //cac:PayeeFinancialAccount/cbc:ID or (cbc:PaymentMeansCode != '31')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:PaymentMeansCode = '31') and //cac:PayeeFinancialAccount/cbc:ID or (cbc:PaymentMeansCode != '31')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R007]-If payment means is funds transfer, invoice MUST have a financial account</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PayeeFinancialAccount/cbc:ID/@schemeID and (cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN') or (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PayeeFinancialAccount/cbc:ID/@schemeID and (cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN') or (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R008]-If bank account is IBAN the bank identifier SHOULD also be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans) or (cac:PaymentMeans/cbc:PaymentMeansCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans) or (cac:PaymentMeans/cbc:PaymentMeansCode)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R044]-When specifying payment means, the invoice MUST specify the payment means code</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:PartyLegalEntity" priority="1008" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PartyLegalEntity"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:CompanyID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CompanyID)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R041]-Company identifier MUST be specified when describing a company legal entity.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:InvoiceLine/cac:Price/cbc:PriceAmount" priority="1007" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine/cac:Price/cbc:PriceAmount"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="number(.) &gt;=0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(.) &gt;=0">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R022]-Prices of items MUST NOT be negative.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:Item" priority="1006" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Item"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="string-length(string(cbc:Name)) &lt;= 50"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(string(cbc:Name)) &lt;= 50">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R019]-Product names SHOULD NOT exceed 50 characters long</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((cac:StandardItemIdentification)) or (cac:StandardItemIdentification/cbc:ID/@schemeID)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R020]-If standard identifiers are provided within an item description, a Scheme Identifier SHOULD be provided (e.g. GTIN)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not((cac:CommodityClassification)) or (cac:CommodityClassification/cbc:ItemClassificationCode/@listID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not((cac:CommodityClassification)) or (cac:CommodityClassification/cbc:ItemClassificationCode/@listID)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R021]-Classification codes within an item description SHOULD use a standard scheme for codes (e.g. CPV or UNSPSC)</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:InvoicePeriod" priority="1005" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoicePeriod"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,'-','')) &lt;= number(translate(cbc:EndDate,'-','')))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:StartDate and cbc:EndDate) and (number(translate(cbc:StartDate,'-','')) &lt;= number(translate(cbc:EndDate,'-','')))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R001]-An invoice period end date MUST be later or equal to an invoice period start date</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:InvoiceLine" priority="1004" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:InvoicedQuantity) or not(cac:Price/cbc:PriceAmount) or (not(cac:Price/cbc:BaseQuantity) and  number(cbc:LineExtensionAmount) = (round(number(cac:Price/cbc:PriceAmount) *number(cbc:InvoicedQuantity) * 10 * 10) div 100) + ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) or ((cac:Price/cbc:BaseQuantity) and  number(cbc:LineExtensionAmount) = (round((number(cac:Price/cbc:PriceAmount) div number(cac:Price/cbc:BaseQuantity) * number(cbc:InvoicedQuantity)) * 10 * 10) div 100)+ (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) -(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:InvoicedQuantity) or not(cac:Price/cbc:PriceAmount) or (not(cac:Price/cbc:BaseQuantity) and number(cbc:LineExtensionAmount) = (round(number(cac:Price/cbc:PriceAmount) *number(cbc:InvoicedQuantity) * 10 * 10) div 100) + ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - ( round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) or ((cac:Price/cbc:BaseQuantity) and number(cbc:LineExtensionAmount) = (round((number(cac:Price/cbc:PriceAmount) div number(cac:Price/cbc:BaseQuantity) * number(cbc:InvoicedQuantity)) * 10 * 10) div 100)+ (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) -(round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R018]-Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:Item/cbc:Name)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Item/cbc:Name)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R025]-Each invoice line MUST contain the product/service name</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R032]-Invoice lines MUST have a line identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:LineExtensionAmount"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:LineExtensionAmount">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R050]-Invoice lines MUST have a line total amount.</svrl:text>
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
               <svrl:text>[BIIRULE-T10-R051]-Invoice lines MUST contain the item price</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice" priority="1003" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:IssueDate)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:IssueDate)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R023]-An invoice MUST have the date of issue.</svrl:text>
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
               <svrl:text>[BIIRULE-T10-R024]-An invoice MUST have an invoice number.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:AccountingSupplierParty/cac:Party/cac:PartyName/cbc:Name)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R026]-An invoice MUST contain the full name of the supplier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R027]-An invoice MUST contain the full name of the customer.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (round(sum(cac:TaxTotal//cac:TaxSubtotal/cbc:TaxableAmount) *10 * 10) div 100 = number(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount))) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (round(sum(cac:TaxTotal//cac:TaxSubtotal/cbc:TaxableAmount) *10 * 10) div 100 = number(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount))) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R028]-If the VAT total amount in an invoice exists then the sum of taxable amount in sub categories MUST equal the sum of invoice tax exclusive amount.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:UBLVersionID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:UBLVersionID)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R029]-An invoice MUST have a syntax identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:CustomizationID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CustomizationID)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R030]-An invoice MUST have a customization identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:ProfileID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:ProfileID)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R031]-An invoice MUST have a profile identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:InvoiceLine)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:InvoiceLine)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R033]-An invoice MUST specify at least one line item.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:DocumentCurrencyCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:DocumentCurrencyCode)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R034]-An invoice MUST have a currency code for the document.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:OrderReference/cbc:ID) or not(cac:OrderReference)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:OrderReference/cbc:ID) or not(cac:OrderReference)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R035]-Any reference to an order MUST specify the order identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:ContractDocumentReference/cbc:ID) or not(cac:ContractDocumentReference)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:ContractDocumentReference/cbc:ID) or not(cac:ContractDocumentReference)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R036]-Any reference to a contract MUST specify the contract identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:LegalMonetaryTotal/cbc:PayableAmount)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:LegalMonetaryTotal/cbc:PayableAmount)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R038]-An invoice MUST specify the total payable amount.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:LegalMonetaryTotal/cbc:TaxInclusiveAmount)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R039]-An invoice MUST specify the total amount with taxes included.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:LegalMonetaryTotal/cbc:TaxExclusiveAmount)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R042]-An invoice MUST specify the total amount without taxes.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:LegalMonetaryTotal/cbc:LineExtensionAmount)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:LegalMonetaryTotal/cbc:LineExtensionAmount)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R043]-An invoice MUST specify the sum of the line amounts.</svrl:text>
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
               <svrl:text>[BIIRULE-T10-R052]-An invoice MUST contain tax information</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:AccountingCustomerParty" priority="1002" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingCustomerParty"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Party/cac:PostalAddress/cbc:CityName and cac:Party/cac:PostalAddress/cbc:PostalZone) or (cac:Party/cac:PostalAddress/cbc:ID)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R004]-A customer address in an invoice SHOULD contain at least city and zip code or have an address identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and  ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID) and (cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) = (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) or ((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) != (preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:ID='VAT' and starts-with(cac:Party/cac:PartyTaxScheme/cbc:CompanyID,cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)))) or not((cac:Party/cac:PartyTaxScheme[cac:TaxScheme/cbc:ID='VAT']/cbc:CompanyID)) or not((cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode)) or not((preceding::cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R005]-In cross border trade the VAT identifier for the customer SHOULD be prefixed with country code.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:Country" priority="1001" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Country"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:IdentificationCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:IdentificationCode)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R040]-Country in an address MUST be specified using the country code.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:AdditionalDocumentReference" priority="1000" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AdditionalDocumentReference"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:ID"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[BIIRULE-T10-R037]-Any reference to a document MUST specify the document identifier.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M14"/>
   <axsl:template match="@*|node()" priority="-2" mode="M14">
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M14"/>
   </axsl:template>

<!--PATTERN EUGENUBL-T10-->


	<!--RULE -->

   <axsl:template match="//cac:LegalMonetaryTotal" priority="1011" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:LegalMonetaryTotal"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="number(cbc:PayableAmount) &gt;= 0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:PayableAmount) &gt;= 0">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R019]-Total payable amount in an invoice MUST NOT be negative</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:TaxSubtotal" priority="1010" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxSubtotal"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="((cac:TaxCategory/cbc:ID = 'E') and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or (cac:TaxCategory/cbc:ID != 'E')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:TaxCategory/cbc:ID = 'E') and (cac:TaxCategory/cbc:TaxExemptionReason or cac:TaxCategory/cbc:TaxExemptionReasonCode)) or (cac:TaxCategory/cbc:ID != 'E')">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R009]-If the category for VAT is exempt (E) then an exemption reason SHOULD be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:TaxCategory" priority="1009" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxCategory"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(parent::cac:AllowanceCharge) or (cbc:ID and cbc:Percent) or (cbc:ID = 'AE')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R008]-For each tax subcategory the category ID and the applicable tax percentage MUST be provided.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:AccountingSupplierParty/cac:Party" priority="1008" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R001]-A supplier postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:PaymentMeans" priority="1007" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="((cbc:PaymentMeansCode = '31') and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC')) or (cbc:PaymentMeansCode != '31') or ((cbc:PaymentMeansCode = '31') and  (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN')))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cbc:PaymentMeansCode = '31') and (cac:PayeeFinancialAccount/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cbc:ID/@schemeID = 'IBAN') and (cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID and cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID = 'BIC')) or (cbc:PaymentMeansCode != '31') or ((cbc:PaymentMeansCode = '31') and (not(cac:PayeeFinancialAccount/cbc:ID/@schemeID) or (cac:PayeeFinancialAccount/cbc:ID/@schemeID != 'IBAN')))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R004]-If the payment means are international account transfer and the account id is IBAN then the financial institution should be identified by using the BIC id.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:InvoicePeriod" priority="1006" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoicePeriod"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:StartDate)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:StartDate)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R020]-If the invoice refers to a period, the period MUST have an start date.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:EndDate)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:EndDate)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R021]-If the invoice refers to a period, the period MUST have an end date.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:InvoiceLine" priority="1005" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:InvoicedQuantity and cbc:InvoicedQuantity/@unitCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:InvoicedQuantity and cbc:InvoicedQuantity/@unitCode)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R003]-Each invoice line SHOULD contain the quantity and unit of measure</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice" priority="1004" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R007]-If the VAT total amount in an invoice exists it MUST contain the suppliers VAT number.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R010]-If payee information is provided then the payee name MUST be specified.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="starts-with(//cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID,//cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R015]-IF VAT = "AE" (reverse charge) THEN it MUST contain Supplier VAT id and Customer VAT</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(((//cac:TaxCategory/cbc:ID) = 'AE')  and not((//cac:TaxCategory/cbc:ID) != 'AE' )) or not((//cac:TaxCategory/cbc:ID) = 'AE') or not(//cac:TaxCategory)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(((//cac:TaxCategory/cbc:ID) = 'AE') and not((//cac:TaxCategory/cbc:ID) != 'AE' )) or not((//cac:TaxCategory/cbc:ID) = 'AE') or not(//cac:TaxCategory)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R016]-IF VAT = "AE" (reverse charge) THEN VAT MAY NOT contain other VAT categories.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(//cbc:TaxExclusiveAmount = //cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='AE']/cbc:TaxableAmount) and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(//cbc:TaxExclusiveAmount = //cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cbc:ID='AE']/cbc:TaxableAmount) and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R017]-IF VAT = "AE" (reverse charge) THEN The taxable amount MUST equal the invoice total without VAT amount.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//cac:TaxTotal/cbc:TaxAmount = 0 and (//cac:TaxCategory/cbc:ID) = 'AE' or not((//cac:TaxCategory/cbc:ID) = 'AE')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R018]-IF VAT = "AE" (reverse charge) THEN VAT tax amount MUST be zero.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(//@currencyID != //cbc:DocumentCurrencyCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(//@currencyID != //cbc:DocumentCurrencyCode)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R024]-Currency Identifier MUST be in stated in the currency stated on header level.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:Delivery/cac:DeliveryLocation/cac:Address" priority="1003" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Delivery/cac:DeliveryLocation/cac:Address"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:CityName and cbc:PostalZone and cac:Country/cbc:IdentificationCode)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R005]-A Delivery address in an invoice SHOULD contain at least, city, zip code and country code.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:AccountingCustomerParty/cac:Party" priority="1002" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingCustomerParty/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R002]-A customer postal address in an invoice SHOULD contain at least, Street name and number, city name, zip code and country code.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:Item/cac:ClassifiedTaxCategory" priority="1001" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Item/cac:ClassifiedTaxCategory"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount and cbc:ID) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount and cbc:ID) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R011]-If the VAT total amount in an invoice exists then each invoice line item MUST have a VAT category ID.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:AllowanceCharge" priority="1000" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AllowanceCharge"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT')) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])) and (local-name(parent:: node())=&#34;Invoice&#34;)) or not(local-name(parent:: node())=&#34;Invoice&#34;)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount) and (cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT')) or not((//cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])) and (local-name(parent:: node())=&#34;Invoice&#34;)) or not(local-name(parent:: node())=&#34;Invoice&#34;)">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R006]-If the VAT total amount in an invoice exists then an Allowances Charges amount on document level MUST have Tax category for VAT.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="number(cbc:Amount)&gt;=0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(cbc:Amount)&gt;=0">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R022]-An allowance or charge amount MUST NOT be negative.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:AllowanceChargeReason)"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:AllowanceChargeReason)">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R023]-AllowanceChargeReason text SHOULD be specified for all allowances and charges</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) &gt;=0"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:MultiplierFactorNumeric) or number(cbc:MultiplierFactorNumeric) &gt;=0">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R012]-An allowance percentage MUST NOT be negative.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount)) "/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:MultiplierFactorNumeric and cbc:BaseAmount) or (not(cbc:MultiplierFactorNumeric) and not(cbc:BaseAmount))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EUGEN-T10-R013]-In allowances, both or none of percentage and base amount SHOULD be provided</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M15"/>
   <axsl:template match="@*|node()" priority="-2" mode="M15">
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M15"/>
   </axsl:template>

<!--PATTERN NONATUBL-T10-->


	<!--RULE -->

   <axsl:template match="//cac:AccountingSupplierParty/cac:Party" priority="1003" mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:AccountingSupplierParty/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NONAT-T10-R001]-The Norwegian legal registration ID for the supplier MUST be provided according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 2"</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NONAT-T10-R006]-A supplier postal address in an invoice MUST contain at least, Street name, city name, zip code and country code.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:InvoiceLine" priority="1002" mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="cbc:InvoicedQuantity and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:InvoicedQuantity and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NONAT-T10-R005]-Each invoice line MUST contain a quantity according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 3" </svrl:text>
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
         <axsl:when test="//cac:PaymentMeans/cbc:PaymentDueDate and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//cac:PaymentMeans/cbc:PaymentDueDate and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
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
         <axsl:when test="//cac:Delivery/cbc:ActualDeliveryDate and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//cac:Delivery/cbc:ActualDeliveryDate and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NONAT-T10-R003]-The actual delivery date  MUST be provided in the invoice according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 4" </svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="//cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName and //cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone and //cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="//cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName and //cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone and //cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NONAT-T10-R004]-A Delivery address in an invoice MUST contain at least, city, zip code and country code according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 4"</svrl:text>
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
         <axsl:when test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PostalAddress/cbc:StreetName and cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NONAT-T10-R007]-A customer postal address in an invoice MUST contain at least, Street name, city name, zip code and country code.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M16"/>
   <axsl:template match="@*|node()" priority="-2" mode="M16">
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M16"/>
   </axsl:template>

<!--PATTERN NOGOVUBL-T10-->


	<!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party" priority="1006" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:AccountingSupplierParty/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:Contact/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Contact/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R001]-A contact reference identifier SHOULD be provided for AccountingSupplierParty according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PostalAddress/cac:Country/cbc:IdentificationCode != '')"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PostalAddress/cac:Country/cbc:IdentificationCode != '')">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R014]-Country code for the supplier address MUST be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:PaymentMeans" priority="1005" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:PaymentMeans"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PayeeFinancialAccount/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PayeeFinancialAccount/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R011]-PayeeFinancialAccount MUST be provided  according EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:PaymentID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:PaymentID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R012]-Payment Identifier (KID number) SHOULD be used according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:OrderReference" priority="1004" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:OrderReference"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(child::cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(child::cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R013]-An association to Order Reference SHOULD be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:Item" priority="1003" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:Item"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:SellersItemIdentification/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:SellersItemIdentification/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R002]-The sellers ID for the item SHOULD be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(number(cac:ClassifiedTaxCategory/cbc:Percent) &gt;=0) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(number(cac:ClassifiedTaxCategory/cbc:Percent) &gt;=0) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R008]-The item's tax rate, expressed as a percentage MUST be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="//cac:InvoiceLine" priority="1002" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:InvoiceLine"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cbc:AccountingCost) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:AccountingCost) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
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
         <axsl:when test="(cac:OrderLineReference/cbc:LineID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:OrderLineReference/cbc:LineID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R004]-An association to Order Line Reference SHOULD be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(child::cbc:InvoicedQuantity/@unitCode != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(child::cbc:InvoicedQuantity/@unitCode != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R010]-The unit qualifier of the invoiced quantity SHOULD be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice" priority="1001" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:ContractDocumentReference/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:ContractDocumentReference/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R005]-ContractDocumentReference SHOULD be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Invoice/cac:AccountingCustomerParty/cac:Party"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PartyIdentification/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PartyIdentification/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
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
         <axsl:when test="(cac:Contact/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:Contact/cbc:ID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R007]-A contact reference identifier MUST be provided for AccountingCustomerParty according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[NOGOV-T10-R009]-PartyLegalEntity for AccountingCustomerParty MUST be provided according to EHF.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M17"/>
   <axsl:template match="@*|node()" priority="-2" mode="M17">
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M17"/>
   </axsl:template>

<!--PATTERN BIIRULESCodesT10-->


	<!--RULE -->

   <axsl:template match="cbc:InvoiceTypeCode" priority="1006" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:InvoiceTypeCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 380 393 ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' 380 393 ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[CL-010-001]-InvoiceTypeCode in an invoice MUST be 380 from UN/ECE 1001 code list</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:DocumentCurrencyCode" priority="1005" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:DocumentCurrencyCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[CL-010-002]-DocumentCurrencyCode MUST be coded using ISO code list 4217</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="@currencyID" priority="1004" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@currencyID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AED AFN ALL AMD ANG AOA ARS AUD AWG AZN BAM BBD BDT BGN BHD BIF BMD BND BOB BOV BRL BSD BTN BWP BYR BZD CAD CDF CHE CHF CHW CLF CLP CNY COP COU CRC CUP CVE CZK DJF DKK DOP DZD EEK EGP ERN ETB EUR FJD FKP GBP GEL GHS GIP GMD GNF GTQ GWP GYD HKD HNL HRK HTG HUF IDR ILS INR IQD IRR ISK JMD JOD JPY KES KGS KHR KMF KPW KRW KWD KYD KZT LAK LBP LKR LRD LSL LTL LVL LYD MAD MDL MGA MKD MMK MNT MOP MRO MUR MVR MWK MXN MXV MYR MZN NAD NGN NIO NOK NPR NZD OMR PAB PEN PGK PHP PKR PLN PYG QAR RON RSD RUB RWF SAR SBD SCR SDG SEK SGD SHP SKK SLL SOS SRD STD SVC SYP SZL THB TJS TMM TND TOP TRY TTD TWD TZS UAH UGX USD USN USS UYI UYU UZS VEF VND VUV WST XAF XAG XAU XBA XBB XBC XBD XCD XDR XFU XOF XPD XPF XTS XXX YER ZAR ZMK ZWR ZWD ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[CL-010-003]-currencyID MUST be coded using ISO code list 4217</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:Country//cbc:IdentificationCode" priority="1003" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Country//cbc:IdentificationCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BL BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[CL-010-004]-Country codes in an invoice MUST be coded using ISO code list 3166-1</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxScheme//cbc:ID" priority="1002" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxScheme//cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK AAL ADD BOL CAP CAR COC CST CUD CVD ENV EXC EXP FET FRE GCN GST ILL IMP IND LAC LCN LDP LOC LST MCA MCD OTH PDB PDC PRF SCN SSS STT SUP SUR SWT TAC TOT TOX TTA VAD VAT ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' AAA AAB AAC AAD AAE AAF AAG AAH AAI AAJ AAK AAL ADD BOL CAP CAR COC CST CUD CVD ENV EXC EXP FET FRE GCN GST ILL IMP IND LAC LCN LDP LOC LST MCA MCD OTH PDB PDC PRF SCN SSS STT SUP SUR SWT TAC TOT TOX TTA VAD VAT ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[CL-010-005]-Invoice tax schemes MUST be coded using UN/ECE 5153 code list</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:PaymentMeans//cbc:PaymentMeansCode" priority="1001" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:PaymentMeans//cbc:PaymentMeansCode"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 60 61 62 63 64 65 66 67 70 74 75 76 77 78 91 92 93 94 95 96 97 ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 60 61 62 63 64 65 66 67 70 74 75 76 77 78 91 92 93 94 95 96 97 ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[CL-010-006]-Payment means in an invoice MUST be coded using CEFACT code list 4461</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:TaxCategory//cbc:ID" priority="1000" mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:TaxCategory//cbc:ID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' A AA AB AC AD AE B C E G H O S Z ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' A AA AB AC AD AE B C E G H O S Z ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[CL-010-007]-Invoice tax categories MUST be coded using UN/ECE 5305 code list</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M18"/>
   <axsl:template match="@*|node()" priority="-2" mode="M18">
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M18"/>
   </axsl:template>

<!--PATTERN EUGENCodesT10-->


	<!--RULE -->

   <axsl:template match="cac:FinancialInstitution/cbc:ID//@schemeID" priority="1006" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:FinancialInstitution/cbc:ID//@schemeID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' BIC ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' BIC ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[PCL-010-002]-If FinancialAccountID is IBAN then Financial InstitutionID SHOULD be BIC code.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:PostalAddress/cbc:ID//@schemeID" priority="1005" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:PostalAddress/cbc:ID//@schemeID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[PCL-010-003]-Postal address identifiers SHOULD be GLN.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID" priority="1004" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[PCL-010-004]-Location identifiers SHOULD be GLN</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID" priority="1003" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Item/cac:StandardItemIdentification/cbc:ID//@schemeID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' GTIN ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' GTIN ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[PCL-010-005]-Standard item identifiers SHOULD be GTIN.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID" priority="1002" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:Item/cac:CommodityClassification/cbc:ItemClassificationCode//@listID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' UNSPSC eCLASS CPV ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' UNSPSC eCLASS CPV ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[PCL-010-006]-Commodity classification SHOULD be one of UNSPSC, eClass or CPV.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cac:PartyIdentification/cbc:ID//@schemeID" priority="1001" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:PartyIdentification/cbc:ID//@schemeID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[PCL-010-008]-Party Identifiers MUST use the PEPPOL PartyID list</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19"/>
   </axsl:template>

	<!--RULE -->

   <axsl:template match="cbc:EndpointID//@schemeID" priority="1000" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cbc:EndpointID//@schemeID"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ',concat(' ',normalize-space(.),' ') ) ) )"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN DUNS IBAN DK:CPR DK:CVR DK:P DK:SE DK:VANS IT:VAT IT:CF IT:FTI IT:SIA IT:SECETI NO:ORGNR NO:VAT HU:VAT SE:ORGNR FI:OVT EU:VAT EU:REID FR:SIRET AT:VAT AT:GOV AT:CID IS:KT IBAN AT:KUR ES:VAT ',concat(' ',normalize-space(.),' ') ) ) )">
               <axsl:attribute name="flag">fatal</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[PCL-010-009]-Endpoint Identifiers MUST use the PEPPOL PartyID list.</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19"/>
   </axsl:template>
   <axsl:template match="text()" priority="-1" mode="M19"/>
   <axsl:template match="@*|node()" priority="-2" mode="M19">
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M19"/>
   </axsl:template>
</axsl:stylesheet>