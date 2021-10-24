This page provides a quick glimpse into the expressive power of YAML.
It is not expected that the first-time reader grok all of the examples.
Rather, these selections are used as motivation for the remainder of the
specification.


## #. Collections

YAML's [block collections] use [indentation] for scope and begin each entry on
its own line.
[Block sequences] indicate each entry with a dash and space ("`- `").
[Mappings] use a colon and space ("`: `") to mark each [key/value pair].
[Comments] begin with an octothorpe (also called a "hash", "sharp", "pound" or
"number sign" - "`#`").


**Example #. Sequence of Scalars (ball players)**

```
- Mark McGwire
- Sammy Sosa
- Ken Griffey
```


**Example #. Mapping Scalars to Scalars (player statistics)**

```
hr:  65    # Home runs
avg: 0.278 # Batting average
rbi: 147   # Runs Batted In
```


**Example #. Mapping Scalars to Sequences (ball clubs in each league)**

```
american:
- Boston Red Sox
- Detroit Tigers
- New York Yankees
national:
- New York Mets
- Chicago Cubs
- Atlanta Braves
```


**Example #. Sequence of Mappings (players' statistics)**

```
-
  name: Mark McGwire
  hr:   65
  avg:  0.278
-
  name: Sammy Sosa
  hr:   63
  avg:  0.288
```

YAML also has [flow styles], using explicit [indicators] rather than
[indentation] to denote scope.
The [flow sequence] is written as a [comma] separated list within [square]
[brackets].
In a similar manner, the [flow mapping] uses [curly] [braces].


**Example #. Sequence of Sequences**

```
- [name        , hr, avg  ]
- [Mark McGwire, 65, 0.278]
- [Sammy Sosa  , 63, 0.288]
```


**Example #. Mapping of Mappings**

```
Mark McGwire: {hr: 65, avg: 0.278}
Sammy Sosa: {
    hr: 63,
    avg: 0.288,
 }
```


## #. Structures

YAML uses three dashes ("`---`") to separate [directives] from [document]
[content].
This also serves to signal the start of a document if no [directives] are
present.
Three dots ( "`...`") indicate the end of a document without starting a new
one, for use in communication channels.


**Example #. Two Documents in a Stream (each with a leading comment)**

```
# Ranking of 1998 home runs
---
- Mark McGwire
- Sammy Sosa
- Ken Griffey

# Team ranking
---
- Chicago Cubs
- St Louis Cardinals
```


**Example #. Play by Play Feed from a Game**

```
---
time: 20:03:20
player: Sammy Sosa
action: strike (miss)
...
---
time: 20:03:47
player: Sammy Sosa
action: grand slam
...
```

Repeated [nodes] (objects) are first [identified] by an [anchor] (marked with
the ampersand - "`&`") and are then [aliased] (referenced with an asterisk -
"`*`") thereafter.


**Example #. Single Document with Two Comments**

```
---
hr: # 1998 hr ranking
- Mark McGwire
- Sammy Sosa
# 1998 rbi ranking
rbi:
- Sammy Sosa
- Ken Griffey
```


**Example #. Node for "`Sammy Sosa`" appears twice in this document**

```
---
hr:
- Mark McGwire
# Following node labeled SS
- &SS Sammy Sosa
rbi:
- *SS # Subsequent occurrence
- Ken Griffey
```

A question mark and space ("`? `") indicate a complex [mapping] [key].
Within a [block collection], [key/value pairs] can start immediately following
the [dash], [colon] or [question mark].


**Example #. Mapping between Sequences**

```
? - Detroit Tigers
  - Chicago cubs
: - 2001-07-23

? [ New York Yankees,
    Atlanta Braves ]
: [ 2001-07-02, 2001-08-12,
    2001-08-14 ]
```


**Example #. Compact Nested Mapping**

```
---
# Products purchased
- item    : Super Hoop
  quantity: 1
- item    : Basketball
  quantity: 4
- item    : Big Shoes
  quantity: 1
```


## #. Scalars

[Scalar content] can be written in [block] notation, using a [literal style]
(indicated by "`|`") where all [line breaks] are significant.
Alternatively, they can be written with the [folded style] (denoted by "`>`")
where each [line break] is [folded] to a [space] unless it ends an [empty] or a
[more-indented] line.


**Example #. In literals, newlines are preserved**

```
# ASCII Art
--- |
  \//||\/||
  // ||  ||__
```


**Example #. In the folded scalars, newlines become spaces**

```
--- >
  Mark McGwire's
  year was crippled
  by a knee injury.
```


**Example #. Folded newlines are preserved for "more indented" and blank
lines**

```
--- >
 Sammy Sosa completed another
 fine season with great stats.

   63 Home Runs
   0.288 Batting Average

 What a year!
```


