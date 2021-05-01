yaml-spec
=========

The YAML Specification

## Overview

This repository contains the source materials and build files for the [YAML
Specification](http://www.yaml.org/spec/1.2/spec.html).

## Build Process

To turn these files into HTML and PDF representations of the spec, you can run:
`make all`, but that requires a lot of prerequisites to be installed. The
easier method is to do this (requires Docker):

```
git clone https://github.com/yaml/yaml-spec-builder-docker
cd yaml-spec-builder-docker
make spec
```

## Contributing

Contributions are welcome. File issues and pull requests
[here](https://github.com/yaml/yaml-spec/issues).
