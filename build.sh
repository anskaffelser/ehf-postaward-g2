#!/bin/sh

PROJECT=$(dirname $(readlink -f "$0"))

docker_pull() {
    if [ ! "$DP_SKIP" = 'true' ]; then
        fold_start "docker-pull" "Pulling Docker images"

        for image in $@; do
            echo "Pulling Docker image '$image'."
            docker pull $image

            res="$?"
            if [ ! "$res" = '0' ]; then
                exit $res
            fi
        done

        fold_end "docker-pull"
    fi
}

docker_run() {
  ident=$1
  title=$2
  shift
  shift

  fold_start $ident "$title"

  docker run --rm -i $@
  res="$?"

  fold_end $ident

  if [ ! "$res" = '0' ]; then
      echo "* Exited with $res."
      echo
  #    exit $res
  fi
}

fold_start() {
    if [ "$TRAVIS" = 'true' ]; then
        echo -n "travis_fold:start:$1"
    fi

    echo "\033[33;1m$2\033[0m"
}

fold_end() {
    if [ "$TRAVIS" = 'true' ]; then
        echo "\ntravis_fold:end:$1\r"
    else
        echo
    fi
}

docker_pull \
    alpine:3.6 \
    difi/vefa-structure:0.7 \
    difi/vefa-validator \
    difi/asciidoctor \
    klakegg/schematron \
    alpine/git

if [ -e $PROJECT/target ]; then
    docker_run "clean" "Removing old target folder" \
        -v $PROJECT:/src \
        alpine:3.6 \
        rm -rf /src/target
fi

docker_run "environment" "Creating environment file" \
    -v $PROJECT:/src \
    -v $PROJECT/target:/target \
    -e IDENTIFIER=ehf-postaward-g2 \
    --entrypoint sh \
    -w /src \
    alpine/git \
    tools/script/docker-environment.sh

docker_run "example-files" "Packaging example files" \
    -v $PROJECT:/src \
    -v $PROJECT/target:/target \
    klakegg/schematron \
    sh tools/script/docker-package-examples.sh

docker_run "vefa-structure" "Running vefa-structure" \
    -v $PROJECT:/src \
    -v $PROJECT/target:/target \
    difi/vefa-structure:0.7

docker_run "schematron-files" "Packaging Schematron files" \
    -v $PROJECT:/src \
    -v $PROJECT/target:/target \
    klakegg/schematron \
    sh tools/script/docker-package-schematron.sh

docker_run "vefa-validator" "Running vefa-validator" \
    -v $PROJECT:/src \
    difi/vefa-validator \
    build -x -t -n no.difi.ehf.postaward -a rules -target target/validator /src

docker_run "asciidoctor" "Creating documentation" \
    -v $PROJECT:/documents \
    -v $PROJECT/target:/target \
    difi/asciidoctor

if [ ! "$TRAVIS" = 'true' ]; then
    docker_run "ownership" "Fixing ownership" \
        -v $PROJECT:/src \
        alpine:3.6 \
        chown -R $(id -g $USER).$(id -g $USER) /src/target
fi
