RFC-000
=======

Add IMPORT directive


| Key | Value |
| --- | --- |
| Target | 1.5 |
| Status | 0 |
| Requires | [RFC-directives-are-stream](RFC-directives-are-stream.md), [RFC-external-aliases](RFC-external-aliases.md) |
| Related | |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [foo]() [bar]() |


## Problem

It can be useful to refer to content in documents that are not part of the current stream.

## Proposal

Define an "IMPORT" directive, which takes the form:

```
%IMPORT BINDINGS from SOURCE
```

`BINDINGS` is either the string `*` to indicate all document anchors defined in `SOURCE`, or a comma-delimited list of individual bindings:
- A binding `*doc` binds the document anchor `doc` of `SOURCE` to have the local name `doc`.
If `SOURCE` may be resolved to contain a single document and `BINDINGS` consists of a single binding that takes this form, that document is bound as if it had the named anchor.

- A binding `*foo as *bar` binds the document anchor `foo` of `SOURCE` to have the local name `bar`.

- A binding `*foo*bar as *baz` binds the anchor `bar` of the document with the anchor `foo` in `SOURCE` to have the local name `baz`.

`SOURCE` is a resource path for an asset that resolves to a YAML document stream.
`SOURCE` MUST be a plain string, a `"double quoted"` string or a `'single quoted'` string.
It MAY be followed by an inline comment.

The mapping of the `SOURCE` string to a YAML stream is left as an implementation detail, with the following provisos:
- If `SOURCE` is a file path, the forward slash `/` MUST be accepted as a path separator.
- If `SOURCE` is a file path, it MUST be fully specified and MUST NOT have any default extensions added to it when determining the source file.
- If `SOURCE` is a relative file path, it MUST start with a `.` or `..` part and be relative to the location of the current YAML stream.
- Implementations MAY define their own security model and refuse to resolve any import `SOURCE`.

Anchors that are imported into the current stream by the "IMPORT" directive may be used by any subsequent document.

It is an error for an import binding to use a local name already used by an earlier document anchor in this stream, or by an earlier "IMPORT" directive.
It is an error for any subsequent document to include an anchor with the same name as used


## Explanation

Effectively, this RFC allows for the following sorts of imports:

```
%IMPORT *doc from ./file.yaml
%IMPORT *foo, *bar from ../../other/file name.yaml
%IMPORT *foo as *bar, *foo*bar as *foo from somewhere
%IMPORT * from /absolute/path.yaml # with comment
```

This work follows on from [RFC-external-aliases](RFC-external-aliases.md), by enabling anchors to be defined outside of the current stream.

The resolution of `SOURCE` is left intentionally incomplete, in order for implementations to have the freedom to e.g. not allow it at all, or to allow imports also from network resources.
The minimal provisos are included for local file mappings to have at least one form of specifying a relative file path that is platform-independent.
