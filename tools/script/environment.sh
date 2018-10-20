#!/bin/sh

# Version: 2018-10-20

# Delete old file
rm -f /target/env

# Function: append
append() {
  echo export $1=\"$2\" >> /target/env
}

# Define variables
append GIT $(git rev-parse HEAD)
append IDENTIFIER "$IDENTIFIER"
append RELEASE "$RELEASE"
append TIMESTAMP "$(date -u +"%Y-%m-%d %H:%Mz")"
append TITLE "$TITLE"
