Rem versjon 10.5.6 26.8.2014

Function Validate(errorMessage As String)
Dim WholeLine As String
Dim FNum As Integer
Dim RowNdx As Long
Dim ColNdx As Integer
Dim StartRow As Long
Dim EndRow As Long
Dim StartCol As Integer
Dim EndCol As Integer
Dim CellValue As String
Dim Mandatory As String
Dim ErrorCount As Integer

ErrorCount = 0

End Function


Function CheckErrorCount(ErrorCount As Integer, errorMessage As String)
Dim errors As String
' Check if error is equal to 5
If ErrorCount = 5 Then
    ' Display error message
    errors = errorMessage & vbNewLine
    errors = errors & "For mange valideringsfeil" & vbNewLine
    MsgBox errors
    End
End If
End Function


''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' DoXMLExport
' This prompts the user for the FileName and the separtor
' character and then calls the ExportToXMLFile procedure.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Sub DoXMLExport()

Dim errorMessage As String
Validate errorMessage
If errorMessage <> "" Then
    MsgBox errorMessage
     Exit Sub
End If
Dim FileName As Variant
Dim Sep As String
FileName = Application.GetSaveAsFilename(InitialFileName:=vbNullString, FileFilter:="Xml Files (*.xml),*.xml")
If FileName = False Then
    ''''''''''''''''''''''''''
    ' user cancelled, exit
    ''''''''''''''''''''''''''
    Exit Sub
End If

ExportToXmlFile32 FName:=CStr(FileName), SelectionOnly:=False, AppendData:=False


End Sub
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' END DoXMLExport
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Sub ExportToXmlFile32(FName As String, SelectionOnly As Boolean, _
    AppendData As Boolean)

Dim xmlstart, Starttag, Version, Custid, ProfileID, IDst, IDen, Aksjonskodest, Aksjonskodeen As String
Dim CatNamest, CatNameen, Issdatest, Issdateen, Versionst, Versionen, Valperiodst, Vstartdatest, Vstartdateen As String
Dim Venddatest, Venddateen, Valperioden, Kontraktrefst, Kontrakttypest, Kontrakttypeen, Kontraktrefen, ProPartst As String
Dim EndpointIDst, EndpointIDen, Paridst, Pariden, Pidst, Piden, PartyNamest, PartyNameen, PartyLegalst, CompanyIDst, CompanyIDen As String
Dim PartyLegalen, ProParten, ReceiverPartyst, ReceiverPartyen, SellerSupplierPartyst, Partyst, RegistrationNamest, RegistrationNameen, Partyen As String
Dim SellerSupplierPartyen, CustomerPartyst, CustomerPartyen, PostalAddressst, PostalAddressen, AddressFormatCodest, AddressFormatCodeen, Departmentst, Departmenten, Postboxst, Postboxen As String
Dim StreetNamest, StreetNameen, BuildingNumberst, BuildingNumberen, CityNamest, CityNameen, PostalZonest, PostalZoneen As String
Dim Subentityst, Subentityen, Countryst, Countryen, Contactst, Contacten, Emailst, Emailen As String
Dim CatalogueLinest, OrderableIndicatorst, OrderableIndicatoren, OrderableUnitst, OrderableUniten, ContentUnitQuantityst, Quantuomen, ContentUnitQuantityen As String
Dim OrderQuantityIncrementNumericst, OrderQuantityIncrementNumericen, MinimumOrderQuantityst, MinimumOrderQuantityen, MaximumOrderQuantityst, MaximumOrderQuantityen As String
Dim ItemComparisonst, RequiredItemLocationQuantityst, RequiredItemLocationQuantityen, LineValidityPeriodst, LineValidityPerioden, ComponentRelatedItemst, ComponentRelatedItemen As String
Dim RequiredRelatedItemst, RequiredRelatedItemen, ReplacedRelatedItemst, ReplacedRelatedItemen, LeadTimeMeasurest, LeadTimeMeasureen, ApplicableTerritoryAddressst, ApplicableTerritoryAddressen, CountrySubentityst As String
Dim CountrySubentityen, Pricest, Priceen, PriceAmountst, Curren, PriceAmounten, BaseQuantityst, BaseQuantityen, Quantityst, Quantityen, DocumentReferencest, IdentificationCodest, IdentificationCodeen As String
Dim DocumentTypest, DocumentTypeen, Attachmentst, ExternalReferencest, FileNamest, FileNameen, Urist, Urien, ExternalReferenceen, Attachmenten, DocumentReferenceen As String
Dim ItemComparisonen, Itemst, Descriptionst, Descriptionen, PackLevelCodest, PackLevelCodeen, PackQuantityst, PackQuantityen, PackSizest, PackSizeen, Namest, Nameen As String
Dim Keywordst, Keyworden, SellersItemIdentificationst, SellersItemIdentificationen, ManufacturersItemIdentificationst, ManufacturersItemIdentificationen, StandardItemIdentificationst As String
Dim StandardItemIdentificationen, ExtendedIDst, ExtendedIDen, CommodityClassificationst, CommodityCodest, CommodityCodeen, ItemClassificationCodest, ItemClassificationCodeen As String
Dim CommodityClassificationen, HazardousItemst, UNDGCodest, UNDGCodeen, HazardClassIDst, HazardClassIDsten, HazardousItemen, ClassifiedTaxCategoryst, ClassifiedTaxCategoryen As String
Dim TaxSchemest, TaxSchemeen, AdditionalItemPropertyst, Valuest, Valueen, AdditionalItemPropertyen, ManufacturerPartyst, ManufacturerPartyen, ItemInstancest, LotIdentificationst As String
Dim LotNumberIDst, LotNumberIDen, ExpiryDatest, ExpiryDateen, LotIdentificationen, ItemInstanceen, Dimensionst, AttributeIDst, AttributeIDen, Measurest, Measureen, Regionst, Regionen As String
Dim Dimensionen, Itemen, CatalogueLineen, stoptag, OriginCountryst, OriginCountryen As String

Dim Tagvalue As String
Dim FNum As Integer
Dim RowNdx As Long
Dim ColNdx As Integer
Dim StartRow As Long
Dim EndRow As Long
Dim StartCol As Integer
Dim EndCol As Integer
Dim CellValue As String
Dim StartHeadRow As Integer
Dim EndHeadRow As Integer
Dim UOM As String

