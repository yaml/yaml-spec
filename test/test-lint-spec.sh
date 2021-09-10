#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

DIR=..

(
  cd "$DIR" || exit

  files=(spec/*.md)

  set -x

  check-spec-file "${files[@]}"
)
