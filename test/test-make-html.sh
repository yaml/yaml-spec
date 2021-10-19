#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

(
  set -x

  cd "$ROOT" || exit

  make clean
  make html

  if [[ ${MAKE_FULL-} ]]; then
    [[ -e www/html/1.2.0/spec.html ]]
    [[ -e www/html/1.2.0/title.html ]]
    [[ -e www/html/1.2.0/single_html.css ]]
    [[ -e www/html/1.2.0/model2.png ]]

    [[ -e www/html/1.2.1/spec.html ]]
    [[ -e www/html/1.2.1/title.html ]]
    [[ -e www/html/1.2.1/single_html.css ]]
    [[ -e www/html/1.2.1/model2.png ]]

    [[ -e www/html/1.2.2/index.html ]]
    [[ -e www/html/1.2.2/title.html ]]
    [[ -e www/html/1.2.2/spec.css ]]
    [[ -e www/html/1.2.2/img/model2.svg ]]
  fi

  [[ -e www/html/1.3.0/index.html ]]
  [[ -e www/html/1.3.0/title.html ]]
  [[ -e www/html/1.3.0/spec.css ]]
  [[ -e www/html/1.3.0/img/model2.svg ]]

  [[ $(head -n1 "www/html/1.3.0/index.html") == '<main'* ]]
)
