RFC-000
=======

Top-level properties require a document-start-indicator


| Key | Value |
| --- | --- |
| Target | 1.3 |
| Status | 0 |
| Requires | []() |
| Related | [RFC-top-scalars-require-header](RFC-top-scalars-require-header.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | foo bar |


## Problem

Properties (anchors, tags, methods) look out of place when they don't follow an indicator.


## Proposal

Documents with top level properties are required to have a document-start-indicator.


## Explanation

Normally properties immediately follow a key or a sequence-entry-indicator.
```
foo: &a1 !t1
- @a2 !t2
  bar: baz
```

At the top level they should follow an indicator as well:
```
--- &a0 !t0
foo: &a1 !t1
- @a2 !t2
  bar: baz
```

These will be disallowed:
```
&a0 !t0
foo: &a1 !t1
- @a2 !t2
  bar: baz
```

```
&a0
!t0
foo: &a1 !t1
- @a2 !t2
  bar: baz
```
