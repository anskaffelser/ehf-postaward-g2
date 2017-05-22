<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:u="utils"
        schemaVersion="iso" queryBinding="xslt2">

   <title>Common EHF rules for Post-Award</title>

   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
   <ns uri="utils" prefix="u"/>

   <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:mod11">
     <param name="val"/>
     <variable name="length" select="string-length($val) - 1"/>
     <variable name="digits" select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
     <variable name="weightedSum" select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
     <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
   </function>

    <!--
      R00X - Document in general
      R01X - Validation of Norwegian organization numbers
      R02X - Validation of tax
      R03X - Format validation
      R1XX - Code lists
    -->

   <pattern>
     <rule context="cbc:*">
        <assert id="EHF-COMMON-R001"
                test=". != ''"
                flag="fatal">[EHF-COMMON-R001]-Document MUST not contain empty elements.</assert>
     </rule>
     <rule context="cac:*">
        <assert id="EHF-COMMON-R002"
                test="count(*) != 0"
                flag="fatal">[EHF-COMMON-R002]-Document MUST not contain empty elements. <value-of select="count(*)"/></assert>
     </rule>
   </pattern>

   <pattern>
     <rule context="/*">
        <assert id="EHF-COMMON-R003"
                test="cbc:UBLVersionID"
                flag="fatal">[EHF-COMMON-R003]-Document MUST have a syntax identifier.</assert>
     </rule>
     <rule context="cbc:EndpointID[@schemeID = 'NO:ORGNR']">
        <assert id="EHF-COMMON-R010"
                test="(string(.) castable as xs:integer) and (string-length(.) = 9) and xs:boolean(u:mod11(.))"
                flag="fatal">[EHF-COMMON-R010]-MUST be a valid Norwegian organization number. Only numerical value allowed</assert>
     </rule>
     <rule context="cbc:EndpointID">
        <assert id="EHF-COMMON-R014"
                test="false()"
                flag="fatal">[EHF-COMMON-R014]-An endpoint identifier scheme MUST have the value 'NO:ORGNR'.</assert>
     </rule>
     <rule context="cac:PartyIdentification/cbc:ID[@schemeID = 'NO:ORGNR']">
        <assert id="EHF-COMMON-R011"
                test="(string(.) castable as xs:integer) and (string-length(.) = 9) and xs:boolean(u:mod11(.))"
                flag="fatal">[EHF-COMMON-R011]-When scheme is NO:ORGNR, a valid Norwegian organization number must be used. Only numerical value allowed</assert>
     </rule>
     <rule context="cbc:CompanyID[@schemeID = 'NO:VAT']">
        <assert id="EHF-COMMON-R012"
                test="(string-length(.) = 12) and (substring(., 1, 9) castable as xs:integer) and (substring(., 10, 12) = 'MVA') and xs:boolean(u:mod11(substring(., 1, 9)))"
                flag="fatal">[NOGOV-T10-R030]-A VAT number MUST be valid Norwegian organization number (nine numbers) followed by the letters MVA.</assert>
     </rule>
     <rule context="cbc:CompanyID[@schemeID = 'NO:ORGNR']">
        <assert id="EHF-COMMON-R013"
                test="(string(.) castable as xs:integer) and (string-length(.) = 9) and xs:boolean(u:mod11(.))"
                flag="fatal">[EHF-COMMON-R013]-When scheme is NO:ORGNR, a valid Norwegian organization number must be used. Only numerical value allowed</assert>
     </rule>
     <rule context="cac:*[ends-with(name(), 'TaxCategory')]/cbc:ID">
        <assert id="EHF-COMMON-R020"
                test="some $code in tokenize('AA E H K R S Z', '\s') satisfies $code = normalize-space(.)"
                flag="fatal">[EHF-COMMON-R020]-Tax categories MUST be one of the follwoing codes:  AA E H K R S Z</assert>
     </rule>
     <rule context="cbc:*[ends-with(name(), 'Date')]">
        <assert id="EHF-COMMON-R030"
                test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                flag="fatal">[EHF-COMMON-R030]-A date must be formatted YYYY-MM-DD.</assert>
     </rule>

     <rule context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]">
        <assert id="EHF-COMMON-R100"
                test="(( @mimeCode = 'application/pdf' or @mimeCode = 'image/gif' or @mimeCode = 'image/tiff' or @mimeCode = 'image/jpeg' or @mimeCode = 'image/png' or @mimeCode = 'text/plain' ))"
                flag="warning">[EHF-COMMON-R100]-Attachment is not a recommended MIMEType.</assert>
     </rule>
   </pattern>

 </schema>
