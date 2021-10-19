#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

(
  set -x

  cd "$ROOT" || exit

  make clean
  make build

  [[ -e www/build/favicon.svg ]]
  [[ -e www/build/main/spec/1.3.0/index.html ]]
)
