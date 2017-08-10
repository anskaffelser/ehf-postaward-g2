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
    R03X - Formating validation
    R1XX - Code lists
  -->

  <pattern>
    <rule context="cbc:*">
      <!--
        Replaces:
        * Catalogue - NOGOV-T19-R018 *F*
        * Catalogue Response - NOGOV-T58-R009 *F*
        * Despatch Advice - NOGOV-T16-R011 *F*
        * Order - NOGOV-T01-R006 *F*
        * Order Response - NOGOV-T76-R010 *F*
      -->
      <assert id="EHF-COMMON-R001"
              test=". != ''"
              flag="fatal">Document MUST not contain empty elements.</assert>
    </rule>
    <rule context="cac:*">
      <!--
        Replaces:
        * Catalogue - NOGOV-T19-R018 *F*
        * Catalogue Response - NOGOV-T58-R009 *F*
        * Despatch Advice - NOGOV-T16-R011 *F*
        * Order - NOGOV-T01-R006 *F*
        * Order Response - NOGOV-T76-R010 *F*
      -->
      <assert id="EHF-COMMON-R002"
              test="count(*) != 0"
              flag="fatal">Document MUST not contain empty elements.</assert>
    </rule>
    <rule context="/*">
      <!--
        Adds validation:
        * Catalogue
        * Catalogue Response
        * Despatch Advice
        * Order
        * Order Response
      -->
      <assert id="EUGEN-T68-R003"
              test="not(@*:schemaLocation)"
              flag="warning">Document SHOULD not contain schema location.</assert>
    </rule>
  </pattern>

  <pattern>
    <rule context="/*">
      <!--
        Replaces:
        * Catalogue - NOGOV-T19-R007 *F*
        * Catalogue Response - NOGOV-T58-R002 *F*
        * Despatch Advice - NOGOV-T16-R001 *F*
        * Order - NOGOV-T01-R012 *F*
        * Order Response - NOGOV-T76-R007 *F*
      -->
      <assert id="EHF-COMMON-R004"
              test="cbc:UBLVersionID"
              flag="fatal">Document MUST have a syntax identifier.</assert>
    </rule>
    <rule context="cbc:EndpointID[@schemeID = 'NO:ORGNR']">
      <!--
        Replaces:
        * Catalogue - NOGOV-T19-R015 *F*, NOGOV-T19-R017 *F*
        * Catalogue Response - NOGOV-T58-R008 *F*
        * Despatch Advice - NOGOV-T16-R010 *F*
        * Order - NOGOV-T01-R009 *F*
        * Order Response - NOGOV-T76-R002 *F*
      -->
      <assert id="EHF-COMMON-R010"
              test="(string(.) castable as xs:integer) and (string-length(.) = 9) and xs:boolean(u:mod11(.))"
              flag="fatal">MUST be a valid Norwegian organization number. Only numerical value allowed</assert>
    </rule>
    <rule context="cbc:EndpointID">
      <!--
        Replaces:
        * Catalogue - NOGOV-T19-R014 *F*, NOGOV-T19-R016 *F*
        * Catalogue Response - NOGOV-T58-R007 *F*
        * Despatch Advice - NOGOV-T16-R008 *F*
        * Order - NOGOV-T01-R008 *F*
        * Order Response - NOGOV-T76-R002 *F*
      -->
      <assert id="EHF-COMMON-R014"
              test="false()"
              flag="fatal">An endpoint identifier scheme MUST have the value 'NO:ORGNR'.</assert>
    </rule>
    <rule context="cac:PartyIdentification/cbc:ID[@schemeID = 'NO:ORGNR']">
      <!--
        Adds validation:
        * Catalogue
        * Catalogue Response
        * Despatch Advice
        * Order
        * Order Response
      -->
      <assert id="EHF-COMMON-R011"
              test="(string(.) castable as xs:integer) and (string-length(.) = 9) and xs:boolean(u:mod11(.))"
              flag="fatal">When scheme is NO:ORGNR, a valid Norwegian organization number must be used. Only numerical value allowed</assert>
    </rule>
    <rule context="cbc:CompanyID[@schemeID = 'NO:VAT']">
      <!--
        Partly replaces:
        * Order - NOGOV-T01-R011 *F*

        Adds validation:
        * Catalogue

        Ignored:
        * Catalogue Response
        * Despatch Advice
        * Order Response
      -->
      <assert id="EHF-COMMON-R012"
              test="(string-length(.) = 12) and (substring(., 1, 9) castable as xs:integer) and (substring(., 10, 12) = 'MVA') and xs:boolean(u:mod11(substring(., 1, 9)))"
              flag="fatal">A VAT number MUST be valid Norwegian organization number (nine numbers) followed by the letters MVA.</assert>
    </rule>
    <rule context="cbc:CompanyID[@schemeID = 'NO:ORGNR']">
      <!--
        Partly replaces:
        * Order - NOGOV-T01-R010 *F*

        Adds validation:
        * Catalogue

        Ignored:
        * Catalogue Response
        * Despatch Advice
        * Order Response
      -->
      <assert id="EHF-COMMON-R013"
              test="(string(.) castable as xs:integer) and (string-length(.) = 9) and xs:boolean(u:mod11(.))"
              flag="fatal">When scheme is NO:ORGNR, a valid Norwegian organization number must be used. Only numerical value allowed</assert>
    </rule>
    <rule context="cac:*[ends-with(name(), 'TaxCategory')]/cbc:ID">
      <!--
        Replaces:
        * Catalogue - NOGOV-T19-R019 *F*

        Adds validation:
        * Order
        * Order Response

        Ignored:
        * Catalogue Response
        * Despatch Advice
      -->
      <assert id="EHF-COMMON-R020"
              test="some $code in tokenize('AA E H K R S Z', '\s') satisfies $code = normalize-space(.)"
              flag="fatal">Tax categories MUST be one of the follwoing codes:  AA E H K R S Z</assert>
    </rule>
    <rule context="cbc:*[ends-with(name(), 'Date')]">
      <!--
        Replaces:
        * Catalogue - NOGOV-T19-R006 *F*
        * Catalogue Response - NOGOV-T58-R001 *F*
        * Despatch Advice - NOGOV-T16-R008 *F*
        * Order - NOGOV-T01-R007 *F*
        * Order Response - NOGOV-T76-R001 *F*
      -->
      <assert id="EHF-COMMON-R030"
              test="(string(.) castable as xs:date) and (string-length(.) = 10)"
              flag="fatal">A date must be formatted YYYY-MM-DD.</assert>
    </rule>
    <!--
      Replaces:
      * Order - NOGOV-T01-R021 *W*

      Adds validation:
      * Catalogue

      Ignored:
      * Catalogue Response
      * Order Response
      * Despatch Advice
    -->
    <rule context="cbc:EmbeddedDocumentBinaryObject[@mimeCode]">
      <assert id="EHF-COMMON-R100"
              test="some $code in tokenize('application/pdf image/gif image/tiff image/jpeg image/png text/plain', '\s') satisfies $code = normalize-space(@mimeCode)"
              flag="warning">Attachment is not a recommended MIMEType.</assert>
    </rule>
  </pattern>

 </schema>
