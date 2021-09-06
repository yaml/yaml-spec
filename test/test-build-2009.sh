#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

DIR=../spec/2009

(
  set -x

  make -C "$DIR" clean html

  [[ -e $DIR/spec.html ]]
)
