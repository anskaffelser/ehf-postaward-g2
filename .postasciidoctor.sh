#!/bin/sh

rm -r /target/guides/order-agreement/1.0/peppol
rm -r /target/guides/punch-out/1.0/peppol

if [ -d /target/site ]; then
  cp -r /target/guides/* /target/site/
  rm -r /target/guides
fi
