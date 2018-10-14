#!/bin/sh

name=ehf-postaward-g2-examples

mkdir -p /$name /src/target/generated
cp -r /src/rules/*/example/* /$name/

cd /$name
zip -9 -r /src/target/generated/$name.zip *
