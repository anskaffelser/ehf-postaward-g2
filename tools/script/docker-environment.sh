#!/bin/sh

target=/target/env

if [ -e $target ]; then
  rm $target
fi

echo GIT=\"$(git rev-parse HEAD)\" >> $target
echo IDENTIFIER=\"$IDENTIFIER\" >> $target
echo TIMESTAMP=\"$(date -u +"%Y-%m-%d %H:%Mz")\" >> $target
