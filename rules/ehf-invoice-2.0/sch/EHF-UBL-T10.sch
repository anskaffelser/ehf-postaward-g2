<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:u="utils"
        schemaVersion="iso" queryBinding="xslt2">

    <title>Rules for EHF Invoice 2.0</title>

    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" prefix="cbc"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" prefix="cac"/>
    <ns uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" prefix="ubl"/>
    <ns uri="utils" prefix="u"/>

    <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:twodec">
        <param name="val"/>
        <value-of select="round($val * 100) div 100"/>
    </function>

    <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:slack" as="xs:boolean">
        <param name="exp"/>
        <param name="val"/>
        <param name="slack"/>
        <value-of select="$exp + xs:decimal($slack) &gt;= $val and $exp - xs:decimal($slack) &lt;= $val"/>
    </function>

    <function xmlns="http://www.w3.org/1999/XSL/Transform" name="u:cat2str">
        <param name="cat"/>
        <value-of select="concat(normalize-space($cat/cbc:ID), '-', round(xs:decimal($cat/cbc:Percent) * 1000000))"/>
    </function>

    <let name="isZ01" value="/ubl:Invoice/cbc:InvoiceTypeCode = 'Z01'"/>
    <let name="isZ02" value="/ubl:Invoice/cbc:InvoiceTypeCode = 'Z02'"/>

    <include href="../../../target/generated/t10-basic.sch"/>
    <include href="parts/NOGOV.sch"/>
    <include href="parts/NONAT.sch"/>

</schema>
