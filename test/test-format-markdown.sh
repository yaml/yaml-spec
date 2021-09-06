#!/usr/bin/env bash

source "$(cd "$(dirname ${BASH_SOURCE[0]})" && pwd)/setup"

( set -x; format-markdown ../spec/spec.md > /tmp/spec.md )

( set -x; diff -u ../spec/spec.md /tmp/spec.md) ||
  die "spec.md not properly formatted"
