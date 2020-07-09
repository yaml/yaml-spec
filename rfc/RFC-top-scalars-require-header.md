RFC-000
=======

Top-level scalars require a document-start-indicator


| Key | Value |
| --- | --- |
| Target | 1.3 |
| Status | 0 |
| Requires | []() |
| Related | [RFC-tail-docs-require-header](RFC-tail-docs-require-header.md) [RFC-json-top-scalars](RFC-json-top-scalars.md) [RFC-json-streaming](RFC-json-streaming.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | foo bar |


## Problem

It isn't obvious that a top-level scalar node is YAML encoded without a document-start-header (`---`).


## Proposal

Each top-level scalar node requires a document-start-header.


## Explanation

[RFC-tail-docs-require-header](RFC-tail-docs-require-header.md) requires that every document except the first, start with a document-start-header.

Top level scalars are rare and unexpected that they should have a document-start-header even if they are the first document.

If both [RFC-json-top-scalars](RFC-json-top-scalars) and [RFC-json-streaming](RFC-json-streaming.md) is part of the spec, we need to make an exception for top level scalar docs that are JSON compatible.

Not allowed:
```
|
  foo
  bar
```

Allowed:
```
--- |
  foo
  bar
```
