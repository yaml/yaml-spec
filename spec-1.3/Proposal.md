YAML 1.3 Specification Proposal
===============================

# Overview

It's been 10 years since the YAML 1.2 spec was "finalized".
The YAML data language is now widely used throughout the software world.
It's time to move the language forward.


* No indentation for top level nodes
* Maximum of 8 spaces for indentation
* Top level literal nodes must be indented
* --- required for
  * Top level scalar node
  * Top level node with properties
* Disallow [ foo: 1, bar: 2 ]
  * Must do [ { foo: 1 }, { bar: 2 } ]
* Disallow flow collections as implicit block keys
* Disallow carriage return (\r) as a break
* Remove 1024 character limits
* Anchors names are [\w\-\.]+
* Only allow empty values as block mapping values
* Disallow tabs as syntax whitespace
  * Only allowed in literal scalar content
* Allow anchors to come after their aliases
* Allow aliases that have not anchors in document
  * Must come from another source
  * Could be a variables document in the stream
* Require string keys with whitespace to be quoted
  * Allow ': ' in values
* Allow an alias to have an anchor
* Allow a node to have multiple anchors
* Remove wiki-like syntax from folded block scalars
* Disallow mixing implicit and explicit mapping style
* Fixed position of node properties and block scalar indicators
* Disallow colon at the end of plain scalars
* Remove Tag URI Expansion
* Fix Regexp for Floats in JSON Schema
* Forbid bare documents (except the first)
