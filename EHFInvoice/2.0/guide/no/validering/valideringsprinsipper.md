# Valideringsprinsipper

Nivåer i valideringsprosessen:

1.	Validering av syntaks mot UBL XML Schema, for eksempel:
  * Tagnavn og eventuelle attributter må være korrekt skrevet og i riktig rekkefølge i henhold til UBL.
  * Alle obligatoriske tagnavn ihht UBL må være inkludert.
  * Innholdet i et element må ha lovlig verdi i henhold til type definisjon.
1.	Validering mot CEN BII for å sikre at meldingen er i henhold til internasjonale krav, for eksempel:
  * Lovlige koder for valuta, land, avgifter etc.
  * Logiske sammenhenger mellom informasjonselementer som at startdato må komme før sluttdato, subtotaler må summeres til korrekt totalsum, test på at faktorer som skal multipliseres får korrekt produkt etc.
1.	Validering mot PEPPOL (EU) regelverk
1.	Validering mot norsk bokføringslov,  for eksempel:
  * Organisasjonsnummer må fylles ut for selger.
1.	Validering mot norske offentlige krav, for eksempel:
  * Deres referanse må være utfylt.
  * Adresse, postnr og sted må være utfylt for kjøper.

Validering for nivå 6 og 7 er det opp til bransjer og bedrifter å etablere ved behov.
