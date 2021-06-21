Implicit Merging
================

A mapping merge looks like this:
```
--- &base
foo: 1
bar: 2
--- !merge
aaa:
- *base
- baz: 3
  bar: 4
- xxx: 9
```

Resulting in:
```
aaa:
  foo: 1
  baz: 3
  bar: 4
  xxx: 9
```

That is, a merge is takes a sequence of two or more mappings and merges them,
with latter pairs taking precedence.

The YAML 1.2 "merge key" can be done with a schema like this:
```
+map:
  base: ++map
  when:
  - pkey: '<<'
    func: merge-key
```

Effectively that makes this YAML:
```
aaa:
  <<: *base
  baz: 3
  bar: 4
```

Be loaded like:
```
aaa: !merge-key
  <<: *base
  baz: 3
  bar: 4
```

In other words, it implicitly tags a mapping.

We can also implicitly tag a value that expects a mapping type, but has a
sequence of mappings. The schema looks like:
```
+map:
  base: ++map
  when:
  - list: +map
    func: merge
```

That makes this YAML:
```
aaa:
- *base
- baz: 3
  bar: 4
- xxx: 9
```

Be loaded like:
```
aaa: !merge
- *base
- baz: 3
  bar: 4
- xxx: 9
```

This is another way to implicitly tag a mapping.

Some 1.1 and 1.2 loaders do the `merge-key` style merging by default.
It would not make sense to do the latter `merge` tag by default, but it
certainly might make sense for a specific application's schema.
It could even be applied only to certain specific nodes in a document.

All it does is save you from needing to explicitly tag a node that the schema
says must be a mapping, but the loader finds a sequence of mappings instead.

This is an example of how a YAML loader can expose the full power of tag
functional transforms, without the YAML ever needing to have explicit tags
actually in the YAML.

Just like:
```
- 123
```
is more natural to write than:
```
- !int '123'
```

It's the exact same thing for collections.
Of course, an author is always free to use the `!merge` tag explicitly (even
though the schema dictates it) if they feel the intent might be lost on others.
