RFC-000
=======

Make anchors unique


| Key | Value |
| --- | --- |
| Target | 1.5 |
| Status | 0 |
| Requires | |
| Related | [RFC-anchors-word-dash](RFC-anchors-word-dash.md), [RFC-external-aliases](RFC-external-aliases.md), [RFC-import-directive](RFC-import-directive.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [foo]() [bar]() |


## Problem

Requiring anchors to be defined before the alias node that refers to them creates restrictions on how nodes may be arranged within a document.
These restrictions are surprising to users, as is the overriding behaviour of reused anchor names.


## Proposal

It is an error for an anchor to use a name that is already defined.

It is not an error for an alias to use an anchor name defined later in the same document.


## Explanation

Effectively, this RFC makes a document have a single namespace for anchor names, and forbids the same anchor name from being reused.
On input, the will require that alias values are resolved after the whole document has been processed, but this is already effectively required by circular references:

```
&anchor
- foo
- *anchor
```

This change would make some constructs that currently are errors into valid YAML:

```
first: *anchor  # 'value'
second: &anchor value
```

And it would make certain currently-valid constructs errors:

```
first: &anchor value
second: &anchor other  # ERROR
third: *anchor
```

It is unlikely that the now-error constructs are commonly used, at least on purpose.

In addition to simplifying anchor names within a document, the anchors defined in further RFCs ([RFC-external-aliases](RFC-external-aliases.md), [RFC-import-directive](RFC-import-directive.md)) define additional anchors that are available within the document's namespace.
The logic and rules around the anchors defined there is significantly simplified if anchor names are unique.
