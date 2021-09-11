#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/setup"

DIR=../www

(
  set -x

  make -C "$DIR" force html

  [[ -e $DIR/html/1.2.0/spec.html ]]
  [[ -e $DIR/html/1.2.0/title.html ]]
  [[ -e $DIR/html/1.2.0/single_html.css ]]
  [[ -e $DIR/html/1.2.0/model2.png ]]

  [[ -e $DIR/html/1.2.1/spec.html ]]
  [[ -e $DIR/html/1.2.1/title.html ]]
  [[ -e $DIR/html/1.2.1/single_html.css ]]
  [[ -e $DIR/html/1.2.1/model2.png ]]

  [[ -e $DIR/html/1.2.2/spec.html ]]
  [[ -e $DIR/html/1.2.2/title.html ]]
  [[ -e $DIR/html/1.2.2/spec.css ]]
  [[ -e $DIR/html/1.2.2/img/model2.svg ]]

  [[ $(head -n1 "$DIR/html/1.2.2/spec.html") == '<main'* ]]
)
