RFC-000
=======

Allow directives to be lowercase or uppercase


| Key | Value |
| --- | --- |
| Target | 1.3 |
| Status | 0 |
| Requires | |
| Related | |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [foo]() [bar]() |


## Problem

There's no need to use all-caps for directives like `%YAML` and `%TAG`,
Allowing less-shouty names would be more polite.


## Proposal

The "YAML" directive is identified as starting with either `%YAML` or `%yaml`.

The "TAG" directive is identified as starting with either `%TAG` or `%tag`.

Any additional directives are identified using either the upper-case or lower-case form of their name.
Directives with differently cased names are treated equivalently.
If an implementation provides an interface for getting the canonical name of a directive, the upper-case name MUST be provided.


## Explanation

This would match how HTML works; the tag case does not matter, and `<body>` is equivalent to `<BODY>`.
The canonical tag name is still `'BODY'` for both.
