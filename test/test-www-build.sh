#!/usr/bin/env bash

source "$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)/setup"

DIR=../www

(
  set -x

  git fetch origin gh-pages

  make -C "$DIR" force build FAST_TEST=1

  [[ -e $DIR/spec.yaml.io/favicon.svg ]]
  [[ -e $DIR/spec.yaml.io/main/spec.html ]]
)
