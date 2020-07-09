RFC-000
=======

Maximum of 8 spaces per indentation level


| Key | Value |
| --- | --- |
| Target | 1.5 |
| Status | 0 |
| Requires | |
| Related | [RFC-unindented-top-level](RFC-unindented-top-level.md) |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [indent]() |


## Problem

YAML 1.2 indentation can be an unlimited number of spaces per level.

This is not needed and might be exploited for nefarious goals.


## Proposal

Only allow a maximum of 8 spaces per indentation level.


## Explanation

YAML's preferred indentation is 2 spaces.
Almost all known dumpers use 2 as the default.

People sometimes use more than 2, but there should be a limit.

In general, indentation in any programming scoping use is not more than 8 columns.
Hard tabs, even though configurable, are either set to 8 columns or less in practice.

It's conceivable that a petabyte of indentation spaces could cause some parsers to break.
It's also conceivable that someone might use the indentation to "hide" values from casual observation; possibly to accomplish a security exploit.

Limiting indentation to 8 spaces should be a good thing for YAML.

OK:
```
foo:
        bar: 42
```

Error:
```
foo:
                                                bar: 42
```
