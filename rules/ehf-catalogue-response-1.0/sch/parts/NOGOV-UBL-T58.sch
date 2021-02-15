<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron">
  <rule context="/ubl:ApplicationResponse">
        <assert id="EOL"
                test="false()"
                flag="warning">This format reach end of life at 2022-05-01. Any further use after end of life is at own risk.</assert>
     <assert id="NOGOV-T58-R003"
             test="cac:SenderParty/cbc:EndpointID"
             flag="warning">[NOGOV-T58-R003]-A catalogue response should have sellers endpoint id.</assert>
     <assert id="NOGOV-T58-R004"
             test="cac:ReceiverParty/cbc:EndpointID"
             flag="warning">[NOGOV-T58-R004]-A catalogue response should have the receivers endpoint id.</assert>
  </rule>
  <rule context="cbc:ProfileID">
     <assert id="EHFPROFILE-T58-R001"
             test=". = 'urn:www.cenbii.eu:profile:bii01:ver2.0'"
             flag="fatal">[EHFPROFILE-T58-R001]-A Catalogue response must only be used in profile 1</assert>
  </rule>
</pattern>
