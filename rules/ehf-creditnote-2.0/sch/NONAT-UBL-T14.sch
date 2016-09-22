<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        schemaVersion="iso" queryBinding="xslt2">

   <title>Sjekk mot norsk bokf. lov</title>

   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl"/>

   <pattern>
      <rule context="/ubl:CreditNote">
         <assert id="NONAT-T14-R023"
                 test="not(count(//*[not(node()[not(self::comment())])]) &gt; 0)"
                 flag="fatal">A credit note MUST not contain empty elements.</assert>
         <assert id="NONAT-T14-R009"
                 test="not(cac:PayeeParty) or (cac:PayeeParty/cac:PartyName/cbc:Name)"
                 flag="fatal">If payee information is provided then the payee name MUST be specified.</assert>
         <assert id="NONAT-T14-R021"
                 test="local-name(/*) = 'CreditNote' and (((//cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) or (//cac:BillingReference/cac:CreditNoteDocumentReference/cbc:ID)) or (//cbc:ProfileID = 'urn:www.cenbii.eu:profile:biixx:ver2.0'))"
                 flag="fatal">A creditnote transaction T14 in Profile other than xx MUST have an invoice or creditnote reference identifier.</assert>
         <assert id="NONAT-T14-R015" test="(cbc:UBLVersionID)" flag="fatal">A Credit Note MUST have a syntax identifier.</assert>
         <assert id="NONAT-T14-R018" test="cac:TaxTotal" flag="fatal">A Credit Note MUST contain tax information</assert>
         <assert id="NONAT-T14-R005"
                 test="(cbc:IssueDate) and current-date() &gt;= cbc:IssueDate or (not(cbc:IssueDate))"
                 flag="warning">Issue date of a creditnote should be today or earlier.</assert>
      </rule>
      <rule context="cbc:UBLVersionID">
         <assert id="NONAT-T14-R016"
                 test="( ( not(contains(normalize-space(.),' ')) and contains( ' 2.1 ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal">UBL version  must be 2.1</assert>
      </rule>
      <rule context="//cac:AccountingSupplierParty/cac:Party">
         <assert id="NONAT-T14-R001"
                 test="(cac:PartyLegalEntity/cbc:CompanyID != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"
                 flag="fatal">PartyLegalEntity for AccountingSupplierParty MUST be provided according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 2"</assert>
         <assert id="NONAT-T14-R006"
                 test="(cac:PartyLegalEntity/cbc:RegistrationName != '') and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"
                 flag="fatal">The Norwegian legal registration name for the supplier MUST be provided according to "FOR 2004-12-01 nr 1558 - § 5-1-1. Point 2"</assert>
         <assert id="NONAT-T14-R003"
                 test="(cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"
                 flag="fatal">A supplier postal address in a credit note MUST contain at least city name, zip code and country code.</assert>
      </rule>
      <rule context="//cac:AccountingCustomerParty/cac:Party">
         <assert id="NONAT-T14-R004"
                 test="(cac:PostalAddress/cbc:CityName and cac:PostalAddress/cbc:PostalZone and cac:PostalAddress/cac:Country/cbc:IdentificationCode) and (//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO') or not((//cac:AccountingSupplierParty/cac:Party/cac:PostalAddress/cac:Country/cbc:IdentificationCode = 'NO'))"
                 flag="fatal">A customer postal address in a credit note MUST contain at least, city name, zip code and country code.</assert>
      </rule>
      <rule context="//cac:PartyLegalEntity">
         <assert id="NONAT-T14-R014" test="(cbc:CompanyID)" flag="fatal">Company identifier MUST be specified when describing a company legal entity.</assert>
      </rule>
      <rule context="cac:Delivery/cac:DeliveryLocation/cbc:ID//@schemeID">
         <assert id="NONAT-T14-R007"
                 test="( ( not(contains(normalize-space(.),' ')) and contains( ' GLN GSRN ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="warning">Location identifiers SHOULD be GLN or GSRN</assert>
      </rule>
      <rule context="cac:PayeeFinancialAccount/cbc:ID//@schemeID">
         <assert id="NONAT-T14-R022"
                 test="( ( not(contains(normalize-space(.),' ')) and contains( ' IBAN BBAN LOCAL ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal">A payee account identifier scheme MUST be either IBAN, BBAN or LOCAL</assert>
      </rule>
      <rule context="//cac:LegalMonetaryTotal">
         <assert id="NONAT-T14-R020"
                 test="number(cbc:TaxInclusiveAmount) &gt;= 0"
                 flag="warning">Tax inclusive amount in a credit note SHOULD NOT be negative</assert>
         <assert id="NONAT-T14-R019"
                 test="number(cbc:PayableAmount) &gt;= 0"
                 flag="warning">Total payable amount in a credit note SHOULD NOT be negative</assert>
      </rule>
      <rule context="//cac:AllowanceCharge">
         <assert id="NONAT-T14-R008"
                 test="(cbc:AllowanceChargeReason)"
                 flag="warning">AllowanceChargeReason text SHOULD be specified for all allowances and charges</assert>
      </rule>
      <rule context="cac:TaxCategory/cbc:ID">
         <assert id="NONAT-T14-R017"
                 test="( ( not(contains(normalize-space(.),' ')) and contains( ' AA E H K R S Z ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal">Credit Note tax categories MUST be one of the follwoing codes:  AA E H K R S Z</assert>
      </rule>
      <rule context="cac:TaxScheme//cbc:ID">
         <assert id="NONAT-T14-R010"
                 test="( ( not(contains(normalize-space(.),' ')) and contains( ' VAT ',concat(' ',normalize-space(.),' ') ) ) )"
                 flag="fatal">Credit Note tax schemes MUST be 'VAT'</assert>
      </rule>
      <rule context="//cac:TaxScheme">
         <assert id="NONAT-T14-R013" test="cbc:ID" flag="fatal">Every tax scheme MUST be defined through an identifier.</assert>
      </rule>
      <rule context="//cac:CreditNoteLine">
         <assert id="NONAT-T14-R012" test="(cac:Item/cbc:Name)" flag="fatal">Each credit note line MUST contain the product/service name</assert>
         <assert id="NONAT-T14-R011" test="cac:Price/cbc:PriceAmount" flag="fatal">Credit Note line MUST contain the item price</assert>
         <assert id="NONAT-T14-R024"
                 test="not(cbc:CreditedQuantity) or not(cac:Price/cbc:PriceAmount) or number(cbc:LineExtensionAmount) &gt; 0 or (cbc:CreditedQuantity) &gt; 0 or (not(cac:Price/cbc:BaseQuantity) and abs(number(cbc:LineExtensionAmount)) = round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * abs(xs:decimal(cbc:CreditedQuantity))) div 100) + ((round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 )) * -1 ) * 10 * 10) div 100) or ((cac:Price/cbc:BaseQuantity) and abs(number(cbc:LineExtensionAmount)) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity)) * abs(xs:decimal(cbc:CreditedQuantity))) div 100) + ((round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) * -1) *10 *10) div 100)"
                 flag="fatal">Credit note line amount MUST be equal to the price amount multiplied by the quantity, plus charges minus allowances at the line level.</assert>
         <assert id="NONAT-T14-R024"
                 test="not(cbc:CreditedQuantity) or not(cac:Price/cbc:PriceAmount) or number(cbc:LineExtensionAmount) &lt; 0 or (not(cac:Price/cbc:BaseQuantity) and (number(cbc:LineExtensionAmount)) = round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:CreditedQuantity)) div 100) + (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) * 10 * 10) div 100) or ((cac:Price/cbc:BaseQuantity) and number(cbc:LineExtensionAmount) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity) * xs:decimal(cbc:CreditedQuantity))) div 100) + (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) *10 *10) div 100)"
                 flag="fatal">Credit note line amount MUST be equal to the price amount multiplied by the quantity, plus charges minus allowances at the line level.</assert>
         <assert id="NONAT-T14-R024"
                 test="not(cbc:CreditedQuantity) or not(cac:Price/cbc:PriceAmount) or number(cbc:LineExtensionAmount) &gt; 0 or (cbc:CreditedQuantity) &lt; 0 or (not(cac:Price/cbc:BaseQuantity) and (number(cbc:LineExtensionAmount)) = round(((round((10 * 10) * xs:decimal(cac:Price/cbc:PriceAmount) * xs:decimal(cbc:CreditedQuantity)) div 100) + (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) *10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100 ) ) * 10 * 10) div 100) or ((cac:Price/cbc:BaseQuantity) and number(cbc:LineExtensionAmount) = round(((round((10 * 10) * (xs:decimal(cac:Price/cbc:PriceAmount) div xs:decimal(cac:Price/cbc:BaseQuantity) * xs:decimal(cbc:CreditedQuantity))) div 100) + (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='true']/cbc:Amount) * 10 * 10) div 100 ) - (round(sum(cac:AllowanceCharge[child::cbc:ChargeIndicator='false']/cbc:Amount) *10 * 10) div 100)) *10 *10) div 100)"
                 flag="fatal">Credit note line amount MUST be equal to the price amount multiplied by the quantity, plus charges minus allowances at the line level.</assert>
      </rule>
   </pattern>
</schema>
