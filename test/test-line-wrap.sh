#!/usr/bin/env bash

source "$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)/setup"

# TODO check all markdown files
# for file in ../spec/*.md; do

for file in ../spec/spec.md; do
  tmp=/tmp/$(basename "$file")
  (set -x; format-markdown "$file" > "$tmp")
  (set -x; diff -u "$file" "$tmp")
done