xmlstart = "<?xml version=" & Chr(34) & "1.0" & Chr(34) & " encoding=" & Chr(34) & "ISO-8859-1" & Chr(34) & "?>"
Starttag = "<Catalogue xmlns:sdt=" & Chr(34) & "urn:oasis:names:specification:ubl:schema:xsd:SpecializedDatatypes-2" & Chr(34) & " xmlns:cac=" & Chr(34) & "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" & Chr(34) & " xmlns:a=" & Chr(34) & "urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" & Chr(34) & " xmlns:udt=" & Chr(34) & "urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" & Chr(34) & " xmlns:xsi=" & Chr(34) & "http://www.w3.org/2001/XMLSchema-instance" & Chr(34) & " xmlns:cbc=" & Chr(34) & "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" & Chr(34) & " xmlns=" & Chr(34) & "urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" & Chr(34) & " xmlns:ccts=" & Chr(34) & "urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2" & Chr(34) & ">"
Rem Starttag = "<Catalogue>"
Version = "  <cbc:UBLVersionID>2.1</cbc:UBLVersionID>"
Custid = "  <cbc:CustomizationID>urn:www.cenbii.eu:transaction:biitrns019:ver2.0:extended:urn:www.peppol.eu:bis:peppol1a:ver2.0:extended:urn:www.difi.no:ehf:katalog:ver1.0</cbc:CustomizationID>"
ProfileID = "<cbc:ProfileID>urn:www.cenbii.eu:profile:bii01:ver2.0</cbc:ProfileID>"
IDst = "   <cbc:ID>"
IDen = "</cbc:ID>"
Aksjonskodest = "<cbc:ActionCode listID=" & Chr(34) & "ACTIONCODE:PEPPOL" & Chr(34) & ">"
Aksjonskodeen = "</cbc:ActionCode>"
CatNamest = "    <cbc:Name languageID=" & Chr(34) & "no" & Chr(34) & ">"
CatNameen = "</cbc:Name>"
Issdatest = " <cbc:IssueDate>"
Issdateen = "</cbc:IssueDate>"
Versionst = "    <cbc:VersionID>"
Versionen = "</cbc:VersionID>"
Valperiodst = "   <cac:ValidityPeriod>"
Vstartdatest = "       <cbc:StartDate>"
Vstartdateen = "</cbc:StartDate>"
Venddatest = "       <cbc:EndDate>"
Venddateen = "</cbc:EndDate>"
Valperioden = "   </cac:ValidityPeriod>"
Kontraktrefst = " <cac:ReferencedContract>"
Kontrakttypest = "<cbc:ContractType>"
Kontrakttypeen = "</cbc:ContractType>"
Kontraktrefen = " </cac:ReferencedContract>"
ProPartst = "<cac:ProviderParty>"
EndpointIDst = "    <cbc:EndpointID>"
EndpointIDen = "</cbc:EndpointID>"
Paridst = "       <cac:PartyIdentification>"
Pariden = "       </cac:PartyIdentification>"
Pidst = "          <cbc:ID>"
Piden = "</cbc:ID>"
PartyNamest = "<cac:PartyName><cbc:Name>"
PartyNameen = "</cbc:Name></cac:PartyName>"
PartyLegalst = "  <cac:PartyLegalEntity>"
CompanyIDst = "    <cbc:CompanyID schemeID=" & Chr(34) & "NO:ORGNR" & Chr(34) & ">"
CompanyIDen = "</cbc:CompanyID>"
PartyLegalen = "   </cac:PartyLegalEntity>"
ProParten = "    </cac:ProviderParty>"
ReceiverPartyst = "   <cac:ReceiverParty>"
ReceiverPartyen = "   </cac:ReceiverParty>"
SellerSupplierPartyst = "    <cac:SellerSupplierParty>"
Partyst = "    <cac:Party>"
RegistrationNamest = "       <cbc:RegistrationName>"
RegistrationNameen = "</cbc:RegistrationName>"
Partyen = "    </cac:Party>"
SellerSupplierPartyen = "</cac:SellerSupplierParty>"
CustomerPartyst = "      <cac:ContractorCustomerParty>"
CustomerPartyen = "</cac:ContractorCustomerParty>"
PostalAddressst = "    <cac:PostalAddress>"
PostalAddressen = "</cac:PostalAddress>"
AddressFormatCodest = "      <cbc:AddressFormatCode>"
AddressFormatCodeen = "</cbc:AddressFormatCode>"
Departmentst = "          <cbc:Department>"
Departmenten = "</cbc:Department>"
Postboxst = "          <cbc:Postbox>"
Postboxen = "</cbc:Postbox>"
StreetNamest = "          <cbc:StreetName>"
StreetNameen = "</cbc:StreetName>"
BuildingNumberst = "          <cbc:BuildingNumber>"
BuildingNumberen = "</cbc:BuildingNumber>"
CityNamest = "          <cbc:CityName>"
CityNameen = "</cbc:CityName>"
PostalZonest = "         <cbc:PostalZone>"
PostalZoneen = "</cbc:PostalZone>"
Subentityst = "          <cbc:CountrySubentity>"
Subentityen = "</cbc:CountrySubentity>"
Countryst = "          <cac:Country><cbc:IdentificationCode listID=" & Chr(34) & "ISO3166-1:Alpha2" & Chr(34) & ">"
Countryen = "</cbc:IdentificationCode></cac:Country>"
Contactst = "           <cac:Contact>"
Contacten = "</cac:Contact>"
Emailst = "              <cbc:ElectronicMail>"
Emailen = "</cbc:ElectronicMail>"
'kataloglinjer
CatalogueLinest = "<cac:CatalogueLine>"
 OrderableIndicatorst = "  <cbc:OrderableIndicator>"
 OrderableIndicatoren = "</cbc:OrderableIndicator>"
 OrderableUnitst = "  <cbc:OrderableUnit>"
 OrderableUniten = "</cbc:OrderableUnit>"
 ContentUnitQuantityst = "  <cbc:ContentUnitQuantity unitCodeListID=" & Chr(34) & "UNECERec20" & Chr(34) & " unitCode=" & Chr(34)
 Quantuomen = Chr(34) & ">"
 ContentUnitQuantityen = "</cbc:ContentUnitQuantity>"
 OrderQuantityIncrementNumericst = "  <cbc:OrderQuantityIncrementNumeric>"
 OrderQuantityIncrementNumericen = "</cbc:OrderQuantityIncrementNumeric>"
 MinimumOrderQuantityst = "  <cbc:MinimumOrderQuantity unitCodeListID=" & Chr(34) & "UNECERec20" & Chr(34) & " unitCode=" & Chr(34)
 MinimumOrderQuantityen = "</cbc:MinimumOrderQuantity>"
 MaximumOrderQuantityst = "  <cbc:MaximumOrderQuantity unitCodeListID=" & Chr(34) & "UNECERec20" & Chr(34) & " unitCode=" & Chr(34)
 MaximumOrderQuantityen = "</cbc:MaximumOrderQuantity>"
 ItemComparisonst = "  <cac:ItemComparison>"
 RequiredItemLocationQuantityst = "   <cac:RequiredItemLocationQuantity>"
 RequiredItemLocationQuantityen = "</cac:RequiredItemLocationQuantity>"
 LineValidityPeriodst = "  <cac:LineValidityPeriod>"
 LineValidityPerioden = "</cac:LineValidityPeriod>"
 ComponentRelatedItemst = "  <cac:ComponentRelatedItem>"
 ComponentRelatedItemen = "</cac:ComponentRelatedItem>"
 RequiredRelatedItemst = "  <cac:RequiredRelatedItem>"
 RequiredRelatedItemen = "</cac:RequiredRelatedItem>"
 ReplacedRelatedItemst = "  <cac:ReplacedRelatedItem>"
 ReplacedRelatedItemen = "  </cac:ReplacedRelatedItem>"
 LeadTimeMeasurest = "   <cbc:LeadTimeMeasure unitCode=" & Chr(34) & "DAY" & Chr(34) & ">"
 LeadTimeMeasureen = "</cbc:LeadTimeMeasure>"
 ApplicableTerritoryAddressst = "  <cac:ApplicableTerritoryAddress>"
 ApplicableTerritoryAddressen = "</cac:ApplicableTerritoryAddress>"
 CountrySubentityst = "   <cbc:CountrySubentity>"
 CountrySubentityen = "</cbc:CountrySubentity>"
 Regionst = "  <cbc:Region>"
 Regionen = "  </cbc:Region>"
 Pricest = "   <cac:Price>"
 Priceen = "</cac:Price>"
 PriceAmountst = "    <cbc:PriceAmount currencyID= " & Chr(34)
 Curren = Chr(34) & ">"
 PriceAmounten = "</cbc:PriceAmount>"
 BaseQuantityst = "     <cbc:BaseQuantity unitCodeListID=" & Chr(34) & "UNECERec20" & Chr(34) & " unitCode=" & Chr(34)
 BaseQuantityen = "</cbc:BaseQuantity>"
