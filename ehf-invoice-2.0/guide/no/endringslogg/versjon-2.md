# Versjon 2.x

## 2.0.5 (01.05.2015)

Validator endringer:
* Nye valideringsartefakter fra PEPPOL og BII, oppgradering til XSLT/xPath 2.0
* Tomme elementer vil medføre feilmelding, ikke advarsel som tidligere, gjelder regel NONAT-T10-R025 og NONAT-T14-R023.

Editorielle endringer:
* Tydeliggjøring av bruk av verdien «NA» dersom kontakt ID ikke er relevant
* Korrigere elementhenvisning for betalingsmottaker under kapittel 6.1

Andre endringer:
* Vedlegg til veileder ”pakkes ut” på Github for å lette tilgang til filene
* Manglende eksempelfiler på github legges tilbake

Forfatter:
* Siw Meckelborg, Edisys Consulting AS


## Hotfix (15.04.2015)

Fjernet  validering av schemeID for ClassifiedTaxCategory på faktura og kreditnota, da denne brøt mot bakoverkompatibilitet

Forfatter:
* Siw Meckelborg, Edisys Consulting AS


## 2.0.4 (01.03.2015)

Validator endringer:
* Validering av at schemeID = «UNCL5305» for ClassifiedTaxCategory på faktura og kreditnota
* Advarsel dersom vedlegg er utenfor anbefalte dokumenttyper, både for faktura og kreditnota

Editiorielle endringer i veilederen:
* Korrigering av eksempel i kapittel 6.15
* Fakturering av forbrukere via sikker digital post
* Tydeliggjøring av bruk av BBAN ved norske kontonnumer
* Editorielle endringer i kap. 7 og 6.2.2

Forfatter:
* Siw Meckelborg, Edisys Consulting AS


## 2.0.3 (01.12.2014)

Validator-endringer:
* Validering av alle påkrevde og anbefalte felt.
* Validering av elementer som ikke finnes i EHF og kardinalitet i hht. EHF.  Validering av ulike datatyper (organisasjons-nummer, dato, bankkontonummer o.l)
* Validering av at beløpet i //cac:TaxTotal/ cac:TaxSubtotal/cbc:TaxableAmount.
* Validering av at EndpointID kun kan være organisasjonsnummer.
* Validering av at valutakode-attributtet er lik DocumentCurrencyCode.
* Korrigere feil i validator for validering av TaxInclusiveAmount, Credit note line amount
* NONAT-T14-R020 gjøres om fra feil til advarsel.

Editorielle endringer i veilederen:
* Tydeliggjøring av avhengige felt (D)
* Spesifisering av pris-elementet
* Endret forklaring til leveringsadresse og – dato.
* Diverse feilrettinger/små tekstlige endringer

Forfatter:
* Siw Meckelborg, Edisys Consulting AS
* Yngve Pettersen, Edisys Consulting AS


## 2.0.2 (29.09.2014)

Endret regel for leverandørs MVA nummer, for å tillate fakturaer fra bedrifter som ikke er registrert i MVA-registeret. Editoriske endringer i vedlegg 3

Forfatter:
* Siw Meckelborg, Edisys Consulting AS


## 2.0.1 (19.08.2014)

Tillat med fakturadato frem i tid, for bade faktura og kreditnota. NONAT-T10-R009 og NONAT-T14-R005 endret fra feil til advarsel. Lagt inn ny regel for å kontrollere at verdiene i Profil ID er korrekte.

Forfatter:
* Siw Meckelborg, Edisys Consulting AS

## 2.0 (07.05.2014)

Endringer, både faktura og kreditnota:

1. Faktura/Kreditnota  i annen valuta enn NOK.  Spesifikasjon av MVA i NOK. Følgende elementer må fylles ut:
  1. TaxCurrency Code
  1. TaxExchangeRate,
    1. From currency
    1. To currency
    1. Exchange rate
  1. TaxTotal/TaxSubtotal/TransactionCurrencyTaxAmount.  
1. Lagt til navn og adresse for finansinstitusjon
1. Endringer i krav om og innhold av attributt listID for henvisning til ulike kodelister
1. Fjernet attributt schemeAgencyID i CompanyID
1. Fjernet moms representantens post adresse for å harmonisere med PEPPOL BIS

Endringer for kreditnota:

1.	OrderReference på dokumentnivå

Editorielle endringer i regel ID’er og regeltekster.

Forfatter:
* Olav Kristiansen, Difi
* Siw Meckelborg, Edisys Consulting AS
* Jostein Frømyr, Edisys Consulting AS
* Are Berg, Edisys
* Trond Bertil Barstad, Edisys


## 2.0 (30.05.2013)

Utvidelser, både faktura og kreditnota:

* Fakturering i annen valuta enn NOK (Moms i NOK)
* Selgers momsrepresentant
* Kontrakstype
* Type rabatt/gebyr
* Navn i kontakt for selger og kjøper
* Periode, produsent samt varens opprinnelsesland på linjenivå

Utvidelser, kreditnota:

* Navn på juridisk enhet selger og kjøper
* Levering på dokument og linje
* Betalingsmåte på dokument
* Rabatt/gebyr på linje
* Antall prisen gjelder for på linje
* Referanse til faktura/fakturalinje på kreditnotalinje (BillingReference)

Følgene elementer er fjernet, faktura og kreditnota:

* Adresseindentifikator, postboks, gatenummer og avdeling under adresse for leverandør og kunde samt levering
* Region, provins, fylke under juridisk adresse
* Avdeling under selger og kjøper
* Betalingskanal under betalingsmåte
* Kontaktperson under selger og kjøper
* MVA spesifikasjon for rabatter/gebyrer på linje og pris

Følgene elementer er fjernet, kreditnota:

* Referanse til kreditnota som kreditnotaen gjelder på dokumentnivå (BillingReference)

Endringer, faktura & kreditnota:

* Fakturatype, obligatorisk
* Navn på juridisk enhet selger og kjøper, obligatorisk
* MVA % på linje, valgfritt
* Betalingsbetingelse kan oppgis flere ganger
* Feil MVA kode medfører avvisning
* Utfylling av endepunktID er endret
* Utfylling av UBL versjon endret fra 2.0 til 2.1
* Utfylling av tilpasningidentifikator er endret
* Versjonsnr. i Profil ID endret fra 1.0 til 2.0

Funksjonell utvidelse:

* Fakturering av forbrukere (B2C)

Diverse tekstlige utvidelser / endringer ang:

* Konteringsstreng
* Leveringssted
* Vedlegg
* Bruk av valgfrie felt
* Endepunkt ID
* Bankkontonummer

Bruk av UBL versjon 2.1 XML schema.

Forfatter:
* Olav A. Kristiansen, Difi
* Camilla Bø, Hafslund
* Morten Gjestad, Nets
* Dan Andre Nylænder, Unit4 Agresso
* Jan Terje Kaaby, NARF
* Morten Krøgenes, Bankenes Standariseringskontor
* Per Martin Jøraholmen, DFØ
* Jostein Frømyr, Edisys Consulting AS
* Erik Gustavsen, Edisys Consulting AS
