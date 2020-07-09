RFC-000
=======

Explicit block-mapping pairs with a flow-collection key can be on a single line


| Key | Value |
| --- | --- |
| Target | 1.3 |
| Status | 0 |
| Requires | |
| Related | [RFC-explicit-flow-keys](RFC-explicit-flow-keys.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [block]() [explicit]() [flow]() [key]() [mapping]() |


## Problem

YAML 1.2 supports:
```
[1, 2]: 3
[4, 5]: 6
```

[RFC-explicit-flow-keys](RFC-explicit-flow-keys.md) requires that this be:
```
? [1, 2]
: 3
? [4, 5]
: 6
```

Although flow collection keys are a rarity, this is overly verbose.


## Proposal

We change the meaning of:
```
? [1, 2]: 3
? [4, 5]: 6
```

from:
```
{{[1, 2]: 3}: null, {[4, 5]: 6}: null}
```

to:
```
{[1, 2]: 3, [4, 5]: 6}
```

The former is counterintuitive.
The latter is obvious.


## Explanation

...
