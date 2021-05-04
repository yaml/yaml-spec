yaml-spec
=========

The YAML Specification

## Overview

This directory contains the source materials and build files for the
[YAML 1.2 Specification](http://www.yaml.org/spec/1.2/spec.html).

## Build Process

To turn these files into HTML, run (from the top level directory):
```
source .rc
make -C 1.2 html
```

The build system requires:

* make
* docker
* python3
  * pyyaml
