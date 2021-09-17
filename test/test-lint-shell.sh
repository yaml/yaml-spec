#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

(
  cd .. || exit

  mapfile -t files < <(grep -rl '^#!.* bash')

  set -x

  lint-shell "${files[@]}"
)