Quantityst = "     <cbc:Quantity unitCodeListID=" & Chr(34) & "UNECERec20" & Chr(34) & " unitCode=" & Chr(34)
Quantityen = "</cbc:Quantity>"
DocumentReferencest = "   <cac:DocumentReference>"
DocumentTypest = "     <cbc:DocumentType>"
DocumentTypeen = "  </cbc:DocumentType>"
DocumentDescriptionst = "     <cbc:DocumentDescription>"
DocumentDescriptionen = "</cbc:DocumentDescription>"
Attachmentst = "    <cac:Attachment>"
ExternalReferencest = "    <cac:ExternalReference>"
FileNamest = "      <cbc:FileName>"
FileNameen = "</cbc:FileName>"
Urist = "    <cbc:URI>"
Urien = "</cbc:URI>"
ExternalReferenceen = "   </cac:ExternalReference>"
Attachmenten = "   </cac:Attachment>"
DocumentReferenceen = "   </cac:DocumentReference>"
ItemComparisonen = "   </cac:ItemComparison>"
Itemst = "    <cac:Item>"
Descriptionst = "       <cbc:Description>"
Descriptionen = "</cbc:Description>"
PackLevelCodest = "      <cbc:PackLevelCode listID=" & Chr(34) & "GS17009:PEPPOL" & Chr(34) & ">"
PackLevelCodeen = "</cbc:PackLevelCode>"
PackQuantityst = "    <cbc:PackQuantity unitCodeListID=" & Chr(34) & "UNECERec20" & Chr(34) & " unitCode=" & Chr(34)
PackQuantityen = "</cbc:PackQuantity>"
PackSizest = "    <cbc:PackSizeNumeric>"
PackSizeen = "</cbc:PackSizeNumeric>"
Namest = "     <cbc:Name>"
Nameen = "</cbc:Name>"
Keywordst = "      <cbc:Keyword>"
Keyworden = "</cbc:Keyword>"
SellersItemIdentificationst = "   <cac:SellersItemIdentification>"
SellersItemIdentificationen = "</cac:SellersItemIdentification>"
ManufacturersItemIdentificationst = "   <cac:ManufacturersItemIdentification>"
ManufacturersItemIdentificationen = "</cac:ManufacturersItemIdentification>"
StandardItemIdentificationst = "   <cac:StandardItemIdentification>"
StandardItemIdentificationen = "</cac:StandardItemIdentification>"
ExtendedIDst = "      <cbc:ExtendedID>"
ExtendedIDen = "</cbc:ExtendedID>"
CommodityClassificationst = "  <cac:CommodityClassification>"
CommodityCodest = "     <cbc:CommodityCode>"
CommodityCodeen = "</cbc:CommodityCode>"
ItemClassificationCodest = "    <cbc:ItemClassificationCode "
ItemClassificationCodeen = "</cbc:ItemClassificationCode>"
ItemSpecificationDocumentReferencest = " <cac:ItemSpecificationDocumentReference>"
ItemSpecificationDocumentReferenceen = " </cac:ItemSpecificationDocumentReference>"
OriginCountryst = "  <cac:OriginCountry>"
OriginCountryen = "  </cac:OriginCountry>"
IdentificationCodest = "      <cbc:IdentificationCode listID=" & Chr(34) & "ISO3166-1:Alpha2" & Chr(34) & ">"
IdentificationCodeen = "</cbc:IdentificationCode>"
CommodityClassificationen = "   </cac:CommodityClassification>"
HazardousItemst = "   <cac:HazardousItem>"
UNDGCodest = "      <cbc:UNDGCode listID=" & Chr(34) & "UNCL8273" & Chr(34) & ">"
UNDGCodeen = "</cbc:UNDGCode>"
HazardClassIDst = "      <cbc:HazardClassID>"
HazardClassIDsten = "</cbc:HazardClassID>"
HazardousItemen = "     </cac:HazardousItem>"
ClassifiedTaxCategoryst = "     <cac:ClassifiedTaxCategory>"
TaxIDst = "         <cbc:ID schemeID=" & Chr(34) & "UNCL5305" & Chr(34) & ">"
ClassifiedTaxCategoryen = "     </cac:ClassifiedTaxCategory>"
TaxSchemest = "     <cac:TaxScheme>"
TaxSchemeen = "     </cac:TaxScheme>"
AdditionalItemPropertyst = "     <cac:AdditionalItemProperty>"
Valuest = "           <cbc:Value>"
Valueen = "</cbc:Value>"
AdditionalItemPropertyen = "     </cac:AdditionalItemProperty>"
ManufacturerPartyst = "    <cac:ManufacturerParty><cac:PartyName>"
ManufacturerPartyen = "    </cac:PartyName></cac:ManufacturerParty>"
ItemInstancest = "   <cac:ItemInstance>"
LotIdentificationst = "   <cac:LotIdentification>"
LotNumberIDst = "        <cbc:LotNumberID>"
LotNumberIDen = "</cbc:LotNumberID>"
ExpiryDatest = "       <cbc:ExpiryDate>"
ExpiryDateen = "</cbc:ExpiryDate>"
LotIdentificationen = "    </cac:LotIdentification>"
ItemInstanceen = "     </cac:ItemInstance>"
Certificatest = "<cac:Certificate>"
CertificateTypeCodest = "  <cbc:CertificateTypeCode>"
CertificateTypeCodeen = "</cbc:CertificateTypeCode>"
CertificateTypest = "    <cbc:CertificateType>"
CertificateTypeen = "</cbc:CertificateType>"
Remarksst = "<cbc:Remarks>"
Remarksen = "</cbc:Remarks>"
IssuerPartyst = "<cac:IssuerParty>"
IssuerPartyen = "</cac:IssuerParty>"
Certificateen = "  </cac:Certificate>"
Dimensionst = "    <cac:Dimension>"
AttributeIDst = "       <cbc:AttributeID schemeID=" & Chr(34) & "UNCL6313" & Chr(34) & ">"
AttributeIDen = "</cbc:AttributeID>"
Measurest = "     <cbc:Measure unitCode=" & Chr(34)
Measureen = "</cbc:Measure>"
Dimensionen = "    </cac:Dimension>"
Itemen = "  </cac:Item>"
CatalogueLineen = " </cac:CatalogueLine>"

