#!/bin/sh

rm -rf /target/order-agreement/1.0/peppol
rm -rf /target/punch-out/1.0/peppol

find /target -name .adocassets | xargs rm
