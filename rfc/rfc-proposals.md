## Disallow explicit key indicator in flow collections
```
# NO
[ ? [4, 2]: 42 ]
# OK
[ { [4, 2]: 42 } ]
```


## Top level scalars require a start indicator
```
# NO
foo

'bar'

|
  baz

# OK
--- foo

--- 'bar'

--- |
  baz
```


## Top level properties require a start indicator
```
# NO
&a1 [4, 2]

!foo bar

# OK
--- &a1 [4, 2]

--- !foo bar
```


## Top level literal scalar content must be visually indented
```
# NO
--- |
\
 \___
# OK
--- |
 \
  \___
```


## Flow nodes must begin on same line as indicators
```
# NO
---
  foo bar

-
  {
    foo: 42
  }

key:
  {
    foo: 42
  }

# OK
--- foo bar

- {
    foo: 42
  }

key: {
    foo: 42
  }
```


## Properties and scalar indicators must be on same line as block indicators
```
# NO
---
&a1
!t1
- foo

---
|
  this

# OK
--- &a1 !t1
- foo

--- |
  this
```




## Multiline top level scalar content must be visually indented after start indicator line
```
# NO
--- foo
bar

--- 'foo
bar'

# OK
--- foo
 bar

--- 'foo
 bar'
```


## Scalar keys containing whitespace must be quoted
```
# NO
foo bar: baz

{ foo
  bar: baz }

# OK
'foo bar': baz

{ 'foo
  bar': baz }
```


## Two flow documents with no properties or directives may be separated by a newline
```
# OK
{ foo: 42 }
[ 4, 2 ]
# NO
--- { foo: 42 }
[ 4, 2 ]
```
For `jq` compatability.


## Top level block collection nodes must start unindented
```
# NO
    foo: 1
    bar: 2

    - foo
    - bar

# OK
foo: 1
bar: 2

- foo
- bar
```


## Maximum of 8 spaces allowed per indentation level
```
# NO
foo:
          bar: 42
# OK
foo:
        bar: 42
```


## Only ASCII word chars and dash allowed in anchor names
```
# NO
[ &*** a, &xxx: b, &你好 c, &x–y d ]
# OK
[ &a09 a, &a-b: b, *_-_- c, &A-z d ]
```


## Hard tabs only allowed in literal scalar content
```
# NO
-<TAB>value<tab># comment

foo:<tab>value

# OK
foo: |
  bar:
  <tab>baz
```


## Support hard tab indentation
```
# OK
foo:
<tab>bar:
<tab><tab>baz: 42
# NO
foo:
<tab>  bar:
<tab>  <tab>baz: 42
```


## Disallow carriage return as break character
```
# NO
foo: bar<cr>
baz: 42<cr>
# OK
foo: bar<lf>
baz: 42<cr><lf>
```


## Support double-quote escapes in literal scalars
```
# OK
- |"
  foo\tbar
```


## Support double-quote escapes in folded scalars
```
# OK
- >"
  foo\tbar
```


## Add a triple double-quote syntax
```
# OK
- """
  foo\tbar
  baz\n\n\n
```


## Add a triple single-quote syntax
```
# OK
- '''
  Don't need to escape 'quotes'
```


## Deprecate folded scalar
```
# NO
- >
  foo
  bar
# OK
- '''
  foo
  bar
```


## Anchors before tags
```
# NO
--- !ttt &aaa []
# OK
--- &aaa !ttt []
```


## Allow multiple anchors on a node
```
# OK
- &a &b foo
```


## Allow anchor on alias
```
# OK
- &a *b
```


## Directives apply until overridden
```
# OK
%YAML 1.3
--- foo
--- bar
%YAML 1.2
--- baz
```

## Empty values not allowed as keys
```
# NO
: {x: 1, : 2}
# OK
null: {x: 1, null: 2}
```

## Plain scalars cannot end with colon
```
# NO
- foo::: bar
- {foo:}
# OK
- 'foo::': bar
- {'foo:'}
- {"foo":}
- {foo: }
```


## Add a SCHEMA directive
```
# OK
%SCHEMA Core

%SCHEMA https://yaml.us/

%SCHEMA ./foo.stp
```


## Documents after the first require a start indicator
```
# NO
- foo
...
- bar
# OK
- foo
---
- bar
```
