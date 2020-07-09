RFC-000
=======

Top-level literal-scalar content must be visually indented


| Key | Value |
| --- | --- |
| Target | 1.3 |
| Status | 0 |
| Requires | |
| Related | |
| Discuss | [Issue 0](../../issues/0) |
| Tags | [indent]() [literal]() [scalar]() [top]() |


## Problem

The YAML 1.2 spec seems to allow the content of a top level literal scalar to be unindented.

## Proposal

Top level literal scalars must be visually indented, such that content never appears in column 1.


## Explanation

Literal scalars are YAML's version of here-docs, allowing any printable content to be encoded, merely by indenting it.
```
python-code: |
  def foo(bar):
    print(bar)
```

One of the main use cases was that any YAML file could be encoded into another YAML file, using the indented form.
```
more-yaml: |
  %YAML 1.2
  ---
  foo: bar
  ...
```

Some implentations allow this:
```
--- |
def foo(bar):
  print(bar)
```

The content appears to be not indented, but technically it is if you follow the 1.2 spec's rule that indentation starts at -1.
The would make the above indented at 0, which is more than -1.

Allowing literal content into the first column (column 1) is problematic if we use the 2nd example above:
```
--- |
%YAML 1.2
---
foo: bar
...
```

This ends up not meaning at all what was intended.

Another problem is that if the literal content is really long, it becomes harder to know that it is YAML encoded.

The right solution is to mandate that top level literal scalar content must be visually indented by at least one space.
