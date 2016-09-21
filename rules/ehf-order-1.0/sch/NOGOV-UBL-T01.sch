<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        schemaVersion="iso" queryBinding="xslt2">

   <title>Norwegian rules for EHF Order</title>

   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:Order-2" prefix="ubl"/>

   <pattern>
      <rule context="/ubl:Order">
         <assert id="NOGOV-T01-R002"
                 test="cac:BuyerCustomerParty/cac:Party"
                 flag="fatal">An order MUST contain buyer information</assert>
         <assert id="NOGOV-T01-R018"
                 test="cac:SellerSupplierParty/cac:Party"
                 flag="fatal">An order MUST contain seller information</assert>
         <assert id="NOGOV-T01-R012" test="(cbc:UBLVersionID != '')" flag="fatal">An order MUST have a syntax identifier.</assert>
         <assert id="NOGOV-T01-R006"
                 test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"
                 flag="fatal">An order MUST not contain empty elements.</assert>
      </rule>
      <rule context="//cac:OrderLine/cac:LineItem">
         <assert id="NOGOV-T01-R005" test="cbc:Quantity" flag="fatal">An order line item MUST have a quantity</assert>
      </rule>
      <rule context="//cac:BuyerCustomerParty">
         <assert id="NOGOV-T01-R001"
                 test="string-length(cac:Party/cac:Contact/cbc:ID) &gt;0"
                 flag="warning">Kundens referanse BØR fylles ut i henhold til norske krav -- Customer reference SHOULD have a value</assert>
      </rule>
      <rule context="//*[contains(name(),'Date')]">
         <assert id="NOGOV-T01-R007"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">A date must be formatted YYYY-MM-DD.</assert>
      </rule>
      <rule context="//cac:PartyLegalEntity/cbc:CompanyID">
         <assert id="NOGOV-T01-R010"
                 test="(string-length(.) = 9) and (string(.) castable as xs:integer)"
                 flag="fatal">An organisational number MUST be nine numbers.</assert>
      </rule>
      <rule context="//cac:PartyTaxScheme/cbc:CompanyID">
         <assert id="NOGOV-T01-R011"
                 test="(string-length(.) = 12) and (substring(.,1,9) castable as xs:integer) and (substring(.,10,12)='MVA')"
                 flag="fatal">A VAT number MUST be nine numbers followed by the letters MVA.</assert>
      </rule>
      <rule context="//cac:Party/cbc:EndpointID">
         <assert id="NOGOV-T01-R008" test="@schemeID = 'NO:ORGNR'" flag="fatal">An endpoint identifier scheme MUST have the value 'NO:ORGNR'.</assert>
         <assert id="NOGOV-T01-R009"
                 test="(string(.) castable as xs:integer) and (string-length(.) = 9)"
                 flag="fatal">MUST be a norwegian organizational number. Only numerical value allowed</assert>
      </rule>
      <rule context="//cac:AdditionalDocumentReference/cac:Attachment/cac:ExternalReference">
         <assert id="NOGOV-T01-R013" test="(cbc:URI !='')" flag="fatal">URI MUST be specified when describing external reference documents.</assert>
      </rule>
      <rule context="//cac:Contract">
         <assert id="NOGOV-T01-R014" test="(cbc:ID !='')" flag="fatal">Contract ID MUST be specified when referencing contracts.</assert>
      </rule>
      <rule context="//cac:PartyTaxScheme">
         <assert id="NOGOV-T01-R016" test="(cbc:CompanyID !='')" flag="fatal">VAT identifier MUST be specified when VAT information is present</assert>
      </rule>
      <rule context="//cac:TaxScheme">
         <assert id="NOGOV-T01-R017" test="cbc:ID" flag="fatal">Every tax scheme MUST be defined through an identifier.</assert>
      </rule>
      <rule context="//cac:Country">
         <assert id="NOGOV-T01-R015"
                 test="(cbc:IdentificationCode !='')"
                 flag="fatal">Identification code MUST be specified when describing a country.</assert>
      </rule>
      <rule context="//cac:OriginatorCustomerParty">
         <assert id="NOGOV-T01-R019" test="(cac:Party !='')" flag="fatal">If originator element is present, party must be specified</assert>
      </rule>
      <rule context="//cac:AccountingCustomerParty">
         <assert id="NOGOV-T01-R020" test="(cac:Party !='')" flag="fatal">If invoicee element is present, party must be specified</assert>
      </rule>
      <rule context="@mimeCode">
         <assert id="NOGOV-T01-R021"
                 test="(( . = 'application/pdf' or . = 'image/gif' or . = 'image/tiff' or . = 'image/jpeg' or . = 'image/png' or . = 'text/plain' ))"
                 flag="warning">Attachment is not a recommended MIMEType.</assert>
      </rule>
      <rule context="//cac:ClassifiedTaxCategory">
         <assert id="NOGOV-T01-R004" test="(cbc:ID !='')" flag="fatal">If classified tax category is present, VAT category code must be specified</assert>
      </rule>
      <rule context="//cac:CommodityClassification">
         <assert id="NOGOV-T01-R003"
                 test="(cbc:ItemClassificationCode !='')"
                 flag="fatal">If product classification element is present, classification code must be specified</assert>
      </rule>
      <rule context="//cbc:ProfileID">
         <assert id="EHFPROFILE-T01-R001"
                 test=". = 'urn:www.cenbii.eu:profile:bii28:ver2.0'"
                 flag="fatal">An order must only be used in profile 28</assert>
      </rule>
   </pattern>
</schema>
