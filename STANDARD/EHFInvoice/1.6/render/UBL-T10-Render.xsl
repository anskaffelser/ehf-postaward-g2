<?xml version="1.0" encoding="UTF-8"?>
<!--
******************************************************************************************************************

		OIOUBL Instance Documentation	

		title= InvoiceHTML2008-01-22.xsl	
		replaces= invoice.xsl
		publisher= "IT og Telestyrelsen"
		Creator= Finn Christensen and Charlotte Dahl Skovhus
		created= 2006-12-29
		modified= 2008-01-22
		issued= 2008-01-22
		conformsTo= UBL-Invoice-2.0.xsd
		description= "Stylesheet for displaying a OIOUBL-2.01 Invoice"
		rights= "It can be used following the Common Creative Licence"
		
		all terms derived from http://dublincore.org/documents/dcmi-terms/

		For more information, see www.oioubl.dk	or email oioubl@itst.dk
		
******************************************************************************************************************
-->
<xsl:stylesheet version="1.0" 

        xmlns:xsl  = "http://www.w3.org/1999/XSL/Transform" 
        xmlns:n1   = "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" 
        xmlns:cac  = "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" 
        xmlns:cbc  = "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" 
        xmlns:ccts = "urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2" 
        xmlns:sdt  = "urn:oasis:names:specification:ubl:schema:xsd:SpecializedDatatypes-2" 
        xmlns:udt  = "urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"
                                      exclude-result-prefixes="n1 cac cbc ccts sdt udt">


	<xsl:include href="/STANDARD/EHFInvoice/1.6/render/CommonTemplates.xsl"/>
	<xsl:output method="xml" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="n1:Invoice">

		<!-- Start HTML -->
		<html>
			<head>
				<link rel="Stylesheet" type="text/css" href="OIOUBL.css"></link>
				<title>PEPPOL BIS Invoice</title>
			</head>
			<body>
				<!-- Start on header-->
				<table border="0" width="100%" cellspacing="0" cellpadding="2">
					<tr>
						<td colspan="4">
						</td>
					</tr>
				</table>
				<br/>
				<table border="0" width="100%" cellspacing="0" cellpadding="2">
					<tr>
						<td colspan="2">
							<!-- Inserting Header -->
							<h3>
								<xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PEPPOLInv']"/>&#160; 
								<xsl:if test="cbc:InvoiceTypeCode = 'Proforma' or cbc:InvoiceTypeCode = 'Factored'">-&#160;<xsl:value-of select="cbc:InvoiceTypeCode"/></xsl:if>&#160;
								<xsl:if test="cbc:CopyIndicator ='true'"><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='CopyIndicator']"/></xsl:if>
							</h3>
						</td>
						<td/>
						<td/>
						<td/>
					</tr>
					<tr>
						<td colspan="5">
							<hr size="5"/>
						</td>
					</tr>
					<tr>
						<td width="40%" valign="top">
							<!-- Inserting Accounting Supplier Party-->
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='AccountingSupplierInv']"/></b>
							<br/>
							<xsl:apply-templates select="cac:AccountingSupplierParty"/>
						</td>
						<td valign="top" width="30%">
							<!-- Inserting contact information -->
							<xsl:if test="cac:AccountingSupplierParty/cac:Party/cac:Contact !=''">
								<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='Contact']"/></b>
								<br/>
								<xsl:apply-templates select="cac:AccountingSupplierParty/cac:Party" mode="accsupcontact"/>
							</xsl:if>
						</td>
						<!--<xsl:if test="cac:SellerSupplierParty !=''">
							<td colspan="2">
								--><!-- Inserting Seller party --><!--
								<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='SellerParty']"/></b>
								<br/>
								<xsl:apply-templates select="cac:SellerSupplierParty"/>
							</td>
						</xsl:if>-->
					</tr>
					<tr>
						<td colspan="5">
							<hr size="2"/>
						</td>
					</tr>
					<tr>
						<td valign="top" width="40%">
							<!-- Inserting Accounting Customer Party -->
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='AccountingCustomerInv']"/></b>
							<br/>
							<xsl:apply-templates select="cac:AccountingCustomerParty"/>            
							<xsl:if test="cbc:AccountingCost !=''">
								<xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='AccountingCost']"/>&#160;<xsl:value-of select="cbc:AccountingCost"/>
							</xsl:if>
						</td>
						<td valign="top" width="30%">
							<xsl:if test="cac:AccountingCustomerParty/cac:Party/cac:Contact !=''">
								<!-- Inserting Contact information-->
								<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='Contact']"/></b>
								<br/>
								<xsl:apply-templates select="cac:AccountingCustomerParty/cac:Party" mode="acccuscontact"/>
							</xsl:if>
						</td>
						<!--<xsl:if test="cac:BuyerCustomerParty !=''">
							<td>
								--><!-- Inserting Buyer Party --><!--
								<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='BuyerParty']"/></b>
								<br/>
								<xsl:apply-templates select="cac:BuyerCustomerParty"/>
							</td>
						</xsl:if>-->
						<xsl:if test="cac:PayeeParty !=''">
							<xsl:if test="cac:PayeeParty/cac:PartyIdentification/cbc:ID != cac:AccountingCustomerParty/cac:Party/cac:PartyIdentification/cbc:ID">
								<xsl:if test="cac:PayeeParty/cac:PartyName/cbc:Name != cac:AccountingCustomerParty/cac:Party/cac:PartyName/cbc:Name">
								<td valign="top" width="30%">
									<!-- Inserting Payee Party -->
									<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PayeeParty']"/></b>
									<br/>
									<xsl:apply-templates select="cac:PayeeParty"/>
								</td>
								</xsl:if>
							</xsl:if>
						</xsl:if>	
					</tr>
					<tr>
						<td colspan="5">
							<hr size="2"/>
						</td>
					</tr>
					<xsl:if test="cac:Delivery !=''">
						<tr>
							<td colspan="5">
								<!-- Instering Delivery Information-->
								<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='Delivery']"/></b>
								<br/>
								<br/>
							</td>
						</tr>	
						<xsl:apply-templates select="cac:Delivery" mode="header"/>
					</xsl:if>
					<tr>
						<td colspan="5">
							<hr size="2"/>
						</td>
					</tr>
					<tr>
						<td width="26%">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='InvoiceID']"/>&#160;</b>
							<!-- Inserting Invoice ID -->
							<xsl:value-of select="cbc:ID"/>
						</td>
						
						<td width="26%">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='OrderReferenceID']"/>&#160;</b>
							<!-- Inserting Order reference number  -->
							<xsl:value-of select="cac:OrderReference/cbc:ID"/>
						</td>
						<td width="23%">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='SalesOrderID']"/>&#160;</b>
							<!-- Inserting Sellers Order reference number -->
							<xsl:value-of select="cac:OrderReference/cbc:SalesOrderID"/>
						</td>
						<td width="27%">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='IssueDate']"/>&#160;</b>
							<!-- Inserting Invoice Date -->
							<xsl:value-of select="cbc:IssueDate"/>
						</td>
					</tr>
					<tr>
						<td colspan="5">
							<hr size="2"/>
						</td>
					</tr>
				</table>
				<br/>
				<!-- End of invoice header -->
				<!--Start Invoiceline-->
				<table border="0" width="100%" cellspacing="0" cellpadding="2">
					<tr class="UBLInvoiceLineHeader">
						<td valign="top">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='LineID']"/></b>
						</td>
						<td valign="top">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='SellersItemIdentification']"/></b>
						</td>
						<td valign="top">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='ItemName']"/></b>
						</td>
						<td valign="top">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='Quantity']"/></b>
						</td>
						<td valign="top">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='QuantityUnitCode']"/></b>
						</td>
						<td valign="top">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PriceUnit']"/></b>
						</td>
						<td valign="top">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='TaxScheme']"/></b>
						</td>
						<td valign="top">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='AllowanceChargePrice']"/></b>
						</td>
						<td align="right" valign="top">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='LineExtensionAmountLine']"/></b>
						</td>
					</tr>
					<xsl:apply-templates select="cac:InvoiceLine"/>
				</table>
				<!--End Invoiceline-->
				
				<!--Start taxes and totals-->
				<table border="0" width="100%" cellspacing="0" cellpadding="2">
					<tr>
						<td colspan="8">
							<hr size="2"/>
						</td>
					</tr>
						<!-- Linetotal -->
						<xsl:apply-templates select="cac:LegalMonetaryTotal" mode="LineTotal"/>
						<!-- Afgifter på header -->
						<xsl:apply-templates select="cac:TaxTotal" mode="afgift"/>
						<!-- Allowance charge on header -->
						<xsl:apply-templates select="cac:AllowanceCharge" mode="total"/>
						<!-- Tax  -->
						<xsl:apply-templates select="cac:TaxTotal" mode="moms"/>
						<!-- Invoicetotal  -->
						<xsl:apply-templates select="cac:LegalMonetaryTotal" mode="Total"/>
					<tr>
						<td colspan="8">
							<hr size="5"/>
						</td>
					</tr>
				</table>
				<!--End taxes and totals-->
				
				<!-- Start on payment information -->
				<table border="0" width="100%" cellspacing="0" cellpadding="2">
					<tr>
						<td valign="top">
							<xsl:apply-templates select="cac:PaymentMeans"/>
						</td>
						<td valign="top">
							<xsl:apply-templates select="cac:PaymentTerms"/>
							<xsl:if test="cac:PrepaidPayment !=''">
								<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PrepaidPayment']"/></b><br/><xsl:apply-templates select="cac:PrepaidPayment"/>
							</xsl:if>
							<xsl:if test="cac:LegalMonetaryTotal !=''">
								<xsl:apply-templates select="cac:LegalMonetaryTotal" mode="supp"/>
							</xsl:if>
							<xsl:if test="cac:AllowanceCharge !=''">
								<br/><xsl:apply-templates select="cac:AllowanceCharge" mode="supp"/>
							</xsl:if>
							<xsl:if test="cac:TaxTotal !=''">
								<br/><xsl:apply-templates select="cac:TaxTotal" mode="supp"/><br/>
							</xsl:if>
						</td>
						<td valign="top">
							<xsl:if test="cac:TaxExchangeRate !=''">
								<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='TaxExchangeRate']"/></b><br/>
								<xsl:apply-templates select="cac:TaxExchangeRate"/>
							</xsl:if>
							<xsl:if test="cac:PricingExchangeRate !=''">
								<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PricingExchangeRate']"/></b><br/>
								<xsl:apply-templates select="cac:PricingExchangeRate"/>
							</xsl:if>
							<xsl:if test="cac:PaymentExchangeRate !=''">
								<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PaymentExchangeRate']"/></b><br/>
								<xsl:apply-templates select="cac:PaymentExchangeRate"/>
							</xsl:if>
							<xsl:if test="cac:PaymentAlternativeExchangeRate !=''">
								<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PaymentAlternativeExchangeRate']"/></b><br/>
								<xsl:apply-templates select="cac:PaymentAlternativeExchangeRate"/>
							</xsl:if>
						</td>
					</tr>
				</table>
				<!-- End of payment information -->
				
				<!-- Start on free text information and references-->
				<xsl:if test="cac:InvoicePeriod !='' or cbc:Note !='' or cac:OrderReference/cac:DocumentReference !='' or cac:ContractDocumentReference/cbc:ID !='' or cac:AdditionalDocumentReference/cbc:ID !=''">
				<table border="0" width="100%" cellspacing="0" cellpadding="2">
					<tr>
						<td colspan="3">
							<hr size="2"/>
						</td>
					</tr>
					<tr>
						<td>
						<xsl:if test="cac:InvoicePeriod !=''">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='InvoicePeriod']"/></b>&#160;<xsl:apply-templates select="cac:InvoicePeriod"/><br/>
						</xsl:if>
						<xsl:if test="cbc:Note[.!='']">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='Notes']"/></b>&#160;<xsl:apply-templates select="cbc:Note"/><br/>
						</xsl:if>
						<xsl:if test="cac:OrderReference/cac:DocumentReference !=''">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='OrderDocumentReference']"/></b>&#160;<xsl:apply-templates select="cac:OrderReference" mode="reference"/><br/>
						</xsl:if>
						<xsl:if test="cac:ContractDocumentReference/cbc:ID !=''">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='ContractDocumentReference']"/></b>&#160;<xsl:apply-templates select="cac:ContractDocumentReference"/><br/>
						</xsl:if>
						<xsl:if test="cac:AdditionalDocumentReference/cbc:ID !=''">
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='AdditionalDocumentReferenceID']"/></b>&#160;<xsl:apply-templates select="cac:AdditionalDocumentReference"/><br/>
						</xsl:if>
						</td>
					</tr>
				</table>
				</xsl:if>
				<!-- Slut på fritekst and references-->
				
				<!-- Start on Footer -->
				<table border="0" width="100%" cellspacing="0" cellpadding="2">
					<tr>
						<td colspan="3">
							<hr size="2"/>
						</td>
					</tr>
					<tr>
						<td>
							<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PEPPOLDoc']"/></b>
							<br/>
                                 <b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='VersionID']"/></b>&#160;<xsl:value-of select="cbc:UBLVersionID"/>
							<br/>
                                <b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='CustomizationID']"/></b>&#160;<xsl:value-of select="cbc:CustomizationID"/>
							<br/>
                                <b> <xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='ProfileID']"/></b>&#160;<xsl:value-of select="cbc:ProfileID"/>
							<br/>
                                <b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='ID']"/></b>&#160;<xsl:value-of select="cbc:ID"/>
							<br/>
							<xsl:if test="cbc:UUID !=''">
                                <xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='UUID']"/>&#160;<xsl:value-of select="cbc:UUID"/>
							</xsl:if>
							<br/>
							<xsl:if test="cbc:DocumentCurrencyCode !=''">
								<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='DocumentCurrencyCode']"/></b>&#160;<xsl:value-of select="cbc:DocumentCurrencyCode"/>
							<br/>
							</xsl:if>							
							<xsl:if test="cbc:TaxCurrencyCode !=''">
								<xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='TaxCurrencyCode']"/>&#160;<xsl:value-of select="cbc:TaxCurrencyCode"/>
							<br/>	
							</xsl:if>
							<xsl:if test="cbc:PricingCurrencyCode !=''">
								<xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PricingCurrencyCode']"/>&#160;<xsl:value-of select="cbc:PricingCurrencyCode"/>
							<br/>
							</xsl:if>
							<xsl:if test="cbc:PaymentCurrencyCode !=''">
								<xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PaymentCurrencyCode']"/>&#160;<xsl:value-of select="cbc:PaymentCurrencyCode"/>
							<br/>
							</xsl:if>
							<xsl:if test="cbc:PaymentAlternativeCurrencyCode !=''">
								<xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PaymentAlternativeCurrencyCode']"/>&#160;<xsl:value-of select="cbc:PaymentAlternativeCurrencyCode"/>
							<br/>
							</xsl:if>
							
						</td>
						<xsl:if test="cac:Signature !=''">
							<td>
								<xsl:apply-templates select="cac:Signature"/>
							</td>
						</xsl:if>
					</tr>
				</table>
				<!-- End of footer-->
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
