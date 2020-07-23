RFC-000
=======

Allow aliases to refer to other documents


| Key | Value |
| --- | --- |
| Target | 1.5 |
| Status | 0 |
| Requires | [RFC-anchors-word-dash](RFC-anchors-word-dash.md), [RFC-anchors-unique](RFC-anchors-unique.md) |
| Related | [RFC-import-directive](RFC-import-directive.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [foo]() [bar]() |


## Problem

Anchors and aliases are currently entirely local to their document, and do not allow references to nodes in other documents.


## Proposal

If a document defines an anchor reference for its root node, that "document anchor" reference is retained for use by later documents in the stream.

An anchor MUST NOT use the same name as any preceding document anchor.

Document anchors MAY BE used by any subsequent alias nodes.

If an alias node value takes the form `*doc*anchor` rather than just `*anchor`, the node anchor is sought from a document that defines a document anchor `&doc`.

It is an error for an alias node to use a document anchor that does not previously occur in the stream.
It is an error for an alias node to use a non-document anchor in the `*doc` part of its value.
It is not an error for an alias node to refer to a document anchor defined for its own document.


## Explanation

It is common for "variables" to be included in a YAML document using some application-specific pattern, such as under a top-level mapping key that starts with `'.'`.
In multi-document streams, it is also common for values and constructs to need to be repeated between documents.
Allowing aliases to work between documents would provide a natural solution to many such issues, allowing for streams such as:

```
&math
constants:
- &pi 3.14159
- &e 2.71828
---
value: *math*pi
```

As it makes sense to allow document anchors to be used directly, the above could also be expressed as follows, presuming that [RFC-bare-flow-docs-newline](RFC-bare-flow-docs-newline.md) and its prerequisites are accepted:

```
&pi 3.14159
&e 2.71828
---
value: *pi
```

Given that `*` is here used as a delimiter in alias nodes, that character must not be usable as an anchor name.
This is done in [RFC-anchors-word-dash](RFC-anchors-word-dash.md).

While this RFC does not directly comment on anchors within a document, it does strongly imply that a single document contains a single "namespace" for anchors.
It is also implied here that a reference to an anchor defined within a document after an alias node would be valid.
To help resolve related ambiuities, [RFC-anchors-unique](RFC-anchors-unique.md) should be considered a prerequisite.
