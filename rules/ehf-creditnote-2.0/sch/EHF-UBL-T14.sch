<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:u="utils"
        schemaVersion="iso" queryBinding="xslt2">

   <title>Rules for EHF Credit Note 2.0</title>

   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
   <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" prefix="ubl"/>
   <ns uri="utils" prefix="u"/>

   <xi:include href="../../shared/function/twodec.xml"/>
   <xi:include href="../../shared/function/slack.xml"/>
   <xi:include href="../../shared/function/cat2str.xml"/>

   <include href="../../../target/generated/t14-basic.sch"/>
   <include href="parts/NOGOV-UBL-T14.sch"/>
   <include href="parts/NONAT-UBL-T14.sch"/>

</schema>
