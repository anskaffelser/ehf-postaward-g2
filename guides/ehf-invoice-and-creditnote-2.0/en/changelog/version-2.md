# Version 2.x

## 2.0.6 (23.05.2016)

Changes in validator:
* Check to ensure all document level amounts have maximum 2 decimals [Github issue 125](https://github.com/difi/vefa-validator-conf/issues/125)
* Check to ensure a norwegian organisational number is 9 digits if schemeID = NO:ORGNR [Github issue 114](https://github.com/difi/vefa-validator-conf/issues/114)
* Check to verify that if allowance or charge is sent on document level, the element for total allowance or charge exists [Github issue 116](https://github.com/difi/vefa-validator-conf/issues/116)
* Check to verify that only one TaxSubtotal exists per TaxCategory in TaxTotal. Implemented as warning identified as NOGOV-T10-R041 and NOGOV-T14-R041. [Github issue 133](https://github.com/difi/vefa-validator-conf/issues/133)

Editorial changes:
* Changed description of Your ref [Github issue 99](https://github.com/difi/vefa-validator-conf/issues/99)
* Added recommondation that PEPPOL BIS is only used in cases where one of the parties are foreign (cross border trade) [Github issue 71](https://github.com/difi/vefa-validator-conf/issues/71)
* Changed text in chapter 6.2 from LineTotalAmount to LineExtensionAmount [Github issue 134](https://github.com/difi/vefa-validator-conf/issues/134)
* Low VAT rate (category AA) changed from 8 to 10%, in chapter 6.6 [Github issue 135](https://github.com/difi/vefa-validator-conf/issues/135)


## 2.0.5 (01.09.2015)

Changes in validator:
* New validation artefacts for PEPPOL and BII rules, upgrade to XSLT/xPath 2.0.
* Empty elements will raise error, not warning as previously, applies to rule NONAT-T10-R025 and NONAT-T14-R023.

Editorial changes:
* Recommondation to use value  «NA» if your reference is not relevant for the invoice.
* Correct element-naming for payee party in chapter 6.1

Other changes:
* Attachments to implementation guide will be unzipped in Github for easier access to documents
* Missing examplefiles restored

Authors:
* Siw Meckelborg, Edisys Consulting AS


## Hotfix (15.04.2015)

Removed  validation on schemeID for ClassifiedTaxCatagory for both invoice and creditnote as this was breaking backwards compatibility.

Authors:
* Siw Meckelborg, Edisys Consulting AS


## 2.0.4 (01.03.2015)

Changes in validator:
* Added validation on schemeID for ClassifiedTaxCatagory for both invoice and creditnote
* Warning if attachments are outside recommended types for both invoice and creditnote

Editorial changes in the implementation guide:
* Correction of example in chapter 6.15
* Clarifying invoicing to consumers
* Clarification of use of BBAN when using Norwegian account numbers
* Editorial changes in chapter 7 and 6.2.2.

Authors:
* Siw Meckelborg, Edisys Consulting AS


## 2.0.3 (01.12.2014)

Changes in validator:
* Validation of all mandatory and recommended elements.
* Validation of elements not used in EHF, and cardinality outside scope of EHF. Validation of datatypes (VAT number, date, bankaccount etc.)
* Validation of the amount in //cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount.
* Only organisational numbers are valid in EndpointID.
* Validation to ensure that the currency attribute is equal to  DocumentCurrencyCode.
* Correction of the validation of TaxInclusiveAmount, Credit note line amount
* NONAT-T14-R020 changed from error to warning.

Editorial changes to the implementation guide:
* Adding Dependant to description of elements.
* Specification of the price element
* Updated description of Delivery address and date.
* Fix of typo’s and other small changes to text.

Authors:
* Siw Meckelborg, Edisys Consulting AS
* Yngve Pettersen, Edisys Consuling AS


## 2.0.2 (29.09.2014)

Change in rule for Sellers VAT number, to allow invoices and credit notes for companies not registered for VAT

Editorial change in appendix 3.

Authors:
* Siw Meckelborg, Edisys Consulting AS


## 2.0.1 (19.08.2014)

Allowing for issue date set to future date for both invoice and credit note. NONAT-T10-R009 and  NONAT-T14-R005 changed from Fatal error to warning.

Added rule to check correct use of Profile ID for both Invoice and credit note.

Authors:
* Siw Meckelborg, Edisys Consulting AS


## 2.0 (07.05.2014)

Changes, invoice and credit note:
1. Invoice in other currency than NOK
1. Specification of VAT in NOK. The following elements must be filled
  1. TaxCurrency Code
  1. TaxExchangeRate,
    1. Source currency
    1. Target currency
    1. Exchange rate
  1. TaxTotal/TaxSubtotal/TransactionCurrencyTaxAmount.  
1.	Added name and address for financial institution
1.	New requirements for use of, and content of the attribute listID for codelist elements.
1.	Removed the use of attribute schemeAgencyID for CompanyID
1.	Removed postal address for VAT representative to harmonize with PEPPOL BIS.

Changes made for credit note:
1.	OrderReference at document level

Editorial changes for rule ID’s and texts.

Authors:
* Olav Kristiansen, Difi
* Siw Meckelborg, Edisys Consulting AS
* Jostein Frømyr, Edisys Consulting AS
* Are Berg, Edisys Consulting AS
* Trond Bertil Barstad, Edisys Consulting AS


## 2.0 (30.05.2013)

Extensions,  invoice and creditnote:
* Invoice in other currency than NOK (VAT in NOK)
* Sellers tax representative
* Contract type
* Type AllowanceCharge
* Contact name for seller and buyer
* Period, manufacturer and country of origin for the item on line level

Extensions, creditnote:
* Registration name for party legal entity, seller and buyer
* Delivery on document and line level
* Payment means on document level
* AllowanceCharge on line level
* Base quantity for price on line level
* Reference to invoice/invoice line on line level  (BillingReference)

Deletions, invoice and creditnote:
* Address identifier, PO box,  Building number and Department  in the Address element , regarding seller, buyer and delivery
* Countrysubentity  in the legal address
* Department, seller and buyer
* Payment channel in the payment measns element
* Contact person, seller and buyer
* MVA spesifikasjon for rabatter/gebyrer på linje og pris

Deletions, creditnote:
* Referance to credtinote on document level (BillingReference)

Changes, invoice and creditnote:
* Invoicetype, mandatory
* Legal registration name, seller and buyer, mandatory
* VAT percentage on line level, optional
* Payment terms may occur several times
* Incorrect VAT category leads to rejection of the document in the validator
* Content in EndpointID changed
* Content in UBLVersionID changed from 2.0 to 2.1
* Content in CustomizationID changed.
* Version number in Profile ID changed from 1.0 to 2.0

Functional extension:
* Invoicing of consumers (B2C)

Several adjustments and clarifications about:
* Accounting cost
* Delivery
* Attachments
* Optional elements
* EndpointID
* Bank account number

Use of UBL version 2.1 XML schema.

Authors:
* Olav A. Kristiansen, Difi
* Camilla Bø, Hafslund
* Morten Gjestad, Nets
* Dan Andre Nylænder, Unit4 Agresso
* Jan Terje Kaaby, NARF
* Morten Krøgenes, Bankenes Standariseringskontor
* Per Martin Jøraholmen, DFØ
* Jostein Frømyr, Edisys
* Erik Gustavsen, Edisys
