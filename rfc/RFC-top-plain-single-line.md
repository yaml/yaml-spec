RFC-000
=======

Top-level plain scalars must not contain newline characters


| Key | Value |
| --- | --- |
| Target | 1.5 |
| Status | 0 |
| Requires | |
| Related | [RFC-json-streaming](RFC-json-streaming.md), [RFC-bare-flow-docs-newline](RFC-bare-flow-docs-newline.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [foo]() [bar]() |


## Problem

Documents with scalar (rather than collection) contents are a valid but relatively rare case which needs to be accounted for.
In particular, it is desirable for YAML to continue to be a complete superset of JSON, which also allows for scalar documents.
As it is also desirable for YAML to be a superset of line-delimited JSON (see [RFC-json-streaming](RFC-json-streaming.md), [RFC-bare-flow-docs-newline](RFC-bare-flow-docs-newline.md)), the rules for top-level plain scalars should be tightened.


## Proposal


Top-level plain scalars MUST NOT contain newline characters.


## Explanation

JSON includes the following plain scalar values:

- `null`
- `true`
- `false`
- numbers, e.g. `42`, `1.23`, `-9e9`

YAML schemas commonly include additional plain scalar values which use default resolution based on regular expressions, rather than needing an explicit tag.
For example, the core schema supports using `0xCAFE` to represent a hexadecimal numbers.
Limiting top-level plain scalars to not include newline characters allows for practically all default-resolution values to still be used at the top level, while disambiguating consecutive newline-separated documents from each other.

This change does not limit the expressibility of the language, as values with newlines may still be used even at the top level, provided that they use some form of flow or block quoting.
Similarly, values including newlines that would normally use regexp-based default resolution may still be used at the top level, provided that they use an explicit tag and quote their value.

Each of these lines consists of a valid YAML document:

```
42
true
plain string
'quoted string'
!!null explicitly tagged value
```

Top-level block scalars are still accepted:

```
>
  A block of text.

--- |
  This is
  fine.
```

This would be parsed as two separate documents:

```
--- !!str
Even explicitly tagging
as string is not enough.
```
