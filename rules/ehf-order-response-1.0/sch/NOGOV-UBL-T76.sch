<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:u="utils"
        schemaVersion="iso" queryBinding="xslt2">

   <title>Norwegian rules for EHF Order Response</title>

   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:OrderResponse-2" prefix="ubl"/>
   <ns uri="utils" prefix="u"/>

   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod11">
     <param name="val"/>
     <variable name="length" select="string-length($val) - 1"/>
     <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
     <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
     <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
   </function>

   <pattern>
      <rule context="/ubl:OrderResponse">
         <assert id="NOGOV-T76-R007"
                 test="cbc:UBLVersionID"
                 flag="fatal">[NOGOV-T76-R007]-An order response MUST have a syntax identifier.</assert>
         <assert id="NOGOV-T76-R010"
                 test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"
                 flag="fatal">[NOGOV-T76-R010]-An order response MUST not contain empty elements.</assert>
      </rule>
      <rule context="cbc:*[contains(name(),'Date')]">
         <assert id="NOGOV-T76-R001"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">[NOGOV-T76-R001]-A date must be formatted YYYY-MM-DD.</assert>
      </rule>
      <rule context="cac:Party/cbc:EndpointID">
         <assert id="NOGOV-T76-R002"
                 test="@schemeID = 'NO:ORGNR'"
                 flag="fatal">[NOGOV-T76-R002]-An endpoint identifier scheme MUST have the value 'NO:ORGNR'.</assert>
         <assert id="NOGOV-T76-R003"
                 test="(string(.) castable as xs:integer) and (string-length(.) = 9) and xs:boolean(u:mod11(.))"
                 flag="fatal">[NOGOV-T76-R003]-MUST be a valid Norwegian organization number. Only numerical value allowed</assert>
      </rule>
      <rule context="cac:BuyerCustomerParty">
         <assert id="NOGOV-T76-R005"
                 test="cac:Party/cbc:EndpointID"
                 flag="warning">[NOGOV-T76-R005]-A buyer should have an EndpointID.</assert>
      </rule>
      <rule context="cac:SellerSupplierParty">
         <assert id="NOGOV-T76-R006"
                 test="cac:Party/cbc:EndpointID"
                 flag="warning">[NOGOV-T76-R006]-A seller should have an EndpointID.</assert>
      </rule>
      <rule context="cac:TaxScheme">
         <assert id="NOGOV-T76-R008"
                 test="cbc:ID"
                 flag="fatal">[NOGOV-T76-R008]-Every tax scheme MUST be defined through an identifier.</assert>
      </rule>
      <rule context="cac:TaxCategory/cbc:ID">
         <assert id="NOGOV-T76-R011"
                 test="some $code in tokenize('AA E H K R S Z', '\s') satisfies $code = normalize-space(.)"
                 flag="fatal">[NOGOV-T76-R011]-Tax categories MUST be one of the follwoing codes:  AA E H K R S Z</assert>
      </rule>
      <rule context="cac:Delivery">
         <assert id="NOGOV-T76-R004"
                 test="cac:PromisedDeliveryPeriod"
                 flag="fatal">[NOGOV-T76-R004]-Information on promised delivery period must be filled if element Delivery exists.</assert>
      </rule>
      <rule context="cac:Item/cac:AdditionalItemProperty">
         <assert id="NOGOV-T76-R009"
                 test="cbc:Value"
                 flag="fatal">[NOGOV-T76-R009]-Value must be filled if additional item property is present.</assert>
      </rule>
      <rule context="cbc:ProfileID">
         <assert id="EHFPROFILE-T76-R001"
                 test=". = 'urn:www.cenbii.eu:profile:bii28:ver2.0'"
                 flag="fatal">[EHFPROFILE-T76-R001]-An order response must only be used in profile 28</assert>
      </rule>
   </pattern>
</schema>
