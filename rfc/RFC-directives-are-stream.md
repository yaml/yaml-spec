RFC-000
=======

Directives belong to the stream and not a document


| Key | Value |
| --- | --- |
| Target | 1.5 |
| Status | 0 |
| Requires | [RFC-tail-docs-require-header](RFC-tail-docs-require-header.md) |
| Related | [RFC-json-streaming](RFC-json-streaming.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [directive]() [document]() [stream]() |


## Problem

The YAML 1.1 spec defines a stream as consisting of a series of documents, each of which "may be preceded by a series of directives."
Documents after the first (`l-next-document`) have this additional specification:
> If the document specifies no directives, it is parsed using the same settings as the previous document.
> If the document does specify any directives, all directives of previous documents, if any, are ignored.

In the YAML 1.2 spec, a document in a stream "is completely independent from the rest".
This version of the spec does not define an `l-next-document` construct, but does define an `l-directive-document` as starting "with some directives".

The complete independence of documents from each other severely limits the usability of multi-document streams, in particular with repect to directives.
The YAML 1.1 implementation should be returned to, while clarifying the relationship between documents and directives.


## Proposal

This RFC follows on from [RFC-tail-docs-require-header](RFC-tail-docs-require-header.md), which renames the "directives end" marker as "document start" and requires it for documents after the first in a stream.

Directives are defined as belonging to the stream, rather than any single document.
Each directive may be repeated, and a directive with the same name as an earlier directive completely replaces the earlier directive.
Directives may themselves limit whether they may be repeated, or defined after the first document.
When parsing a document, only the values of directives declared before that document are taken into account.

If any directives are declared before the first document, that document must have a document-start marker.
If directives need to be set between documents, the preceding document must have a document-end marker.

A stream therefore consists of a sequence of four different constructs, each of which may be parsed a single line at a time:
* `empty` lines, consisting only of white space
* `comment` lines, which have `#` as their first non-white-space character
* `directive` lines, which start with `%`
* documents, which may include:
  * document `start` (line starts with `---`) and `end` (line starts with `...`) markers as well as
  * all `other` valid document constructs, which includes `empty` and `comment` lines.

The stream parser may be implemented based on a state machine that is in one of three states.
At any point, `empty` lines and `comment`s may be encountered; they are not considered here.
1. `START`: The state at the beginning of the stream.
   When encountering the first non-`empty` non-`comment` construct, the state switches to `STREAM` if it is a `directive` or to `DOCUMENT` if it is `start` or `other`.
   Encountering `end` here is an error.
2. `STREAM`: Only `directive` and `start` are valid constructs, everything else is an error.
   When encountering `start`, the state switches to `DOCUMENT`.
3. `DOCUMENT`:
   When encountering `start`, any previous document ends and a new document is started.
   After encountering `end`, the document ends and the stream state switches to `STREAM`.
   Within a document, `directive` parsing does not take place and `other` constructs may occur.

The stream may end at any point, at which any remaining document should be considered to end.
On output, implementations should include all directives before the first document, if possible.

For single-document streams, this matches the behaviour of YAML 1.1 and YAML 1.2.
For multi-document streams, this matches the behaviour of YAML 1.1.
Compared to YAML 1.2, there is a difference in directives preceding earlier documents also being taken into accound when parsing.

If both [RFC-json-streaming](RFC-json-streaming.md) and this are accepted, certain `other` constructs such as flow mappings and sequences may begin a new document when within the `DOCUMENT` state.

OK:
```
plain: document
```

OK:
```
%YAML 1.3
%TAG ! !foo/
---
document: with directives
...

%TAG ! !bar/
---
other: document with redefined ! tag
```

Error:
```
...
```
