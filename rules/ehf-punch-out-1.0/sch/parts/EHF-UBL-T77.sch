<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
  <!--
    00X - Document level
    03X - Delivery
    05X - Totals

    1XX - Line level

    2XX - Item level
    21X - Item Properties
    22X - Tax category
  -->

  <rule context="ubl:Catalogue">
    <assert id="EOL"
            test="false()"
            flag="warning">This format reach end of life at 2022-05-01. Any further use after end of life is at own risk.</assert>
    <assert id="EHF-T77-R001"
            test="cbc:ProfileID"
            flag="fatal">Punch out MUST have a profile identification.</assert>
  </rule>

  <rule context="cac:Item">
    <assert id="EHF-T77-R220"
            test="cac:ClassifiedTaxCategory"
            flag="fatal">Tax category on line level MUST exists.</assert>
  </rule>

  <rule context="cac:AdditionalItemProperty">
    <assert id="EHF-T77-R210"
            test="cbc:Value"
            flag="fatal">Additional item property MUST have a value.</assert>
  </rule>
</pattern>
