RFC-000
=======

Flow-collections as block-keys must be explicit


| Key | Value |
| --- | --- |
| Target | 1.3 |
| Status | 0 |
| Requires | |
| Related | [RFC-single-line-flow-key-pairs](RFC-single-line-flow-key-pairs.md) [RFC-no-complex-key-in-flow-seq](RFC-no-complex-key-in-flow-seq.md) [RFC-no-explicit-key-in-flow](RFC-no-explicit-key-in-flow.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [block]() [explicit]() [flow]() [key]() [mapping]() |


## Problem

Implicit flow collections currently require an unbounded look-ahead, since they may or may not be block mapping keys.


## Proposal

Block mapping keys that are flow collections must be explicitly marked as such with the `?` indicator.


## Explanation

When a parser sees a flow collection, it must check for a colon after the collection has terminated.

YAML 1.2 imposes a 1024 character limit if the collection is intended to become a key.

This is a poor solution and places too much burden on parser implementations.

Collection keys are not a commonly used feature.

Under this RFC proposal, the following form will become invalid:
```
[4, 2]: 42
```

And will need to be written as:
```
? [4, 2]
: 42
```

Combined with [RFC-single-line-flow-key-pairs](RFC-single-line-flow-key-pairs.md) we can make it use one line:
```
? [4, 2]: 42
```

and get rid of the look-ahead simply by adding `? ` before entries.
