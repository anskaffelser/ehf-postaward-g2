#!/bin/sh

name=ehf-postaward-g2-schematron

if [ -e /target/schematron ]; then
  rm -r /target/schematron
fi

mkdir /target/schematron

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

for sch in $(ls /src/rules/*/sch/*.sch); do
  echo "Prepare: $sch"
  schematron prepare $sch /target/schematron/$(basename $sch)
done

cd /target/schematron

if [ -e /target/site/files/$name.zip ]; then
  rm /target/site/files/$name.zip
fi

if [ -e /target/site/files ]; then
  zip -9 /target/site/files/$name.zip *
else
  zip -9 /target/$name.zip *
fi
