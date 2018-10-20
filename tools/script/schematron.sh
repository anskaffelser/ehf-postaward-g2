#!/bin/sh

# Version: 2018-10-20

# Load environment variables
test ! -r /target/env || . /target/env

# Prepare target
rm -rf /target/schematron
mkdir -p /target/schematron /target/site/files

# Create readme file
test ! -r /src/tools/template/schematron-readme || \
  cat /src/tools/template/schematron-readme \
  | envsubst \
  > /target/schematron/README

# Prepare Schematron files
for sch in $(ls /src/rules/*/sch/*.sch); do
  echo "Prepare: $sch"
  schematron prepare $sch /target/schematron/$(basename $sch)
done

# Prepare PEPPOL BIS Schematron files
ls /src/sources/peppol-bis/rules/*/Schematron/*/*.sch \
 | grep -v "CORE" \
 | grep -v "trdm071" \
 | grep -v "trdm111" \
 > /tmp/peppol-bis

while read sch; do
  echo "Prepare: $sch"
  bn=$(basename "$sch")
  cd "$(dirname "$sch")"
  schematron prepare "$bn" "/target/schematron/$bn"
done < /tmp/peppol-bis

cd /src

# Create zip
cd /target/schematron

rm -rf /target/schematron.zip
zip -9 -r /target/schematron.zip *

# Publish
cp /target/schematron.zip /target/site/files/schematron.zip