stoptag = "</Catalogue>"

Rem MsgBox Asc(Sheet1.Cells(1, 7).Value) & Sheet1.Cells(1, 7).Value
StartHeadRow = 3
EndHeadRow = 11
StartRow = 12
Application.ScreenUpdating = False
On Error GoTo EndMacro:
FNum = FreeFile


If SelectionOnly = True Then
    With Selection
        EndRow = .Cells(.Cells.Count).Row
        EndCol = .Cells(.Cells.Count).Column
    End With
Else
    With ActiveSheet.UsedRange
        EndRow = .Cells(.Cells.Count).Row
        EndCol = .Cells(.Cells.Count).Column
    End With
End If

For i = StartRow To EndRow

If Sheet1.Cells(i, 2) = "" Then Exit For
Rem dette fungerer ikke
Rem For j = 1 To EndCol
Rem Sheet1.Cells(i, j) = StrConv(Sheet1.Cells(i, j), vbUnicode)
Rem Next j
Next i
EndRow = i - 1

Open FName For Output Access Write As #FNum

Rem skriver ut header

Print #FNum, xmlstart
Print #FNum, Starttag
Print #FNum, Version
Print #FNum, Custid
Print #FNum, ProfileID
Print #FNum, IDst & Sheet1.Cells(3, 2).Value & IDen
Print #FNum, Aksjonskodest & Sheet1.Cells(3, 6).Value & Aksjonskodeen
Print #FNum, CatNamest & Sheet1.Cells(3, 3).Value & CatNameen
Print #FNum, Issdatest & Format(Sheet1.Cells(3, 7).Value, "yyyy-mm-dd") & Issdateen
If Len(Sheet1.Cells(3, 4).Value) > 0 Then
Print #FNum, Versionst & Sheet1.Cells(3, 4).Value & Versionen
End If
If Len(Sheet1.Cells(3, 8).Value) > 0 Then
Print #FNum, Valperiodst
Print #FNum, Vstartdatest & Format(Sheet1.Cells(3, 8).Value, "yyyy-mm-dd") & Vstartdateen
If Len(Sheet1.Cells(3, 9).Value) > 0 Then
Print #FNum, Venddatest & Format(Sheet1.Cells(3, 9).Value, "yyyy-mm-dd") & Venddateen
End If
Print #FNum, Valperioden
End If
If Len(Sheet1.Cells(3, 10).Value) > 0 Or Len(Sheet1.Cells(3, 11).Value) > 0 Then
Print #FNum, Kontraktrefst
If Len(Sheet1.Cells(3, 10).Value) > 0 Then
Print #FNum, IDst & Sheet1.Cells(3, 10).Value & IDen
End If
If Len(Sheet1.Cells(3, 11).Value) > 0 Then
Print #FNum, Kontrakttypest & Sheet1.Cells(3, 11).Value & Kontrakttypeen
Print #FNum, Kontraktrefen
End If
End If
Print #FNum, ProPartst
If Len(Sheet1.Cells(5, 2).Value) = 9 Then
Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "NO:ORGNR" & Chr(34) & " >" & Sheet1.Cells(5, 2).Value & EndpointIDen
    ElseIf InStr(Sheet1.Cells(5, 2).Value, ":") > 2 Then Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "ISO 6523" & Chr(34) & " >" & Sheet1.Cells(5, 2).Value & EndpointIDen
    ElseIf Len(Sheet1.Cells(5, 2).Value) > 9 Then Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "GLN" & Chr(34) & " >" & Sheet1.Cells(5, 2).Value & EndpointIDen
End If
If Len(Sheet1.Cells(5, 3).Value) > 0 Then
Print #FNum, Paridst
If Len(Sheet1.Cells(5, 3).Value) = 9 Then
Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "NO:ORGNR" & Chr(34) & " >" & Sheet1.Cells(5, 3).Value & Piden
    ElseIf InStr(Sheet1.Cells(5, 3).Value, ":") > 2 Then Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "ISO 6523" & Chr(34) & " >" & Sheet1.Cells(5, 3).Value & Piden
    ElseIf Len(Sheet1.Cells(5, 3).Value) > 9 Then Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "GLN" & Chr(34) & " >" & Sheet1.Cells(5, 3).Value & Piden
    Else
    Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "ZZZ" & Chr(34) & " >" & Sheet1.Cells(5, 3).Value & Piden
