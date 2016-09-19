<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        schemaVersion="iso"
        queryBinding="xslt2">
   <title>Sjekk mot norsk bokf.lov</title>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
       prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
       prefix="cac"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
       prefix="ubl"/>
   <pattern>
      <rule context="//cac:AccountingSupplierParty/cac:Party">
         <assert id="NONAT-T10-R001"
                 test="(cac:PartyLegalEntity/cbc:CompanyID != '')"
                 flag="fatal">The Norwegian legal registration ID for the supplier MUST be provided according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 2"</assert>
         <assert id="NONAT-T10-R008"
                 test="(cac:PartyLegalEntity/cbc:RegistrationName != '')"
                 flag="fatal">The Norwegian legal registration name for the supplier MUST be provided according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 2"</assert>
         <assert id="NONAT-T10-R006"
                 test="((cac:PostalAddress/cbc:CityName !='') and (cac:PostalAddress/cbc:PostalZone != '') and (cac:PostalAddress/cac:Country/cbc:IdentificationCode != ''))"
                 flag="fatal">A supplier postal address in an invoice MUST contain at least city name, zip code and country code.</assert>
      </rule>
      <rule context="/ubl:Invoice">
         <assert id="NONAT-T10-R025"
                 test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"
                 flag="fatal">An invoice MUST not contain empty elements.</assert>
         <assert id="NONAT-T10-R012" test="cac:TaxTotal" flag="fatal">An invoice MUST contain tax information</assert>
         <assert id="NONAT-T10-R002"
                 test="//cac:PaymentMeans/cbc:PaymentDueDate"
                 flag="fatal">Payment due date MUST be provided in the invoice according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 5"</assert>
         <assert id="NONAT-T10-R013"
                 test="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name != '')"
                 flag="fatal">If payee information is provided then the payee name MUST be specified.</assert>
         <assert id="NONAT-T10-R019" test="(cbc:UBLVersionID != '')" flag="fatal">An invoice MUST have a syntax identifier.</assert>
         <assert id="NONAT-T10-R009"
                 test="(cbc:IssueDate) and current-date() &gt;= cbc:IssueDate or (not(cbc:IssueDate))"
                 flag="warning">Issue date of an invoice should be today or earlier.</assert>
         <assert id="NONAT-T10-R003"
                 test="//cac:Delivery/cbc:ActualDeliveryDate"
                 flag="warning">The actual delivery date SHOULD be provided in the invoice according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 4 and § 5-1-4", see also “NOU 2002:20, point 9.4.1.4”"</assert>
         <assert id="NONAT-T10-R004"
                 test="//cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:CityName and //cac:Delivery/cac:DeliveryLocation/cac:Address/cbc:PostalZone and //cac:Delivery/cac:DeliveryLocation/cac:Address/cac:Country/cbc:IdentificationCode"
                 flag="warning">A Delivery address in an invoice SHOULD contain at least, city, zip code and country code according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 4 and § 5-1-4", see also “NOU 2002:20, point 9.4.1.4”</assert>
      </rule>
      <rule context="cbc:UBLVersionID">
         <assert id="NONAT-T10-R020"
                 test="( ( not(contains(normalize-space(.),' ')) and contains( ' 2.1 ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal">UBL version  must be 2.1</assert>
      </rule>
      <rule context="//cac:AccountingCustomerParty/cac:Party">
         <assert id="NONAT-T10-R007"
                 test="(cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode)"
                 flag="fatal">A customer postal address in an invoice MUST contain at least city name, zip code and country code.</assert>
      </rule>
      <rule context="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID">
         <assert id="NONAT-T10-R010"
                 test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN GSRN ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="warning">Location identifiers SHOULD be GLN or GSRN</assert>
      </rule>
      <rule context="//cac:PartyLegalEntity">
         <assert id="NONAT-T10-R018" test="(cbc:CompanyID != '')" flag="fatal">Company identifier MUST be specified when describing a company legal entity.</assert>
      </rule>
      <rule context="cac:PayeeFinancialAccount/cbc:ID//@schemeID">
         <assert id="NONAT-T10-R024"
                 test="( ( not(contains(normalize-space(.),' ')) and contains( ' IBAN BBAN LOCAL ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal">A payee account identifier scheme MUST be either IBAN, BBAN or LOCAL</assert>
      </rule>
      <rule context="cac:TaxCategory//cbc:ID">
         <assert id="NONAT-T10-R021"
                 test="( ( not(contains(normalize-space(.),' ')) and contains( ' AA E H K R S Z ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal">Invoice tax categories MUST be one of the follwoing codes:  AA E H K R S Z</assert>
      </rule>
      <rule context="//cac:TaxScheme">
         <assert id="NONAT-T10-R017" test="cbc:ID" flag="fatal">Every tax scheme MUST be defined through an identifier.</assert>
      </rule>
      <rule context="cac:TaxScheme//cbc:ID">
         <assert id="NONAT-T10-R014"
                 test="( ( not(contains(normalize-space(.),' ')) and contains( ' VAT ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal">Invoice tax schemes MUST be 'VAT'</assert>
      </rule>
      <rule context="//cac:LegalMonetaryTotal">
         <assert id="NONAT-T10-R023"
                 test="number(cbc:TaxInclusiveAmount) &gt;= 0"
                 flag="warning">Tax inclusive amount in an invoice SHOULD NOT be negative</assert>
         <assert id="NONAT-T10-R022"
                 test="number(cbc:PayableAmount) &gt;= 0"
                 flag="warning">Total payable amount in an invoice SHOULD NOT be negative</assert>
      </rule>
      <rule context="//cac:AllowanceCharge">
         <assert id="NONAT-T10-R011"
                 test="(cbc:AllowanceChargeReason)"
                 flag="warning">AllowanceChargeReason text SHOULD be specified for all allowances and charges</assert>
      </rule>
      <rule context="//cac:InvoiceLine">
         <assert id="NONAT-T10-R016" test="(cac:Item/cbc:Name)" flag="fatal">Each invoice line MUST contain the product/service name</assert>
         <assert id="NONAT-T10-R015" test="cac:Price/cbc:PriceAmount" flag="fatal">Invoice lines MUST contain the item price</assert>
         <assert id="NONAT-T10-R026"
                 test="not(cbc:InvoicedQuantity) or not(cac:Price/cbc:PriceAmount) or number(cbc:LineExtensionAmount) &gt; 0 or (cbc:InvoicedQuantity) &gt; 0 or (not(cac:Price/cbc:BaseQuantity) and abs(number(cbc:LineExtensionAmount)) = round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * abs(xs:decimal(cbc:InvoicedQuantity))) div 100) + ((round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 )) * -1 ) * 10 * 10) div 100) or ((cac:Price/cbc:BaseQuantity) and abs(number(cbc:LineExtensionAmount)) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity)) * abs(xs:decimal(cbc:InvoicedQuantity))) div 100) + ((round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) * -1) *10 *10) div 100)"
                 flag="fatal">Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</assert>
         <assert id="NONAT-T10-R026"
                 test="not(cbc:InvoicedQuantity) or not(cac:Price/cbc:PriceAmount) or number(cbc:LineExtensionAmount) &lt; 0 or (not(cac:Price/cbc:BaseQuantity) and (number(cbc:LineExtensionAmount)) = round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:InvoicedQuantity)) div 100) + (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) * 10 * 10) div 100) or ((cac:Price/cbc:BaseQuantity) and number(cbc:LineExtensionAmount) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity) * xs:decimal(cbc:InvoicedQuantity))) div 100) + (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) *10 *10) div 100)"
                 flag="fatal">Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</assert>
         <assert id="NONAT-T10-R026"
                 test="not(cbc:InvoicedQuantity) or not(cac:Price/cbc:PriceAmount) or number(cbc:LineExtensionAmount) &gt; 0 or (cbc:InvoicedQuantity) &lt; 0 or (not(cac:Price/cbc:BaseQuantity) and (number(cbc:LineExtensionAmount)) = round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:InvoicedQuantity)) div 100) + (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) * 10 * 10) div 100) or ((cac:Price/cbc:BaseQuantity) and number(cbc:LineExtensionAmount) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity) * xs:decimal(cbc:InvoicedQuantity))) div 100) + (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) *10 *10) div 100)"
                 flag="fatal">Invoice line amount MUST be equal to the price amount multiplied by the quantity plus charges minus allowances at line level</assert>
      </rule>
   </pattern>
</schema>
