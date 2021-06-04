---
rfc: RFC-0007
title: Support tabs for indentation
status: new
discuss: https://github.com/yaml/yaml-spec/issues/40
tags: syntax
---

## Problem

The current YAML specification does not allow for tab indentation. This forces
people to use a particular model that may not suit their existing coding
standards or accessibility requirements.

## Proposal

We propose to allow tab indentation in YAML files. For simplicity against the
current specification, they can be parsed as semantically equivalent to 2
spaces.

## Explanation

There are pros and cons to different methods of indentation. We will not go into
those here. Simply to say, the YAML specification should not force people to
follow one way.

There are also pros and cons regarding allowing mixed models of indentation. We
have deliberately defined an explicit equivalence to mitigate potential
inconsistencies.

Specifically, if users choose to mix tabs and spaces, the proposed model handles
this precisely. Alternatively, it could be invalid syntax to use both the tab
and space character within a single span of indentation.

More elaborate and forgiving models exist, such as considering indentation as a
sequence of [\s\t]+ and subsequent lines must match that exactly. However, while
these models might capture the abstract concept of indentation more accurately,
they can be tricky for users and potentially error-prone.

## See Also

### RFC Specification

Refer to [RFC20](https://tools.ietf.org/html/rfc20):

> SP (Space): A normally non-printing graphic character used to separate words.
> It is also a format effector which controls the movement of the printing
> position, one printing position forward. (Applicable also to display devices.)

> HT (Horizontal Tabulation): A format effector which controls the movement of
> the printing position to the next in a series of predetermined positions along
> the printing line. (Applicable also to display devices and the skip function
> on punched cards.)

For a modern interpretation, read "predetermined positions" as "indentation levels".

### Accessibility

The [NVDA](https://www.nvaccess.org/) screen reader used for software
development prefers tabs for indentation. A single semantic character for
indentation is an advantage for these use cases, such as producing tones for
different indentation levels, or giving a precise indentation level without
having to understand the document format.

Many editors allow users to change the width of tab indentation. This allows
[visually impaired users to adjust indentation size to suit their preference](
https://www.reddit.com/r/javascript/comments/c8drjo/).

For more anecdotal evidence, [this thread](
https://twitter.com/sarah_federman/status/1146544481556033537) is a good
starting point.
