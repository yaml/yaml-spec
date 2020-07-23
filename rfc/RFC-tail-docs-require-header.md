RFC-000
=======

Documents after the first require a document-start-indicator


| Key | Value |
| --- | --- |
| Target | 1.5 |
| Status | 0 |
| Requires | |
| Related | [RFC-json-streaming](RFC-json-streaming.md), [RFC-directives-are-stream](RFC-directives-are-stream.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [document]() [indicator]() |


## Problem

YAML supports two document markers, `---` and `...`.
Their roles and usage is not entirely clear.
The YAML 1.2 spec refers to these as the "directives end" and the "document end" markers or indicators.
The YAML 1.1 spec referred to `---` as the "document start" marker.


## Proposal

The "directives end" marker should be renamed back to "document start", and be explicitly required when starting any document after the first in a stream.
The "document end" marker would continue to be optional, and useful far more rarely:

* When needing to include directives between documents.
* Explicitly ending a document in a persistent stream.


## Explanation

The `...` (document end) indicator was originally proposed to explicitly end a document in a streaming operation in situations where the next document might take too much time to appear.
The next document, starting with `---`, would effectively end the previous document, in the absence of the document end indicator.

Later on, it was noted that in the presence of `...`, the `---` for the next document was not really needed.
This, in turn, led to the renaming of `---` to "directives end" which while possibly technically correct, obsured the true meaning and purpose of `---`.

This proposal and its related ones, bring back the original meaning to the indicators, require the start indicator to start a subsequent document, and make a clear distinction between stream-related content and document-related content.

OK:
```
doc: 1
---
doc: 2
...
%TAG ! !foo/
--- !bar
doc: 3
```

Error:
```
doc: 1
...
doc: 2
```