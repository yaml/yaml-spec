RFC-000
=======

Only ASCII-word-characters and dash are allowed in anchor names


| Key | Value |
| --- | --- |
| Target | 1.5 |
| Status | 0 |
| Requires | |
| Related | |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [anchor]() |


## Problem

At the moment, an anchor name can consist of almost any printable character, with the following specific exceptions:

```
\t | \r | \n | ' ' | ',' | '[' | ']' | '{' | '}'
```

Some implementations support a stricter subset of characters.
LibYAML, for instance, only supports:

```
'A'-'Z' | 'a'-'z' | '0'-'9' | '_' | '-'
```

This freedom in anchor names is useless to the user, while making parsing more difficult.


## Proposal

An implementation MUST accept anchor names composed of one or more of the following characters:

```
'A'-'Z' | 'a'-'z' | '0'-'9' | '_' | '-'
```

An implementation MAY accept anchor names that start with one of the following characters:

```
\p{ID_Start} | \p{Nd} | \p{Pc} | \p{Pd}
```

and for which any subsequent characters are from:

```
\p{ID_Continue} | \p{Pd}
```

These categories are defined in terms of Unicode code point properties:
- `ID_Start`, `ID_Continue`: As described in [Unicode Standard Annex #31](http://www.unicode.org/reports/tr31/), "Unicode Identifier and Pattern Syntax".
  `ID_Continue` is a superset of `ID_Start` which also includes `Nd` and `Pc` characters, among others.
- `Nd`: Number, decimal digit
- `Pc`: Punctuation, connector (includes `_`)
- `Pd`: Punctuation, dash (includes `-`)


## Explanation

These are always fine:

```
&foo
&Bar-baz
&42
&_
```

These will work with implementations that support the full set of Unicode characters:

```
&kääk
&😁
&شيء
```

These are errors:

```
&foo.bar
&syntax/is:not*allowed&
& # empty string
```

A less technical way to express this is that anchor names should consist of letters, numbers, underscores and dashes.
If you use characters outside of the ASCII set, those might not be supported by all implementations.

Earlier versions of this RFC also included period `.` and forward slash `/` as valid anchor name characters.
These have been left out in order to effectively reserve them for future use in aliases, for instance as path separators.
