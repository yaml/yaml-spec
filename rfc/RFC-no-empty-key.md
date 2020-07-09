RFC-000
=======

Empty-scalars not allowed as keys


Key | Value
-|-
Target | 1.5
Status | 0
Requires
Related
Discuss | [Issue 0](../../issues/0)
Tags | empty key scalar
Tests | 4ABK 2JQS FRK4 NHX8 S3PD 6M2F KZN9 9MMW


## Problem

YAML 1.2 allows "nothing" to be a valid value; a plain empty scalar that often is loaded as a null value.

The null value isn't very useful as a mapping key, and using an empty value to specify it is confusing to read.


## Proposal

Disallow (untagged) plain empty scalars as mapping keys.


## Explanation

In YAML 1.2, the absence of any value is a valid plain scalar, and usually that loads to a native `null` value.

This can be used nicely to encode unspecified values:
```
size: 5
shape:
color:
```

You can also use these "empty" values as mapping keys.
This means that `:` is same as `null: null`.

Using a null value as a mapping key is a rare thing for a program to do (if it is even allowed by the programming language).

Under this RFC you can still have a null key, but it needs to happen explicitly like in these examples:
```
- null: foo
- !!null: foo
- !null "": foo
- key: &null !null
  *null: foo
```

The following will be parse errors:
```
- :
- : foo
- { : foo }
- &x :
```
