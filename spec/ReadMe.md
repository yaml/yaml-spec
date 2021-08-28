spec
====

This directory contains the YAML spec sources currently under development.

The top level `www/` directory uses the contents ofdirectory to build the spec
web pages for https://spec.yaml.io.

## Directory Layout

* `2009/`

  The 1.2 spec sources for https://yaml.org/spec/1.2/ published in 2009.
  The source files are written in DocBook.

* `1.2/`

  The published 2009 1.2 spec HTML converted to a Markdown format.
  We sometimes call this format "Markydown"; see below.

  The HTML resulting from this markdown is better in some ways than then
  original, so we may eventually replace https://yaml.org/spec/1.2/ with it.

  The wording of this spec.md will remain constant, but improvements can be
  continually made to the markdown.

* `spec.md`

  This is the YAML spec source file under current development, and published as
  a draft on https://spec.yaml.io.

* `links.yaml`

  To make the spec source file cleaner, internal link references are maintained
  in this file.

* `tex/`

  The LaTeX source files used to create the spec diagram images.

## Makefile targets

* `build`

  Build the bare HTML content from Markdown and build the png image files from
  LaTeX.

* `build-html`

  Build just the HTML.

* `build-img`

  Build just the images.

## The Markydown Format

The markdown files in this repo are run through a pre-processor script (called
markydown-to-kramdown) to convert from a very clean input to a full-power but
messier markdown.
The kramdown is then used by a Jekyll system to produce the final output.

The toolchain required to do all this has been dockerized so that it will just
work as long as you have Docker installed.
