YAML Specification
==================

The YAML Data Language Specification

## Overview

[YAML](https://en.wikipedia.org/wiki/YAML) (YAML Ain't Markup Language) is a
_versioned_ language for data.
The current versions of the language are 1.0, 1.1 and 1.2.

This repository is where the YAML language is further developed and the next
versions are defined.

This repository contains the source code and build system for the [published
YAML specification](https://yaml.org/).
Versions 1.2 and older are located under the `spec` directory.

The various components of the next YAML specification version will be added
here incrementally following a well defined methodology.

## Makefile Targets

The Makefile for this repository triggers the various processes needed to
successfully make changes and submit them as pull requests.

* `make test`

  Run all the local unit tests.

* `make serve`

  Generate and serve a local website with the specs and related pages.

* `make format`

  Reformat all the markdown pages to the canonical style.

* `html`

  Generate the HTML pages with just the `<body>` content.

* `clean`

  Remove generated files.

* `make test-docker`

  Run tests using the dockerized versions of the build tools.
  This is the same methodology that CI/CD uses.

* `make edit`

  Start your editor with the current spec source file.
  This is just a shortcut for `$EDITOR 1.2.2/spec.md`.