End If
Print #FNum, Pariden
End If
If Len(Sheet1.Cells(5, 4).Value) > 0 Then
Print #FNum, PartyNamest & Sheet1.Cells(5, 4).Value & PartyNameen
End If
Print #FNum, ProParten
Print #FNum, ReceiverPartyst
If Len(Sheet1.Cells(6, 2).Value) = 9 Then
Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "NO:ORGNR" & Chr(34) & " >" & Sheet1.Cells(6, 2).Value & EndpointIDen
    ElseIf InStr(Sheet1.Cells(6, 2).Value, ":") > 2 Then Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "ISO 6523" & Chr(34) & " >" & Sheet1.Cells(6, 2).Value & EndpointIDen
    ElseIf Len(Sheet1.Cells(6, 2).Value) > 9 Then Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "GLN" & Chr(34) & " >" & Sheet1.Cells(6, 2).Value & EndpointIDen
End If
If Len(Sheet1.Cells(6, 3).Value) > 0 Then
Print #FNum, Paridst
If Len(Sheet1.Cells(6, 3).Value) = 9 Then
Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "NO:ORGNR" & Chr(34) & " >" & Sheet1.Cells(6, 3).Value & Piden
    ElseIf InStr(Sheet1.Cells(6, 3).Value, ":") > 2 Then Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "ISO 6523" & Chr(34) & " >" & Sheet1.Cells(6, 3).Value & Piden
    ElseIf Len(Sheet1.Cells(6, 3).Value) > 9 Then Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "GLN" & Chr(34) & " >" & Sheet1.Cells(6, 3).Value & Piden
    Else
    Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "ZZZ" & Chr(34) & " >" & Sheet1.Cells(6, 3).Value & Piden
End If
Print #FNum, Pariden
End If
If Len(Sheet1.Cells(6, 4).Value) > 0 Then
Print #FNum, PartyNamest & Sheet1.Cells(6, 4).Value & PartyNameen
End If
Print #FNum, ReceiverPartyen
If Len(Sheet1.Cells(7, 2).Value) > 0 Or Len(Sheet1.Cells(7, 3).Value) > 0 Or Len(Sheet1.Cells(7, 5).Value) > 0 Then
Print #FNum, SellerSupplierPartyst
Print #FNum, Partyst
If Len(Sheet1.Cells(7, 2).Value) = 9 Then
Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "NO:ORGNR" & Chr(34) & " >" & Sheet1.Cells(7, 2).Value & EndpointIDen
    ElseIf InStr(Sheet1.Cells(7, 2).Value, ":") > 2 Then Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "ISO 6523" & Chr(34) & " >" & Sheet1.Cells(7, 2).Value & EndpointIDen
    ElseIf Len(Sheet1.Cells(7, 2).Value) > 9 Then Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "GLN" & Chr(34) & " >" & Sheet1.Cells(7, 2).Value & EndpointIDen
End If
If Len(Sheet1.Cells(7, 3).Value) > 0 Then
Print #FNum, Paridst
If Len(Sheet1.Cells(7, 3).Value) = 9 Then
Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "NO:ORGNR" & Chr(34) & " >" & Sheet1.Cells(7, 3).Value & Piden
    ElseIf InStr(Sheet1.Cells(7, 3).Value, ":") > 2 Then Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "ISO 6523" & Chr(34) & " >" & Sheet1.Cells(7, 3).Value & Piden
    ElseIf Len(Sheet1.Cells(7, 3).Value) > 9 Then Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "GLN" & Chr(34) & " >" & Sheet1.Cells(7, 3).Value & Piden
    Else
    Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "ZZZ" & Chr(34) & " >" & Sheet1.Cells(7, 3).Value & Piden
End If
Print #FNum, Pariden
End If
If Len(Sheet1.Cells(7, 4).Value) > 0 Then
Print #FNum, PartyNamest & Sheet1.Cells(7, 4).Value & PartyNameen
End If
If Len(Sheet1.Cells(7, 6).Value) > 0 Or Len(Sheet1.Cells(7, 7).Value) > 0 Or Len(Sheet1.Cells(7, 8).Value) > 0 Or Len(Sheet1.Cells(7, 9).Value) > 0 Then
Print #FNum, PostalAddressst
If Len(Sheet1.Cells(7, 6).Value) > 0 Then
Print #FNum, CityNamest & Sheet1.Cells(7, 6).Value & CityNameen
End If
If Len(Sheet1.Cells(7, 7).Value) > 0 Then
Print #FNum, PostalZonest & Sheet1.Cells(7, 7).Value & PostalZoneen
End If
If Len(Sheet1.Cells(7, 8).Value) > 0 Then
Print #FNum, Subentityst & Sheet1.Cells(7, 8).Value & Subentityen
End If
If Len(Sheet1.Cells(7, 9).Value) > 0 Then
Print #FNum, Countryst & Sheet1.Cells(7, 9).Value & Countryen
End If
Print #FNum, PostalAddressen
End If
Rem Print #FNum, PartyLegalst
Rem Print #FNum, RegistrationNamest & Sheet1.Cells(7, 4).Value & RegistrationNameen
Rem Print #FNum, CompanyIDst & Sheet1.Cells(7, 5).Value & CompanyIDen
Rem Print #FNum, PartyLegalen
If Len(Sheet1.Cells(7, 10).Value) > 0 Then
Print #FNum, Contactst
Print #FNum, Emailst & Sheet1.Cells(7, 10).Value & Emailen
Print #FNum, Contacten
End If
Print #FNum, Partyen
Print #FNum, SellerSupplierPartyen
End If
If Len(Sheet1.Cells(8, 2).Value) > 0 Or Len(Sheet1.Cells(8, 3).Value) > 0 Or Len(Sheet1.Cells(8, 5).Value) > 0 Then
Print #FNum, CustomerPartyst
Print #FNum, Partyst
If Len(Sheet1.Cells(8, 2).Value) = 9 Then
Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "NO:ORGNR" & Chr(34) & " >" & Sheet1.Cells(8, 2).Value & EndpointIDen
    ElseIf InStr(Sheet1.Cells(8, 2).Value, ":") > 2 Then Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "ISO 6523" & Chr(34) & " >" & Sheet1.Cells(8, 2).Value & EndpointIDen
    ElseIf Len(Sheet1.Cells(8, 2).Value) > 9 Then Print #FNum, "<cbc:EndpointID  schemeID = " & Chr(34) & "GLN" & Chr(34) & " >" & Sheet1.Cells(8, 2).Value & EndpointIDen
