<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:u="utils"
        schemaVersion="iso" queryBinding="xslt2">

   <title>Norwegian rules for EHF Despatch Advice</title>

   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" prefix="ubl"/>
   <ns uri="utils" prefix="u"/>

   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod11">
     <param name="val"/>
     <variable name="length" select="string-length($val) - 1"/>
     <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
     <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
     <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
   </function>

   <pattern>
      <rule context="/ubl:DespatchAdvice">
         <assert id="NOGOV-T16-R001" test="(cbc:UBLVersionID != '')" flag="fatal">[NOGOV-T16-R001]-A despatch advice MUST have a syntax identifier.</assert>
         <assert id="NOGOV-T16-R011"
                 test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"
                 flag="fatal">[NOGOV-T16-R011]-A despatch advice MUST not contain empty elements.</assert>
      </rule>
      <rule context="//cac:Country">
         <assert id="NOGOV-T16-R002"
                 test="(cbc:IdentificationCode !='')"
                 flag="fatal">[NOGOV-T16-R002]-Identification code MUST be specified when describing a country.</assert>
      </rule>
      <rule context="//cac:DespatchSupplierParty">
         <assert id="NOGOV-T16-R003" test="(cac:Party !='')" flag="fatal">[NOGOV-T16-R003]-If despatch supplier element is present, party must be specified</assert>
      </rule>
      <rule context="//cac:DeliverCustomerParty">
         <assert id="NOGOV-T16-R004" test="(cac:Party !='')" flag="fatal">[NOGOV-T16-R004]-If deliver customer element is present, party must be specified</assert>
      </rule>
      <rule context="//cac:BuyerCustomerParty">
         <assert id="NOGOV-T16-R005" test="(cac:Party !='')" flag="fatal">[NOGOV-T16-R005]-If buyer customer element is present, party must be specified</assert>
      </rule>
      <rule context="//cac:OriginatorCustomerParty">
         <assert id="NOGOV-T16-R006" test="(cac:Party !='')" flag="fatal">[NOGOV-T16-R006]-If originator customer element is present, party must be specified</assert>
      </rule>
      <rule context="//cac:CarrierParty/cac:Person">
         <assert id="NOGOV-T16-R007"
                 test="(cac:IdentityDocumentReference !='')"
                 flag="fatal">[NOGOV-T16-R007]-If carrier person element is present, identity must be specified</assert>
      </rule>
      <rule context="//*[contains(name(),'Date')]">
         <assert id="NOGOV-T16-R008"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">[NOGOV-T16-R008]-A date must be formatted YYYY-MM-DD.</assert>
      </rule>
      <rule context="//cac:Party/cbc:EndpointID">
         <assert id="NOGOV-T16-R009" test="@schemeID = 'NO:ORGNR'" flag="fatal">[NOGOV-T16-R009]-An endpoint identifier scheme MUST have the value 'NO:ORGNR'.</assert>
         <assert id="NOGOV-T16-R010"
                 test="(string(.) castable as xs:integer) and (string-length(.) = 9) and xs:boolean(u:mod11(.))"
                 flag="fatal">[NOGOV-T16-R010]-MUST be a norwegian organizational number. Only numerical value allowed</assert>
      </rule>
      <rule context="//cbc:ProfileID">
         <assert id="EHFPROFILE-T16-R001"
                 test=". = 'urn:www.cenbii.eu:profile:bii30:ver2.0'"
                 flag="fatal">[EHFPROFILE-T16-R001]-A despatch advice must only be used in profile 30</assert>
      </rule>
   </pattern>
</schema>
