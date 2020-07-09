RFC-000
=======

Multiline top-level scalar content must be visually indented


| Key | Value |
| --- | --- |
| Target | 1.3 |
| Status | 0 |
| Requires | [RFC-top-plain-single-line]() [RFC-top-scalars-require-header]() |
| Related | |
| Discuss | [Issue 0](../../issues/0) |
| Tags | indent multiline scalar top |


## Problem

Top level, multiline scalar content can have ambiguous lines like `...`.

In the middle of a large multiline, it is not obvious that the content is YAML encoded.


## Proposal

Every line after the first line of a multiline top-level scalar must be visually indented.

The entire scalar will be quoted, literal or folded according to [RFC-top-plain-single-line](RFC-top-plain-single-line.md).
The scalar will have a document-start-indicator according to [RFC-top-scalars-require-header](RFC-top-scalars-require-header.md).


## Explanation

YAML is serializes 3 kinds of data nodes, mappings, sequences and scalars.
In practice, top level nodes are almost always mappings or sequences.
Top level scalars are rare, but have a lot of edge cases that complicate YAML.

From a language perspective, it is important to be unambiguous and also clear as possible that the text you see is YAML encoded.

For example, encoding a Makrdown document should require more than just adding a `--- |` in front of the text.

These would be invalid:
```
--- "foo
bar
baz"
--- |
foo
bar
baz
```

While these would be valid:
```
--- "foo
 bar
 baz"
--- |
  foo
  bar
  baz
```
