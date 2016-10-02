<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        schemaVersion="iso" queryBinding="xslt2">

   <title>Sjekk mot norske regler </title>

   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl"/>

   <pattern>
      <rule context="//cbc:ProfileID">
         <assert id="EHFPROFILE-T14-R001"
                 test=". = 'urn:www.cenbii.eu:profile:bii05:ver2.0' or . = 'urn:www.cenbii.eu:profile:biixx:ver2.0' or . = 'urn:www.cenbii.eu:profile:biixy:ver2.0'"
                 flag="fatal">[EHFPROFILE-T14-R001]-A credit note transaction T14 must only be used with profiles 5, xx or xy.</assert>
      </rule>
      <rule context="/ubl:CreditNote">
         <assert id="NOGOV-T14-R003"
                 test="((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount != 0) and (cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID) or (cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT']/cbc:TaxAmount = 0) or not((cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = 'VAT'])))"
                 flag="fatal">[NOGOV-T14-R003]-If the VAT total amount in a credit note exists it MUST contain the suppliers VAT number.</assert>
         <assert id="NOGOV-T14-R021"
                 test="((cac:AllowanceCharge[cbc:ChargeIndicator = 'true']) and (cac:LegalMonetaryTotal/cbc:ChargeTotalAmount != '') or not(cac:AllowanceCharge[cbc:ChargeIndicator = 'true']) )"
                 flag="fatal">[NOGOV-T14-R021]-If charge is present on document level, total charge must be stated.</assert>
         <assert id="NOGOV-T14-R022"
                 test="((cac:AllowanceCharge[cbc:ChargeIndicator = 'false']) and (cac:LegalMonetaryTotal/cbc:AllowanceTotalAmount != '') or not(cac:AllowanceCharge[cbc:ChargeIndicator = 'false']) )"
                 flag="fatal">[NOGOV-T14-R022]-If allowance is present on document level, total allowance must be stated.</assert>
         <assert id="EHFPROFILE-T14-R002"
                 test="local-name(/*) = 'CreditNote' and (((//cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID) or (//cac:BillingReference/cac:CreditNoteDocumentReference/cbc:ID)) or (//cbc:ProfileID = 'urn:www.cenbii.eu:profile:biixx:ver2.0'))"
                 flag="fatal">[EHFPROFILE-T14-R002]-A creditnote transaction T14 in Profile other than xx MUST have an invoice or creditnote reference identifier.</assert>
      </rule>
      <rule context="//cac:AccountingSupplierParty/cac:Party">
         <assert id="NOGOV-T14-R001"
                 test="(cac:Contact/cbc:ID != '')"
                 flag="warning">[NOGOV-T14-R001]-A contact reference identifier SHOULD be provided for AccountingSupplierParty according to EHF.</assert>
      </rule>
      <rule context="//*[contains(name(),'Amount') and not(contains(name(),'Transaction'))]">
         <assert id="NOGOV-T14-R005"
                 test="not(attribute::currencyID) or (attribute::currencyID and attribute::currencyID = /ubl:CreditNote/cbc:DocumentCurrencyCode)"
                 flag="fatal">[NOGOV-T14-R005]-The attribute currencyID must have the same value as DocumentCurrencyCode, except the attribute for TransactionCurrencyTaxAmount.</assert>
         <assert id="NOGOV-T14-R024"
                 test="not(name(parent::node()) = 'cac:LegalMonetaryTotal') or string-length(substring-after(., '.')) &lt;= 2"
                 flag="fatal">[NOGOV-T14-R024]-Document level amounts cannot have more than 2 decimals</assert>
      </rule>
      <rule context="//cac:Item">
         <assert id="NOGOV-T14-R002"
                 test="(cac:SellersItemIdentification/cbc:ID != '')"
                 flag="warning">[NOGOV-T14-R002]-The sellers ID for the item SHOULD be provided according to EHF.</assert>
      </rule>
      <rule context="//cac:AccountingCustomerParty/cac:Party">
         <assert id="NOGOV-T14-R004"
                 test="(cac:PartyLegalEntity/cbc:CompanyID != '')or (//cac:AdditionalDocumentReference/cbc:DocumentType = 'elektroniskB2Cfaktura')"
                 flag="fatal">[NOGOV-T14-R004]-PartyLegalEntity for AccountingCustomerParty MUST be provided according to EHF.</assert>
         <assert id="NOGOV-T14-R008"
                 test="(cac:PartyLegalEntity/cbc:RegistrationName != '') or (//cac:AdditionalDocumentReference/cbc:DocumentType = 'elektroniskB2Cfaktura')"
                 flag="fatal">[NOGOV-T14-R008]-Registration name for AccountingCustomerParty MUST be provided according to EHF.</assert>
         <assert id="NOGOV-T14-R006"
                 test="(cac:PartyIdentification/cbc:ID != '')"
                 flag="warning">[NOGOV-T14-R006]-A customer number for AccountingCustomerParty SHOULD be provided according to EHF.</assert>
         <assert id="NOGOV-T14-R007" test="(cac:Contact/cbc:ID != '')" flag="fatal">[NOGOV-T14-R007]-A contact reference identifier MUST be provided for AccountingCustomerParty according to EHF.</assert>
      </rule>
      <rule context="/ubl:CreditNote/cac:TaxTotal">
         <assert id="NOGOV-T14-R018" test="(cac:TaxSubtotal)" flag="fatal">[NOGOV-T14-R018]-A credit note MUST have Tax Subtotal specifications.</assert>
         <assert id="NOGOV-T14-R025"
                 test="string-length(substring-after(cbc:TaxAmount, '.')) &lt;= 2"
                 flag="fatal">[NOGOV-T14-R025]-Total tax amount cannot have more than 2 decimals</assert>
         <assert id="NOGOV-T14-R041"
                 test="count(distinct-values(cac:TaxSubtotal/cac:TaxCategory/cbc:ID/normalize-space(text()))) = count(cac:TaxSubtotal)"
                 flag="fatal">[NOGOV-T14-R041]-Multiple tax subtotals per tax category is not allowed.</assert>
      </rule>
      <rule context="/ubl:CreditNote/cac:TaxRepresentativeParty">
         <assert id="NOGOV-T14-R017"
                 test="(cac:PartyTaxScheme/cbc:CompanyID !='')"
                 flag="fatal">[NOGOV-T14-R017]-Company identifier MUST be specified when describing a Tax Representative</assert>
      </rule>
      <rule context="//cac:Party/cbc:EndpointID">
         <assert id="NOGOV-T14-R010" test="@schemeID = 'NO:ORGNR'" flag="fatal">[NOGOV-T14-R010]-An endpoint identifier scheme MUST have the value 'NO:ORGNR'.</assert>
         <assert id="NOGOV-T14-R009"
                 test="(string(.) castable as xs:integer) and (string-length(.) = 9)"
                 flag="fatal">[NOGOV-T14-R009]-Endpoint ID MUST be a norwegian organizational number. Only numerical value allowed</assert>
      </rule>
      <rule context="//cac:PartyLegalEntity/cbc:CompanyID">
         <assert id="NOGOV-T14-R014"
                 test="(string-length(.) = 9) and (string(.) castable as xs:integer)"
                 flag="fatal">[NOGOV-T14-R014]-An organisational number for seller, buyer and payee MUST be nine numbers..</assert>
      </rule>
      <rule context="//cac:PartyTaxScheme/cbc:CompanyID">
         <assert id="NOGOV-T14-R013"
                 test="(string-length(.) = 12) and (substring(.,1,9) castable as xs:integer) and (substring(.,10,12)='MVA')"
                 flag="fatal">[NOGOV-T14-R013]-A VAT number MUST be nine numbers followed by the letters MVA.</assert>
      </rule>
      <rule context="//*[contains(name(),'Date')]">
         <assert id="NOGOV-T14-R011"
                 test="(string(.) castable as xs:date) and (string-length(.) = 10)"
                 flag="fatal">[NOGOV-T14-R011]-A date must be formatted YYYY-MM-DD.</assert>
      </rule>
      <rule context="@mimeCode">
         <assert id="NOGOV-T14-R020"
                 test="(( . = 'application/pdf' or . = 'image/gif' or . = 'image/tiff' or . = 'image/jpeg' or . = 'image/png' or . = 'text/plain' ))"
                 flag="warning">[NOGOV-T14-R020]-Attachment is not a recommended MIMEType.</assert>
      </rule>
      <rule context="//cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID[attribute::schemeID = 'BBAN']">
         <assert id="NOGOV-T14-R015"
                 test="(string(.) castable as xs:integer)"
                 flag="fatal">[NOGOV-T14-R015]-Only numbers are allowed as bank account number if scheme is BBAN.</assert>
      </rule>
      <rule context="//cac:PaymentMeans/cac:PayeeFinancialAccount/cbc:ID[attribute::schemeID = 'IBAN']">
         <assert id="NOGOV-T14-R016"
                 test="(matches(.,'[A-Z][A-Z]')= true()) and (substring(.,3) castable as xs:integer)"
                 flag="warning">[NOGOV-T14-R016]-IBAN number is not for a norwegain bank account</assert>
      </rule>
      <rule context="//cac:CreditNoteLine/cac:Item/cac:CommodityClassification">
         <assert id="NOGOV-T14-R019"
                 test="(cbc:ItemClassificationCode !='')"
                 flag="warning">[NOGOV-T14-R019]-Item classification code MUST be specified when describing commodity classification.</assert>
      </rule>
      <rule context="//cac:PartyIdentification/cbc:ID[@schemeID='NO:ORGNR']">
         <assert id="NOGOV-T14-R023"
                 test="(string(.) castable as xs:integer) and (string-length(.) = 9)"
                 flag="fatal">[NOGOV-T14-R023]-When scheme is NO:ORGNR, a norwegian organizational number must be used. Only numerical value allowed</assert>
      </rule>
      <rule context="/ubl:CreditNote/cac:TaxTotal/cac:TaxSubtotal">
         <assert id="NOGOV-T14-R026"
                 test="string-length(substring-after(cbc:TaxableAmount, '.')) &lt;= 2"
                 flag="fatal">[NOGOV-T14-R026]-Tax subtotal amounts cannot have more than 2 decimals</assert>
         <assert id="NOGOV-T14-R026"
                 test="string-length(substring-after(cbc:TaxAmount, '.')) &lt;= 2"
                 flag="fatal">[NOGOV-T14-R026]-Tax subtotal amounts cannot have more than 2 decimals</assert>
      </rule>
      <rule context="/ubl:CreditNote/cac:AllowanceCharge">
         <assert id="NOGOV-T14-R027"
                 test="string-length(substring-after(cbc:Amount, '.')) &lt;= 2"
                 flag="fatal">[NOGOV-T14-R027]-Allowance or charge amounts on document level cannot have more than 2 decimals</assert>
      </rule>
   </pattern>
</schema>
