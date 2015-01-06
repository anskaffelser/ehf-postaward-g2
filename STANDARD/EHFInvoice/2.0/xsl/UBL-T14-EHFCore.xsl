<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
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
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Sjekk mot Bii Core " schemaVersion="">
         <axsl:comment>
            <axsl:value-of select="$archiveDirParameter"/>   
		 <axsl:value-of select="$archiveNameParameter"/>  
		 <axsl:value-of select="$fileNameParameter"/>  
		 <axsl:value-of select="$fileDirParameter"/>
         </axsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
         <svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl"/>
         <svrl:active-pattern>
            <axsl:attribute name="id">EHFCOREUBL-T14</axsl:attribute>
            <axsl:attribute name="name">EHFCOREUBL-T14</axsl:attribute>
            <axsl:apply-templates/>
         </svrl:active-pattern>
         <axsl:apply-templates select="/" mode="M12"/>
       </svrl:schematron-output>
   </axsl:template>

<!--SCHEMATRON PATTERNS-->

   <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Sjekk mot EHF Core</svrl:text>

<!--PATTERN BIICOREUBL-T14-->


	<!--RULE -->

   <axsl:template match="/ubl:CreditNote" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:CreditNote"/>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:CopyIndicator)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:UUID)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:IssueTime)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:IssueTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:TaxPointDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:TaxPointDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:PricingCurrencyCode)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PricingCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:PaymentCurrencyCode)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PaymentCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:PaymentAlternativeCurrencyCode)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:PaymentAlternativeCurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:AccountingCostCode)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cbc:LineCountNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cbc:LineCountNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:BillingReference/cac:SelfBilledInvoiceDocumentReference) or not(cac:BillingReference/cac:DebitNoteDocumentReference) or not(cac:BillingReference/cac:ReminderDocumentReference) or not(AdditionalDocumentReference) or not(BillingReferenceLine) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:CopyIndicator) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentType) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:XPath) or not(cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:CopyIndicator) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:UUID) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:IssueDate) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:DocumentTypeCode) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:DocumentType) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:XPath) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cac:Attachment)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:BillingReference/cac:SelfBilledInvoiceDocumentReference) or not(cac:BillingReference/cac:DebitNoteDocumentReference) or not(cac:BillingReference/cac:ReminderDocumentReference) or not(AdditionalDocumentReference) or not(BillingReferenceLine) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:CopyIndicator) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:UUID) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:IssueDate) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentTypeCode) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:DocumentType) or not(cac:BillingReference/cac:InvoiceDocumentReference/cbc:XPath) or not(cac:BillingReference/cac:InvoiceDocumentReference/cac:Attachment) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:CopyIndicator) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:UUID) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:IssueDate) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:DocumentTypeCode) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:DocumentType) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cbc:XPath) or not(cac:BillingReference/cac:CreditNoteDocumentReference/cac:Attachment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:DespatchDocumentReference)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:DespatchDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ReceiptDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ReceiptDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OriginatorDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OriginatorDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Signature) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Signature) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:BuyerCustomerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:BuyerCustomerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:SellerSupplierParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:SellerSupplierParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>



		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:DeliveryTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:DeliveryTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PrepaidPayment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PrepaidPayment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PricingExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PricingExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentAlternativeExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentAlternativeExchangeRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNotePeriod/cbc:StartTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNotePeriod/cbc:StartTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNotePeriod/cbc:EndTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNotePeriod/cbc:EndTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNotePeriod/cbc:DurationMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNotePeriod/cbc:DurationMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNotePeriod/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNotePeriod/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNotePeriod/cbc:DescriptionCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNotePeriod/cbc:DescriptionCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:SalesOrderID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:SalesOrderID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:CopyIndicator)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:UUID)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:IssueDate)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:IssueTime)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:IssueTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cbc:CustomerReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cbc:CustomerReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:OrderReference/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:OrderReference/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ContractDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:CopyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ContractDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ContractDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ContractDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:ContractDocumentReference/cac:Attachment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:ContractDocumentReference/cac:Attachment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cbc:CooyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:CooyIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:IssueDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:DocumentTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cbc:XPath) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:DocumentHash) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference/cbc:ExpiryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cbc:DataSendingCapability) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cbc:DataSendingCapability) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:DespatchContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:DespatchContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:SellerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:SellerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->
<!-- 2013-05-14 EG Commented out
      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
-->
		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingSupplierParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:SupplierAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:CustomerAssignedAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cbc:AdditionalAccountID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:DeliveryContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:DeliveryContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:AccountingContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:BuyerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:BuyerContact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PostalAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:TaxLevelCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:ExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Postbox) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:StreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:AdditionalStreetName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:BuildingNumber) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:PostalZone) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:RegistrationAddress/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->
		<!-- 2013-05-14 EG Commented out
      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
