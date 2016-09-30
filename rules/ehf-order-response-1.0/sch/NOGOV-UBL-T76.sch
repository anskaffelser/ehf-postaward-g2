<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        schemaVersion="iso" queryBinding="xslt2">

   <title>Norwegian rules for EHF Order Response</title>

   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:OrderResponse-2" prefix="ubl"/>

   <pattern>
      <rule context="/ubl:OrderResponse">
         <assert id="NOGOV-T76-R007" test="(cbc:UBLVersionID != '')" flag="fatal">An order response MUST have a syntax identifier.</assert>
         <assert id="NOGOV-T76-R010"
                 test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"
                 flag="fatal">An order response MUST not contain empty elements.</assert>
      </rule>
      <rule context="//*[contains(name(),'Date')]">
         <assert id="NOGOV-T76-R001"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">A date must be formatted YYYY-MM-DD.</assert>
      </rule>
      <rule context="//cac:Party/cbc:EndpointID">
         <assert id="NOGOV-T76-R002" test="@schemeID = 'NO:ORGNR'" flag="fatal">An endpoint identifier scheme MUST have the value 'NO:ORGNR'.</assert>
         <assert id="NOGOV-T76-R003"
                 test="(string(.) castable as xs:integer) and (string-length(.) = 9)"
                 flag="fatal">MUST be a norwegian organizational number. Only numerical value allowed</assert>
      </rule>
      <rule context="//cac:BuyerCustomerParty">
         <assert id="NOGOV-T76-R005" test="cac:Party/cbc:EndpointID" flag="warning">A buyer should have an EndpointID.</assert>
      </rule>
      <rule context="//cac:SellerSupplierParty">
         <assert id="NOGOV-T76-R006" test="cac:Party/cbc:EndpointID" flag="warning">A seller should have an EndpointID.</assert>
      </rule>
      <rule context="//cac:TaxScheme">
         <assert id="NOGOV-T76-R008" test="cbc:ID" flag="fatal">Every tax scheme MUST be defined through an identifier.</assert>
      </rule>
      <rule context="//cac:Delivery">
         <assert id="NOGOV-T76-R004" test="cac:PromisedDeliveryPeriod" flag="fatal">Information on promised delivery period must be filled if element Delivery exists.</assert>
      </rule>
      <rule context="//cac:Item/cac:AdditionalItemProperty">
         <assert id="NOGOV-T76-R009" test="(cbc:Value != '')" flag="fatal">Value must be filled if additional item property is present.</assert>
      </rule>
      <rule context="//cbc:ProfileID">
         <assert id="EHFPROFILE-T76-R001"
                 test=". = 'urn:www.cenbii.eu:profile:bii28:ver2.0'"
                 flag="fatal">An order response must only be used in profile 28</assert>
      </rule>
   </pattern>
</schema>
