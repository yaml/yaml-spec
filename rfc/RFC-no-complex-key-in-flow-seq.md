RFC-000
=======

Single-pair-mappings with collection-key forbidden in flow-sequences


| Key | Value |
| --- | --- |
| Target | 1.3 |
| Status | 0 |
| Requires | |
| Related | |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [flow]() [key]() [mapping]() |


## Problem

In YAML 1.2, inside a flow sequence, a key + colon + value creates a single pair mapping.
When the mapping key is a collection, there is an unbounded lookahead.


## Proposal

Single pair mappings must be explicitly defined with curly braces inside of flow sequences.


## Explanation

In YAML 1.2, this flow sequence:
```
[ foo: 1, bar: true ]
```

Has the same meaning as this one:
```
[ { foo: 1 }, {bar: true } ]
```

This is a clever syntax for defining an ordered mapping.
In block form it would be:
```
- foo: 1
- bar: 2
```

Unfortunately when the key of one of these pairs is a collection, that collection can be arbitrarily deep, and a parser can't tell if it's a mapping key or not until it is complete.
```
[ [ ... ]: 42 ]
```

This is an unbounded and unruly lookahead situation.

YAML 1.2 deals with this by placing an arbitrary 1024 character limit on resolving the situation.

This feature is not well known, and not heavily used.
Especially with collection keys, which themselves are quite rare.

This RFC proposes that these single pair mappings with collection keys must use curly braces explicitly.
```
[ { [ ... ]: 42 } ]
```

This should make make the writing of correct parsers be easier.
