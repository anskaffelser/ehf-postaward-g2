#!/bin/sh

target=/target/environment

if [ -e $target ]; then
  rm $target
fi

echo GIT=\"$(git rev-parse HEAD)\" >> $target
echo TIMESTAMP=\"$(date -u +"%Y-%m-%d %H:%Mz")\" >> $target
