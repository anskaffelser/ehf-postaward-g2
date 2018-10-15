#!/bin/sh

if [ -e /src/target/schematron ]; then
  rm -r /src/target/schematron
fi

mkdir /src/target/schematron

for sch in $(ls /src/rules/*/sch/*.sch); do
  sh /schematron/bin/run.sh prepare $sch /src/target/schematron/$(basename $sch)
done

cd /src/target/schematron

if [ -e /src/target/site/files/ehf-postaward-g2-schematron.zip ]; then
  rm /src/target/site/files/ehf-postaward-g2-schematron.zip
fi

zip -9 /src/target/site/files/ehf-postaward-g2-schematron.zip *