End If
If Len(Sheet1.Cells(8, 3).Value) > 0 Then
Print #FNum, Paridst
If Len(Sheet1.Cells(8, 3).Value) = 9 Then
Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "NO:ORGNR" & Chr(34) & " >" & Sheet1.Cells(8, 3).Value & Piden
    ElseIf InStr(Sheet1.Cells(8, 3).Value, ":") > 2 Then Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "ISO 6523" & Chr(34) & " >" & Sheet1.Cells(8, 3).Value & Piden
    ElseIf Len(Sheet1.Cells(8, 3).Value) > 9 Then Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "GLN" & Chr(34) & " >" & Sheet1.Cells(8, 3).Value & Piden
    Else
    Print #FNum, "<cbc:ID  schemeID = " & Chr(34) & "ZZZ" & Chr(34) & " >" & Sheet1.Cells(7, 3).Value & Piden
End If
Print #FNum, Pariden
End If
If Len(Sheet1.Cells(8, 4).Value) > 0 Then
Print #FNum, PartyNamest & Sheet1.Cells(8, 4).Value & PartyNameen
End If
Rem Print #FNum, PostalAddressst
Rem Print #FNum, CityNamest & Sheet1.Cells(8, 6).Value & CityNameen
Rem Print #FNum, PostalZonest & Sheet1.Cells(8, 7).Value & PostalZoneen
Rem Print #FNum, Subentityst & Sheet1.Cells(8, 8).Value & Subentityen
Rem Print #FNum, Countryst & Sheet1.Cells(8, 9).Value & Countryen
Rem Print #FNum, PostalAddressen
If Len(Sheet1.Cells(8, 10).Value) > 0 Then
Print #FNum, Contactst
Print #FNum, Emailst & Sheet1.Cells(8, 10).Value & Emailen
Print #FNum, Contacten
End If
Print #FNum, Partyen
Print #FNum, CustomerPartyen
End If

Rem skriver ut kataloglinjer
For RowNdx = StartRow To EndRow
Print #FNum, CatalogueLinest
Print #FNum, IDst & Sheet1.Cells(RowNdx, 2).Value & IDen
If Sheet1.Cells(3, 6).Value = "" Then aksjkode = Sheet1.Cells(RowNdx, 20) Else aksjkode = Sheet1.Cells(3, 6).Value
Rem Print #FNum, Aksjonskodest & aksjkode & Aksjonskodeen
If Sheet1.Cells(RowNdx, 3) = "JA" Then ordable = "true" Else ordable = "false"
Print #FNum, OrderableIndicatorst & ordable & OrderableIndicatoren
For i = 3 To 258
If Worksheets("koder").Cells(i, 7).Value = Sheet1.Cells(RowNdx, 4) Then Exit For
Next i
Print #FNum, OrderableUnitst & Worksheets("koder").Cells(i, 9).Value & OrderableUniten
Rem If Len(Sheet1.Cells(RowNdx, 15).Value) > 0 Then
Rem Print #FNum, ContentUnitQuantityst & Worksheets("koder").Cells(i, 9) & Quantuomen & Sheet1.Cells(RowNdx, 15).Value & ContentUnitQuantityen
Rem End If
If Len(Sheet1.Cells(RowNdx, 14).Value) > 0 Then
Print #FNum, OrderQuantityIncrementNumericst & Sheet1.Cells(RowNdx, 14).Value & OrderQuantityIncrementNumericen
End If
If Len(Sheet1.Cells(RowNdx, 16).Value) > 0 Then
Print #FNum, MinimumOrderQuantityst & Worksheets("koder").Cells(i, 9) & Quantuomen & Sheet1.Cells(RowNdx, 16).Value & MinimumOrderQuantityen
End If
If Len(Sheet1.Cells(RowNdx, 17).Value) > 0 Then
Print #FNum, MaximumOrderQuantityst & Worksheets("koder").Cells(i, 9) & Quantuomen & Sheet1.Cells(RowNdx, 17).Value & MaximumOrderQuantityen
End If
If Len(Sheet1.Cells(RowNdx, 18).Value) > 0 Then
Print #FNum, PackLevelCodest & Sheet1.Cells(RowNdx, 18).Value & PackLevelCodeen
End If
If Len(Sheet1.Cells(RowNdx, 19).Value) > 0 Then
Print #FNum, LineValidityPeriodst
Print #FNum, Vstartdatest & Format(Sheet1.Cells(RowNdx, 19).Value, "yyyy-mm-dd") & Vstartdateen
If Len(Sheet1.Cells(RowNdx, 20).Value) > 0 Then
Print #FNum, Venddatest & Format(Sheet1.Cells(RowNdx, 20).Value, "yyyy-mm-dd") & Venddateen
End If
Print #FNum, LineValidityPerioden
End If
If Len(Sheet1.Cells(RowNdx, 23).Value) > 0 Then
Print #FNum, ComponentRelatedItemst & IDst & Sheet1.Cells(RowNdx, 23).Value & IDen
Print #FNum, ComponentRelatedItemen
End If
If Len(Sheet1.Cells(RowNdx, 25).Value) > 0 Then
Print #FNum, RequiredRelatedItemst & IDst & Sheet1.Cells(RowNdx, 25).Value & IDen
Print #FNum, RequiredRelatedItemen
End If
If Len(Sheet1.Cells(RowNdx, 21).Value) > 0 Then
Print #FNum, ReplacedRelatedItemst & IDst & Sheet1.Cells(RowNdx, 21).Value & IDen
Print #FNum, ReplacedRelatedItemen
End If
Print #FNum, RequiredItemLocationQuantityst
If Len(Sheet1.Cells(RowNdx, 27).Value) > 0 Then
Print #FNum, LeadTimeMeasurest & Sheet1.Cells(RowNdx, 27).Value & LeadTimeMeasureen
End If
If Len(Sheet1.Cells(RowNdx, 28).Value) > 0 Then
Print #FNum, ApplicableTerritoryAddressst & CountrySubentityst & Sheet1.Cells(RowNdx, 28).Value & CountrySubentityen & ApplicableTerritoryAddressen
End If
Price$ = Format(Sheet1.Cells(RowNdx, 5).Value, "0.0000")
Price$ = Replace(Price$, ",", ".")
Print #FNum, Pricest
Print #FNum, PriceAmountst & Sheet1.Cells(RowNdx, 6).Value & Curren & Price$ & PriceAmounten
Rem stedsavhengig antall tatt ut 14.5.2013
Rem If Len(Sheet1.Cells(RowNdx, 30).Value) > 0 Then
Rem For i = 3 To 258
Rem If Worksheets("koder").Cells(i, 7).Value = Sheet1.Cells(RowNdx, 30) Then Exit For
Rem Next i
Rem Print #FNum, BaseQuantityst & Worksheets("koder").Cells(i, 9).Value & Quantuomen & Sheet1.Cells(RowNdx, 29).Value & BaseQuantityen
Rem End If
Print #FNum, Priceen
Print #FNum, RequiredItemLocationQuantityen
Print #FNum, Itemst
If Len(Sheet1.Cells(RowNdx, 12).Value) > 0 Then
Print #FNum, Descriptionst & Sheet1.Cells(RowNdx, 12).Value & Descriptionen
End If
If Len(Sheet1.Cells(RowNdx, 30).Value) > 0 Then
For i = 3 To 258
If Worksheets("koder").Cells(i, 7).Value = Sheet1.Cells(RowNdx, 30) Then Exit For
Next i
If Len(Sheet1.Cells(RowNdx, 29).Value) > 0 Then
Print #FNum, PackQuantityst & Worksheets("koder").Cells(i, 9).Value & Quantuomen & Sheet1.Cells(RowNdx, 29).Value & PackQuantityen
End If
If Len(Sheet1.Cells(RowNdx, 15).Value) > 0 Then
Print #FNum, PackSizest & Sheet1.Cells(RowNdx, 15).Value & PackSizeen
End If
End If
Print #FNum, Namest & Sheet1.Cells(RowNdx, 10).Value & Nameen
If Len(Sheet1.Cells(RowNdx, 13).Value) > 0 Then
Print #FNum, Keywordst & Sheet1.Cells(RowNdx, 13).Value & Keyworden
End If
Print #FNum, SellersItemIdentificationst
Print #FNum, IDst & Sheet1.Cells(RowNdx, 7).Value & IDen
Rem Print #FNum, ExtendedIDst & Sheet1.Cells(RowNdx, 31).Value & ExtendedIDen
Print #FNum, SellersItemIdentificationen
If Len(Sheet1.Cells(RowNdx, 32).Value) > 0 Then
Print #FNum, ManufacturersItemIdentificationst
Print #FNum, IDst & Sheet1.Cells(RowNdx, 32).Value & IDen
Rem skjult Print #FNum, ExtendedIDst & Sheet1.Cells(RowNdx, 33).Value & ExtendedIDen
Print #FNum, ManufacturersItemIdentificationen
End If
If Len(Sheet1.Cells(RowNdx, 33).Value) > 0 Then
Print #FNum, StandardItemIdentificationst
Print #FNum, IDst & Sheet1.Cells(RowNdx, 33).Value & IDen
Print #FNum, StandardItemIdentificationen
End If
If Len(Sheet1.Cells(RowNdx, 34).Value) > 0 Or Len(Sheet1.Cells(RowNdx, 35).Value) > 0 Or Len(Sheet1.Cells(RowNdx, 36).Value) > 0 Or Len(Sheet1.Cells(RowNdx, 37).Value) > 0 Then
Print #FNum, ItemSpecificationDocumentReferencest
If Len(Sheet1.Cells(RowNdx, 34).Value) > 0 Then
Print #FNum, IDst & Sheet1.Cells(RowNdx, 34).Value & IDen
End If
If Len(Sheet1.Cells(RowNdx, 35).Value) > 0 Then
Print #FNum, DocumentDescriptionst & Sheet1.Cells(RowNdx, 35).Value & DocumentDescriptionen
End If
If Len(Sheet1.Cells(RowNdx, 37).Value) > 0 Or Len(Sheet1.Cells(RowNdx, 36).Value) > 0 Then
Print #FNum, Attachmentst
Print #FNum, ExternalReferencest
If Len(Sheet1.Cells(RowNdx, 37).Value) > 0 Then
    Print #FNum, Urist & Sheet1.Cells(RowNdx, 37).Value & Urien
 ElseIf Len(Sheet1.Cells(RowNdx, 36).Value) > 0 Then
  Print #FNum, FileNamest & Sheet1.Cells(RowNdx, 36).Value & FileNameen
