<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
  <!--
    00X - Document level
    03X - Delivery
    05X - Totals

    1XX - Line level

    2XX - Item level
    21X - Item Properties
  -->
  <rule context="ubl:OrderResponse">
    <assert id="EOL"
            test="false()"
            flag="warning">This format reach end of life at 2021-02-15. Any further use after end of life is at own risk.</assert>
    <assert id="EHF-T110-R001"
            test="cbc:ProfileID"
            flag="fatal">Order agreement MUST have a profile identification.</assert>

    <assert id="EHF-T110-R100"
            test="cac:OrderLine"
            flag="fatal">At least one order line MUST exist.</assert>
  </rule>

  <rule context="cac:PromisedDeliveryPeriod">
    <assert id="EHF-T110-R030"
            test="cbc:StartDate"
            flag="fatal">Delivery period MUST have a start date.</assert>
  </rule>

  <rule context="cac:LegalMonetaryTotal">
    <assert id="EHF-T110-R050"
            test="cbc:TaxExclusiveAmount"
            flag="fatal">Monetary total MUST have total amount without VAT.</assert>
  </rule>

  <rule context="cac:LineItem">
    <assert id="EHF-T110-R200"
            test="cbc:Quantity"
            flag="fatal">An Order agreement line MUST contain a quantity.</assert>
    <assert id="EHF-T110-R201"
            test="cac:Price"
            flag="fatal">An Order agreement line MUST contain price.</assert>
  </rule>

  <rule context="cac:AdditionalItemProperty">
    <assert id="EHF-T110-R210"
            test="cbc:Value"
            flag="fatal">Additional item property MUST have a value.</assert>
  </rule>
</pattern>
