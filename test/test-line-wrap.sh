#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

# TODO check all markdown files
files=(
  ../spec/spec.md
)

for file in "${files[@]}"; do
  tmp=/tmp/$(basename "$file")
  (set -x; format-markdown "$file" > "$tmp")
  (set -x; diff -u "$file" "$tmp")
done
