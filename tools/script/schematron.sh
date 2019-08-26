#!/bin/sh

_bn() {
  basename "$1"
}

_prepare() {
  bn=$(_bn "$file")
  echo "Prepare: $file > $bn"
  cd "$(dirname "$file")"
}

# Order

file="/src/sources/peppol-bis/rules/peppolbis-trdm001-2.0-order/Schematron/BII RULES/BIIRULES-UBL-T01.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  > "/target/schematron/$bn"

file="/src/sources/peppol-bis/rules/peppolbis-trdm001-2.0-order/Schematron/OPENPEPPOL/OPENPEPPOL-UBL-T01.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
| schutil exclude - - OP-T01-R008 \
  > "/target/schematron/$bn"

# Invoice

file="/src/sources/peppol-bis/rules/peppolbis-trdm010-2.0-invoice/Schematron/BII RULES/BIIRULES-UBL-T10.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  | schutil exclude - - BII2-T10-R025 BII2-T10-R035 BII2-T10-R037 BII2-T10-R044 BII2-T10-R047 BII2-T10-R048 BII2-T10-R049 BII2-T10-R050 CL-T10-R001 CL-T10-R007 \
  > "/target/schematron/$bn"

file="/src/sources/peppol-bis/rules/peppolbis-trdm010-2.0-invoice/Schematron/OPENPEPPOL/OPENPEPPOL-UBL-T10.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  | schutil exclude - - EUGEN-T10-R041 OP-T10-R004 \
  > "/target/schematron/$bn"

# Credit Note

file="/src/sources/peppol-bis/rules/peppolbis-trdm014-2.0-creditnote/Schematron/OPENPEPPOL/OPENPEPPOL-UBL-T14.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  | schutil exclude - - EUGEN-T14-R041 OP-T14-R004 \
  > "/target/schematron/$bn"

# Special for use with EHF profile XX.
file="/src/sources/peppol-bis/rules/peppolbis-trdm014-2.0-creditnote/Schematron/OPENPEPPOL/OPENPEPPOL-UBL-T14.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  | schutil exclude - - EUGEN-T14-R041 EUGEN-T14-R047 OP-T14-R004 \
  > "/target/schematron/OPENPEPPOL-UBL-T14-XX.sch"

file="/src/sources/peppol-bis/rules/peppolbis-trdm014-2.0-creditnote/Schematron/BII RULES/BIIRULES-UBL-T14.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  | schutil exclude - - BII2-T14-R025 BII2-T14-R035 BII2-T14-R037 BII2-T14-R044 BII2-T14-R047 BII2-T14-R048 BII2-T14-R049 BII2-T14-R050 CL-T14-R007 \
  > "/target/schematron/$bn"

# Despatch Advice

file="/src/sources/peppol-bis/rules/peppolbis-trdm016-2.0-despatch-advice/Schematron/BII RULES/BIIRULES-UBL-T16.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  > "/target/schematron/$bn"

file="/src/sources/peppol-bis/rules/peppolbis-trdm016-2.0-despatch-advice/Schematron/OPENPEPPOL/OPENPEPPOL-UBL-T16.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  > "/target/schematron/$bn"

# Catalogue

file="/src/sources/peppol-bis/rules/peppolbis-trdm019-2.0-catalogue/Schematron/BII RULES/BIIRULES-UBL-T19.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  | schutil exclude - - CL-T19-R004 BII2-T19-R021 \
  > "/target/schematron/$bn"

file="/src/sources/peppol-bis/rules/peppolbis-trdm019-2.0-catalogue/Schematron/OPENPEPPOL/OPENPEPPOL-UBL-T19.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  > "/target/schematron/$bn"

# Catalogue Response

file="/src/sources/peppol-bis/rules/peppolbis-trdm058-2.0-catalogue-response/Schematron/BII RULES/BIIRULES-UBL-T58.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  > "/target/schematron/$bn"

file="/src/sources/peppol-bis/rules/peppolbis-trdm058-2.0-catalogue-response/Schematron/OPENPEPPOL/OPENPEPPOL-UBL-T58.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  > "/target/schematron/$bn"

# Order Response

file="/src/sources/peppol-bis/rules/peppolbis-trdm076-2.0-order-response/Schematron/BII RULES/BIIRULES-UBL-T76.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  > "/target/schematron/$bn"

file="/src/sources/peppol-bis/rules/peppolbis-trdm076-2.0-order-response/Schematron/OPENPEPPOL/OPENPEPPOL-UBL-T76.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
| schutil exclude - - OP-T76-R008 \
  > "/target/schematron/$bn"

# Punch Out

file="/src/sources/peppol-bis/rules/peppolbis-trdm077-1.0-punch-out/Schematron/BII RULES/BIIRULES-UBL-T77.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  > "/target/schematron/$bn"

file="/src/sources/peppol-bis/rules/peppolbis-trdm077-1.0-punch-out/Schematron/OPENPEPPOL/OPENPEPPOL-UBL-T77.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  > "/target/schematron/$bn"

# Order Agreement

file="/src/sources/peppol-bis/rules/peppolbis-trdm110-1.0-order-agreement/Schematron/BII RULES/BIIRULES-UBL-T110.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  > "/target/schematron/$bn"

file="/src/sources/peppol-bis/rules/peppolbis-trdm110-1.0-order-agreement/Schematron/OPENPEPPOL/OPENPEPPOL-UBL-T110.sch"
_prepare "$file"; bn=$(_bn "$file")
schematron prepare "$bn" - \
  > "/target/schematron/$bn"