-->
		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cbc:Note) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Contact/cac:OtherCommunication) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:Title) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:NameSuffix) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:Person/cbc:OrganizationDepartment) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AccountingCustomerParty/cac:Party/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:MarkCareIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:MarkAttentionIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:WebsiteURI) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cbc:LogoReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Language) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PostalAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PostalAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PhysicalLocation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PartyTaxScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyTaxScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cbc:RegistrationName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:RegistrationAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:PartyLegalEntity/cac:CorporateRegistrationScheme) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:Contact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Contact) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:Person) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:Person) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PayeeParty/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PayeeParty/cac:AgentParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:Quantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:Quantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:MinimumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:MinimumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:MaximumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:MaximumQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:ActualDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:ActualDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:LatestDeliveryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:LatestDeliveryDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:LatestDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:LatestDeliveryTime) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cbc:TrackingID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cbc:TrackingID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Description) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:Conditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:AddressFormatCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Floor) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Room) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BlockName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:BuildingName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:InhouseMail) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Department) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkAttention) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:MarkCare) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PlotIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CitySubdivisionName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CountrySubentityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:Region) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:District) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:TimezoneOffset) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:AddressLine) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Address/cac:LocationCoordinate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:RequestedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:RequestedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:PromisedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:PromisedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:EstimatedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:EstimatedDeliveryPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:DeliveryParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:Delivery/cac:DeliveryLocation/cac:Despatch) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:Delivery/cac:DeliveryLocation/cac:Despatch) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cbc:InstructionID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:InstructionID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cbc:InstructionNote) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cbc:InstructionNote) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:CardAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CardAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayerFinancialAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayerFinancialAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:CreditAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:CreditAccount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:AccountTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:Country) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentMeans/cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:PaymentMeansID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PaymentMeansID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PrepaidPaymentReferenceID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:ReferenceEventCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:ReferenceEventCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:SettlementDiscountPercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:SettlementDiscountPercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:PenaltySurchargePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:PenaltySurchargePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cbc:Amount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cbc:Amount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cac:SettlementPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cac:SettlementPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:PaymentTerms/cac:PenaltyPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:PaymentTerms/cac:PenaltyPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>


		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:MultiplierFactorNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:BaseAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:CalculationSequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:Percent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:PerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cbc:TaxPointDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cbc:TaxPointDate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cbc:FreeOfChargeIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cbc:FreeOfChargeIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:OrderLineReference/cbc:SalesOrderLineID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:OrderLineReference/cbc:SalesOrderLineID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:DespatchLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:DespatchLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:ReceiptLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:ReceiptLineReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>


		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:DocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:PricingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:PricingReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:OriginatorParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:OriginatorParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:PaymentTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:PaymentTerms) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:TaxTotal/cbc:RoundingAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:TaxTotal/cbc:TaxEvidenceIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:TaxTotal/cac:TaxSubtotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cbc:PackQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cbc:PackQuantity) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cbc:PackSizeNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cbc:PackSizeNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cbc:CatalogueIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cbc:CatalogueIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cbc:HazardousRiskIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cbc:HazardousRiskIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cbc:AdditionalInformation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cbc:AdditionalInformation) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cbc:Keyword) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cbc:Keyword) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cbc:BrandName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cbc:BrandName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cbc:ModelName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cbc:ModelName) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:SellersItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:SellersItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:SellersItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:SellersItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:SellersItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:SellersItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:SellersItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:ExtendedID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:PhysycalAttribute) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:MeasurementDimension) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:StandardItemIdentification/cbc:IssuerParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:BuyersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:BuyersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:NatureCargo) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:NatureCargo) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:CargoTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:CommodityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:CommodityClassification/cbc:CommodityCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:ManufacturersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:ManufacturersItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:CatalogueItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:CatalogueItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:AdditionalItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:AdditionalItemIdentification) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:CatalogueDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:CatalogueDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:ItemSpecificationDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:ItemSpecificationDocumentReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TransactionConditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TransactionConditions) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:HazardousItem) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:HazardousItem) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>


		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:InformationContentProviderParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:InformationContentProviderParty) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:OriginAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:OriginAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:ItemInstance) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:ItemInstance) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:BaseUnitMeasure) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbcPerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbcPerUnitAmount) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:TaxExemptionReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:TierRange) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cbc:TierRatePercent) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:Name) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:UsabilityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:UsabilityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:ItemPropertyGroup) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Item/cac:TaxCategory/cac:AdditionalProperty/cac:ItemPropertyGroup) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cbc:PriceChangeReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cbc:PriceChangeReason) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cbc:PriceTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cbc:PriceTypeCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cbc:PriceType) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cbc:PriceType) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cbc:OrderableUnitFactorRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cbc:OrderableUnitFactorRate) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cac:ValidityPeriod) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cac:PriceList) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cac:PriceList) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:ID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:AllowanceChargeReasonCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:PrepaidIndicator) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:SequenceNumeric) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCostCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cbc:AccountingCost) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress)  and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Name) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:Percent) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:BaseUnitMeasure) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:PerUnitAmount) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReasonCode) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TaxExemptionReason) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRange) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cbc:TierRatePercent) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:Name) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:TaxTypeCode) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cbc:CurrencyCode) or not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxCategory/cac:TaxScheme/cac:JurisdictionRegionAddress) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:TaxTotal) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:Price/cac:AllowanceCharge/cac:PaymentMeans) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:OrderLineReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:OrderLineReference/cbc:UUID) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:OrderLineReference/cbc:LineStatusCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:OrderLineReference/cbc:LineStatusCode) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>

		<!--ASSERT -->

      <axsl:choose>
         <axsl:when test="not(cac:CreditNoteLine/cac:OrderLineReference/cac:OrderReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
         <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(cac:CreditNoteLine/cac:OrderLineReference/cac:OrderReference) and contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
               <axsl:attribute name="flag">warning</axsl:attribute>
               <axsl:attribute name="location">
                  <axsl:apply-templates select="." mode="schematron-get-full-path"/>
               </axsl:attribute>
               <svrl:text>[EHFCORE-T14-R001]-Elements used SHOULD be according to EHF specifications</svrl:text>
            </svrl:failed-assert>
         </axsl:otherwise>
      </axsl:choose>
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>
   
   <!--CARDINALITY CHECKS-->
	<axsl:template match="/ubl:CreditNote/cac:AccountingCustomerParty/cac:Party" priority="1007" mode="M12">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:CreditNote/cac:AccountingCustomerParty/cac:Party"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="/ubl:CreditNote/cac:AccountingSupplierParty/cac:Party" priority="1006" mode="M12">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:CreditNote/cac:AccountingSupplierParty/cac:Party"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyName)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:PostalAddress)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PostalAddress)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyTaxScheme)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="/ubl:CreditNoteLine" priority="1005" mode="M12">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:CreditNoteLine"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:TaxTotal)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:TaxTotal)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:Price)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:Price)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="/ubl:CreditNote/cac:InvoiceLine/cac:Item" priority="1004" mode="M12">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:CreditNote/cac:InvoiceLine/cac:Item"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cbc:Description)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:Description)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cbc:Name)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:Name)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:ClassifiedTaxCategory)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:ClassifiedTaxCategory)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="/ubl:CreditNote/cac:InvoiceLine/cac:Price" priority="1003" mode="M12">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:CreditNote/cac:InvoiceLine/cac:Price"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:AllowanceCharge)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:AllowanceCharge)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="/ubl:CreditNote/cac:LegalMonetaryTotal" priority="1002" mode="M12">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:CreditNote/cac:LegalMonetaryTotal"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cbc:TaxExclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:TaxExclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cbc:TaxInclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:TaxInclusiveAmount)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
	</axsl:template>
	
	
	
		<axsl:template match="/ubl:CreditNote/cac:InvoiceLine" priority="1007" mode="M12">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:CreditNote/cac:InvoiceLine"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:Delivery)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:Delivery)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>	
			<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
	</axsl:template>
	
	
	<!--RULE -->
	<axsl:template match="/ubl:CreditNote/cac:PayeeParty" priority="1001" mode="M12">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:CreditNote/cac:PayeeParty"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyIdentification)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cac:PartyName)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cac:PartyName)&lt;=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
	</axsl:template>
	<!--RULE -->
	<axsl:template match="/ubl:CreditNote/cac:PaymentMeans/cac:PayeeFinancialAccount" priority="1000" mode="M12">
		<svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:CreditNote/cac:PaymentMeans/cac:PayeeFinancialAccount"/>
		<!--ASSERT -->
		<axsl:choose>
			<axsl:when test="count(cbc:ID)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))"/>
			<axsl:otherwise>
				<svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cbc:ID)=1 and contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0') or not(contains(preceding::cbc:CustomizationID, 'urn:www.cenbii.eu:transaction:biitrns014:ver2.0'))">
					<axsl:attribute name="flag">warning</axsl:attribute>
					<axsl:attribute name="location">
						<axsl:apply-templates select="." mode="schematron-get-full-path"/>
					</axsl:attribute>
					<svrl:text>[EHFCORE-T14-R002]-Cardinality SHOULD be according to EHF specifications.</svrl:text>
				</svrl:failed-assert>
			</axsl:otherwise>
		</axsl:choose>
		<axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
	</axsl:template>
   <axsl:template match="text()" priority="-1" mode="M12"/>
   <axsl:template match="@*|node()" priority="-2" mode="M12">
      <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M12"/>
   </axsl:template>
</axsl:stylesheet>