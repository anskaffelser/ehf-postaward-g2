<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
        <rule context="ubl:*">
                <assert id="EOL"
                        test="false()"
                        flag="warning">This format reach end of life at 2021-02-15. Any further use after end of life is at own risk.</assert>
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
