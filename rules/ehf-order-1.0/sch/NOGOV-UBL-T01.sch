<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:u="utils"
        schemaVersion="iso" queryBinding="xslt2">

   <title>Norwegian rules for EHF Order</title>

   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:Order-2" prefix="ubl"/>
   <ns uri="utils" prefix="u"/>

   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod11">
     <param name="val"/>
     <variable name="length" select="string-length($val) - 1"/>
     <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
     <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
     <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
   </function>

   <pattern>
      <rule context="/ubl:Order">
         <assert id="NOGOV-T01-R002"
                 test="cac:BuyerCustomerParty/cac:Party"
                 flag="fatal">[NOGOV-T01-R002]-An order MUST contain buyer information</assert>
         <assert id="NOGOV-T01-R018"
                 test="cac:SellerSupplierParty/cac:Party"
                 flag="fatal">[NOGOV-T01-R018]-An order MUST contain seller information</assert>
         <assert id="NOGOV-T01-R012"
                 test="(cbc:UBLVersionID != '')"
                 flag="fatal">[NOGOV-T01-R012]-An order MUST have a syntax identifier.</assert>
         <assert id="NOGOV-T01-R006"
                 test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"
                 flag="fatal">[NOGOV-T01-R006]-An order MUST not contain empty elements.</assert>
      </rule>
      <rule context="//cac:OrderLine/cac:LineItem">
         <assert id="NOGOV-T01-R005"
                 test="cbc:Quantity"
                 flag="fatal">[NOGOV-T01-R005]-An order line item MUST have a quantity</assert>
      </rule>
      <rule context="//cac:BuyerCustomerParty">
         <assert id="NOGOV-T01-R001"
                 test="string-length(cac:Party/cac:Contact/cbc:ID) &gt;0"
                 flag="warning">[NOGOV-T01-R001]-Kundens referanse BØR fylles ut i henhold til norske krav -- Customer reference SHOULD have a value</assert>
      </rule>
      <rule context="//*[contains(name(),'Date')]">
         <assert id="NOGOV-T01-R007"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">[NOGOV-T01-R007]-A date must be formatted YYYY-MM-DD.</assert>
      </rule>
      <rule context="//cac:PartyLegalEntity/cbc:CompanyID">
         <assert id="NOGOV-T01-R010"
                 test="(string-length(.) = 9) and (string(.) castable as xs:integer) and xs:boolean(u:mod11(.))"
                 flag="fatal">[NOGOV-T01-R010]-A valid Norwegian organization number MUST be nine numbers.</assert>
      </rule>
      <rule context="//cac:PartyTaxScheme/cbc:CompanyID">
         <assert id="NOGOV-T01-R011"
                 test="(string-length(.) = 12) and (substring(.,1,9) castable as xs:integer) and xs:boolean(u:mod11(substring(., 1, 9))) and (substring(.,10,12)='MVA')"
                 flag="fatal">[NOGOV-T01-R011]-A VAT number MUST be a valid Norwegian organization number (nine numbers) followed by the letters MVA.</assert>
      </rule>
      <rule context="//cac:Party/cbc:EndpointID">
         <assert id="NOGOV-T01-R008"
                 test="@schemeID = 'NO:ORGNR'"
                 flag="fatal">[NOGOV-T01-R008]-An endpoint identifier scheme MUST have the value 'NO:ORGNR'.</assert>
         <assert id="NOGOV-T01-R009"
                 test="(string(.) castable as xs:integer) and (string-length(.) = 9) and xs:boolean(u:mod11(.))"
                 flag="fatal">[NOGOV-T01-R009]-MUST be a valid Norwegian organization number. Only numerical value allowed</assert>
      </rule>
      <rule context="//cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference">
         <assert id="NOGOV-T01-R013"
                 test="(cbc:URI !='')"
                 flag="fatal">[NOGOV-T01-R013]-URI MUST be specified when describing external reference documents.</assert>
      </rule>
      <rule context="//cac:Contract">
         <assert id="NOGOV-T01-R014"
                 test="(cbc:ID !='')"
                 flag="fatal">[NOGOV-T01-R014]-Contract ID MUST be specified when referencing contracts.</assert>
      </rule>
      <rule context="//cac:PartyTaxScheme">
         <assert id="NOGOV-T01-R016"
                 test="(cbc:CompanyID !='')"
                 flag="fatal">[NOGOV-T01-R016]-VAT identifier MUST be specified when VAT information is present</assert>
      </rule>
      <rule context="//cac:TaxScheme">
         <assert id="NOGOV-T01-R017"
                 test="cbc:ID"
                 flag="fatal">[NOGOV-T01-R017]-Every tax scheme MUST be defined through an identifier.</assert>
      </rule>
      <rule context="//cac:Country">
         <assert id="NOGOV-T01-R015"
                 test="(cbc:IdentificationCode !='')"
                 flag="fatal">[NOGOV-T01-R015]-Identification code MUST be specified when describing a country.</assert>
      </rule>
      <rule context="//cac:OriginatorCustomerParty">
         <assert id="NOGOV-T01-R019"
                 test="(cac:Party !='')"
                 flag="fatal">[NOGOV-T01-R019]-If originator element is present, party must be specified</assert>
      </rule>
      <rule context="//cac:AccountingCustomerParty">
         <assert id="NOGOV-T01-R020"
                 test="(cac:Party !='')"
                 flag="fatal">[NOGOV-T01-R020]-If invoicee element is present, party must be specified</assert>
      </rule>
      <rule context="@mimeCode">
         <assert id="NOGOV-T01-R021"
                 test="(( . = 'application/pdf' or . = 'image/gif' or . = 'image/tiff' or . = 'image/jpeg' or . = 'image/png' or . = 'text/plain' ))"
                 flag="warning">[NOGOV-T01-R021]-Attachment is not a recommended MIMEType.</assert>
      </rule>
      <rule context="//cac:ClassifiedTaxCategory">
         <assert id="NOGOV-T01-R004"
                 test="(cbc:ID !='')"
                 flag="fatal">[NOGOV-T01-R004]-If classified tax category is present, VAT category code must be specified</assert>
      </rule>
      <rule context="//cac:CommodityClassification">
         <assert id="NOGOV-T01-R003"
                 test="(cbc:ItemClassificationCode !='')"
                 flag="fatal">[NOGOV-T01-R003]-If product classification element is present, classification code must be specified</assert>
      </rule>
      <rule context="//cbc:ProfileID">
         <assert id="EHFPROFILE-T01-R001"
                 test=". = 'urn:www.cenbii.eu:profile:bii28:ver2.0'"
                 flag="fatal">[EHFPROFILE-T01-R001]-An order must only be used in profile 28</assert>
      </rule>
   </pattern>
</schema>
