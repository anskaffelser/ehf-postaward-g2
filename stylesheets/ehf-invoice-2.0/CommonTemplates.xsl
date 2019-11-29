<?xml version="1.0" encoding="utf-8"?>
 <!--
******************************************************************************************************************

		PEPPOL Instance Documentation

		title= CommonTemplates.xml
		publisher= Difi
		created= 2014-02-12
		conformsTo= UBL-Invoice-2.1.xsd
		description= "Common templates for displaying EHF Invoice and creditnote, version 2.0"

		Derived from work by SFTI, Sweden and OIOUBL, Denmark.

******************************************************************************************************************
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:n1="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
	xmlns:n2="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
	xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
	xmlns:ccts="urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2"
	xmlns:sdt="urn:oasis:names:specification:ubl:schema:xsd:SpecializedDatatypes-2"
	xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"
	exclude-result-prefixes="n1 n2 cac cbc ccts sdt udt">
	<!--Language parameters-->
	<xsl:param name="pLang" select="'en'"/>
	<xsl:variable name="moduleDoc" select="document('Headlines.xml')"/>
	<!--UomText/Code parameters-->
	<xsl:param name="pUoMText" select="'not'"/>
	<xsl:variable name="vcodeText" select="document('UomText.xml')"/>


	<!--Party templates from here:-->
	<xsl:template match=" cac:AccountingSupplierParty | cac:AccountingCustomerParty">
		<div class="UBLBuyerCustomerParty">
			<xsl:apply-templates select="cac:Party"/>
		</div>
	</xsl:template>
	<xsl:template match="cac:Party | cac:PayeeParty | cac:TaxRepresentativeParty">
		<div class="UBLPayeeParty">
			<xsl:apply-templates select="cac:PartyName"/>
			<xsl:apply-templates select="cac:PostalAddress"/>

			<div>
				<xsl:if test="cac:PartyIdentification/cbc:ID">


					<small><xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='PartyID']/g-lang[lang($pLang)]"
					/> &#160;(<xsl:apply-templates select="cac:PartyIdentification/cbc:ID/@schemeID"/>)
						<xsl:apply-templates select="cac:PartyIdentification/cbc:ID"/>

					</small>

				</xsl:if>
			</div>
			<!--Party legal registration: -->

			<xsl:if test="cac:PartyLegalEntity">
				<xsl:if test="cac:PartyLegalEntity">
					<div>
						<xsl:if test="cac:PartyLegalEntity/cbc:CompanyID !='' ">


							<small><xsl:value-of
									select="$moduleDoc/module/document-merge/g-funcs/g[@name='CompanyID']/g-lang[lang($pLang)]"
								/> &#160;<xsl:apply-templates
									select="cac:PartyLegalEntity/cbc:CompanyID"/>

							</small>
						</xsl:if>
					</div>

				</xsl:if>

				<xsl:if test="cac:PartyLegalEntity/cbc:RegistrationName !=''">

					<div>

						<small><xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='RegistrationName']/g-lang[lang($pLang)]"
							/> &#160;<xsl:apply-templates
								select="cac:PartyLegalEntity/cbc:RegistrationName"/>
						</small>
					</div>

				</xsl:if>

				<xsl:if test="cac:PartyLegalEntity/cac:RegistrationAddress !=''">

					<div>

						<small>
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='RegistrationAddress']/g-lang[lang($pLang)]"/>

							<xsl:choose>

								<xsl:when
									test="cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName !='' and

							cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country !=''"
									> &#160;<xsl:apply-templates
										select="cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"
									/>,&#160; <xsl:apply-templates
										select="cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"
									/>
								</xsl:when>

								<xsl:otherwise>

									<xsl:if
										test="cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName !=''"
										> &#160;<xsl:apply-templates
											select="cac:PartyLegalEntity/cac:RegistrationAddress/cbc:CityName"
										/>
									</xsl:if>

									<xsl:if
										test="cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country !=''"
										> &#160;<xsl:apply-templates
											select="cac:PartyLegalEntity/cac:RegistrationAddress/cac:Country"
										/>
									</xsl:if>

								</xsl:otherwise>

							</xsl:choose>

						</small>
					</div>

				</xsl:if>
			</xsl:if>

			<!--Party VAT registration: -->

			<xsl:if test="cac:PartyTaxScheme">
				<div class="small">

					<xsl:if test="cac:PartyTaxScheme">
						<div>
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='VAT Number']/g-lang[lang($pLang)]"
							/> &#160;<xsl:apply-templates select="cac:PartyTaxScheme/cbc:CompanyID"/>

						</div>
					</xsl:if>

					<xsl:if test="cac:PartyTaxScheme/cbc:ExemptionReason">
						<div>
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='ExemptionReason']/g-lang[lang($pLang)]"
							/> &#160;<xsl:apply-templates
								select="cac:PartyTaxScheme/cbc:ExemptionReason"/>
						</div>
					</xsl:if>


				</div>
			</xsl:if>
		</div>
	</xsl:template>



	<xsl:template match="cac:PartyName">
		<xsl:if test="cbc:Name !=''">
			<xsl:apply-templates select="cbc:Name"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cac:PostalAddress | cac:DeliveryAddress | cac:Address ">
		<div>
			<xsl:if test="cbc:StreetName !=''">
				<span class="UBLStreetName">
					<xsl:apply-templates select="cbc:StreetName"/>
				</span>
			</xsl:if>
		</div>
		<div>
			<xsl:if test="cbc:AdditionalStreetName !=''">
				<span class="UBLAdditionalStreetName">
					<xsl:apply-templates select="cbc:AdditionalStreetName"/>
				</span>
			</xsl:if>
		</div>
		<div>
			<xsl:if test="cbc:PostalZone !='' or cbc:CityName !=''">

				<span class="UBLCityName">

					<xsl:choose>

						<xsl:when test="cbc:PostalZone !=''">
							<xsl:apply-templates select="cbc:PostalZone"/>
								&#160;<xsl:apply-templates select="cbc:CityName"/>
						</xsl:when>

						<xsl:otherwise>

							<xsl:apply-templates select="cbc:CityName"/>

						</xsl:otherwise>

					</xsl:choose>


				</span>

			</xsl:if>
		</div>
		<div>

			<xsl:if test="cbc:CountrySubentity !='' or cac:Country !=''">

				<xsl:choose>

					<xsl:when test="cbc:CountrySubentity !='' and cac:Country !=''">
						<div>
							<xsl:apply-templates select="cbc:CountrySubentity"/>,
								&#160;<xsl:apply-templates select="cac:Country"/>
						</div>
					</xsl:when>


					<xsl:otherwise>

						<div>

							<xsl:if test="cbc:CountrySubentity !=''">

								<xsl:apply-templates select="cbc:CountrySubentity"/>

							</xsl:if>

							<xsl:if test="cac:Country !=''">

								<xsl:apply-templates select="cac:Country/cbc:IdentificationCode"/>

							</xsl:if>
						</div>
					</xsl:otherwise>

				</xsl:choose>

			</xsl:if>
		</div>

	</xsl:template>



	<xsl:template match="cac:Country">
		<span>
			<xsl:apply-templates select="cbc:IdentificationCode"/>

			<!-- Checking of listID (normally NOT a function of a stylesheet): -->

			<xsl:if test="cbc:IdentificationCode/@listID !=''">

				<xsl:if test="cbc:IdentificationCode/@listID !='ISO3166-1:Alpha2'">
								&#160;<em class="small">[<xsl:apply-templates
								select="cbc:IdentificationCode/@listID"/> &#160;-invalid
							listID]</em>
				</xsl:if>


			</xsl:if>

		</span>
	</xsl:template>


	<!--Delivery templates start: -->

	<xsl:template match="cac:Delivery" mode="DocumentHeader">
		<td colspan="2">
			<xsl:if test="cbc:ActualDeliveryDate !='' ">
				<xsl:if test="cbc:ActualDeliveryDate !=''">
					<h2>
						<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='ActualDeliveryDate']/g-lang[lang($pLang)]"
						/>
					</h2>
					<xsl:apply-templates select="cbc:ActualDeliveryDate"/>
				</xsl:if>
			</xsl:if>
		</td>
		<xsl:if test="cac:DeliveryLocation !=''">
			<td colspan="2">
				<h2>
					<xsl:value-of
						select="$moduleDoc/module/document-merge/g-funcs/g[@name='DeliveryLocation']/g-lang[lang($pLang)]"
					/>
				</h2>
				<xsl:apply-templates select="cac:DeliveryLocation"/>
			</td>
		</xsl:if>
	</xsl:template>



	<xsl:template match="cac:DeliveryLocation">
		<xsl:if test="cbc:ID !=''">
			<small>
				<xsl:value-of
					select="$moduleDoc/module/document-merge/g-funcs/g[@name='DeliveryLocationID']/g-lang[lang($pLang)]"
				/> &#160;<xsl:apply-templates select="cbc:ID"/>

			</small>
		</xsl:if>
		<xsl:if test="cac:Address !=''">
			<xsl:apply-templates select="cac:Address"/>
		</xsl:if>
	</xsl:template>



	<xsl:template match="cac:Delivery" mode="line-new">

		<tr>
			<td>

				<small>
					<xsl:if test="cbc:ActualDeliveryDate !=''">
						<h2><xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='ActualDeliveryDate']/g-lang[lang($pLang)]"
							/> </h2>&#160;<xsl:apply-templates select="cbc:ActualDeliveryDate"
						/>&#160; </xsl:if>

				</small>

			</td>

			<xsl:if test="cac:DeliveryLocation !=''">
				<td class="small">

						<h2>
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='DeliveryLocation']/g-lang[lang($pLang)]"
							/>
						</h2>

						<xsl:if test="cac:DeliveryLocation/cbc:ID !=''">
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='DeliveryLocationID']/g-lang[lang($pLang)]"
							/> &#160;<xsl:apply-templates select="cac:DeliveryLocation/cbc:ID"/>
							<xsl:choose>
								<xsl:when test="cac:DeliveryLocation/cbc:ID/@schemeID !=''">
										&#160;[<xsl:apply-templates
										select="cac:DeliveryLocation/cbc:ID/@schemeID"/>] </xsl:when>
								<xsl:otherwise> &#160;[No schemeID] </xsl:otherwise>
							</xsl:choose>
						</xsl:if>

						<xsl:if test="cac:DeliveryLocation/cac:Address !=''">
							<xsl:apply-templates select="cac:DeliveryLocation/cac:Address"/>&#160; </xsl:if>

				</td>

			</xsl:if>

		</tr>

	</xsl:template>
	<!--Delivery template end-->


	<!--Contact from here: -->
	<xsl:template match="cac:AccountingSupplierParty/cac:Party" mode="accsupcontact">
		<xsl:apply-templates select="cac:Contact"/>
	</xsl:template>
	<xsl:template match="cac:AccountingCustomerParty/cac:Party" mode="acccuscontact">
		<xsl:apply-templates select="cac:Contact"/>
	</xsl:template>


	<xsl:template match="cac:Contact">
		<div class="UBLContact">
			<div class="UBLID">
				<xsl:if test="cbc:ID">
					<small><xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='ContactID']/g-lang[lang($pLang)]"
						/> &#160;<xsl:apply-templates select="cbc:ID"/></small>
				</xsl:if>
			</div>
			<xsl:if test="cbc:Name !=''">
				<div class="UBLName">
					<xsl:apply-templates select="cbc:Name"/>
				</div>
			</xsl:if>
			<div>
				<xsl:if test="cbc:Telephone !=''">
					<span class="UBLTelephone">
						<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='Telephone']/g-lang[lang($pLang)]"
						/> &#160;<xsl:apply-templates select="cbc:Telephone"/>
					</span>
				</xsl:if>
			</div>
			<div>
				<xsl:if test="cbc:Telefax !=''">
					<span class="UBLTelefax">
						<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='Telefax']/g-lang[lang($pLang)]"
						/> &#160;<xsl:apply-templates select="cbc:Telefax"/>
					</span>
				</xsl:if>
			</div>
			<div>
				<xsl:if test="cbc:ElectronicMail !=''">
					<span class="UBLElectronicMail">
						<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='ElectronicMail']/g-lang[lang($pLang)]"
						/> &#160;<xsl:apply-templates select="cbc:ElectronicMail"/>
					</span>
				</xsl:if>
			</div>
		</div>
	</xsl:template>
	<!--Contact end-->



	<!--Invoiceline start: -->
	<xsl:template match="cac:InvoiceLine | cac:CreditNoteLine">

		<xsl:param name="pUoM" select="cbc:InvoicedQuantity/@unitCode"/>
		<tr>
			<td>
				<xsl:apply-templates select="cbc:ID"/>
			</td>
			<td>
				<xsl:apply-templates select="cac:Item/cac:SellersItemIdentification"/>
			</td>
			<td>
				<xsl:apply-templates select="cac:Item/cbc:Name"/>
			</td>
			<td class="right">
				<xsl:if test="cbc:InvoicedQuantity !=''">

					<xsl:apply-templates select="cbc:InvoicedQuantity"/>
				</xsl:if>

				<xsl:if test="cbc:CreditedQuantity !=''">

					<xsl:apply-templates select="cbc:CreditedQuantity"/>
				</xsl:if>

			</td>
			<td class="center">
				<xsl:if test="cbc:InvoicedQuantity !=''">
					<!--Checking of parameter to set output of unitcodes to text or code -->
					<xsl:choose>
						<xsl:when test="$pUoMText = 'yes' and $vcodeText/uomText/uom[@key = $pUoM]">
							<xsl:apply-templates select="$vcodeText/uomText/uom[@key = $pUoM]/tekst[lang($pLang)]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="cbc:InvoicedQuantity/@unitCode"/>
						</xsl:otherwise>
					</xsl:choose>&#160;&#160;


					<!-- Checking of unitCodeListID (NOT a normal control function of a stylesheet): -->
					<xsl:choose>
						<xsl:when test="cbc:InvoicedQuantity/@unitCodeListID !=''">
							<xsl:if test="cbc:InvoicedQuantity/@unitCodeListID != 'UNECERec20'">
											&#160;<em class="small">[<xsl:apply-templates select="cbc:InvoicedQuantity/@unitCodeListID"/>&#160;-invalid unitCodeListID]</em>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<em class="small">&#160;[No unitCodeListID]</em>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>

				<xsl:if test="cbc:CreditedQuantity !=''">
					<!--Checking of parameter to set output of unitcodes to text or code -->
					<xsl:choose>
						<xsl:when test="$pUoMText = 'yes' and $vcodeText/uomText/uom[@key = $pUoM]">
							<xsl:apply-templates select="$vcodeText/uomText/uom[@key = $pUoM]/tekst[lang($pLang)]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="cbc:CreditedQuantity/@unitCode"/>
						</xsl:otherwise>
					</xsl:choose>&#160;&#160;

					<!-- Checking of unitCodeListID (NOT a normal control function of a stylesheet): -->
					<xsl:choose>
						<xsl:when test="cbc:CreditedQuantity/@unitCodeListID !=''">
							<xsl:if test="cbc:CreditedQuantity/@unitCodeListID != 'UNECERec20'">
							  &#160;<small><em>[<xsl:apply-templates select="cbc:CreditedQuantity/@unitCodeListID"/>&#160;-invalid unitCodeListID]</em></small>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<em class="small">&#160;[No unitCodeListID]</em>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>

			</td>
			<td>
				<xsl:apply-templates select="cac:Price"/>
				<xsl:if test="cac:Price/cbc:BaseQuantity">

					<div class="small">
						<div>
						per&#160;<xsl:apply-templates select="cac:Price/cbc:BaseQuantity"/>
							&#160;<xsl:apply-templates select="cac:Price/cbc:BaseQuantity/@unitCode"/>
						</div>
						<xsl:choose>
							<xsl:when test="cbc:InvoicedQuantity !=''">
								<!-- Unit of BaseQuantity must correspond to InvoicedQuantity (NOT a normal control function of a stylesheet): -->
								<xsl:if test="cac:Price/cbc:BaseQuantity/@unitCode != ''">
									<xsl:if
										test="cac:Price/cbc:BaseQuantity/@unitCode != cbc:InvoicedQuantity/@unitCode"
										> &#160;<small><em>[Invalid unitCode]</em></small>
									</xsl:if>
								</xsl:if>
								<xsl:if test="cac:Price/cbc:BaseQuantity/@unitCodeListID != ''">
									<xsl:if test="cac:Price/cbc:BaseQuantity/@unitCodeListID != cbc:InvoicedQuantity/@unitCodeListID">
										&#160;<small><em>[<xsl:apply-templates select="cac:Price/cbc:BaseQuantity/@unitCodeListID"/> &#160;-invalid unitCodeListID]</em></small>
									</xsl:if>
								</xsl:if>
							</xsl:when>
							<xsl:when test="cbc:CreditedQuantity !=''">
								<!-- Unit of BaseQuantity must correspond to CreditedQuantity (NOT a normal control function of a stylesheet): -->
								<xsl:if test="cac:Price/cbc:BaseQuantity/@unitCode != ''">
									<xsl:if
										test="cac:Price/cbc:BaseQuantity/@unitCode != cbc:CreditedQuantity/@unitCode"
										> &#160;<small><em>[Invalid unitCode]</em></small>
									</xsl:if>
								</xsl:if>
								<xsl:if test="cac:Price/cbc:BaseQuantity/@unitCodeListID != ''">
									<xsl:if
										test="cac:Price/cbc:BaseQuantity/@unitCodeListID != cbc:CreditedQuantity/@unitCodeListID"
										> &#160;<small><em>[<xsl:apply-templates
												select="cac:Price/cbc:BaseQuantity/@unitCodeListID"
												/> &#160;-invalid unitCodeListID]</em></small>
									</xsl:if>
								</xsl:if>
							</xsl:when> <xsl:otherwise/>
						</xsl:choose>
					</div>
				</xsl:if>

			</td>
			<td>
				<xsl:if test="cac:Item/cac:ClassifiedTaxCategory !='' ">
					<xsl:choose>
						<xsl:when test="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent !=''">
							<xsl:apply-templates select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"
							/>,&#160; <xsl:apply-templates
								select="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent"/>% </xsl:when>

						<xsl:otherwise>
							<xsl:apply-templates select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID"/>

						</xsl:otherwise>
					</xsl:choose>

					<xsl:if test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID/@schemeID !='' ">
						<xsl:if
							test="cac:Item/cac:ClassifiedTaxCategory/cbc:ID/@schemeID !='UNCL5305' ">

							<br/>
							<small>[<xsl:apply-templates
									select="cac:Item/cac:ClassifiedTaxCategory/cbc:ID/@schemeID"/> -
								Invalid schemeID]</small>
						</xsl:if>

					</xsl:if>


				</xsl:if>

				<xsl:if test="cac:TaxTotal/cbc:TaxAmount">

					<small>

						<xsl:choose>
							<xsl:when test="cac:Item/cac:ClassifiedTaxCategory/cbc:Percent !=''">
								<br/>(<xsl:apply-templates select="cac:TaxTotal/cbc:TaxAmount"
								/>&#160; <xsl:apply-templates
									select="cac:TaxTotal/cbc:TaxAmount/@currencyID"/>) </xsl:when>

							<xsl:otherwise> (<xsl:apply-templates
									select="cac:TaxTotal/cbc:TaxAmount"/>&#160; <xsl:apply-templates
									select="cac:TaxTotal/cbc:TaxAmount/@currencyID"/>) </xsl:otherwise>

						</xsl:choose>


					</small>

				</xsl:if>


			</td>

			<td>

				<xsl:if test="cac:AllowanceCharge !=''">
					<xsl:apply-templates select="cac:AllowanceCharge" mode="LineLevel-new"/>
				</xsl:if>
			</td>
			<td class="right">
				<xsl:apply-templates select="cbc:LineExtensionAmount"/> &#160;<xsl:apply-templates
					select="cbc:LineExtensionAmount/@currencyID"/>
			</td>
		</tr>

		<tr>
			<!-- Invoice line/part 2: -->
			<td colspan="2">&#160;</td>
			<td class="small">
				<xsl:if test="cac:Item/cac:StandardItemIdentification/cbc:ID !=''">
					<div>
						<b>
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='StandardItemIdentification']/g-lang[lang($pLang)]"
							/>&#160;</b>
						<xsl:apply-templates
							select="cac:Item/cac:StandardItemIdentification/cbc:ID"/>

						<xsl:choose>
							<xsl:when
								test="cac:Item/cac:StandardItemIdentification/cbc:ID/@schemeID !=''">
								<small>&#160;[<xsl:apply-templates
										select="cac:Item/cac:StandardItemIdentification/cbc:ID/@schemeID"
									/>]</small>
							</xsl:when>
							<xsl:otherwise>
								<small>&#160;[No schemeID]</small>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</xsl:if>
				<xsl:if test="cac:Item/cbc:Description !=''">
					<div>
						<b>
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='ItemDescription']/g-lang[lang($pLang)]"
							/>&#160;</b>
						<xsl:apply-templates select="cac:Item/cbc:Description"/>
					</div>
				</xsl:if>

				<xsl:if test="cac:Item/cac:AdditionalItemProperty !=''">
					<xsl:apply-templates select="cac:Item/cac:AdditionalItemProperty"/>
				</xsl:if>

				<xsl:if test="cbc:Note !=''">
					<div>
						<b>
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='LineNotes']/g-lang[lang($pLang)]"
							/>&#160;</b>
						<xsl:apply-templates select="cbc:Note"/>
					</div>
				</xsl:if>
				<xsl:if test="cac:Item/cac:CommodityClassification !=''">
					<xsl:apply-templates select="cac:Item/cac:CommodityClassification"/>
				</xsl:if>

				<xsl:if test="cbc:AccountingCost !=''">
					<div>
						<b>
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='AccountingCost']/g-lang[lang($pLang)]"
							/>&#160;</b>: <xsl:apply-templates select="cbc:AccountingCost"/>
					</div>
				</xsl:if>

				<xsl:if test="cac:InvoicePeriod !=''">
					<div>
						<b><xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='InvoicePeriod']/g-lang[lang($pLang)]"
							/></b>&#160; <xsl:apply-templates select="cac:InvoicePeriod"/>
					</div>

				</xsl:if>


				<xsl:if test="cac:Price/cac:AllowanceCharge !=''">
					<xsl:apply-templates select="cac:Price/cac:AllowanceCharge"
						mode="PriceUnit-new"/>
				</xsl:if>

				<xsl:if test="cac:Item/cac:OriginCountry/cbc:IdentificationCode !=''">
					<div>
					<b>
						<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='OriginCountry']/g-lang[lang($pLang)]"
						/>&#160;</b>
					<xsl:apply-templates
						select="cac:Item/cac:OriginCountry/cbc:IdentificationCode"/>

					<xsl:if
						test="cac:Item/cac:OriginCountry/cbc:IdentificationCode/@listID !=''">
						<small>&#160;[<xsl:apply-templates
								select="cac:Item/cac:OriginCountry/cbc:IdentificationCode/@listID"
							/>]</small>
					</xsl:if>
					</div>
				</xsl:if>

				<xsl:if test="cac:OrderLineReference/cbc:LineID !=''">
					<div>
						<b><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='OrderLineReferenceID']/g-lang[lang($pLang)]"/>&#160;</b>
						<xsl:apply-templates select="cac:OrderLineReference/cbc:LineID"/>
					</div>
				</xsl:if>

				<xsl:if test="cac:Item/cac:ManufacturerParty/cac:PartyName/cbc:Name !=''">
					<b>
						<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='ManufacturerName']/g-lang[lang($pLang)]"
						/>&#160;</b>
					<xsl:apply-templates
						select="cac:Item/cac:ManufacturerParty/cac:PartyName/cbc:Name"/> ,
					&#160; <xsl:value-of
						select="$moduleDoc/module/document-merge/g-funcs/g[@name='ManufacturerID']/g-lang[lang($pLang)]"
					/>&#160; <xsl:apply-templates
						select="cac:Item/cac:ManufacturerParty/cac:PartyLegalEntity/cbc:CompanyID"
					/>
				</xsl:if>

				<xsl:if test="cac:BillingReference !=''">
					<div>
					<b><xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='BillingReference']/g-lang[lang($pLang)]"
						/>&#160;</b>
					<xsl:if test="cac:BillingReference/cac:CreditNoteDocumentReference !=''">
						<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='BillingRef-CreditNote']/g-lang[lang($pLang)]"
						/>&#160; <xsl:apply-templates
							select="cac:BillingReference/cac:CreditNoteDocumentReference/cbc:ID"
						/>&#160; </xsl:if>

					<xsl:if test="cac:BillingReference/cac:InvoiceDocumentReference !=''">
						<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='BillingRef-Invoice']/g-lang[lang($pLang)]"
						/>&#160; <xsl:apply-templates
							select="cac:BillingReference/cac:InvoiceDocumentReference/cbc:ID"
						/>&#160; </xsl:if>

					<xsl:if test="cac:BillingReference/cac:BillingReferenceLine !=''">
						<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='BillingRef-Line']/g-lang[lang($pLang)]"
						/>&#160; <xsl:apply-templates
							select="cac:BillingReference/cac:BillingReferenceLine/cbc:ID"/>
					</xsl:if>
					</div>
				</xsl:if>
			</td>
			<td colspan="6">&#160;</td>
		</tr>
		<!-- Invoice line/part 3: -->

		<xsl:if test="cac:Delivery !=''">

			<tr>

				<td> </td>
				<td> </td>

				<td class="UBLName">

					<table border="0" width="90%" cellspacing="0" cellpadding="2">

						<xsl:apply-templates select="cac:Delivery" mode="line-new"/>

					</table>

				</td>

			</tr>

		</xsl:if>


	</xsl:template>



	<xsl:template match="cac:CommodityClassification">

		<xsl:if test="cbc:CommodityCode !=''">
			<div>
			<b>
				<xsl:value-of
					select="$moduleDoc/module/document-merge/g-funcs/g[@name='CommodityCode']/g-lang[lang($pLang)]"
				/>&#160;</b>
			<xsl:apply-templates select="cbc:CommodityCode"/>
			<xsl:choose>
				<xsl:when test="cbc:CommodityCode/@listID !=''">
					<small>&#160;[<xsl:apply-templates select="cbc:CommodityCode/@listID"/>]</small>
				</xsl:when>
				<xsl:otherwise>
					<small>&#160;[No listID]</small>
				</xsl:otherwise>
			</xsl:choose>
			</div>
		</xsl:if>
		<xsl:if test="cbc:ItemClassificationCode !=''">
			<div>
			<b><xsl:value-of
					select="$moduleDoc/module/document-merge/g-funcs/g[@name='ItemClassificationCode']/g-lang[lang($pLang)]"
				/>&#160;</b>
			<xsl:apply-templates select="cbc:ItemClassificationCode"/>
			<xsl:choose>
				<xsl:when test="cbc:ItemClassificationCode/@listID !=''">
					<small>&#160;[<xsl:apply-templates select="cbc:ItemClassificationCode/@listID"
						/>]</small>
				</xsl:when>
				<xsl:otherwise>
					<small>&#160;[No listID]</small>
				</xsl:otherwise>
			</xsl:choose>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="cac:AdditionalItemProperty">
		<div>
			<b>
				<xsl:value-of
					select="$moduleDoc/module/document-merge/g-funcs/g[@name='AdditionalItemProperty']/g-lang[lang($pLang)]"
				/>&#160; </b>
			<xsl:apply-templates select="cbc:Name"/>:&#160;<xsl:apply-templates select="cbc:Value"/>
		</div>
	</xsl:template>



	<xsl:template match="cac:SellersItemIdentification">
		<xsl:apply-templates select="cbc:ID"/>
	</xsl:template>


	<xsl:template match="cac:Price">
		<xsl:apply-templates select="cbc:PriceAmount"/>&#160;<xsl:apply-templates
			select="cbc:PriceAmount/@currencyID"/>
	</xsl:template>

	<!--Invoiceline end-->



	<!-- Document legal totals from here-->
	<xsl:template match="cac:LegalMonetaryTotal" mode="New">
		<tr class="totals">
			<th><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='LineExtensionAmountTotal']/g-lang[lang($pLang)]"/></th>
			<th>
				<xsl:if test="cbc:AllowanceTotalAmount !='' ">
					<xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='AllowanceTotalAmount']/g-lang[lang($pLang)]"/>
				</xsl:if>
			</th>
			<th>
				<xsl:if test="cbc:ChargeTotalAmount !='' ">
					<xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='ChargeTotalAmount']/g-lang[lang($pLang)]"/>
				</xsl:if>
			</th>
			<th><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='TaxExclusiveAmount']/g-lang[lang($pLang)]"/></th>
			<th><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='TaxTotal(VAT)']/g-lang[lang($pLang)]"/></th>
			<th><xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='TaxInclusiveAmount']/g-lang[lang($pLang)]"/></th>
			<th>
				<xsl:if test="cbc:PrepaidAmount !='' ">
					<xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PrepaidAmount']/g-lang[lang($pLang)]"/>
				</xsl:if>
			</th>
			<th class="right">
				<xsl:choose>
					<xsl:when test="/n1:Invoice">
						<xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PayableAmountInv']/g-lang[lang($pLang)]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$moduleDoc/module/document-merge/g-funcs/g[@name='PayableAmountCre']/g-lang[lang($pLang)]"/>
					</xsl:otherwise>
				</xsl:choose>
			</th>
		</tr>
		<tr class="totals">
			<td><xsl:apply-templates select="cbc:LineExtensionAmount"/>&#160;<xsl:apply-templates select="cbc:LineExtensionAmount/@currencyID"/></td>
			<td>
				<xsl:if test="cbc:AllowanceTotalAmount !='' ">
					<xsl:apply-templates select="cbc:AllowanceTotalAmount"/>&#160;<xsl:apply-templates select="cbc:AllowanceTotalAmount/@currencyID"/>
				</xsl:if>
			</td>
			<td>
				<xsl:if test="cbc:ChargeTotalAmount !='' ">
					<xsl:apply-templates select="cbc:ChargeTotalAmount"/>&#160;<xsl:apply-templates select="cbc:ChargeTotalAmount/@currencyID"/>
				</xsl:if>
			</td>
			<td><xsl:apply-templates select="cbc:TaxExclusiveAmount"/>&#160;<xsl:apply-templates select="cbc:TaxExclusiveAmount/@currencyID"/></td>
			<td>
				<xsl:if test="../cac:TaxTotal/cbc:TaxAmount">
					<xsl:apply-templates select="../cac:TaxTotal/cbc:TaxAmount"/>&#160;<xsl:apply-templates	select="../cac:TaxTotal/cbc:TaxAmount/@currencyID"/>
				</xsl:if>
			</td>
			<td><xsl:apply-templates select="cbc:TaxInclusiveAmount"/>&#160;<xsl:apply-templates select="cbc:TaxInclusiveAmount/@currencyID"/></td>
			<td>
				<xsl:if test="cbc:PrepaidAmount !='' ">
					<xsl:apply-templates select="cbc:PrepaidAmount"/>&#160;<xsl:apply-templates select="cbc:PrepaidAmount/@currencyID"/>
				</xsl:if>
			</td>
			<td class="right"><strong><xsl:apply-templates select="cbc:PayableAmount"/>&#160;<xsl:apply-templates select="cbc:PayableAmount/@currencyID"/></strong></td>
		</tr>
	</xsl:template>


	<!-- Document legal totals until here-->



	<!--Allowance/Charge from here-->

	<!-- 1) A/C on document level -->

	<xsl:template match="cac:AllowanceCharge" mode="DocumentLevel-new">

		<tr>
			<td colspan="2">

				<xsl:choose>
					<xsl:when test="cbc:ChargeIndicator ='true'">
						<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='ChargeIndicatorTrue']/g-lang[lang($pLang)]"
						/>
					</xsl:when>
					<xsl:when test="cbc:ChargeIndicator ='false'">
						<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='ChargeIndicatorFalse']/g-lang[lang($pLang)]"
						/>
					</xsl:when>
					<xsl:otherwise/>

				</xsl:choose>

			</td>
			<td colspan="2">

				<xsl:if test="cbc:AllowanceChargeReasonCode !=''">
					<xsl:apply-templates select="cbc:AllowanceChargeReasonCode"/>

					<xsl:if test="cbc:AllowanceChargeReasonCode/@listID !='UNCL4465'">
								&#160;<small>[<xsl:apply-templates
								select="cbc:AllowanceChargeReasonCode/@listID"/>&#160;- invalid
							listID]</small>&#160; </xsl:if>
				</xsl:if>

			</td>

			<td colspan="2">

				<xsl:apply-templates select="cbc:AllowanceChargeReason"/>
			</td>

			<td>

				<xsl:if test="cac:TaxCategory !='' ">
					<xsl:choose>
						<xsl:when test="cac:TaxCategory/cbc:Percent !=''">
							<xsl:apply-templates select="cac:TaxCategory/cbc:ID"/>,
								&#160;<xsl:apply-templates select="cac:TaxCategory/cbc:Percent"/>% </xsl:when>

						<xsl:otherwise>


							<xsl:apply-templates select="cac:TaxCategory/cbc:ID"/>

						</xsl:otherwise>
					</xsl:choose>

				</xsl:if>

			</td>
			<td class="right">
				<xsl:apply-templates select="cbc:Amount"/>&#160;<xsl:apply-templates
					select="cbc:Amount/@currencyID"/>
			</td>
		</tr>

	</xsl:template>



	<!-- 2) A/C on line level -->

	<xsl:template match="cac:AllowanceCharge" mode="LineLevel-new">
		<xsl:choose>
			<xsl:when test="cbc:ChargeIndicator ='true'">
				<xsl:value-of
					select="$moduleDoc/module/document-merge/g-funcs/g[@name='ChargeIndicatorTrue']/g-lang[lang($pLang)]"
				/>:&#160; </xsl:when>
			<xsl:when test="cbc:ChargeIndicator ='false'">
				<xsl:value-of
					select="$moduleDoc/module/document-merge/g-funcs/g[@name='ChargeIndicatorFalse']/g-lang[lang($pLang)]"
				/>:&#160; </xsl:when>
		</xsl:choose>
		<xsl:apply-templates select="cbc:Amount"/>&#160;<xsl:apply-templates
			select="cbc:Amount/@currencyID"/>
		<small> <div><xsl:apply-templates select="cbc:AllowanceChargeReason"/> </div> </small>
	</xsl:template>



	<!-- 3) A/C on price unit level (for information only) -->

	<xsl:template match="cac:AllowanceCharge" mode="PriceUnit-new">
		<div>

		<b><xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='UnitNetPriceIncl']/g-lang[lang($pLang)]"
			/>&#160;</b>

		<xsl:choose>
			<xsl:when test="cbc:ChargeIndicator ='true'">
				<xsl:value-of
					select="$moduleDoc/module/document-merge/g-funcs/g[@name='ChargeIndicatorTrue']/g-lang[lang($pLang)]"
				/>
			</xsl:when>
			<xsl:when test="cbc:ChargeIndicator ='false'">
				<xsl:value-of
					select="$moduleDoc/module/document-merge/g-funcs/g[@name='ChargeIndicatorFalse']/g-lang[lang($pLang)]"
				/>
			</xsl:when>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="cbc:BaseAmount !='' "> &#160;<xsl:apply-templates select="cbc:Amount"
					/>&#160;<xsl:apply-templates select="cbc:Amount/@currencyID"/>,
					&#160;<xsl:value-of
					select="$moduleDoc/module/document-merge/g-funcs/g[@name='BasedOnAmount']/g-lang[lang($pLang)]"
				/> &#160;<xsl:apply-templates select="cbc:BaseAmount"/>&#160;<xsl:apply-templates
					select="cbc:BaseAmount/@currencyID"/>
			</xsl:when>

			<xsl:otherwise> &#160;<xsl:apply-templates select="cbc:Amount"
					/>&#160;<xsl:apply-templates select="cbc:Amount/@currencyID"/>
			</xsl:otherwise>
		</xsl:choose>
		</div>

	</xsl:template>
	<!-- AllowanceCharge end -->



	<!-- Tax (VAT) totals from here: -->
	<xsl:template match="cac:TaxTotal/cac:TaxSubtotal">

		<tr class="TAXInformation">
			<td colspan="2">
				<xsl:apply-templates select="cac:TaxCategory/cbc:ID"/>&#160; <xsl:choose> <xsl:when
						test="cac:TaxCategory/cbc:ID/@schemeID ='UNCL5305' "/>
					<xsl:otherwise>
						<br/><em><small>[<xsl:apply-templates
									select="cac:TaxCategory/cbc:ID/@schemeID"/> - Invalid
								schemeID]</small></em>
					</xsl:otherwise>
				</xsl:choose>
				<small>(= <xsl:choose>
						<!-- List as included in EHF -->
						<xsl:when test="cac:TaxCategory/cbc:ID = 'S'">
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='TAXCat_S']/g-lang[lang($pLang)]"
							/>
						</xsl:when> <xsl:when test="cac:TaxCategory/cbc:ID = 'E'">
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='TAXCat_E']/g-lang[lang($pLang)]"
							/>
						</xsl:when> <xsl:when test="cac:TaxCategory/cbc:ID = 'K'">
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='TAXCat_K']/g-lang[lang($pLang)]"
							/>
						</xsl:when> <xsl:when test="cac:TaxCategory/cbc:ID = 'AA'">
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='TAXCat_AA']/g-lang[lang($pLang)]"
							/>
						</xsl:when> <xsl:when test="cac:TaxCategory/cbc:ID = 'H'">
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='TAXCat_H']/g-lang[lang($pLang)]"
							/>
						</xsl:when> <xsl:when test="cac:TaxCategory/cbc:ID = 'Z'">
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='TAXCat_Z']/g-lang[lang($pLang)]"
							/>
						</xsl:when> <xsl:when test="cac:TaxCategory/cbc:ID = 'R'">
							<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='TAXCat_R']/g-lang[lang($pLang)]"
							/>
						</xsl:when> <xsl:otherwise>
							<!-- Outside the BII subset: -->
							<xsl:value-of select="'Not specified'"/>
						</xsl:otherwise>
					</xsl:choose> ),</small>
				<xsl:choose>
					<xsl:when test="cac:TaxCategory/cbc:Percent !=''"> &#160;<xsl:apply-templates
							select="cac:TaxCategory/cbc:Percent"/>% </xsl:when>
					<xsl:otherwise> % </xsl:otherwise>
				</xsl:choose>
			</td>
			<td colspan="2">

				<xsl:if test="cac:TaxCategory/cbc:TaxExemptionReason !=''">
					<xsl:apply-templates select="cac:TaxCategory/cbc:TaxExemptionReason"/>
				</xsl:if>

			</td>
			<td colspan="2">
				<xsl:apply-templates select="cbc:TaxableAmount"/> &#160;<xsl:apply-templates
					select="cbc:TaxableAmount/@currencyID"/>
			</td>
			<td class="right">
				<xsl:if test="cbc:TransactionCurrencyTaxAmount !=''">
					<xsl:apply-templates select="cbc:TransactionCurrencyTaxAmount"/>
						&#160;<xsl:apply-templates
						select="cbc:TransactionCurrencyTaxAmount/@currencyID"/>
				</xsl:if>

			</td>
			<td class="right">
				<xsl:apply-templates select="cbc:TaxAmount"/>&#160;<xsl:apply-templates
					select="cbc:TaxAmount/@currencyID"/>
			</td>
		</tr>
	</xsl:template>
	<!--TaxTotal until here-->



	<!--PaymentMeans from here-->
	<xsl:template match="cac:PaymentMeans">
		<tr>

			<td>
				<xsl:apply-templates select="cbc:PaymentMeansCode"/>

				<xsl:choose>

					<xsl:when test="cbc:PaymentMeansCode/@listID ='UNCL4461' "/>
					<xsl:otherwise>
						<br/>
						<em>
							<small>[<xsl:apply-templates select="cbc:PaymentMeansCode/@listID"/> -
								Invalid listID]</small>
						</em>
					</xsl:otherwise>
				</xsl:choose>
			</td>

			<td>
				<xsl:if test="cbc:PaymentChannelCode !=''">
					<xsl:apply-templates select="cbc:PaymentChannelCode"/>
				</xsl:if>

			</td>

			<td colspan="2">
				<xsl:if
					test="cac:CardAccount/cbc:PrimaryAccountNumberID !='' or cac:CardAccount/cbc:NetworkID !=''">

					<xsl:apply-templates select="cac:CardAccount/cbc:PrimaryAccountNumberID"/>

				</xsl:if>

				<xsl:if
					test="cac:PayeeFinancialAccount/cbc:ID !='' or
							cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID !=''">
					<xsl:if
						test="cac:CardAccount/cbc:PrimaryAccountNumberID !='' or cac:CardAccount/cbc:NetworkID !=''"
						> <br/> </xsl:if>
					<xsl:apply-templates select="cac:PayeeFinancialAccount/cbc:ID"/>&#160; <xsl:if
						test="cac:PayeeFinancialAccount/cbc:ID/@schemeID">
								<small>(<xsl:apply-templates
								select="cac:PayeeFinancialAccount/cbc:ID/@schemeID"/>)</small>
					</xsl:if>
				</xsl:if>

			</td>
			<td colspan="2">

				<xsl:if
					test="cac:CardAccount/cbc:PrimaryAccountNumberID !='' or cac:CardAccount/cbc:NetworkID !=''">

					<xsl:apply-templates select="cac:CardAccount/cbc:NetworkID"/>

				</xsl:if>
				<xsl:if
					test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID">
					<xsl:if
						test="cac:CardAccount/cbc:PrimaryAccountNumberID !='' or cac:CardAccount/cbc:NetworkID !=''"
						> <br/> </xsl:if>
					<xsl:apply-templates
						select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID"
					/>&#160; <small>( <xsl:choose>
							<xsl:when
								test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID !=''">
								<xsl:apply-templates
									select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID/@schemeID"
								/>
							</xsl:when>
							<xsl:otherwise> No schemeID </xsl:otherwise>
						</xsl:choose> )</small>
				</xsl:if>


			</td>

			<td>
				<xsl:if test="cbc:PaymentID !=''">
					<xsl:apply-templates select="cbc:PaymentID"/>
				</xsl:if>

			</td>
			<td class="right">
				<xsl:if test="cbc:PaymentDueDate !=''">
					<xsl:apply-templates select="cbc:PaymentDueDate"/>
				</xsl:if>
			</td>

		</tr>

		<!-- If needed, a 2nd row with certain financial details: -->

		<xsl:if
			test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID !=''

				or cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name !=''

				or cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address !='' ">

			<tr>

				<td> </td>

				<td> </td>

				<td colspan="2">
					<xsl:if
						test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID !='' ">
						<xsl:apply-templates
							select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID"
						/>&#160; <small>(<xsl:value-of
								select="$moduleDoc/module/document-merge/g-funcs/g[@name='PayeeFinancialInstitutionBranchID']/g-lang[lang($pLang)]"
							/>)</small>
					</xsl:if>

				</td>

				<td colspan="2">

					<small>
						<xsl:if
							test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name !='' ">
							<xsl:apply-templates
								select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name"
							/>&#160; </xsl:if>

						<xsl:if
							test="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address !='' ">

							<xsl:apply-templates
								select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cac:Address"/>

						</xsl:if>

					</small>

				</td>

				<td> </td>

			</tr>

		</xsl:if>

	</xsl:template>
	<!--PaymentMeans template until here-->




	<!-- PaymentTerms from here: -->
	<xsl:template match="cac:PaymentTerms">
		<xsl:if test="cbc:Note !=''">
			<tr>
				<td>
					<xsl:apply-templates select="cbc:Note"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>




	<!-- Document references from here: -->
	<xsl:template match="cac:ContractDocumentReference | cac:AdditionalDocumentReference ">
		<xsl:if test="cbc:ID !=''"> -&#160;<xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='ID']/g-lang[lang($pLang)]"
			/> &#160;<xsl:apply-templates select="cbc:ID"/>
		</xsl:if>
		<small>

			<xsl:if test="cbc:DocumentType !='' or cbc:DocumentTypeCode !=''">
				<xsl:choose>

					<xsl:when test="cbc:DocumentType !=''">

						<xsl:choose>

							<xsl:when test="cbc:DocumentTypeCode !=''"> (
							 <xsl:apply-templates select="cbc:DocumentType"/>,
									&#160;<xsl:value-of
									select="$moduleDoc/module/document-merge/g-funcs/g[@name='DocumentTypeCode']/g-lang[lang($pLang)]"
								/> &#160;<xsl:apply-templates select="cbc:DocumentTypeCode"/> )
								<xsl:if test="cbc:DocumentTypeCode/@listID !='UNCL1001'">
										&#160;[<xsl:value-of select="cbc:DocumentTypeCode/@listID"
									/>&#160;- invalid listID!]) </xsl:if>
							</xsl:when>

							<xsl:otherwise> (<xsl:apply-templates select="cbc:DocumentType"/>) </xsl:otherwise>

						</xsl:choose>

					</xsl:when>

					<xsl:otherwise> (&#160;<xsl:value-of
							select="$moduleDoc/module/document-merge/g-funcs/g[@name='DocumentTypeCode']/g-lang[lang($pLang)]"
						/> &#160;<xsl:apply-templates select="cbc:DocumentTypeCode"/>
							&#160;[<xsl:value-of select="cbc:DocumentTypeCode/@listID"/>]) </xsl:otherwise>

				</xsl:choose>

			</xsl:if>

			<xsl:apply-templates select="cac:Attachment"/>
		</small>
	</xsl:template>


	<xsl:template match="cac:Attachment">
		<!-- No processing of attached document, just info: -->

		<xsl:if test="cbc:EmbeddedDocumentBinaryObject/@mimeCode !=''">
			<xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='AttachmentInfo1']/g-lang[lang($pLang)]"/>
		</xsl:if>
		<xsl:if test="cbc:EmbeddedDocumentBinaryObject/@format !=''"> &#160;<xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='AttachmentInfo4']/g-lang[lang($pLang)]"
			/>&#160; <xsl:apply-templates select="cbc:EmbeddedDocumentBinaryObject/@format"/>
		</xsl:if>

		<xsl:if test="cbc:EmbeddedDocumentBinaryObject/@filename !=''"> &#160;<xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='AttachmentInfo3']/g-lang[lang($pLang)]"
			/>&#160; <xsl:apply-templates select="cbc:EmbeddedDocumentBinaryObject/@filename"/>
		</xsl:if>

		<xsl:if test="cac:ExternalReference !=''">
			<xsl:apply-templates select="cac:ExternalReference"/>
		</xsl:if>
	</xsl:template>


	<xsl:template match="cac:ExternalReference">
		<xsl:if test="cbc:URI !=''">
			<xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='URI']/g-lang[lang($pLang)]"
			/> &#160;<xsl:apply-templates select="cbc:URI"/>
		</xsl:if>
	</xsl:template>



	<xsl:template match="cac:BillingReference">

		<xsl:if test="cac:CreditNoteDocumentReference !=''"> -&#160;<xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='BillingRef-CreditNote']/g-lang[lang($pLang)]"
			/>&#160; <xsl:apply-templates select="cac:CreditNoteDocumentReference/cbc:ID"/>&#160; </xsl:if>

		<xsl:if test="cac:InvoiceDocumentReference !=''">
			<xsl:if test="cac:CreditNoteDocumentReference !=''"> </xsl:if> -&#160;<xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='BillingRef-Invoice']/g-lang[lang($pLang)]"
			/>&#160; <xsl:apply-templates select="cac:InvoiceDocumentReference/cbc:ID"/>&#160; </xsl:if>

	</xsl:template>


	<!-- Document references end -->


	<!--ExchangeRates from here: -->
	<xsl:template match="cac:TaxExchangeRate">
		<b><xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='TaxExchangeRate']/g-lang[lang($pLang)]"
			/>
		</b> &#160;<xsl:value-of
			select="$moduleDoc/module/document-merge/g-funcs/g[@name='SourceCurrencyCode']/g-lang[lang($pLang)]"
		/> &#160;<xsl:apply-templates select="cbc:SourceCurrencyCode"/>
		<xsl:if test="cbc:SourceCurrencyCode/@listID != 'ISO4217'"> &#160;<em>[<xsl:apply-templates
					select="cbc:SourceCurrencyCode/@listID"/>]&#160;- invalid listID!]</em>
		</xsl:if> &#160;<xsl:value-of
			select="$moduleDoc/module/document-merge/g-funcs/g[@name='TargetCurrencyCode']/g-lang[lang($pLang)]"
		/> &#160;<xsl:apply-templates select="cbc:TargetCurrencyCode"/>
		<!-- Checking of listID (NOT a normal function of a stylesheet): -->
		<xsl:if test="cbc:TargetCurrencyCode/@listID != 'ISO4217'"> &#160;<em>[<xsl:apply-templates
					select="cbc:TargetCurrencyCode/@listID"/>]&#160;- invalid listID!]</em>
		</xsl:if> ;&#160;<xsl:apply-templates select="cbc:MathematicOperatorCode"/>
			&#160;<xsl:value-of
			select="$moduleDoc/module/document-merge/g-funcs/g[@name='CalculationRate']/g-lang[lang($pLang)]"
		/> &#160;<xsl:apply-templates select="cbc:CalculationRate"/>&#160; <xsl:if
			test="cbc:Date !=''"> &#160;<xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='ExchangeRateDate']/g-lang[lang($pLang)]"
			/> &#160;<xsl:apply-templates select="cbc:Date"/>
		</xsl:if>
	</xsl:template>
	<!--ExchangeRates hertil-->


	<!--Periods from here-->
	<xsl:template match="cac:InvoicePeriod">
		<xsl:if test="cbc:StartDate !=''">
			<xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='PeriodStartDate']/g-lang[lang($pLang)]"
			/>&#160; <xsl:apply-templates select="cbc:StartDate"/>&#160; </xsl:if>
		<xsl:if test="cbc:EndDate !='' ">
			<xsl:value-of
				select="$moduleDoc/module/document-merge/g-funcs/g[@name='PeriodEndDate']/g-lang[lang($pLang)]"
			/> &#160;<xsl:apply-templates select="cbc:EndDate"/>&#160; </xsl:if>
	</xsl:template>
	<!--Periods end-->





</xsl:stylesheet>
