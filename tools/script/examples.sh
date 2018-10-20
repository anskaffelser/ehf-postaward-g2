#!/bin/sh

# Version: 2018-10-20

# Load environment variables
test ! -r /target/env || . /target/env

# Prepare target
rm -rf /target/examples
mkdir -p /target/examples /target/site/files

# Create readme file
test ! -r /src/tools/template/examples-readme || \
  cat /src/tools/template/examples-readme \
  | envsubst \
  > /target/examples/README

# Copy example files
cp -r /src/rules/*/example/* /target/examples/

# Create zip
cd /target/examples

rm -rf /target/examples.zip
zip -9 -r /target/examples.zip *

# Publish
cp /target/examples.zip /target/site/files/examples.zip
