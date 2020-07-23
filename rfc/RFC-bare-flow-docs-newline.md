RFC-000
=======

Any two bare-flow-documents may be separated by a newline


| Key | Value |
| --- | --- |
| Target | 1.5 |
| Status | 0 |
| Requires | [RFC-json-streaming](RFC-json-streaming.md), [RFC-top-plain-single-line](RFC-top-plain-single-line.md) |
| Related | [RFC-directives-are-stream](RFC-directives-are-stream.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [bare]() [document]() [flow]() |


## Problem

While JSON itself does not support streaming or otherwise allow multiple separate documents to be defined in a single file, [JSON streaming](https://en.wikipedia.org/wiki/JSON_streaming) does.
The term refers to a family of protocols such as JSON Lines that allow the concatenation of multiple JSON documents, most often by using a newline `\n` as a delimiter.
These are not currently supported by YAML, but they could be.

[RFC-json-streaming](RFC-json-streaming.md) adds support for line-delimited JSON consisting only of collections; this is about also supporting JSON scalars.


## Proposal

This RFC has a precondition that a bare document with untagged top-level plain scalar contents can be unambiguously determined to be a JSON `null`, `true`, `false`, or a JSON number if it starts with characters that would match one of those patterns.
How exactly that should happen is a separate issue, and addressed e.g. in [RFC-top-plain-single-line](RFC-top-plain-single-line.md).

Provided the preceding happens, the first paragraph of the [RFC-json-streaming](RFC-json-streaming.md) proposal is amended to refer to all flow nodes, rather then only flow collections:

Adjacent documents with root-level flow nodes do not need a document marker separating them, but do need at least one newline `\n` between them.

A valid stream of three documents:

```
"first quoted string"
[ second, doc ]
42
```

Comments and empty lines between such documents are allowed, and flow nodes are not required to fit on a single line:

```
{
  first: doc
}

# this is fine
'second,

  doc'
```

Using no separator, or only whitespace not including `\n` as a separator, is an error:

```
# ERROR
"not" { fine }
```


## Explanation

In order to support line-delimited JSON scalar values, the meaning of the following stream will need to change:

```
true
true
true
```

In YAML 1.2, that parses as a top-level scalar with the value `"true true true\n"`.
As line-delimited JSON, that would parse as three documents each with the boolean value `true`.

In order for YAML to also be able to parse that as three `true` documents, plain untagged scalar values other than `true`, `false`, `null` and JSON numbers need to not be allowed at the top level of a document.
This RFC does not suggest if or how that should happen, but if it does become possible to unambiguously parse a document as ending after any possible JSON scalar value, that the relaxation of needing only a newline separator between documents should be extended from flow collections to also cover JSON scalar values.
