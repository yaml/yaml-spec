RFC-000
=======

Bare documents of flow collections may be separated by a newline


| Key | Value |
| --- | --- |
| Target | 1.5 |
| Status | 0 |
| Requires | [RFC-tail-docs-require-header](RFC-tail-docs-require-header.md) |
| Related | [RFC-top-plain-single-line](RFC-top-plain-single-line.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [bare]() [document]() [flow]() |


## Problem

While JSON itself does not support streaming or otherwise allow multiple separate documents to be defined in a single file, [JSON streaming](https://en.wikipedia.org/wiki/JSON_streaming) does.
The term refers to a family of protocols such as JSON Lines that allow the concatenation of multiple JSON documents, most often by using a newline `\n` as a delimiter.
These are not currently supported by YAML, but they could be.


## Proposal

Adjacent documents with root-level flow collection values do not need a document marker separating them, but do need at least one newline `\n` between them.

On output, YAML libraries SHOULD by default include a `---` separator for documents even if the output could be parsed as valid YAML without it.
If it's desirable for the output to be parsed by non-YAML line-delimited JSON consumers, each document SHOULD be formatted as valid JSON and output on a single line.

A valid stream of three documents:

```
{ "first": "doc" }
[ second, doc ]
{ third }
```

Comments and empty lines between such documents are allowed, and flow collections are not required to fit on a single line:

```
{
  first: doc
}

# this is fine
[
    second,
    doc
]
```

Using no separator, or only whitespace not including `\n` as a separator, is an error:

```
# ERROR
[ not ] { fine }
```

## Explanation

Normally, documents after the first in a stream need a document marker separating them to ensure clarity.
For flow mappings and sequences, this is not required as there is no ambiguity.
Requiring at least one newline `\n` as a separator makes it more obvious that the documents are intentionally separated, and clarifies the starting index of the second document

This change could be considered semver-minor, as it does not change any existing working code.
This would also support parsing most real-world line-delimited JSON, but it would not support JSON streams that may contain documents that are JSON scalar values.

For complete line-delimited JSON support, see [RFC-top-plain-single-line](RFC-top-plain-single-line.md), which builds on this and other spec changes.
