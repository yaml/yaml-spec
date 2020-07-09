RFC-000
=======

Define YAML syntax based on Unicode code points


| Key | Value |
| --- | --- |
| Target | 1.3 |
| Status | 0 |
| Requires | |
| Related | [RFC-directives-are-stream](RFC-directives-are-stream.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | |


## Problem

Previous versions of the specification include a section on "Character Encodings", and define how exactly the byte order mark should be used to determine the encoding.
This is all a bit besides the point, and doesn't really belong in the spec.


## Proposal

YAML syntax is defined as a sequence of Unicode code points.
On input and output, it is an implementation detail for the encoding to be determined.

Any byte order mark `\uFEFF` MUST be ignored if encountered as the first character of a stream.
Otherwise, the character `\uFEFF` gets no special treatment.


## Explanation

This RFC takes inspiration from the [ECMA-404](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf) definition for JSON, which just says this on the topic:
> JSON syntax describes a sequence of Unicode code points.

That's clear and simple, and lets the encoding be a non-issue within the specification.

In these examples, byte order mark characters are displayed as “⇔”.

OK:
```
⇔# Comment
# lines
Document
```

Error:
```
⇔first: doc
...

⇔---
second: doc
```
