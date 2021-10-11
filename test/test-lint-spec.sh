#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

DIR=..

(
  cd "$DIR" || exit

  files=(spec/1.2.2/*.md spec/1.3.0/*.md)

  set -x

  check-spec-file "${files[@]}"
)
