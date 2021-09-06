#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

DIR=../www

(
  set -x

  make -C $DIR force html FAST_TEST=1

  [[ -e $DIR/html/spec.html ]]
  [[ $(head -n1 $DIR/html/spec.html) == '<main'* ]]
)