End If
Print #FNum, ExternalReferenceen
Print #FNum, Attachmenten
End If
Print #FNum, ItemSpecificationDocumentReferenceen
End If
If Len(Sheet1.Cells(RowNdx, 38).Value) > 0 Or Len(Sheet1.Cells(RowNdx, 39).Value) > 0 Or Len(Sheet1.Cells(RowNdx, 40).Value) > 0 Or Len(Sheet1.Cells(RowNdx, 41).Value) > 0 Then
Print #FNum, ItemSpecificationDocumentReferencest
If Len(Sheet1.Cells(RowNdx, 38).Value) > 0 Then
Print #FNum, IDst & Sheet1.Cells(RowNdx, 38).Value & IDen
End If
If Len(Sheet1.Cells(RowNdx, 39).Value) > 0 Then
Print #FNum, DocumentDescriptionst & Sheet1.Cells(RowNdx, 39).Value & DocumentDescriptionen
End If
If Len(Sheet1.Cells(RowNdx, 40).Value) > 0 Or Len(Sheet1.Cells(RowNdx, 41).Value) > 0 Then
Print #FNum, Attachmentst
Print #FNum, ExternalReferencest
If Len(Sheet1.Cells(RowNdx, 41).Value) > 0 Then
    Print #FNum, Urist & Sheet1.Cells(RowNdx, 41).Value & Urien
 ElseIf Len(Sheet1.Cells(RowNdx, 40).Value) > 0 Then
  Print #FNum, FileNamest & Sheet1.Cells(RowNdx, 40).Value & FileNameen
