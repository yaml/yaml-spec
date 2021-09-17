#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

find "$SPEC" -name '*.md' |
while read -r file; do

  temp=/tmp/$(basename "$file")

  ( set -x; format-markdown "$file" > "$temp" )

  ( set -x; diff -u "$file" "$temp" ||
    die "spec.md not properly formatted" )

done
