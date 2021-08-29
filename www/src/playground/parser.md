---
layout: playground
title: YAML Parser Playground
eatme:
  slug: playground-parser-events
  cols: 4
  html: <div class="container-fluid row">

  pane:
  - name: Menu of Examples
    slug: menu
    mark: |
      * foo
      * bar

  - name: YAML Input
    slug: yaml-input
    type: input
    colx: 1

  - name: YAML Reference Parser
    slug: refparser
    call: [refparser-events, yaml-input]
    colx: 1

  - name: libfyaml (C)
    slug: libfyaml
    call: [libfyaml-events, yaml-input]
    colx: 2

  - name: libyaml (C)
    slug: libyaml
    call: [libyaml-events, yaml-input]
    colx: 2

  - name: YAML::PP (Perl)
    slug: yamlpp
    call: [yamlpp-events, yaml-input]
    colx: 3

  - name: PyYAML (Python)
    slug: pyyaml
    call: [pyyaml-events, yaml-input]
    colx: 3

  - name: NPM yaml.js v1.10.2 (JS)
    slug: npmyaml1
    type: text
    call: [npmyaml1-event, yaml-input]
    colx: 4

  - name: NPM yaml.js master (JS)
    slug: npmyamlmaster
    type: text
    call: [npmyamlmaster-event, yaml-input]
    colx: 4
---
```
# Edit Me!

%YAML 1.2
---
foo: Hello, YAML!
bar: [123, true]
baz:
- one
- two
- null
```
