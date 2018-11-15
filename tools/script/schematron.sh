#!/bin/sh

# Prepare PEPPOL BIS Schematron files
ls /src/sources/peppol-bis/rules/*/Schematron/*/*.sch \
 | grep -v "CORE" \
 | grep -v "trdm071" \
 | grep -v "trdm111" \
 | sort \
 > /tmp/peppol-bis

while read sch; do
  echo "Prepare: $sch"
  bn=$(basename "$sch")
  cd "$(dirname "$sch")"
  schematron prepare "$bn" "/target/schematron/$bn"
done < /tmp/peppol-bis
