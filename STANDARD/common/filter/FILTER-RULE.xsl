<?xml version="1.0" encoding="UTF-8" standalone="yes"?>

<xsl:stylesheet 
	xmlns:axsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
	xmlns:saxon="http://saxon.sf.net/" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:schold="http://www.ascc.net/xml/schematron" 
	xmlns:iso="http://purl.oclc.org/dsdl/schematron" 
	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" 
	xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" 
	xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" version="2.0">
	
	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<status>
			<xsl:text>true</xsl:text>
		</status>				
	</xsl:template>
       
</xsl:stylesheet>