End If
Print #FNum, ExternalReferenceen
Print #FNum, Attachmenten
End If
Print #FNum, ItemSpecificationDocumentReferenceen
End If
If Len(Sheet1.Cells(RowNdx, 42).Value) > 0 Then
Print #FNum, ItemSpecificationDocumentReferencest
Print #FNum, IDst & Sheet1.Cells(RowNdx, 42).Value & IDen
Print #FNum, DocumentDescriptionst & "HMS- blad" & DocumentDescriptionen
If Len(Sheet1.Cells(RowNdx, 44).Value) > 0 Then
Print #FNum, Attachmentst
Print #FNum, ExternalReferencest
Print #FNum, Urist & Sheet1.Cells(RowNdx, 44).Value & Urien
Print #FNum, ExternalReferenceen
Print #FNum, Attachmenten
End If
Print #FNum, ItemSpecificationDocumentReferenceen
End If
If Len(Sheet1.Cells(RowNdx, 31).Value) > 0 Then
Print #FNum, OriginCountryst & IdentificationCodest & Sheet1.Cells(RowNdx, 31).Value & IdentificationCodeen & OriginCountryen
End If
Print #FNum, CommodityClassificationst
atrib = "listID= " & Chr(34) & Sheet1.Cells(RowNdx, 8).Value & Chr(34) & ">"
Print #FNum, ItemClassificationCodest & atrib & Sheet1.Cells(RowNdx, 9).Value & ItemClassificationCodeen
Print #FNum, CommodityClassificationen
If Len(Sheet1.Cells(RowNdx, 42).Value) > 0 Or Len(Sheet1.Cells(RowNdx, 43).Value) > 0 Then
Print #FNum, HazardousItemst
If Len(Sheet1.Cells(RowNdx, 41).Value) > 0 Then
Print #FNum, UNDGCodest & Sheet1.Cells(RowNdx, 42).Value & UNDGCodeen
End If
If Len(Sheet1.Cells(RowNdx, 43).Value) > 0 Then
Print #FNum, HazardClassIDst & Sheet1.Cells(RowNdx, 43).Value & HazardClassIDsten
End If
Print #FNum, HazardousItemen
End If
If Len(Sheet1.Cells(RowNdx, 11).Value) > 0 Then
Print #FNum, ClassifiedTaxCategoryst
Print #FNum, TaxIDst & Sheet1.Cells(RowNdx, 11).Value & IDen
Print #FNum, TaxSchemest & IDst & "VAT" & IDen & TaxSchemeen
Print #FNum, ClassifiedTaxCategoryen
End If
If Len(Sheet1.Cells(RowNdx, 45).Value) > 0 Then
Print #FNum, AdditionalItemPropertyst
Print #FNum, Namest & Sheet1.Cells(RowNdx, 45).Value & Nameen
If Len(Sheet1.Cells(RowNdx, 46).Value) > 0 Then
Print #FNum, Valuest & Sheet1.Cells(RowNdx, 46).Value & Valueen
End If
Print #FNum, AdditionalItemPropertyen
End If
If Len(Sheet1.Cells(RowNdx, 49).Value) > 9 Then
Print #FNum, AdditionalItemPropertyst
Print #FNum, Namest & "EXPRY" & Nameen
Print #FNum, Valuest & Format(Sheet1.Cells(RowNdx, 49).Value, "yyyy-mm-dd") & Valueen
Print #FNum, AdditionalItemPropertyen
End If
If Len(Sheet1.Cells(RowNdx, 47).Value) > 0 Then
Print #FNum, ManufacturerPartyst
Print #FNum, Namest & Replace(Sheet1.Cells(RowNdx, 47).Value, "&", "&amp;") & Nameen
Print #FNum, ManufacturerPartyen
End If
If Len(Sheet1.Cells(RowNdx, 48).Value) > 0 Then
Print #FNum, ItemInstancest
Print #FNum, LotIdentificationst
Print #FNum, LotNumberIDst & Sheet1.Cells(RowNdx, 48).Value & LotNumberIDen
Rem If Len(Sheet1.Cells(RowNdx, 49).Value) > 9 Then
Rem Print #FNum, ExpiryDatest & Format(Sheet1.Cells(RowNdx, 49).Value, "yyyy-mm-dd") & ExpiryDateen
Rem End If
Print #FNum, LotIdentificationen
Print #FNum, ItemInstanceen
End If
Rem Miljømerking
For imerk = 0 To 4
If Len(Sheet1.Cells(RowNdx, 50 + imerk * 3).Value) > 0 Or Len(Sheet1.Cells(RowNdx, 51 + imerk * 3).Value) > 0 Then
Print #FNum, Certificatest
If Len(Sheet1.Cells(RowNdx, 50 + imerk * 3).Value) > 0 Then
Print #FNum, IDst & Sheet1.Cells(RowNdx, 50 + imerk * 3).Value & IDen
End If
Rem Print #FNum, CertificateTypeCodest & CertificateTypeCodeen
Rem Print #FNum, CertificateTypest & CertificateTypeen
Rem Print #FNum, Remarksst & Sheet1.Cells(RowNdx, 60).Value & Remarksen
Print #FNum, IssuerPartyst
Rem Print #FNum, Paridst
Rem Print #FNum, Pidst & Sheet1.Cells(RowNdx, 58 + imerk * 4).Value & Piden
Rem Print #FNum, Pariden
If Len(Sheet1.Cells(RowNdx, 51 + imerk * 3).Value) = 0 Then Sheet1.Cells(RowNdx, 50 + imerk * 3).Value = "Ukjent"
Print #FNum, PartyNamest & Sheet1.Cells(RowNdx, 51 + imerk * 3).Value & PartyNameen
Print #FNum, IssuerPartyen
If Len(Sheet1.Cells(RowNdx, 52 + imerk * 3).Value) > 0 Then
Print #FNum, DocumentReferencest
Print #FNum, IDst
Rem Print #FNum, DocumentTypest & Sheet1.Cells(RowNdx, 38).Value & DocumentTypeen
Rem Print #FNum, Attachmentst
Rem Print #FNum, ExternalReferencest
Print #FNum, Sheet1.Cells(RowNdx, 52 + imerk * 3).Value
Rem Print #FNum, ExternalReferenceen
Print #FNum, IDen
Print #FNum, DocumentReferenceen
End If
Print #FNum, Certificateen
End If
Next imerk
If Len(Sheet1.Cells(RowNdx, 67).Value) > 0 Then
For i = 3 To 258
If Worksheets("koder").Cells(i, 7).Value = Sheet1.Cells(RowNdx, 67) Then Exit For
Next i
Measval$ = Format(Sheet1.Cells(RowNdx, 66).Value, "0.0###")
Measval$ = Replace(Measval$, ",", ".")
If Len(Sheet1.Cells(RowNdx, 65).Value) > 0 Then
Print #FNum, Dimensionst
Print #FNum, AttributeIDst & Sheet1.Cells(RowNdx, 65).Value & AttributeIDen
If Len(Worksheets("koder").Cells(i, 9)) > 0 Then
Print #FNum, Measurest & Worksheets("koder").Cells(i, 9).Value & Quantuomen & Measval$ & Measureen
End If
Print #FNum, Dimensionen
End If
End If
Print #FNum, Itemen
Print #FNum, CatalogueLineen
Next RowNdx
Print #FNum, stoptag
EndMacro:
On Error GoTo 0
Application.ScreenUpdating = True
Close #FNum
End Sub





