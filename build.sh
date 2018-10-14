#!/bin/sh

PROJECT=$(dirname $(readlink -f "$0"))

if [ -e $PROJECT/target ]; then
    docker run --rm -i -v $PROJECT:/src alpine:3.6 rm -rf /src/target
fi

# Structure
docker run --rm -i \
    -v $PROJECT:/src \
    -v $PROJECT/target:/target \
    difi/vefa-structure:0.6.1

# Validator
docker run --rm -i \
    -v $PROJECT:/src \
    difi/vefa-validator \
    build -x -t -n no.difi.ehf.postaward -a rules,guides -target target/validator /src

# Guides
docker run --rm -i \
    -v $PROJECT:/documents \
    -v $PROJECT/target:/target \
    -e "pdf=false" \
    difi/asciidoctor

# Fix ownership
docker run --rm -i \
    -v $PROJECT:/src \
    alpine:3.6 \
    chown -R $(id -g $USER).$(id -g $USER) /src/target
