#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

DIR=../www

(
  set -x

  make -C "$DIR" force build

  [[ -e $DIR/build/favicon.svg ]]
  [[ -e $DIR/build/main/spec.html ]]
)