**Example #. Indentation determines scope**

```
name: Mark McGwire
accomplishment: >
  Mark set a major league
  home run record in 1998.
stats: |
  65 Home Runs
  0.278 Batting Average
```

YAML's [flow scalars] include the [plain style] (most examples thus far) and
two quoted styles.
The [double-quoted style] provides [escape sequences].
The [single-quoted style] is useful when [escaping] is not needed.
All [flow scalars] can span multiple lines; [line breaks] are always [folded].


**Example #. Quoted Scalars**

```
unicode: "Sosa did fine.\u263A"
control: "\b1998\t1999\t2000\n"
hex esc: "\x0d\x0a is \r\n"

single: '"Howdy!" he cried.'
quoted: ' # Not a ''comment''.'
tie-fighter: '|\-*-/|'
```


**Example #. Multi-line Flow Scalars**

```
plain:
  This unquoted scalar
  spans many lines.

quoted: "So does this
  quoted scalar.\n"
```


## #. Tags

In YAML, [untagged nodes] are given a type depending on the [application].
The examples in this specification generally use the `seq`, `map` and `str`
types from the [fail safe schema].
A few examples also use the `int`, `float` and `null` types from the [JSON
schema].


**Example #. Integers**

```
canonical: 12345
decimal: +12345
octal: 0o14
hexadecimal: 0xC
```


**Example #. Floating Point**

```
canonical: 1.23015e+3
exponential: 12.3015e+02
fixed: 1230.15
negative infinity: -.inf
not a number: .nan
```


**Example #. Miscellaneous**

```
null:
booleans: [ true, false ]
string: '012345'
```


**Example #. Timestamps**

```
canonical: 2001-12-15T02:59:43.1Z
iso8601: 2001-12-14t21:59:43.10-05:00
spaced: 2001-12-14 21:59:43.10 -5
date: 2002-12-14
```

Explicit typing is denoted with a [tag] using the exclamation point ("`!`")
symbol.
[Global tags] are URIs and may be specified in a [tag shorthand] notation using
a [handle].
[Application]\-specific [local tags] may also be used.


**Example #. Various Explicit Tags**

```
---
not-date: !!str 2002-04-28

picture: !!binary |
 R0lGODlhDAAMAIQAAP//9/X
 17unp5WZmZgAAAOfn515eXv
 Pz7Y6OjuDg4J+fn5OTk6enp
 56enmleECcgggoBADs=

application specific tag: !something |
 The semantics of the tag
 above may be different for
 different documents.
```


**Example #. Global Tags**

```
%TAG ! tag:clarkevans.com,2002:
--- !shape
  # Use the ! handle for presenting
  # tag:clarkevans.com,2002:circle
- !circle
  center: &ORIGIN {x: 73, y: 129}
  radius: 7
- !line
  start: *ORIGIN
  finish: { x: 89, y: 102 }
- !label
  start: *ORIGIN
  color: 0xFFEEBB
  text: Pretty vector drawing.
```


**Example #. Unordered Sets**

```
# Sets are represented as a
# Mapping where each key is
# associated with a null value
--- !!set
? Mark McGwire
? Sammy Sosa
? Ken Griffey
```


**Example #. Ordered Mappings**

```
# Ordered maps are represented as
# A sequence of mappings, with
# each mapping having one key
--- !!omap
- Mark McGwire: 65
- Sammy Sosa: 63
- Ken Griffey: 58
```


## #. Full Length Example

Below are two full-length examples of YAML.
The first is a sample invoice; the second is a sample log file.


**Example #. Invoice**

```
--- !<tag:clarkevans.com,2002:invoice>
invoice: 34843
date   : 2001-01-23
bill-to: &id001
  given  : Chris
  family : Dumars
  address:
    lines: |
      458 Walkman Dr.
      Suite #292
    city    : Royal Oak
    state   : MI
    postal  : 48046
ship-to: *id001
product:
- sku         : BL394D
  quantity    : 4
  description : Basketball
  price       : 450.00
- sku         : BL4438H
  quantity    : 1
  description : Super Hoop
  price       : 2392.00
tax  : 251.42
total: 4443.52
comments:
  Late afternoon is best.
  Backup contact is Nancy
  Billsmer @ 338-4338.
```


**Example #. Log File**

```
---
Time: 2001-11-23 15:01:42 -5
User: ed
Warning:
  This is an error message
  for the log file
---
Time: 2001-11-23 15:02:31 -5
User: ed
Warning:
  A slightly different error
  message.
---
Date: 2001-11-23 15:03:17 -5
User: ed
Fatal:
  Unknown variable "bar"
Stack:
- file: TopClass.py
  line: 23
  code: |
    x = MoreObject("345\n")
- file: MoreClass.py
  line: 58
  code: |-
    foo = bar
```
