#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

find .. -type f -name '*.md' |
while read -r file; do
  [[ $file == */1.2/* ]] && continue
  [[ $file == *www/build* ]] && continue
  [[ $file == *www/main* ]] && continue
  [[ $file == *contributing* ]] && continue
  [[ $file == *pull_request_template* ]] && continue

  temp=/tmp/$(basename "$file")

  ( set -x; format-markdown "$file" > "$temp" )

  ( set -x; diff -u "$file" "$temp" ||
    die "spec.md not properly formatted" )
done
