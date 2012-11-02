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

	<!-- Get supplier- and customer id and store as variable -->
	<xsl:variable name="supplierCompanyID" select="/*/cac:AccountingSupplierParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" />
	<xsl:variable name="customerCompanyID" select="/*/cac:AccountingCustomerParty/cac:Party/cac:PartyTaxScheme/cbc:CompanyID" />

	<xsl:template match="/">
	
		<!-- Check if both supplier- and customer id are norwegian. That is company id starts with "NO..." -->
		<status>
			<xsl:choose>
				<xsl:when test="substring($supplierCompanyID, 0, 3) = 'NO' and substring($customerCompanyID, 0, 3) = 'NO'">
					<xsl:text>true</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>false</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</status>				
	</xsl:template>
       
</xsl:stylesheet>