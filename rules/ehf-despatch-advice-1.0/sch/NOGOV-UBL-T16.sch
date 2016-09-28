<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        schemaVersion="iso" queryBinding="xslt2">

   <title>Norwegian rules for EHF Despatch Advice</title>

   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" prefix="ubl"/>

   <pattern>
      <rule context="/ubl:DespatchAdvice">
         <assert id="NOGOV-T16-R001" test="(cbc:UBLVersionID != '')" flag="fatal">A despatch advice MUST have a syntax identifier.</assert>
         <assert id="NOGOV-T16-R011"
                 test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"
                 flag="fatal">A despatch advice MUST not contain empty elements.</assert>
      </rule>
      <rule context="//cac:Country">
         <assert id="NOGOV-T16-R002"
                 test="(cbc:IdentificationCode !='')"
                 flag="fatal">Identification code MUST be specified when describing a country.</assert>
      </rule>
      <rule context="//cac:DespatchSupplierParty">
         <assert id="NOGOV-T16-R003" test="(cac:Party !='')" flag="fatal">If despatch supplier element is present, party must be specified</assert>
      </rule>
      <rule context="//cac:DeliverCustomerParty">
         <assert id="NOGOV-T16-R004" test="(cac:Party !='')" flag="fatal">If deliver customer element is present, party must be specified</assert>
      </rule>
      <rule context="//cac:BuyerCustomerParty">
         <assert id="NOGOV-T16-R005" test="(cac:Party !='')" flag="fatal">If buyer customer element is present, party must be specified</assert>
      </rule>
      <rule context="//cac:OriginatorCustomerParty">
         <assert id="NOGOV-T16-R006" test="(cac:Party !='')" flag="fatal">If originator customer element is present, party must be specified</assert>
      </rule>
      <rule context="//cac:CarrierParty/cac:Person">
         <assert id="NOGOV-T16-R007"
                 test="(cac:IdentityDocumentReference !='')"
                 flag="fatal">If carrier person element is present, identity must be specified</assert>
      </rule>
      <rule context="//*[contains(name(),'Date')]">
         <assert id="NOGOV-T16-R008"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">A date must be formatted YYYY-MM-DD.</assert>
      </rule>
      <rule context="//cac:Party/cbc:EndpointID">
         <assert id="NOGOV-T16-R009" test="@schemeID = 'NO:ORGNR'" flag="fatal">An endpoint identifier scheme MUST have the value 'NO:ORGNR'.</assert>
         <assert id="NOGOV-T16-R010"
                 test="(string(.) castable as xs:integer) and (string-length(.) = 9)"
                 flag="fatal">MUST be a norwegian organizational number. Only numerical value allowed</assert>
      </rule>
      <rule context="//cbc:ProfileID">
         <assert id="EHFPROFILE-T16-R001"
                 test=". = 'urn:www.cenbii.eu:profile:bii30:ver2.0'"
                 flag="fatal">A despatch advice must only be used in profile 30</assert>
      </rule>
   </pattern>
</schema>
