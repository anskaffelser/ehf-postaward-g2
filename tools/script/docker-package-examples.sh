#!/bin/sh

. /target/env

name=$IDENTIFIER-examples

mkdir -p /$name /target/generated
cp -r /src/rules/*/example/* /$name/

cd /$name
zip -9 -r /target/generated/$name.zip *
