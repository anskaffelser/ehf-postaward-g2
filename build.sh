#!/bin/sh

PROJECT=$(dirname $(readlink -f "$0"))

docker_pull() {
  echo "Pulling Docker image '$1'."
  docker pull $1

  res="$?"
  if [ ! "$res" = '0' ]; then
    exit $res
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
      echo Exited with $res.
  #    exit $res
  fi
}

fold_start() {
  if [ "$TRAVIS" = 'true' ]; then
    echo -e "travis_fold:start:$1\033[33;1m$2\033[0m"
  else
    echo $2
  fi
}

fold_end() {
  if [ "$TRAVIS" = 'true' ]; then
    echo -e "\ntravis_fold:end:$1"
  else
    echo
  fi
}

if [ ! "$DP_SKIP" = 'true' ]; then
  fold_start "docker_pull" "Pulling Docker images"
  docker_pull alpine:3.6
  docker_pull difi/vefa-structure:0.7
  docker_pull difi/vefa-validator
  docker_pull difi/asciidoctor
  fold_end "docker_pull"
fi

if [ -e $PROJECT/target ]; then
    docker_run "clean" "Removing old target folder" \
        -v $PROJECT:/src \
        alpine:3.6 \
        rm -rf /src/target
fi

docker_run "vefa-structure" "Running vefa-structure" \
    -v $PROJECT:/src \
    -v $PROJECT/target:/target \
    difi/vefa-structure:0.7

docker_run "vefa-validator" "Running vefa-validator" \
    -v $PROJECT:/src \
    difi/vefa-validator \
    build -x -t -n no.difi.ehf.postaward -a rules,guides -target target/validator /src

docker_run "asciidoctor" "Creating documentation" \
    -v $PROJECT:/documents \
    -v $PROJECT/target:/target \
    difi/asciidoctor

if [ ! "$CI" = 'true' ]; then
    docker_run "ownership" "Fixing ownership" \
        -v $PROJECT:/src \
        alpine:3.6 \
        chown -R $(id -g $USER).$(id -g $USER) /src/target
fi
