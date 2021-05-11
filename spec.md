# YAML Ain’t Markup Language (YAML™) Version 1.2

## 3rd Edition, Patched at YYYY-MM-DD

### Oren Ben-Kiki <[oren@ben-kiki.org](mailto:oren@ben-kiki.org)>

### Clark Evans <[cce@clarkevans.com](mailto:cce@clarkevans.com)>

### Ingy döt Net <[ingy@ingy.net](mailto:ingy@ingy.net)>

_Latest (patched) version:_  
HTML:
[http://yaml.org/spec/1.2/spec.html](http://yaml.org/spec/1.2/spec.html)  
PDF: [http://yaml.org/spec/1.2/spec.pdf](http://yaml.org/spec/1.2/spec.pdf)  
PS: [http://yaml.org/spec/1.2/spec.ps](http://yaml.org/spec/1.2/spec.ps)  
Errata:
[http://yaml.org/spec/1.2/errata.html](http://yaml.org/spec/1.2/errata.html)  
_Previous (original) version:_
[http://yaml.org/spec/1.2/2009-07-21/spec.html](http://yaml.org/spec/1.2/2009-0
7-21/spec.html)  

Copyright © 2001-YYYY Oren Ben-Kiki, Clark Evans, Ingy döt Net

This document may be freely copied, provided it is not modified.

**Status of this Document**

This document reflects the third version of YAML data serialization language.
The content of the specification was arrived at by consensus of its authors and
through user feedback on the
[yaml-core](http://lists.sourceforge.net/lists/listinfo/yaml-core) mailing list.
We encourage implementers to please update their software with support for this
version.

The primary objective of this revision is to bring YAML into compliance with
JSON as an official subset.
YAML 1.2 is compatible with 1.1 for most practical applications - this is a
minor revision.
An expected source of incompatibility with prior versions of YAML, especially
the syck implementation, is the change in implicit typing rules.
We have removed unique implicit typing rules and have updated these rules to
align them with JSON's productions.
In this version of YAML, boolean values may be serialized as "**`true`**" or
"**`false`**"; the empty scalar as "**`null`**".
Unquoted numeric values are a superset of JSON's numeric production.
Other changes in the specification were the removal of the Unicode line breaks
and production bug fixes.
We also define 3 built-in implicit typing rule sets: untyped, strict JSON, and
a more flexible YAML rule set that extends JSON typing.

The difference between late 1.0 drafts which syck 0.55 implements and the 1.1
revision of this specification is much more extensive.
We fixed usability issues with the tagging syntax.
In particular, the single exclamation was re-defined for private types and a
simple prefixing mechanism was introduced.
This revision also fixed many production edge cases and introduced a type
repository.
Therefore, there are several incompatibilities between syck and this revision
as well.

The list of known errors in this specification is available at
[http://yaml.org/spec/1.2/errata.html](http://yaml.org/spec/1.2/errata.html).
Please report errors in this document to the yaml-core mailing list.
This revision contains fixes for all errors known as of YYYY-MM-DD.

We wish to thank implementers who have tirelessly tracked earlier versions of
this specification, and our fabulous user community whose feedback has both
validated and clarified our direction.

**Abstract**

YAML™ (rhymes with "camel") is a human-friendly, cross language, Unicode based
data serialization language designed around the common native data types of
agile programming languages.
It is broadly useful for programming needs ranging from configuration files to
Internet messaging to object persistence to data auditing.
Together with the [Unicode standard for characters](http://www.unicode.org/),
this specification provides all the information necessary to understand YAML
Version 1.2 and to create programs that process YAML information.

----

{{toc}}

# Chapter 1. Introduction

"YAML Ain’t Markup Language" (abbreviated YAML) is a data serialization
language designed to be human-friendly and work well with modern programming
languages for common everyday tasks.
This specification is both an introduction to the YAML language and the
concepts supporting it, and also a complete specification of the information
needed to develop [applications](#application//) for processing YAML.

Open, interoperable and readily understandable tools have advanced computing
immensely.
YAML was designed from the start to be useful and friendly to people working
with data.
It uses Unicode [printable](#printable character//) characters,
[some](#indicator//) of which provide structural information and the rest
containing the data itself.
YAML achieves a unique cleanness by minimizing the amount of structural
characters and allowing the data to show itself in a natural and meaningful way.
For example, [indentation](#space/indentation/) may be used for structure,
[colons](#: mapping value//) separate [key: value pairs](#key: value pair//),
and [dashes](#- block sequence entry//) are used to create "bullet"
[lists](#sequence//).

There are myriad flavors of [data structures](#native data structure//), but
they can all be adequately [represented](#represent//) with three basic
primitives: [mappings](#mapping//) (hashes/dictionaries),
[sequences](#sequence//) (arrays/lists) and [scalars](#scalar//)
(strings/numbers).
YAML leverages these primitives, and adds a simple typing system and
[aliasing](#alias//) mechanism to form a complete language for
[serializing](#serialize//) any [native data structure](#native data
structure//).
While most programming languages can use YAML for data serialization, YAML
excels in working with those languages that are fundamentally built around the
three basic primitives.
These include the new wave of agile languages such as Perl, Python, PHP, Ruby,
and Javascript.

There are hundreds of different languages for programming, but only a handful
of languages for storing and transferring data.
Even though its potential is virtually boundless, YAML was specifically created
to work well for common use cases such as: configuration files, log files,
interprocess messaging, cross-language data sharing, object persistence, and
debugging of complex data structures.
When data is easy to view and understand, programming becomes a simpler task.

## 1.1. Goals

The design goals for YAML are, in decreasing priority:

1.  YAML is easily readable by humans.
2.  YAML data is portable between programming languages.
3.  YAML matches the [native data structures](#native data structure//) of agile languages.
4.  YAML has a consistent model to support generic tools.
5.  YAML supports one-pass processing.
6.  YAML is expressive and extensible.
7.  YAML is easy to implement and use.

## 1.2. Prior Art

YAML’s initial direction was set by the data serialization and markup language
discussions among [SML-DEV members](http://www.docuverse.com/smldev/).
Later on, it directly incorporated experience from Ingy döt Net’s Perl module
[Data::Denter](http://search.cpan.org/dist/Data-Denter/).
Since then, YAML has matured through ideas and support from its user community.

YAML integrates and builds upon concepts described by
[C](http://cm.bell-labs.com/cm/cs/cbook/index.html),
[Java](http://java.sun.com/), [Perl](http://www.perl.org/),
[Python](http://www.python.org/), [Ruby](http://www.ruby-lang.org/),
[RFC0822](http://www.ietf.org/rfc/rfc0822.txt) (MAIL),
[RFC1866](http://www.ics.uci.edu/pub/ietf/html/rfc1866.txt) (HTML),
[RFC2045](http://www.ietf.org/rfc/rfc2045.txt) (MIME),
[RFC2396](http://www.ietf.org/rfc/rfc2396.txt) (URI),
[XML](http://www.w3.org/TR/REC-xml.html), [SAX](http://www.saxproject.org/),
[SOAP](http://www.w3.org/TR/SOAP), and [JSON](http://www.json.org/).

The syntax of YAML was motivated by Internet Mail (RFC0822) and remains
partially compatible with that standard.
Further, borrowing from MIME (RFC2045), YAML’s top-level production is a
[stream](#stream//) of independent [documents](#document//), ideal for
message-based distributed processing systems.

YAML’s [indentation](#space/indentation/)\-based scoping is similar to Python’s
(without the ambiguities caused by [tabs](#tab//)). [Indented
blocks](#style/block/) facilitate easy inspection of the data’s structure.
YAML’s [literal style](#style/block/literal) leverages this by enabling
formatted text to be cleanly mixed within an [indented](#space/indentation/)
structure without troublesome [escaping](#escaping/in double-quoted scalars/).
YAML also allows the use of traditional [indicator](#indicator//)\-based
scoping similar to JSON’s and Perl’s.
Such [flow content](#style/flow/) can be freely nested inside [indented
blocks](#style/block/).

YAML’s [double-quoted style](#style/flow/double-quoted) uses familiar C-style
[escape sequences](#escaping/in double-quoted scalars/).
This enables ASCII encoding of non-[printable](#printable character//) or 8-bit
(ISO 8859-1) characters such as ["**`\x3B`**"](#ns-esc-8-bit).
Non-[printable](#printable character//) 16-bit Unicode and 32-bit (ISO/IEC
10646) characters are supported with [escape sequences](#escaping/in
double-quoted scalars/) such as ["**`\u003B`**"](#ns-esc-16-bit) and
["**`\U0000003B`**"](#ns-esc-32-bit).

Motivated by HTML’s end-of-line normalization, YAML’s [line folding](#line
folding//) employs an intuitive method of handling [line breaks](#line break//).
A single [line break](#line break//) is [folded](#line folding//) into a single
[space](#space//), while [empty lines](#empty line//) are interpreted as [line
break](#line break//) characters.
This technique allows for paragraphs to be word-wrapped without affecting the
[canonical form](#scalar/canonical form/) of the [scalar content](#scalar//).

YAML’s core type system is based on the requirements of agile languages such as
Perl, Python, and Ruby.
YAML directly supports both [collections](#collection//)
([mappings](#mapping//), [sequences](#sequence//)) and [scalars](#scalar//).
Support for these common types enables programmers to use their language’s
[native data structures](#native data structure//) for YAML manipulation,
instead of requiring a special document object model (DOM).

Like XML’s SOAP, YAML supports [serializing](#serialize//) a graph of [native
data structures](#native data structure//) through an [aliasing](#alias//)
mechanism.
Also like SOAP, YAML provides for [application](#application//)\-defined
[types](#tag//).
This allows YAML to [represent](#represent//) rich data structures required for
modern distributed computing.
YAML provides globally unique [type names](#tag/global/) using a namespace
mechanism inspired by Java’s DNS-based package naming convention and XML’s
URI-based namespaces.
In addition, YAML allows for private [types](#tag/local/) specific to a single
[application](#application//).

YAML was designed to support incremental interfaces that include both input
("**`getNextEvent()`**") and output ("**`sendNextEvent()`**") one-pass
interfaces.
Together, these enable YAML to support the processing of large
[documents](#document//) (e.g. transaction logs) or continuous
[streams](#stream//) (e.g. feeds from a production machine).

## 1.3. Relation to JSON

Both JSON and YAML aim to be human readable data interchange formats.
However, JSON and YAML have different priorities.
JSON’s foremost design goal is simplicity and universality.
Thus, JSON is trivial to generate and parse, at the cost of reduced human
readability.
It also uses a lowest common denominator information model, ensuring any JSON
data can be easily processed by every modern programming environment.

In contrast, YAML’s foremost design goals are human readability and support for
[serializing](#serialize//) arbitrary [native data structures](#native data
structure//).
Thus, YAML allows for extremely readable files, but is more complex to generate
and parse.
In addition, YAML ventures beyond the lowest common denominator data types,
requiring more complex processing when crossing between different programming
environments.

YAML can therefore be viewed as a natural superset of JSON, offering improved
human readability and a more complete information model.
This is also the case in practice; every JSON file is also a valid YAML file.
This makes it easy to migrate from JSON to YAML if/when the additional features
are required.

JSON's [RFC4627](http://www.ietf.org/rfc/rfc4627.txt) requires that
[mappings](#mapping//) [keys](#key//) merely "SHOULD" be [unique](#equality//),
while YAML insists they "MUST" be.
Technically, YAML therefore complies with the JSON spec, choosing to treat
duplicates as an error.
In practice, since JSON is silent on the semantics of such duplicates, the only
portable JSON files are those with unique keys, which are therefore valid YAML
files.

It may be useful to define a intermediate format between YAML and JSON.
Such a format would be trivial to parse (but not very human readable), like
JSON.
At the same time, it would allow for [serializing](#serialize//) arbitrary
[native data structures](#native data structure//), like YAML.
Such a format might also serve as YAML’s "canonical format".
Defining such a "YSON" format (YSON is a Serialized Object Notation) can be
done either by enhancing the JSON specification or by restricting the YAML
specification.
Such a definition is beyond the scope of this specification.

## 1.4. Relation to XML

Newcomers to YAML often search for its correlation to the eXtensible Markup
Language (XML).
Although the two languages may actually compete in several application domains,
there is no direct correlation between them.

YAML is primarily a data serialization language.
XML was designed to be backwards compatible with the Standard Generalized
Markup Language (SGML), which was designed to support structured documentation.
XML therefore had many design constraints placed on it that YAML does not share.
XML is a pioneer in many domains, YAML is the result of lessons learned from
XML and other technologies.

It should be mentioned that there are ongoing efforts to define standard
XML/YAML mappings.
This generally requires that a subset of each language be used.
For more information on using both XML and YAML, please visit
[http://yaml.org/xml](http://yaml.org/xml).

## 1.5. Terminology

This specification uses key words based on
[RFC2119](http://www.ietf.org/rfc/rfc2119.txt) to indicate requirement level.
In particular, the following words are used to describe the actions of a YAML
[processor](#processor//):

May

The word _may_, or the adjective _optional_, mean that conforming YAML
[processors](#processor//) are permitted to, but _need not_ behave as
described.

Should

The word _should_, or the adjective _recommended_, mean that there could be
reasons for a YAML [processor](#processor//) to deviate from the behavior
described, but that such deviation could hurt interoperability and should
therefore be advertised with appropriate notice.

Must

The word _must_, or the term _required_ or _shall_, mean that the behavior
described is an absolute requirement of the specification.

The rest of this document is arranged as follows.
Chapter [2](#Preview "Chapter 2. Preview") provides a short preview of the main
YAML features.
Chapter [3](#Processing "Chapter 3. Processing YAML Information") describes the
YAML information model, and the processes for converting from and to this model
and the YAML text format.
The bulk of the document, chapters [4](#Syntax "Chapter 4. Syntax Conventions")
through [9](#YAML "Chapter 9. YAML Character Stream"), formally define this
text format.
Finally, chapter [10](#Syntax "Chapter 4. Syntax Conventions") recommends basic
YAML schemas.

# Chapter 2. Preview

This section provides a quick glimpse into the expressive power of YAML.
It is not expected that the first-time reader grok all of the examples.
Rather, these selections are used as motivation for the remainder of the
specification.

## 2.1. Collections

YAML’s [block collections](#style/block/collection) use
[indentation](#space/indentation/) for scope and begin each entry on its own
line. [Block sequences](#style/block/sequence) indicate each entry with a dash
and space ( ["**`-`** "](#- block sequence entry//)). [Mappings](#mapping//)
use a colon and space (["**`:`** "](#: mapping value//)) to mark each
[key: value pair](#key: value pair//). [Comments](#comment//) begin with an
octothorpe (also called a "hash", "sharp", "pound", or "number sign" -
["**`#`**"](## comment//)).

**Example 2.1.  Sequence of Scalars  
(ball players)**

```
- Mark McGwire
- Sammy Sosa
- Ken Griffey
```

**Example 2.2.  Mapping Scalars to Scalars  
(player statistics)**

```
hr:  65    # Home runs
avg: 0.278 # Batting average
rbi: 147   # Runs Batted In
```

**Example 2.3.  Mapping Scalars to Sequences  
(ball clubs in each league)**

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

**Example 2.4.  Sequence of Mappings  
(players’ statistics)**

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

YAML also has [flow styles](#style/flow/), using explicit
[indicators](#indicator//) rather than [indentation](#space/indentation/) to
denote scope.
The [flow sequence](#style/flow/sequence) is written as a [comma](#, end flow
entry//) separated list within [square](#[ start flow sequence//) [brackets](#]
end flow sequence//).
In a similar manner, the [flow mapping](#style/flow/mapping) uses [curly](#{
start flow mapping//) [braces](#} end flow mapping//).

**Example 2.5. Sequence of Sequences**

```
- [name        , hr, avg  ]
- [Mark McGwire, 65, 0.278]
- [Sammy Sosa  , 63, 0.288]
```

**Example 2.6. Mapping of Mappings**

```
Mark McGwire: {hr: 65, avg: 0.278}
Sammy Sosa: {
    hr: 63,
    avg: 0.288
  }
```

## 2.2. Structures

YAML uses three dashes (["**`---`**"](#marker/directives end/)) to separate
[directives](#directive//) from [document](#document//) [content](#content//).
This also serves to signal the start of a document if no
[directives](#directive//) are present.
Three dots ( ["**`...`**"](#marker/document end/)) indicate the end of a
document without starting a new one, for use in communication channels.

**Example 2.7.  Two Documents in a Stream  
(each with a leading comment)**

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

**Example 2.8.  Play by Play Feed  
from a Game**

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

Repeated [nodes](#node//) (objects) are first [identified](#alias/identified/)
by an [anchor](#anchor//) (marked with the ampersand - ["**`&`**"](#&
anchor//)), and are then [aliased](#alias//) (referenced with an
asterisk - ["**`*`**"](#* alias//)) thereafter.

**Example 2.9.  Single Document with  
Two Comments**

```
---
hr: # 1998 hr ranking
  - Mark McGwire
  - Sammy Sosa
rbi:
  # 1998 rbi ranking
  - Sammy Sosa
  - Ken Griffey
```

**Example 2.10.  Node for "**`Sammy Sosa`**"  
appears twice in this document**

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

A question mark and space (["**`?`** "](#? mapping key//)) indicate a complex
[mapping](#mapping//) [key](#key//).
Within a [block collection](#style/block/collection), [key: value pairs](#key:
value pair//) can start immediately following the [dash](#- block sequence
entry//), [colon](#: mapping value//), or [question mark](#? mapping key//).

**Example 2.11. Mapping between Sequences**

```
? - Detroit Tigers
  - Chicago cubs
:
  - 2001-07-23

? [ New York Yankees,
    Atlanta Braves ]
: [ 2001-07-02, 2001-08-12,
    2001-08-14 ]
```

**Example 2.12. Compact Nested Mapping**

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

## 2.3. Scalars

[Scalar content](#scalar//) can be written in [block](#style/block/) notation,
using a [literal style](#style/block/literal) (indicated by ["**`|`**"](#|
literal style//)) where all [line breaks](#line break//) are significant.
Alternatively, they can be written with the [folded
style](#style/block/folded) [(denoted by "**`>`**"](#> folded style//)) where
each [line break](#line break//) is [folded](#line folding//) to a
[space](#space//) unless it ends an [empty](#empty line//) or a
[more-indented](#more-indented//) line.

**Example 2.13.  In literals,  
newlines are preserved**

```
# ASCII Art
--- |
  \\//||\\/||
  // ||  ||\_\_
```

**Example 2.14.  In the folded scalars,  
newlines become spaces**

```
--- >
  Mark McGwire's
  year was crippled
  by a knee injury.
```

**Example 2.15.  Folded newlines are preserved  
for "more indented" and blank lines**

```
>
 Sammy Sosa completed another
 fine season with great stats.

   63 Home Runs
   0.288 Batting Average

 What a year!
```

**Example 2.16.  Indentation determines scope**

```
name: Mark McGwire
accomplishment: >
  Mark set a major league
  home run record in 1998.
stats: |
  65 Home Runs
  0.278 Batting Average
```

YAML’s [flow scalars](#style/flow/scalar) include the [plain
style](#style/flow/plain) (most examples thus far) and two quoted styles.
The [double-quoted style](#style/flow/double-quoted) provides [escape
sequences](#escaping/in double-quoted scalars/).
The [single-quoted style](#style/flow/) is useful when [escaping](#escaping/in
double-quoted scalars/) is not needed.
All [flow scalars](#style/flow/scalar) can span multiple lines; [line
breaks](#line break//) are always [folded](#line folding//).

**Example 2.17. Quoted Scalars**

```
unicode: "Sosa did fine.\\u263A"
control: "\\b1998\\t1999\\t2000\\n"
hex esc: "\\x0d\\x0a is \\r\\n"

single: '"Howdy!" he cried.'
quoted: ' # Not a ''comment''.'
tie-fighter: '|\\-*-/|'
```

**Example 2.18. Multi-line Flow Scalars**

```
plain:
  This unquoted scalar
  spans many lines.

quoted: "So does this
  quoted scalar.\\n"
```

## 2.4. Tags

In YAML, [untagged nodes](#tag/non-specific/) are given a type depending on the
[application](#application//).
The examples in this specification generally use the
[**`seq`**](#tag/repository/seq), [**`map`**](#tag/repository/map) and
[**`str`**](#tag/repository/str) types from the [fail safe
schema](#schema/failsafe/).
A few examples also use the [**`int`**](#tag/repository/int),
[**`float`**](#tag/repository/float), and [**`null`**](#tag/repository/null)
types from the [JSON schema](#schema/JSON/).
The [repository](#tag/repository/) includes additional types such as
[**`binary`**](http://yaml.org/type/binary.html),
[**`omap`**](http://yaml.org/type/omap.html),
[**`set`**](http://yaml.org/type/set.html) and others.

**Example 2.19. Integers**

```
canonical: 12345
decimal: +12345
octal: 0o14
hexadecimal: 0xC
```

**Example 2.20. Floating Point**

```
canonical: 1.23015e+3
exponential: 12.3015e+02
fixed: 1230.15
negative infinity: -.inf
not a number: .NaN
```

**Example 2.21. Miscellaneous**

```
null:
booleans: [ true, false ]
string: '012345'
```

**Example 2.22. Timestamps**

```
canonical: 2001-12-15T02:59:43.1Z
iso8601: 2001-12-14t21:59:43.10-05:00
spaced: 2001-12-14 21:59:43.10 -5
date: 2002-12-14
```

Explicit typing is denoted with a [tag](#tag//) using the exclamation point
(["**`!`**"](#! tag indicator//)) symbol. [Global tags](#tag/global/) are URIs
and may be specified in a [tag shorthand](#tag/shorthand/) notation using a
[handle](#tag/handle/). [Application](#application//)\-specific [local
tags](#tag/local/) may also be used.

**Example 2.23. Various Explicit Tags**

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

**Example 2.24. Global Tags**

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

**Example 2.25. Unordered Sets**

```
# Sets are represented as a
# Mapping where each key is
# associated with a null value
--- !!set
? Mark McGwire
? Sammy Sosa
? Ken Griff
```

**Example 2.26. Ordered Mappings**

```
# Ordered maps are represented as
# A sequence of mappings, with
# each mapping having one key
--- !!omap
- Mark McGwire: 65
- Sammy Sosa: 63
- Ken Griffy: 58
```

## 2.5. Full Length Example

Below are two full-length examples of YAML.
On the left is a sample invoice; on the right is a sample log file.

**Example 2.27. Invoice**

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

**Example 2.28. Log File**

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
      x = MoreObject("345\\n")
  - file: MoreClass.py
    line: 58
    code: |-
      foo = bar
```

# Chapter 3. Processing YAML Information

YAML is both a text format and a method for [presenting](#present//) any
[native data structure](#native data structure//) in this format.
Therefore, this specification defines two concepts: a class of data objects
called YAML [representations](#representation//), and a syntax for
[presenting](#present//) YAML [representations](#representation//) as a series
of characters, called a YAML [stream](#stream//).
A YAML _processor_ is a tool for converting information between these
complementary views.
It is assumed that a YAML processor does its work on behalf of another module,
called an _application_.
This chapter describes the information structures a YAML processor must provide
to or obtain from the application.

YAML information is used in two ways: for machine processing, and for human
consumption.
The challenge of reconciling these two perspectives is best done in three
distinct translation stages: [representation](#representation//),
[serialization](#serialization//), and [presentation](#presentation//).
[Representation](#representation//) addresses how YAML views [native data
structures](#native data structure//) to achieve portability between
programming environments. [Serialization](#serialization//) concerns itself
with turning a YAML [representation](#representation//) into a serial form,
that is, a form with sequential access constraints.
[Presentation](#presentation//) deals with the formatting of a YAML
[serialization](#serialization//) as a series of characters in a human-friendly
manner.

## 3.1. Processes

Translating between [native data structures](#native data structure//) and a
character [stream](#stream//) is done in several logically distinct stages,
each with a well defined input and output data model, as shown in the following
diagram:

**Figure 3.1. Processing Overview**

![Processing Overview](overview2.png)

  
A YAML processor need not expose the [serialization](#serialization//) or
[representation](#representation//) stages.
It may translate directly between [native data structures](#native data
structure//) and a character [stream](#stream//) ([dump](#dump//) and
[load](#load//) in the diagram above).
However, such a direct translation should take place so that the [native data
structures](#native data structure//) are [constructed](#construct//) only from
information available in the [representation](#representation//).
In particular, [mapping key order](#key/order/), [comments](#comment//), and
[tag handles](#tag/handle/) should not be referenced during
[composition](#compose//).

### 3.1.1. Dump

_Dumping_ native data structures to a character [stream](#stream//) is done
using the following three stages:

Representing Native Data Structures

YAML _represents_ any _native data structure_ using three [node
kinds](#kind//): [sequence](#sequence//) - an ordered series of entries;
[mapping](#mapping//) - an unordered association of [unique](#equality//)
[keys](#key//) to [values](#value//); and [scalar](#scalar//) - any datum with
opaque structure presentable as a series of Unicode characters.
Combined, these primitives generate directed graph structures.
These primitives were chosen because they are both powerful and familiar: the
[sequence](#sequence//) corresponds to a Perl array and a Python list, the
[mapping](#mapping//) corresponds to a Perl hash table and a Python dictionary.
The [scalar](#scalar//) represents strings, integers, dates, and other atomic
data types.

Each YAML [node](#node//) requires, in addition to its [kind](#kind//) and
[content](#content//), a [tag](#tag//) specifying its data type.
Type specifiers are either [global](#tag/global/) URIs, or are
[local](#tag/local/) in scope to a single [application](#application//).
For example, an integer is represented in YAML with a [scalar](#scalar//) plus
the [global tag](#tag/global/) "**`tag:yaml.org,2002:int`**".
Similarly, an invoice object, particular to a given organization, could be
represented as a [mapping](#mapping//) together with the [local
tag](#tag/local/) "**`!invoice`**".
This simple model can represent any data structure independent of programming
language.

Serializing the Representation Graph

For sequential access mediums, such as an event callback API, a YAML
[representation](#representation//) must be _serialized_ to an ordered tree.
Since in a YAML [representation](#representation//), [mapping keys](#key//) are
unordered and [nodes](#node//) may be referenced more than once (have more than
one incoming "arrow"), the serialization process is required to impose an
[ordering](#key/order/) on the [mapping keys](#key//) and to replace the second
and subsequent references to a given [node](#node//) with place holders called
[aliases](#alias//).
YAML does not specify how these _serialization details_ are chosen.
It is up to the YAML [processor](#processor//) to come up with human-friendly
[key order](#key/order/) and [anchor](#anchor//) names, possibly with the help
of the [application](#application//).
The result of this process, a YAML [serialization tree](#serialization//), can
then be traversed to produce a series of event calls for one-pass processing of
YAML data.

Presenting the Serialization Tree

The final output process is _presenting_ the YAML
[serializations](#serialization//) as a character [stream](#stream//) in a
human-friendly manner.
To maximize human readability, YAML offers a rich set of stylistic options
which go far beyond the minimal functional needs of simple data storage.
Therefore the YAML [processor](#processor//) is required to introduce various
_presentation details_ when creating the [stream](#stream//), such as the
choice of [node styles](#style//), how to [format scalar
content](#scalar/content format/), the amount of
[indentation](#space/indentation/), which [tag handles](#tag/handle/) to use,
the [node tags](#tag//) to leave [unspecified](#tag/non-specific/), the set of
[directives](#directive//) to provide and possibly even what
[comments](#comment//) to add.
While some of this can be done with the help of the
[application](#application//), in general this process should be guided by the
preferences of the user.

### 3.1.2. Load

_Loading_ [native data structures](#native data structure//) from a character
[stream](#stream//) is done using the following three stages:

Parsing the Presentation Stream

_Parsing_ is the inverse process of [presentation](#present//), it takes a
[stream](#stream//) of characters and produces a series of events.
Parsing discards all the [details](#presentation/detail/) introduced in the
[presentation](#present//) process, reporting only the
[serialization](#serialization//) events.
Parsing can fail due to [ill-formed](#stream/ill-formed/) input.

Composing the Representation Graph

_Composing_ takes a series of [serialization](#serialization//) events and
produces a [representation graph](#representation//).
Composing discards all the [details](#serialization/detail/) introduced in the
[serialization](#serialize//) process, producing only the [representation
graph](#representation//).
Composing can fail due to any of several reasons, detailed
[below](#load/failure point/).

Constructing Native Data Structures

The final input process is _constructing_ [native data structures](#native data
structure//) from the YAML [representation](#representation//).
Construction must be based only on the information available in the
[representation](#representation//), and not on additional
[serialization](#serialization//) or [presentation
details](#presentation/detail/) such as [comments](#comment//),
[directives](#directive//), [mapping key order](#key/order/), [node
styles](#style//), [scalar content format](#scalar/content format/),
[indentation](#space/indentation/) levels etc.
Construction can fail due to the [unavailability](#tag/unavailable/) of the
required [native data types](#native data structure//).

## 3.2. Information Models

This section specifies the formal details of the results of the above processes.
To maximize data portability between programming languages and implementations,
users of YAML should be mindful of the distinction between
[serialization](#serialization//) or [presentation](#presentation//) properties
and those which are part of the YAML [representation](#representation//).
Thus, while imposing a [order](#key/order/) on [mapping keys](#key//) is
necessary for flattening YAML [representations](#representation//) to a
sequential access medium, this [serialization detail](#serialization/detail/)
must not be used to convey [application](#application//) level information.
In a similar manner, while [indentation](#space/indentation/) technique and a
choice of a [node style](#style//) are needed for the human readability, these
[presentation details](#presentation/detail/) are neither part of the YAML
[serialization](#serialization//) nor the YAML
[representation](#representation//).
By carefully separating properties needed for [serialization](#serialization//)
and [presentation](#presentation//), YAML [representations](#representation//)
of [application](#application//) information will be consistent and portable
between various programming environments.

The following diagram summarizes the three _information models_.
Full arrows denote composition, hollow arrows denote inheritance, "**`1`**" and
"**`*`**" denote "one" and "many" relationships.
A single "**`+`**" denotes [serialization](#serialization//) details, a double
"**`++`**" denotes [presentation](#presentation//) details.

**Figure 3.2. Information Models**

![Information Models](model2.png)

  

### 3.2.1. Representation Graph

YAML’s _representation_ of [native data structure](#native data structure//) is
a rooted, connected, directed graph of [tagged](#tag//) [nodes](#node//).
By "directed graph" we mean a set of [nodes](#node//) and directed edges
("arrows"), where each edge connects one [node](#node//) to another (see [a
formal definition](http://www.nist.gov/dads/HTML/directedGraph.html)).
All the [nodes](#node//) must be reachable from the _root node_ via such edges.
Note that the YAML graph may include cycles, and a [node](#node//) may have
more than one incoming edge.

[Nodes](#node//) that are defined in terms of other [nodes](#node//) are
[collections](#collection//); [nodes](#node//) that are independent of any
other [nodes](#node//) are [scalars](#scalar//).
YAML supports two [kinds](#kind//) of [collection nodes](#collection//):
[sequences](#sequence//) and [mappings](#mapping//). [Mapping
nodes](#mapping//) are somewhat tricky because their [keys](#key//) are
unordered and must be [unique](#equality//).

**Figure 3.3. Representation Model**

![Representation Model](represent2.png)

  

#### 3.2.1.1. Nodes

A YAML _node_ [represents](#representation//) a single [native data
structure](#native data structure//).
Such nodes have _content_ of one of three _kinds_: scalar, sequence, or mapping.
In addition, each node has a [tag](#tag//) which serves to restrict the set of
possible values the content can have.

Scalar

The content of a _scalar_ node is an opaque datum that can be
[presented](#present//) as a series of zero or more Unicode characters.

Sequence

The content of a _sequence_ node is an ordered series of zero or more nodes.
In particular, a sequence may contain the same node more than once.
It could even contain itself (directly or indirectly).

Mapping

The content of a _mapping_ node is an unordered set of _key:_ _value_ node
_pairs_, with the restriction that each of the keys is [unique](#equality//).
YAML places no further restrictions on the nodes.
In particular, keys may be arbitrary nodes, the same node may be used as the
value of several key: value pairs, and a mapping could even contain itself as a
key or a value (directly or indirectly).

When appropriate, it is convenient to consider sequences and mappings together,
as _collections_.
In this view, sequences are treated as mappings with integer keys starting at
zero.
Having a unified collections view for sequences and mappings is helpful both
for theoretical analysis and for creating practical YAML tools and APIs.
This strategy is also used by the Javascript programming language.

#### 3.2.1.2. Tags

YAML [represents](#represent//) type information of [native data
structures](#native data structure//) with a simple identifier, called a _tag_.
_Global tags_ are [URIs](http://www.ietf.org/rfc/rfc2396.txt) and hence
globally unique across all [applications](#application//).
The "**`tag:`**" [URI scheme](http://www.faqs.org/rfcs/rfc4151.html) is
recommended for all global YAML tags.
In contrast, _local tags_ are specific to a single
[application](#application//).
Local tags start with _"**`!`**"_, are not URIs and are not expected to be
globally unique.
YAML provides a ["**`TAG`**" directive](#directive/TAG/) to make tag notation
less verbose; it also offers easy migration from local to global tags.
To ensure this, local tags are restricted to the URI character set and use URI
character [escaping](#% escaping in URI//).

YAML does not mandate any special relationship between different tags that
begin with the same substring.
Tags ending with URI fragments (containing "**`#`**") are no exception; tags
that share the same base URI but differ in their fragment part are considered
to be different, independent tags.
By convention, fragments are used to identify different "variants" of a tag,
while "**`/`**" is used to define nested tag "namespace" hierarchies.
However, this is merely a convention, and each tag may employ its own rules.
For example, Perl tags may use "**`::`**" to express namespace hierarchies,
Java tags may use "**`.`**", etc.

YAML tags are used to associate meta information with each [node](#node//).
In particular, each tag must specify the expected [node kind](#kind//)
([scalar](#scalar//), [sequence](#sequence//), or [mapping](#mapping//)).
[Scalar](#scalar//) tags must also provide a mechanism for converting
[formatted content](#scalar/content format/) to a [canonical
form](#scalar/canonical form/) for supporting [equality](#equality//) testing.
Furthermore, a tag may provide additional information such as the set of
allowed [content](#content//) values for validation, a mechanism for [tag
resolution](#tag/resolution/), or any other data that is applicable to all of
the tag’s [nodes](#node//).

#### 3.2.1.3. Node Comparison

Equality

Since YAML [mappings](#mapping//) require [key](#key//) uniqueness,
[representations](#representation//) must include a mechanism for testing the
equality of [nodes](#node//).
In general, it is impossible to ensure uniqueness for
[presentations](#presentation//), for the following reasons:

* YAML allows various ways to [format scalar content](#scalar/content format/).
For example, the integer eleven can be written as "**`0o13`**" (octal) or
"**`0xB`**" (hexadecimal).
If both notations are used as [keys](#key//) in the same [mapping](#mapping//),
only a YAML [processor](#processor//) which recognizes integer
[formats](#scalar/content format/) would correctly flag the duplicate
[key](#key//) as an error.
  
* The semantics of the [representation](#representation//) may require that
values with different [tags](#tag//) be considered equal.
For example, the integer one and the float one are considered equal.
If both are used as [keys](#key//) in the same [mapping](#mapping//), only a
YAML [processor](#processor//) which recognizes integer and float
[representations](#representation//) would correctly flag the duplicate
[key](#key//) as an error.
  

YAML therefore requires that each [tag](#tag//) must specify a mechanism for
testing any of its values for _equality_ with any other value (including values
of any different [tag](#tag//)).
This is often implemented directly by the [native data structure](#native data
structure//) instead of the YAML [processor](#processor//).
That is, duplicate [keys](#key//) are often flagged as an error during the
[construction](#construct//) processing stage.

In order to ensure greater compatibility and clarity, YAML allows the
[processor](#processor//) to flag obvious duplicate [keys](#key//) based on the
[presentation](#presentation//).
Specifically, two [scalar](#scalar//) [keys](#key//) in the same
[mapping](#mapping//), with the same [tag](#tag//) and the same
[content](#content//), may be flagged as an error as soon as the
[parsing](#parse//) stage.
Note that this tests also works for [non-specific tags](#tag/non-specific/) due
to the way that [tag resolution](#tag/resolution/) is defined.
This allows a human reader to reasonably identify **`{ a: 1, a: 2 }`** as an
error.
Such constructs are silently accepted by many languages, but have no well
defined meaning, and are therefore disallowed in YAML to avoid surprising
behavior.

Canonical Form

YAML also requires that every [scalar](#scalar//) [tag](#tag//) must specify a
mechanism for producing the _canonical form_ of any [formatted
content](#scalar/content format/).
This form is a Unicode character string which also [presents](#present//) the
same [content](#scalar/content format/).
While this can be used for equality testing (as long as the compared values
have the same [tag](#tag//)), it has other uses, such as the production of
digital signatures.

Identity

Two [nodes](#node//) are _identical_ only when they [represent](#represent//)
the same [native data structure](#native data structure//).
Typically, this corresponds to a single memory address.
Identity should not be confused with equality; two equal [nodes](#node//) need
not have the same identity.
A YAML [processor](#processor//) may treat equal [scalars](#scalar//) as if
they were identical.
In contrast, the separate identity of two distinct but equal
[collections](#collection//) must be preserved.

A common programming idiom is creating an empty object to obtain a value that
is only equal to itself (for example, in order to generate a dynamic
"enumerated type").
The proper way to [represent](#representation//) this in YAML would be
**`!object {}`**, where the **`!object`** [tag](#tag//) defines two objects to
be equal only if they are identical.
The alternative [scalar](#scalar//) [representation](#representation//)
**`!object ''`** will not work as expected, as the YAML
[processor](#processor//) is not required to preserve the identity of such
objects.

### 3.2.2. Serialization Tree

To express a YAML [representation](#representation//) using a serial API, it is
necessary to impose an [order](#key/order/) on [mapping keys](#key//) and
employ [alias nodes](#alias//) to indicate a subsequent occurrence of a
previously encountered [node](#node//).
The result of this process is a _serialization tree_, where each
[node](#node//) has an ordered set of children.
This tree can be traversed for a serial event-based API.
[Construction](#construct//) of [native data structures](#native data
structure//) from the serial interface should not use [key order](#key/order/)
or [anchor names](#anchor//) for the preservation of
[application](#application//) data.

**Figure 3.4. Serialization Model**

![Serialization Model](serialize2.png)

  

#### 3.2.2.1. Keys Order

In the [representation](#representation//) model, [mapping keys](#key//) do not
have an order.
To [serialize](#serialize//) a [mapping](#mapping//), it is necessary to impose
an _ordering_ on its [keys](#key//).
This order is a [serialization detail](#serialization/detail/) and should not
be used when [composing](#compose//) the [representation
graph](#representation//) (and hence for the preservation of
[application](#application//) data).
In every case where [node](#node//) order is significant, a
[sequence](#sequence//) must be used.
For example, an ordered [mapping](#mapping//) can be
[represented](#represent//) as a [sequence](#sequence//) of
[mappings](#mapping//), where each [mapping](#mapping//) is a single
[key: value pair](#key: value pair//).
YAML provides convenient [compact notation](#style/single key:value pair
mapping/) for this case.

#### 3.2.2.2. Anchors and Aliases

In the [representation graph](#representation//), a [node](#node//) may appear
in more than one [collection](#collection//).
When [serializing](#serialize//) such data, the first occurrence of the
[node](#node//) is _identified_ by an _anchor_.
Each subsequent occurrence is [serialized](#serialize//) as an [alias
node](#alias//) which refers back to this anchor.
Otherwise, anchor names are a [serialization detail](#serialization/detail/)
and are discarded once [composing](#compose//) is completed.
When [composing](#compose//) a [representation graph](#representation//) from
[serialized](#serialize//) events, an alias node refers to the most recent
[node](#node//) in the [serialization](#serialization//) having the specified
anchor.
Therefore, anchors need not be unique within a
[serialization](#serialization//).
In addition, an anchor need not have an alias node referring to it.
It is therefore possible to provide an anchor for all [nodes](#node//) in
[serialization](#serialization//).

### 3.2.3. Presentation Stream

A YAML _presentation_ is a [stream](#stream//) of Unicode characters making use
of [styles](#style//), [scalar content formats](#scalar/content format/),
[comments](#comment//), [directives](#directive//) and other [presentation
details](#presentation/detail/) to [present](#present//) a YAML
[serialization](#serialization//) in a human readable way.
Although a YAML [processor](#processor//) may provide these
[details](#presentation/detail/) when [parsing](#parse//), they should not be
reflected in the resulting [serialization](#serialization//).
YAML allows several [serialization trees](#serialization//) to be contained in
the same YAML character stream, as a series of [documents](#document//)
separated by [markers](#marker//).
Documents appearing in the same stream are independent; that is, a
[node](#node//) must not appear in more than one [serialization
tree](#serialization//) or [representation graph](#representation//).

**Figure 3.5. Presentation Model**

![Presentation Model](present2.png)

  

#### 3.2.3.1. Node Styles

Each [node](#node//) is presented in some _style_, depending on its
[kind](#kind//).
The node style is a [presentation detail](#presentation/detail/) and is not
reflected in the [serialization tree](#serialization//) or [representation
graph](#representation//).
There are two groups of styles. [Block styles](#style/block/) use
[indentation](#space/indentation/) to denote structure; in contrast, [flow
styles](#style/flow/) rely on explicit [indicators](#indicator//).

YAML provides a rich set of _scalar styles_. [Block
scalar](#style/block/scalar) styles include the [literal
style](#style/block/literal) and the [folded style](#style/block/folded). [Flow
scalar](#style/flow/scalar) styles include the [plain style](#style/flow/plain)
and two quoted styles, the [single-quoted style](#style/flow/single-quoted) and
the [double-quoted style](#style/flow/double-quoted).
These styles offer a range of trade-offs between expressive power and
readability.

Normally, [block sequences](#style/block/sequence) and
[mappings](#style/block/mapping) begin on the next line.
In some cases, YAML also allows nested [block](#style/block/)
[collections](#collection//) to start in-line for a more [compact
notation](#style/compact block collection/).
In addition, YAML provides a [compact notation](#style/single key:value pair
mapping/) for [flow mappings](#style/flow/mapping) with a single [key: value
pair](#key: value pair//), nested inside a [flow
sequence](#style/flow/sequence).
These allow for a natural "ordered mapping" notation.

**Figure 3.6. Kind/Style Combinations**

![Kind/Style Combinations](styles2.png)

  

#### 3.2.3.2. Scalar Formats

YAML allows [scalars](#scalar//) to be [presented](#present//) in several
_formats_.
For example, the integer "**`11`**" might also be written as "**`0xB`**".
[Tags](#tag//) must specify a mechanism for converting the formatted content to
a [canonical form](#scalar/canonical form/) for use in [equality](#equality//)
testing.
Like [node style](#style//), the format is a [presentation
detail](#presentation/detail/) and is not reflected in the [serialization
tree](#serialization//) and [representation graph](#representation//).

#### 3.2.3.3. Comments

[Comments](#comment//) are a [presentation detail](#presentation/detail/) and
must not have any effect on the [serialization tree](#serialization//) or
[representation graph](#representation//).
In particular, comments are not associated with a particular [node](#node//).
The usual purpose of a comment is to communicate between the human maintainers
of a file.
A typical example is comments in a configuration file.
Comments must not appear inside [scalars](#scalar//), but may be interleaved
with such [scalars](#scalar//) inside [collections](#collection//).

#### 3.2.3.4. Directives

Each [document](#document//) may be associated with a set of
[directives](#directive//).
A directive has a name and an optional sequence of parameters.
Directives are instructions to the YAML [processor](#processor//), and like all
other [presentation details](#presentation/detail/) are not reflected in the
YAML [serialization tree](#serialization//) or [representation
graph](#representation//).
This version of YAML defines two directives, ["**`YAML`**"](#directive/YAML/)
and ["**`TAG`**"](#directive/TAG/).
All other directives are [reserved](#directive/reserved/) for future versions
of YAML.

## 3.3. Loading Failure Points

The process of [loading](#load//) [native data structures](#native data
structure//) from a YAML [stream](#stream//) has several potential _failure
points_.
The character [stream](#stream//) may be [ill-formed](#stream/ill-formed/),
[aliases](#alias//) may be [unidentified](#alias/unidentified/), [unspecified
tags](#tag/non-specific/) may be [unresolvable](#tag/unresolved/),
[tags](#tag//) may be [unrecognized](#tag/unrecognized/), the
[content](#content//) may be [invalid](#invalid content//), and a native type
may be [unavailable](#tag/unavailable/).
Each of these failures results with an incomplete loading.

A _partial representation_ need not [resolve](#tag/resolution/) the
[tag](#tag//) of each [node](#node//), and the [canonical
form](#scalar/canonical form/) of [formatted scalar content](#scalar/content
format/) need not be available.
This weaker representation is useful for cases of incomplete knowledge of the
types used in the [document](#document//).
In contrast, a _complete representation_ specifies the [tag](#tag//) of each
[node](#node//), and provides the [canonical form](#scalar/canonical form/) of
[formatted scalar content](#scalar/content format/), allowing for
[equality](#equality//) testing.
A complete representation is required in order to [construct](#construct//)
[native data structures](#native data structure//).

**Figure 3.7. Loading Failure Points**

![Loading Failure Points](validity2.png)

  

### 3.3.1. Well-Formed Streams and Identified Aliases

A [well-formed](#stream/well-formed/) character [stream](#stream//) must match
the BNF productions specified in the following chapters.
Successful loading also requires that each [alias](#alias//) shall refer to a
previous [node](#node//) [identified](#alias/identified/) by the
[anchor](#anchor//).
A YAML [processor](#processor//) should reject _ill-formed streams_ and
_unidentified aliases_.
A YAML [processor](#processor//) may recover from syntax errors, possibly by
ignoring certain parts of the input, but it must provide a mechanism for
reporting such errors.

### 3.3.2. Resolved Tags

Typically, most [tags](#tag//) are not explicitly specified in the character
[stream](#stream//).
During [parsing](#parse//), [nodes](#node//) lacking an explicit [tag](#tag//)
are given a _non-specific tag_: _"**`!`**"_ for non-[plain
scalars](#style/flow/plain), and _"**`?`**"_ for all other [nodes](#node//).
[Composing](#compose//) a [complete representation](#representation/complete/)
requires each such non-specific tag to be _resolved_ to a _specific tag_, be it
a [global tag](#tag/global/) or a [local tag](#tag/local/).

Resolving the [tag](#tag//) of a [node](#node//) must only depend on the
following three parameters: (1) the non-specific tag of the [node](#node//),
(2) the path leading from the [root](#node/root/) to the [node](#node//), and
(3) the [content](#content//) (and hence the [kind](#kind//)) of the
[node](#node//).
When a [node](#node//) has more than one occurrence (using
[aliases](#alias//)), tag resolution must depend only on the path to the first
([anchored](#anchor//)) occurrence of the [node](#node//).

Note that resolution must not consider [presentation
details](#presentation/detail/) such as [comments](#comment//),
[indentation](#space/indentation/) and [node style](#style//).
Also, resolution must not consider the [content](#content//) of any other
[node](#node//), except for the [content](#content//) of the [key
nodes](#key//) directly along the path leading from the [root](#node/root/) to
the resolved [node](#node//).
Finally, resolution must not consider the [content](#content//) of a sibling
[node](#node//) in a [collection](#collection//), or the [content](#content//)
of the [value node](#value//) associated with a [key node](#key//) being
resolved.

These rules ensure that tag resolution can be performed as soon as a
[node](#node//) is first encountered in the [stream](#stream//), typically
before its [content](#content//) is [parsed](#parse//).
Also, tag resolution only requires referring to a relatively small number of
previously parsed [nodes](#node//).
Thus, in most cases, tag resolution in one-pass [processors](#processor//) is
both possible and practical.

YAML [processors](#processor//) should resolve [nodes](#node//) having the
"**`!`**" non-specific tag as "**`tag:yaml.org,2002:seq`**",
"**`tag:yaml.org,2002:map`**" or "**`tag:yaml.org,2002:str`**" depending on
their [kind](#kind//).
This _tag resolution convention_ allows the author of a YAML character
[stream](#stream//) to effectively "disable" the tag resolution process.
By explicitly specifying a "**`!`**" non-specific [tag
property](#tag/property/), the [node](#node//) would then be resolved to a
"vanilla" [sequence](#sequence//), [mapping](#mapping//), or string, according
to its [kind](#kind//).

[Application](#application//) specific tag resolution rules should be
restricted to resolving the "**`?`**" non-specific tag, most commonly to
resolving [plain scalars](#style/flow/plain).
These may be matched against a set of regular expressions to provide automatic
resolution of integers, floats, timestamps, and similar types.
An [application](#application//) may also match the [content](#content//) of
[mapping nodes](#mapping//) against sets of expected [keys](#key//) to
automatically resolve points, complex numbers, and similar types.
Resolved [sequence node](#sequence//) types such as the "ordered mapping" are
also possible.

That said, tag resolution is specific to the [application](#application//).
YAML [processors](#processor//) should therefore provide a mechanism allowing
the [application](#application//) to override and expand these default tag
resolution rules.

If a [document](#document//) contains _unresolved tags_, the YAML
[processor](#processor//) is unable to [compose](#compose//) a [complete
representation](#representation/complete/) graph.
In such a case, the YAML [processor](#processor//) may [compose](#compose//) a
[partial representation](#representation/partial/), based on each [node’s
kind](#kind//) and allowing for non-specific tags.

### 3.3.3. Recognized and Valid Tags

To be _valid_, a [node](#node//) must have a [tag](#tag//) which is
_recognized_ by the YAML [processor](#processor//) and its
[content](#content//) must satisfy the constraints imposed by this
[tag](#tag//).
If a [document](#document//) contains a [scalar node](#scalar//) with an
_unrecognized tag_ or _invalid content_, only a [partial
representation](#representation/partial/) may be [composed](#compose//).
In contrast, a YAML [processor](#processor//) can always [compose](#compose//)
a [complete representation](#representation/complete/) for an unrecognized or
an invalid [collection](#collection//), since [collection](#collection//)
[equality](#equality//) does not depend upon knowledge of the
[collection’s](#collection//) data type.
However, such a [complete representation](#representation/complete/) cannot be
used to [construct](#construct//) a [native data structure](#native data
structure//).

### 3.3.4. Available Tags

In a given processing environment, there need not be an _available_ native type
corresponding to a given [tag](#tag//).
If a [node’s tag](#tag//) is _unavailable_, a YAML [processor](#processor//)
will not be able to [construct](#construct//) a [native data structure](#native
data structure//) for it.
In this case, a [complete representation](#representation/complete/) may still
be [composed](#compose//), and an [application](#application//) may wish to use
this [representation](#representation//) directly.

# Chapter 4. Syntax Conventions

The following chapters formally define the syntax of YAML character
[streams](#stream//), using parameterized BNF productions.
Each BNF production is both named and numbered for easy reference.
Whenever possible, basic structures are specified before the more complex
structures using them in a "bottom up" fashion.

The order of alternatives inside a production is significant.
Subsequent alternatives are only considered when previous ones fails.
See for example the [**`b-break`**](#b-break) production.
In addition, production matching is expected to be greedy.
Optional (**`?`**), zero-or-more (**`*`**) and one-or-more (**`+`**) patterns
are always expected to match as much of the input as possible.

The productions are accompanied by examples, which are given side-by-side next
to equivalent YAML text in an explanatory format.
This format uses only [flow collections](#style/flow/collection),
[double-quoted scalars](#style/flow/double-quoted), and explicit [tags](#tag//)
for each [node](#node//).

A reference implementation using the productions is available as the
[YamlReference](http://hackage.haskell.org/cgi-bin/hackage-scripts/package/Yaml
Reference) Haskell package.
This reference implementation is also available as an interactive web
application at [http://dev.yaml.org/ypaste](http://dev.yaml.org/ypaste).

## 4.1. Production Parameters

YAML’s syntax is designed for maximal human readability.
This requires [parsing](#parse//) to depend on the surrounding text.
For notational compactness, this dependency is expressed using parameterized
BNF productions.

This context sensitivity is the cause of most of the complexity of the YAML
syntax definition.
It is further complicated by struggling with the human tendency to look ahead
when interpreting text.
These complications are of course the source of most of YAML’s power to
[present](#presentation//) data in a very human readable way.

Productions use any of the following parameters:

Indentation: `n` or `m`

Many productions use an explicit [indentation](#space/indentation/) level
parameter.
This is less elegant than Python’s "indent" and "undent" conceptual tokens.
However it is required to formally express YAML’s indentation rules.

Context: `c`

This parameter allows productions to tweak their behavior according to their
surrounding.
YAML supports two groups of _contexts_, distinguishing between [block
styles](#style/block/) and [flow styles](#style/flow/).

In [block styles](#style/block/), [indentation](#space/indentation/) is used to
delineate structure.
To capture human perception of [indentation](#space/indentation/) the rules
require special treatment of the ["**`-`**"](#- block sequence entry//)
character, used in [block sequences](#style/block/sequence).
Hence in some cases productions need to behave differently inside [block
sequences](#style/block/sequence) (_block-in context_) and outside them
(_block-out context_).

In [flow styles](#style/flow/), explicit [indicators](#indicator//) are used to
delineate structure.
These styles can be viewed as the natural extension of JSON to cover
[tagged](#tag//), [single-quoted](#style/flow/single-quoted) and [plain
scalars](#style/flow/plain).
Since the latter have no delineating [indicators](#indicator//), they are
subject to some restrictions to avoid ambiguities.
These restrictions depend on where they appear: as implicit keys directly
inside a [block mapping](#style/block/mapping) (_block-key_); as implicit keys
inside a [flow mapping](#style/flow/mapping) (_flow-key_); as values inside a
[flow collection](#style/flow/collection) (_flow-in_); or as values outside one
(_flow-out_).

(Block) Chomping: `t`

Block scalars offer three possible mechanisms for [chomping](#chomping//) any
trailing [line breaks](#line break//): [strip](#chomping/strip/),
[clip](#chomping/clip/) and [keep](#chomping/keep/).
Unlike the previous parameters, this only controls interpretation; the [line
breaks](#line break//) are valid in all cases.

## 4.2. Production Naming Conventions

To make it easier to follow production combinations, production names use a
Hungarian-style naming convention.
Each production is given a prefix based on the type of characters it begins and
ends with.

**`e-`**

A production matching no characters.

**`c-`**

A production starting and ending with a special character.

**`b-`**

A production matching a single [line break](#line break//).

**`nb-`**

A production starting and ending with a non-[break](#line break//) character.

**`s-`**

A production starting and ending with a [white space](#space/white/) character.

**`ns-`**

A production starting and ending with a non-[space](#space/white/) character.

**`l-`**

A production matching complete line(s).

`X`**`-`**`Y`**`-`**

A production starting with an `X`**`-`** character and ending with a `Y`**`-`**
character, where `X`**`-`** and `Y`**`-`** are any of the above prefixes.

`X`**`+`**, `X`**`-`**`Y`**`+`**

A production as above, with the additional property that the matched content
[indentation](#space/indentation/) level is greater than the specified `n`
parameter.

# Chapter 5. Characters

## 5.1. Character Set

To ensure readability, YAML [streams](#stream//) use only the _printable_
subset of the Unicode character set.
The allowed character range explicitly excludes the C0 control block
**`#x0-#x1F`** (except for TAB **`#x9`**, LF **`#xA`**, and CR **`#xD`** which
are allowed), DEL **`#x7F`**, the C1 control block **`#x80-#x9F`** (except for
NEL **`#x85`** which is allowed), the surrogate block **`#xD800-#xDFFF`**,
**`#xFFFE`**, and **`#xFFFF`**.

On input, a YAML [processor](#processor//) must accept all Unicode characters
except those explicitly excluded above.

On output, a YAML [processor](#processor//) must only produce acceptable
characters.
Any excluded characters must be [presented](#present//) using
[escape](#escaping/in double-quoted scalars/) sequences.
In addition, any allowed characters known to be non-printable should also be
[escaped](#escaping/in double-quoted scalars/).
This isn’t mandatory since a full implementation would require extensive
character property tables.

```
[1] c-printable ::=
    #x9 | #xA | #xD | [#x20-#x7E]          /* 8 bit */
  | #x85 | [#xA0-#xD7FF] | [#xE000-#xFFFD] /* 16 bit */
  | [#x10000-#x10FFFF]                     /* 32 bit */
```

To ensure [JSON compatibility](#JSON compatibility//), YAML
[processors](#processor//) must allow all non-control characters inside [quoted
scalars](#style/flow/double-quoted).
To ensure readability, non-printable characters should be
[escaped](#escaping/in double-quoted scalars/) on output, even inside such
[scalars](#style/flow/double-quoted).
Note that JSON [quoted scalars](#style/flow/double-quoted) cannot span multiple
lines or contain [tabs](#tab//), but YAML [quoted
scalars](#style/flow/double-quoted) can.

```
[2] nb-json ::=
  #x9 | [#x20-#x10FFFF]
```

## 5.2. Character Encodings

All characters mentioned in this specification are Unicode code points.
Each such code point is written as one or more bytes depending on the
_character encoding_ used.
Note that in UTF-16, characters above **`#xFFFF`** are written as four bytes,
using a surrogate pair.

The character encoding is a [presentation detail](#presentation/detail/) and
must not be used to convey [content](#content//) information.

On input, a YAML [processor](#processor//) must support the UTF-8 and UTF-16
character encodings.
For [JSON compatibility](#JSON compatibility//), the UTF-32 encodings must also
be supported.

If a character [stream](#stream//) begins with a _byte order mark_, the
character encoding will be taken to be as indicated by the byte order mark.
Otherwise, the [stream](#stream//) must begin with an ASCII character.
This allows the encoding to be deduced by the pattern of null (**`#x00`**)
characters.

To make it easier to concatenate [streams](#stream//), byte order marks may
appear at the start of any [document](#document//).
However all [documents](#document//) in the same [stream](#stream//) must use
the same character encoding.

To allow for [JSON compatibility](#JSON compatibility//), byte order marks are
also allowed inside [quoted scalars](#style/flow/double-quoted).
For readability, such [content](#content//) byte order marks should be
[escaped](#escaping/in double-quoted scalars/) on output.

The encoding can therefore be deduced by matching the first few bytes of the
[stream](#stream//) with the following table rows (in order):

|   | Byte0 | Byte1 | Byte2 | Byte3 | Encoding
| -- | -- | -- | -- | -- | --
| Explicit BOM | #x00 | #x00 | #xFE | #xFF | UTF-32BE
| ASCII first character | #x00 | #x00 | #x00 | any | UTF-32BE
| Explicit BOM | #xFF | #xFE | #x00 | #x00 | UTF-32LE
| ASCII first character | any | #x00 | #x00 | #x00 | UTF-32LE
| Explicit BOM | #xFE | #xFF |   |   | UTF-16BE
| ASCII first character | #x00 | any |   |   | UTF-16BE
| Explicit BOM | #xFF | #xFE |   |   | UTF-16LE
| ASCII first character | any | #x00 |   |   | UTF-16LE
| Explicit BOM | #xEF | #xBB | #xBF |   | UTF-8
| Default |   |   |   |   | UTF-8

The recommended output encoding is UTF-8.
If another encoding is used, it is recommended that an explicit byte order mark
be used, even if the first [stream](#stream//) character is ASCII.

For more information about the byte order mark and the Unicode character
encoding schemes see the [Unicode
FAQ](http://www.unicode.org/unicode/faq/utf_bom.html).

```
[3] c-byte-order-mark ::= #xFEFF
```

In the examples, byte order mark characters are displayed as "**`⇔`**".

**Example 5.1. Byte Order Mark**

```
`⇔`\# Comment only.

```

```
Legend:
  `[c-byte-order-mark](#c-byte-order-mark)`

```

```
# This stream contains no
# documents, only comments.
```

**Example 5.2. Invalid Byte Order Mark**

```
- Invalid use of BOM
`⇔`
- Inside a document.
```

```
ERROR:
 A `BOM` must not appear
 inside a document.
```

## 5.3. Indicator Characters

_Indicators_ are characters that have special semantics.

```
[4] c-sequence-entry ::= "-"
```

A ["**`-`**"](#- block sequence entry//) (**`#x2D`**, hyphen) denotes a [block sequence](#style/block/sequence) entry.

```
[5] c-mapping-key ::= "?"
```

A ["**`?`**"](#? mapping key//) (**`#x3F`**, question mark) denotes a [mapping key](#key//).

```
[6] c-mapping-value ::= ":"
```

A ["**`:`**"](#: mapping value//) (**`#x3A`**, colon) denotes a [mapping value](#value//).

**Example 5.3. Block Structure Indicators**

```
sequence:
`-` one
`-` two
mapping:
  `?` sky
  : blue
  sea : green
```

```
Legend:
  `[c-sequence-entry](#c-sequence-entry)`
  `[c-mapping-key](#c-mapping-key)` [c-mapping-value](#c-mapping-value)

```

```
%YAML 1.2
---
!!map {
  ? !!str "sequence"
  : !!seq [ !!str "one", !!str "two" ],
  ? !!str "mapping"
  : !!map {
    ? !!str "sky" : !!str "blue",
    ? !!str "sea" : !!str "green",
  },
}
```

```
[7] c-collect-entry ::= ","
```

A ["**`,`**"](#, end flow entry//) (**`#x2C`**, comma) ends a [flow collection](#style/flow/collection) entry.

```
[8] c-sequence-start ::= "["
```

A ["**`[`**"](#[ start flow sequence//) (**`#x5B`**, left bracket) starts a [flow sequence](#style/flow/sequence).

```
[9] c-sequence-end ::= "]"
```

A ["**`]`**"](#] end flow sequence//) (**`#x5D`**, right bracket) ends a [flow sequence](#style/flow/sequence).

```
[10] c-mapping-start ::= "{"
```

A ["**`{`**"](#{ start flow mapping//) (**`#x7B`**, left brace) starts a [flow mapping](#style/flow/mapping).

```
[11] c-mapping-end ::= "}"
```

A ["**`}`**"](#} end flow mapping//) (**`#x7D`**, right brace) ends a [flow mapping](#style/flow/mapping).

**Example 5.4. Flow Collection Indicators**

```
sequence: `[` one, two, `]`
mapping: `{` sky: blue, sea: green `}`
```

```
Legend:
  `[c-sequence-start](#c-sequence-start)` `[c-sequence-end](#c-sequence-end)`
  `[c-mapping-start](#c-mapping-start)`  `[c-mapping-end](#c-mapping-end)`
  [c-collect-entry](#c-collect-entry)

```

```
%YAML 1.2
---
!!map {
  ? !!str "sequence"
  : !!seq [ !!str "one", !!str "two" ],
  ? !!str "mapping"
  : !!map {
    ? !!str "sky" : !!str "blue",
    ? !!str "sea" : !!str "green",
  },
}
```

```
[12] c-comment ::= "#"
```

An ["**`#`**"](## comment//) (**`#x23`**, octothorpe, hash, sharp, pound, number sign) denotes a [comment](#comment//).

**Example 5.5. Comment Indicator**

```
`#` Comment only.

```

```
Legend:
  `[c-comment](#c-comment)`

```

```
# This stream contains no
# documents, only comments.
```

```
[13] c-anchor ::= "&"
```

An ["**`&`**"](#& anchor//) (**`#x26`**, ampersand) denotes a [node’s anchor property](#anchor//).

```
[14] c-alias ::= "*"
```

An ["**`*`**"](#* alias//) (**`#x2A`**, asterisk) denotes an [alias node](#alias//).

```
[15] c-tag ::= "!"
```

The ["**`!`**"](#! tag indicator//) (**`#x21`**, exclamation) is heavily overloaded for specifying [node tags](#tag//). It is used to denote [tag handles](#tag/handle/) used in [tag directives](#directive/TAG/) and [tag properties](#tag/property/); to denote [local tags](#tag/local/); and as the [non-specific tag](#tag/non-specific/) for non-[plain scalars](#style/flow/plain).

**Example 5.6. Node Property Indicators**

```
anchored: `!`local `&`anchor value
alias: *anchor
```

```
Legend:
  `[c-tag](#c-tag)` `[c-anchor](#c-anchor)` [c-alias](#c-alias)

```

```
%YAML 1.2
---
!!map {
  ? !!str "anchored"
  : !local &A1 "value",
  ? !!str "alias"
  : *A1,
}
```

```
[16] c-literal ::= "|"
```

A ["**`|`**"](#| literal style//) (**`7C`**, vertical bar) denotes a [literal block scalar](#style/block/literal).

```
[17] c-folded ::= ">"
```

A ["**`>`**"](#> folded style//) (**`#x3E`**, greater than) denotes a [folded block scalar](#style/block/folded).

**Example 5.7. Block Scalar Indicators**

```
literal: `|`
  some
  text
folded: `>`
  some
  text
```

```
Legend:
  `[c-literal](#c-literal)` `[c-folded](#c-folded)`

```

```
%YAML 1.2
---
!!map {
  ? !!str "literal"
  : !!str "some\\ntext\\n",
  ? !!str "folded"
  : !!str "some text\\n",
}
```

```
[18] c-single-quote ::= "'"
```

An ["**`'`**"](#' single-quoted style//) (**`#x27`**, apostrophe, single quote) surrounds a [single-quoted flow scalar](#style/flow/single-quoted).

```
[19] c-double-quote ::= '"'
```

A ["**`"`**"](#" double-quoted style//) (**`#x22`**, double quote) surrounds a [double-quoted flow scalar](#style/flow/double-quoted).

**Example 5.8. Quoted Scalar Indicators**

```
single: `'`text`'`
double: `"`text`"`
```

```
Legend:
  `[c-single-quote](#c-single-quote)` `[c-double-quote](#c-double-quote)`

```

```
%YAML 1.2
---
!!map {
  ? !!str "single"
  : !!str "text",
  ? !!str "double"
  : !!str "text",
}
```

```
[20] c-directive ::= "%"
```

A ["**`%`**"](#% directive//) (**`#x25`**, percent) denotes a [directive](#directive//) line.

**Example 5.9. Directive Indicator**

```
`%`YAML 1.2
--- text
```

```
Legend:
  `[c-directive](#c-directive)`

```

```
%YAML 1.2
---
!!str "text"
```

```
[21] c-reserved ::=
  "@" | "`"
```

The _"**`@`**"_ (**`#x40`**, at) and _"**```**"_ (**`#x60`**, grave accent) are _reserved_ for future use.

**Example 5.10. Invalid use of Reserved Indicators**

```
commercial-at: `@`text
grave-accent: ```text
```

```
ERROR:
 `Reserved indicators` can't
 start a plain scalar.
```

Any indicator character:

```
[22] c-indicator ::=
    "-" | "?" | ":" | "," | "[" | "]" | "{" | "}"
  | "#" | "&" | "*" | "!" | "|" | ">" | "'" | '"'
  | "%" | "@" | "`"
```

The ["**`[`**"](#[ start flow sequence//), ["**`]`**"](#] end flow sequence//),
["**`{`**"](#{ start flow mapping//), ["**`}`**"](#} end flow mapping//) and
["**`,`**"](#, end flow entry//) indicators denote structure in [flow
collections](#style/flow/collection).
They are therefore forbidden in some cases, to avoid ambiguity in several
constructs.
This is handled on a case-by-case basis by the relevant productions.

```
[23] c-flow-indicator ::=
  "," | "[" | "]" | "{" | "}"
```

## 5.4. Line Break Characters

YAML recognizes the following ASCII _line break_ characters.

```
[24] b-line-feed ::=
  #xA    /* LF */
```

```
[25] b-carriage-return ::=
  #xD    /* CR */
```

```
[26] b-char ::=
  b-line-feed | b-carriage-return
```

All other characters, including the form feed (**`#x0C`**), are considered to
be non-break characters.
Note that these include the _non-ASCII line breaks_: next line (**`#x85`**),
line separator (**`#x2028`**) and paragraph separator (**`#x2029`**).

[YAML version 1.1](#YAML 1.1 processing//) did support the above non-ASCII line
break characters; however, JSON does not.
Hence, to ensure [JSON compatibility](#JSON compatibility//), YAML treats them
as non-break characters as of version 1.2.
In theory this would cause incompatibility with [version 1.1](#YAML 1.1
processing//); in practice these characters were rarely (if ever) used.
YAML 1.2 [processors](#processor//) [parsing](#parse//) a [version 1.1](#YAML
1.1 processing//) [document](#document//) should therefore treat these line
breaks as non-break characters, with an appropriate warning.

```
[27] nb-char ::=
  c-printable - b-char - c-byte-order-mark
```

Line breaks are interpreted differently by different systems, and have several
widely used formats.

```
[28] b-break ::=
    ( b-carriage-return b-line-feed ) /* DOS, Windows */
  | b-carriage-return                 /* MacOS upto 9.x */
  | b-line-feed                       /* UNIX, MacOS X */
```

Line breaks inside [scalar content](#scalar//) must be _normalized_ by the YAML
[processor](#processor//).
Each such line break must be [parsed](#parse//) into a single line feed
character.
The original line break format is a [presentation
detail](#presentation/detail/) and must not be used to convey
[content](#content//) information.

```
[29] b-as-line-feed ::= b-break
```

Outside [scalar content](#scalar//), YAML allows any line break to be used to
terminate lines.

```
[30] b-non-content ::= b-break
```

On output, a YAML [processor](#processor//) is free to emit line breaks using
whatever convention is most appropriate.

In the examples, line breaks are sometimes displayed using the "**`↓`**" glyph
for clarity.

**Example 5.11. Line Break Characters**

```
|
  Line break (no glyph)
  Line break (glyphed)`↓`
```

```
Legend:
  `[b-break](#b-break)`

```

```
%YAML 1.2
---
!!str "line break (no glyph)\\n\\
      line break (glyphed)\\n"
```

## 5.5. White Space Characters

YAML recognizes two _white space_ characters: _space_ and _tab_.

```
[31] s-space ::=
  #x20 /* SP */
```

```
[32] s-tab ::=
  #x9  /* TAB */
```

```
[33] s-white ::=
  s-space | s-tab
```

The rest of the ([printable](#printable character//)) non-[break](#line
break//) characters are considered to be non-space characters.

```
[34] ns-char ::=
  nb-char - s-white
```

In the examples, tab characters are displayed as the glyph "**`→`**".
Space characters are sometimes displayed as the glyph "**`·`**" for clarity.

**Example 5.12. Tabs and Spaces**

```
# Tabs and spaces
quoted:`·`"Quoted `→`"
block:`→`|
`··`void main() {
`··``→`printf("Hello, world!\\n");
`··`}
```

```
Legend:
  `[s-space](#s-space)` `[s-tab](#s-tab)`

```

```
%YAML 1.2
---
!!map {
  ? !!str "quoted"
  : "Quoted \\t",
  ? !!str "block"
  : "void main() {\\n\\
    \\tprintf(\\"Hello, world!\\\\n\\");\\n\\
    }\\n",
}
```

## 5.6. Miscellaneous Characters

The YAML syntax productions make use of the following additional character
classes:

*   A decimal digit for numbers:

```
[35] ns-dec-digit ::=
  [#x30-#x39] /* 0-9 */
```

*   A hexadecimal digit for [escape sequences](#escaping/in double-quoted scalars/):

```
[36] ns-hex-digit ::=
    ns-dec-digit
  | [#x41-#x46] /* A-F */ | [#x61-#x66] /* a-f */
```

*   ASCII letter (alphabetic) characters:

```
[37] ns-ascii-letter ::=
  [#x41-#x5A] /* A-Z */ | [#x61-#x7A] /* a-z */
```

*   Word (alphanumeric) characters for identifiers:

```
[38] ns-word-char ::=
  ns-dec-digit | ns-ascii-letter | "-"
```

*   URI characters for [tags](#tag//), as specified in
    [RFC2396](http://www.ietf.org/rfc/rfc2396.txt), with the addition of the
    "**`[`**" and "**`]`**" for presenting IPv6 addresses as proposed in
    [RFC2732](http://www.ietf.org/rfc/rfc2732.txt).
    
    By convention, any URI characters other than the allowed printable ASCII
    characters are first _encoded_ in UTF-8, and then each byte is _escaped_ using
    the _"**`%`**"_ character.
    The YAML [processor](#processor//) must not expand such escaped characters.
    [Tag](#tag//) characters must be preserved and compared exactly as
    [presented](#present//) in the YAML [stream](#stream//), without any
    processing.
    

```
[39] ns-uri-char ::=
    "%" ns-hex-digit ns-hex-digit | ns-word-char | "#"
  | ";" | "/" | "?" | ":" | "@" | "&" | "=" | "+" | "$" | ","
  | "_" | "." | "!" | "~" | "*" | "'" | "(" | ")" | "[" | "]"
```

*   The ["**`!`**"](#c-tag) character is used to indicate the end of a [named tag handle](#tag/handle/named); hence its use in [tag shorthands](#tag/shorthand/) is restricted. In addition, such [shorthands](#tag/shorthand/) must not contain the ["**`[`**"](#[ start flow sequence//), ["**`]`**"](#] end flow sequence//), ["**`{`**"](#{ start flow mapping//), ["**`}`**"](#} end flow mapping//) and ["**`,`**"](#, end flow entry//) characters. These characters would cause ambiguity with [flow collection](#style/flow/collection) structures.

```
[40] ns-tag-char ::=
  ns-uri-char - "!" - c-flow-indicator
```

## 5.7. Escaped Characters

All non-[printable](#printable character//) characters must be _escaped_.
YAML escape sequences use the _"**`\`**"_ notation common to most modern
computer languages.
Each escape sequence must be [parsed](#parse//) into the appropriate Unicode
character.
The original escape sequence is a [presentation detail](#presentation/detail/)
and must not be used to convey [content](#content//) information.

Note that escape sequences are only interpreted in [double-quoted
scalars](#style/flow/double-quoted).
In all other [scalar styles](#style/scalar/), the "**`\`**" character has no
special meaning and non-[printable](#printable character//) characters are not
available.

```
[41] c-escape ::= "\"
```

YAML escape sequences are a superset of C’s escape sequences:

```
[42] ns-esc-null ::= "0"
```

Escaped ASCII null (**`#x0`**) character.

```
[43] ns-esc-bell ::= "a"
```

Escaped ASCII bell (**`#x7`**) character.

```
[44] ns-esc-backspace ::= "b"
```

Escaped ASCII backspace (**`#x8`**) character.

```
[45] ns-esc-horizontal-tab ::=
  "t" | #x9
```

Escaped ASCII horizontal tab (**`#x9`**) character. This is useful at the start or the end of a line to force a leading or trailing tab to become part of the [content](#content//).

```
[46] ns-esc-line-feed ::= "n"
```

Escaped ASCII line feed (**`#xA`**) character.

```
[47] ns-esc-vertical-tab ::= "v"
```

Escaped ASCII vertical tab (**`#xB`**) character.

```
[48] ns-esc-form-feed ::= "f"
```

Escaped ASCII form feed (**`#xC`**) character.

```
[49] ns-esc-carriage-return ::= "r"
```

Escaped ASCII carriage return (**`#xD`**) character.

```
[50] ns-esc-escape ::= "e"
```

Escaped ASCII escape (**`#x1B`**) character.

```
[51] ns-esc-space ::= #x20
```

Escaped ASCII space (**`#x20`**) character. This is useful at the start or the end of a line to force a leading or trailing space to become part of the [content](#content//).

```
[52] ns-esc-double-quote ::= '"'
```

Escaped ASCII double quote (**`#x22`**).

```
[53] ns-esc-slash ::= "/"
```

Escaped ASCII slash (**`#x2F`**), for [JSON compatibility](#JSON compatibility//).

```
[54] ns-esc-backslash ::= "\"
```

Escaped ASCII back slash (**`#x5C`**).

```
[55] ns-esc-next-line ::= "N"
```

Escaped Unicode next line (**`#x85`**) character.

```
[56] ns-esc-non-breaking-space ::= "_"
```

Escaped Unicode non-breaking space (**`#xA0`**) character.

```
[57] ns-esc-line-separator ::= "L"
```

Escaped Unicode line separator (**`#x2028`**) character.

```
[58] ns-esc-paragraph-separator ::= "P"
```

Escaped Unicode paragraph separator (**`#x2029`**) character.

```
[59] ns-esc-8-bit ::=
  "x"
  ( ns-hex-digit × 2 )
```

Escaped 8-bit Unicode character.

```
[60] ns-esc-16-bit ::=
  "u"
  ( ns-hex-digit × 4 )
```

Escaped 16-bit Unicode character.

```
[61] ns-esc-32-bit ::=
  "U"
  ( ns-hex-digit × 8 )
```

Escaped 32-bit Unicode character.

Any escaped character:

```
[62] c-ns-esc-char ::=
  "\"
  ( ns-esc-null | ns-esc-bell | ns-esc-backspace
  | ns-esc-horizontal-tab | ns-esc-line-feed
  | ns-esc-vertical-tab | ns-esc-form-feed
  | ns-esc-carriage-return | ns-esc-escape | ns-esc-space
  | ns-esc-double-quote | ns-esc-slash | ns-esc-backslash
  | ns-esc-next-line | ns-esc-non-breaking-space
  | ns-esc-line-separator | ns-esc-paragraph-separator
  | ns-esc-8-bit | ns-esc-16-bit | ns-esc-32-bit )
```

**Example 5.13. Escaped Characters**

```
"Fun with `\\`
`\"` `\a` `\b` `\e` `\f` `\↓`
`\n` `\r` `\t` `\v` `\0` `\↓`
`\ ` `\_` `\N` `\L` `\P` `\↓`
`\x41` `\u0041` `\U00000041`"
```

```
Legend:
  `[c-ns-esc-char](#c-ns-esc-char)`

```

```
%YAML 1.2
---
"Fun with \\x5C
\x22 \\x07 \\x08 \\x1B \\x0C
\x0A \\x0D \\x09 \\x0B \\x00
\x20 \\xA0 \\x85 \\u2028 \\u2029
A A A"
```

**Example 5.14. Invalid Escaped Characters**

```
Bad escapes:
  "\\`c`
  \\x`q-`"
```

```
ERROR:
- `c` is an invalid escaped character.
- `q` and `-` are invalid hex digits.
```

# Chapter 6. Basic Structures

## 6.1. Indentation Spaces

In YAML [block styles](#style/block/), structure is determined by _indentation_.
In general, indentation is defined as a zero or more [space](#space//)
characters at the start of a line.

To maintain portability, [tab](#tab//) characters must not be used in
indentation, since different systems treat [tabs](#tab//) differently.
Note that most modern editors may be configured so that pressing the
[tab](#tab//) key results in the insertion of an appropriate number of
[spaces](#space//).

The amount of indentation is a [presentation detail](#presentation/detail/) and
must not be used to convey [content](#content//) information.

```
[63] s-indent(n) ::=
  s-space × n
```

A [block style](#style/block/) construct is terminated when encountering a line
which is less indented than the construct.
The productions use the notation "**`s-indent(<n)`**" and "**`s-indent(≤n)`**"
to express this.

```
[64] s-indent(<n) ::=
  s-space × m /* Where m < n */
```

```
[65] s-indent(≤n) ::=
  s-space × m /* Where m ≤ n */
```

Each [node](#node//) must be indented further than its parent [node](#node//).
All sibling [nodes](#node//) must use the exact same indentation level.
However the [content](#content//) of each sibling [node](#node//) may be
further indented independently.

**Example 6.1. Indentation Spaces**

```
··\# Leading comment line spaces are
···\# neither content nor indentation.
····
Not indented:
`·`By one space: |
`····`By four
`····``··`spaces
`·`Flow style: [    # Leading spaces
`··`·By two,        # in flow style
`··`Also by two,    # are neither
`··`→Still by two   # content nor
`··`··]             # indentation.
```

```
Legend:
  `[s-indent(n)](#s-indent(n))` `Content`
  Neither content nor indentation

```

```
%YAML 1.2
- - -
!!map {
  ? !!str "Not indented"
  : !!map {
      ? !!str "By one space"
      : !!str "By four\\n  spaces\\n",
      ? !!str "Flow style"
      : !!seq [
          !!str "By two",
          !!str "Also by two",
          !!str "Still by two",
        ]
    }
}
```

The ["**`-`**"](#- block sequence entry//), ["**`?`**"](#? mapping key//) and
["**`:`**"](#: mapping value//) characters used to denote [block
collection](#style/block/collection) entries are perceived by people to be part
of the indentation.
This is handled on a case-by-case basis by the relevant productions.

**Example 6.2. Indentation Indicators**

```
`?`·a
`:`·`-`→b
``··`-`··`-`→c
``·····`-`·d
```

```
Legend:
  `Total Indentation`
  `[s-indent(n)](#s-indent(n))` Indicator as indentation

```

```
%YAML 1.2
---
!!map {
  ? !!str "a"
  : !!seq [
    !!str "b",
    !!seq [ !!str "c", !!str "d" ]
  ],
}
```

## 6.2. Separation Spaces

Outside [indentation](#space/indentation/) and [scalar content](#scalar//),
YAML uses [white space](#space/white/) characters for _separation_ between
tokens within a line.
Note that such [white space](#space/white/) may safely include [tab](#tab//)
characters.

Separation spaces are a [presentation detail](#presentation/detail/) and must
not be used to convey [content](#content//) information.

```
[66] s-separate-in-line ::=
  s-white+ | /* Start of line */
```

**Example 6.3. Separation Spaces**

```
-`·`foo:`→·`bar
- -`·`baz
  -`→`baz
```

```
Legend:
  `[s-separate-in-line](#s-separate-in-line)`

```

```
%YAML 1.2
---
!!seq [
  !!map {
    ? !!str "foo" : !!str "bar",
  },
  !!seq [ !!str "baz", !!str "baz" ],
]
```

## 6.3. Line Prefixes

Inside [scalar content](#scalar//), each line begins with a
non-[content](#content//) _line prefix_.
This prefix always includes the [indentation](#space/indentation/).
For [flow scalar styles](#style/flow/scalar) it additionally includes all
leading [white space](#space/white/), which may contain [tab](#tab//)
characters.

Line prefixes are a [presentation detail](#presentation/detail/) and must not
be used to convey [content](#content//) information.

```
[67] s-line-prefix(n,c) ::=
  c = block-out ⇒ s-block-line-prefix(n)
  c = block-in  ⇒ s-block-line-prefix(n)
  c = flow-out  ⇒ s-flow-line-prefix(n)
  c = flow-in   ⇒ s-flow-line-prefix(n)
```

```
[68] s-block-line-prefix(n) ::= s-indent(n)
```

```
[69] s-flow-line-prefix(n) ::=
  s-indent(n) s-separate-in-line?
```

**Example 6.4. Line Prefixes**

```
plain: text
`··`lines
quoted: "text
`··→`lines"
block: |
`··`text
`··`·→lines
```

```
Legend:
  `[s-flow-line-prefix(n)](#s-flow-line-prefix(n))` `[s-block-line-prefix(n)](#s-block-line-prefix(n))` [s-indent(n)](#s-indent(n))

```

```
%YAML 1.2
---
!!map {
  ? !!str "plain"
  : !!str "text lines",
  ? !!str "quoted"
  : !!str "text lines",
  ? !!str "block"
  : !!str "text\\n·→lines\\n",
}
```

## 6.4. Empty Lines

An _empty line_ line consists of the non-[content](#content//) [prefix](#line
prefix//) followed by a [line break](#line break//).

```
[70] l-empty(n,c) ::=
  ( s-line-prefix(n,c) | s-indent(<n) )
  b-as-line-feed
```

The semantics of empty lines depend on the [scalar style](#style/scalar/) they
appear in.
This is handled on a case-by-case basis by the relevant productions.

**Example 6.5. Empty Lines**

```
Folding:
  "Empty line
`···→`
  as a line feed"
Chomping: |
  Clipped empty lines
`·`
```

```
Legend:
  `[l-empty(n,c)](#l-empty(n,c))`

```

```
%YAML 1.2
---
!!map {
  ? !!str "Folding"
  : !!str "Empty line\\nas a line feed",
  ? !!str "Chomping"
  : !!str "Clipped empty lines\\n",
}
```

## 6.5. Line Folding

_Line folding_ allows long lines to be broken for readability, while retaining
the semantics of the original long line.
If a [line break](#line break//) is followed by an [empty line](#empty line//),
it is _trimmed_; the first [line break](#line break//) is discarded and the
rest are retained as [content](#content//).

```
[71] b-l-trimmed(n,c) ::=
  b-non-content l-empty(n,c)+
```

Otherwise (the following line is not [empty](#empty line//)), the [line
break](#line break//) is converted to a single [space](#space//) (**`#x20`**).

```
[72] b-as-space ::= b-break
```

A folded non-[empty line](#empty line//) may end with either of the above [line
breaks](#line break//).

```
[73] b-l-folded(n,c) ::=
  b-l-trimmed(n,c) | b-as-space
```

**Example 6.6. Line Folding**

```
>-
  trimmed`↓
··↓
·↓
↓`
  as`↓`
  space
```

```
%YAML 1.2
---
!!str "trimmed\\n\\n\\nas space"
```

```
 Legend:
   `[b-l-trimmed(n,c)](#b-l-trimmed(n,c))`
   `[b-as-space](#b-as-space)`

```

The above rules are common to both the [folded block
style](#style/block/folded) and the [scalar flow styles](#style/flow/scalar).
Folding does distinguish between these cases in the following way:

Block Folding

In the [folded block style](#style/block/folded), the final [line break](#line
break//) and trailing [empty lines](#empty line//) are subject to
[chomping](#chomping//), and are never folded.
In addition, folding does not apply to [line breaks](#line break//) surrounding
text lines that contain leading [white space](#space/white/).
Note that such a [more-indented](#more-indented//) line may consist only of
such leading [white space](#space/white/).

The combined effect of the _block line folding_ rules is that each "paragraph"
is interpreted as a line, [empty lines](#empty line//) are interpreted as a
line feed, and the formatting of [more-indented](#more-indented//) lines is
preserved.

**Example 6.7. Block Folding**

```
>
`··`foo·`↓`
`·↓`
`··`→·bar`↓`
`↓`
`··`baz↓
```

```
%YAML 1.2
--- !!str
"foo \\n\\n\\t bar\\n\\nbaz\\n"
```

```
 Legend:
   `[b-l-folded(n,c)](#b-l-folded(n,c))`
   `Non-content spaces` Content spaces

```

Flow Folding

Folding in [flow styles](#style/flow/) provides more relaxed semantics. [Flow
styles](#style/flow/) typically depend on explicit [indicators](#indicator//)
rather than [indentation](#space/indentation/) to convey structure.
Hence spaces preceding or following the text in a line are a [presentation
detail](#presentation/detail/) and must not be used to convey
[content](#content//) information.
Once all such spaces have been discarded, all [line breaks](#line break//) are
folded, without exception.

The combined effect of the _flow line folding_ rules is that each "paragraph"
is interpreted as a line, [empty lines](#empty line//) are interpreted as line
feeds, and text can be freely [more-indented](#more-indented//) without
affecting the [content](#content//) information.

```
[74] s-flow-folded(n) ::=
  s-separate-in-line? b-l-folded(n,flow-in)
  s-flow-line-prefix(n)
```

**Example 6.8. Flow Folding**

```
"`↓
`··``foo``·`↓
`·`↓
`··→·``bar`↓
↓
`··``baz`↓` "
```

```
%YAML 1.2
--- !!str
" foo\\nbar\\nbaz "
```

```
 Legend:
   `[s-flow-folded(n)](#s-flow-folded(n))`
   `Non-content spaces`

```

## 6.6. Comments

An explicit _comment_ is marked by a _"**`#`**" indicator_.
Comments are a [presentation detail](#presentation/detail/) and must not be
used to convey [content](#content//) information.

Comments must be [separated](#space/separation/) from other tokens by [white
space](#space/white/) characters.
To ensure [JSON compatibility](#JSON compatibility//), YAML
[processors](#processor//) must allow for the omission of the final comment
[line break](#line break//) of the input [stream](#stream//).
However, as this confuses many tools, YAML [processors](#processor//) should
terminate the [stream](#stream//) with an explicit [line break](#line break//)
on output.

```
[75] c-nb-comment-text ::=
  "#" nb-char*
```

```
[76] b-comment ::=
  b-non-content | /* End of file */
```

```
[77] s-b-comment ::=
  ( s-separate-in-line c-nb-comment-text? )?
  b-comment
```

**Example 6.9. Separated Comment**

```
key:····`# Comment``↓`
  value`_eof_`
```

```
Legend:
  `[c-nb-comment-text](#c-nb-comment-text)` `[b-comment](#b-comment)`
  [s-b-comment](#s-b-comment)

```

```
%YAML 1.2
---
!!map {
  ? !!str "key"
  : !!str "value",
}
```

Outside [scalar content](#scalar//), comments may appear on a line of their
own, independent of the [indentation](#space/indentation/) level.
Note that outside [scalar content](#scalar//), a line containing only [white
space](#space/white/) characters is taken to be a comment line.

```
[78] l-comment ::=
  s-separate-in-line c-nb-comment-text? b-comment
```

**Example 6.10. Comment Lines**

```
`··`# Comment↓``
`···`↓``
``↓``
```

```
# This stream contains no
# documents, only comments.
```

```
 Legend:
   `[s-b-comment](#s-b-comment)` `[l-comment](#l-comment)`

```

In most cases, when a line may end with a comment, YAML allows it to be
followed by additional comment lines.
The only exception is a comment ending a [block scalar header](#block scalar
header//).

```
[79] s-l-comments ::=
  ( s-b-comment | /* Start of line */ )
  l-comment*
```

**Example 6.11. Multi-Line Comments**

```
key:`····# Comment↓`
`········# lines↓`
  value`↓`
`↓`
```

```
%YAML 1.2
---
!!map {
  ? !!str "key"
  : !!str "value",
}
```

```
Legend:
  `[s-b-comment](#s-b-comment)` `[l-comment](#l-comment)` [s-l-comments](#s-l-comments)

```

## 6.7. Separation Lines

[Implicit keys](#key/implicit/) are restricted to a single line.
In all other cases, YAML allows tokens to be separated by multi-line (possibly
empty) [comments](#comment//).

Note that structures following multi-line comment separation must be properly
[indented](#space/indentation/), even though there is no such restriction on
the separation [comment](#comment//) lines themselves.

```
[80] s-separate(n,c) ::=
  c = block-out ⇒ s-separate-lines(n)
  c = block-in  ⇒ s-separate-lines(n)
  c = flow-out  ⇒ s-separate-lines(n)
  c = flow-in   ⇒ s-separate-lines(n)
  c = block-key ⇒ s-separate-in-line
  c = flow-key  ⇒ s-separate-in-line
```

```
[81] s-separate-lines(n) ::=
    ( s-l-comments s-flow-line-prefix(n) )
  | s-separate-in-line
```

**Example 6.12. Separation Spaces**

```
{`·`first:`·`Sammy,`·`last:`·`Sosa`·`}:`↓
# Statistics:
··`hr:`··# Home runs
·····`65
··avg:`·# Average
···`0.278
```

```
Legend:
  `[s-separate-in-line](#s-separate-in-line)`
  `[s-separate-lines(n)](#s-separate-lines(n))`
  [s-indent(n)](#s-indent(n))

```

```
%YAML 1.2
---
!!map {
  ? !!map {
    ? !!str "first"
    : !!str "Sammy",
    ? !!str "last"
    : !!str "Sosa",
  }
  : !!map {
    ? !!str "hr"
    : !!int "65",
    ? !!str "avg"
    : !!float "0.278",
  },
}
```

## 6.8. Directives

_Directives_ are instructions to the YAML [processor](#processor//).
This specification defines two directives, ["**`YAML`**"](#directive/YAML/) and
["**`TAG`**"](#directive/TAG/), and _reserves_ all other directives for future
use.
There is no way to define private directives.
This is intentional.

Directives are a [presentation detail](#presentation/detail/) and must not be
used to convey [content](#content//) information.

```
[82] l-directive ::=
  "%"
  ( ns-yaml-directive
  | ns-tag-directive
  | ns-reserved-directive )
  s-l-comments
```

Each directive is specified on a separate non-[indented](#space/indentation/)
line starting with the _"**`%`**" indicator_, followed by the directive name
and a list of parameters.
The semantics of these parameters depends on the specific directive.
A YAML [processor](#processor//) should ignore unknown directives with an
appropriate warning.

```
[83] ns-reserved-directive ::=
  ns-directive-name
  ( s-separate-in-line ns-directive-parameter )*
```

```
[84] ns-directive-name ::= ns-char+
```

```
[85] ns-directive-parameter ::= ns-char+
```

**Example 6.13. Reserved Directives**

```
%``FOO`  bar baz` # Should be ignored
               # with a warning.
--- "foo"
```

```
%YAML 1.2
--- !!str
"foo"
```

```
Legend:
  `[ns-reserved-directive](#ns-reserved-directive)` `[ns-directive-name](#ns-directive-name)` [ns-directive-parameter](#ns-directive-parameter)

```

### 6.8.1. "**`YAML`**" Directives

The _"**`YAML`**" directive_ specifies the version of YAML the
[document](#document//) conforms to.
This specification defines version "**`1.2`**", including recommendations for
_YAML 1.1 processing_.

A version 1.2 YAML [processor](#processor//) must accept
[documents](#document//) with an explicit "**`%YAML 1.2`**" directive, as well
as [documents](#document//) lacking a "**`YAML`**" directive.
Such [documents](#document//) are assumed to conform to the 1.2 version
specification. [Documents](#document//) with a "**`YAML`**" directive
specifying a higher minor version (e.g. "**`%YAML 1.3`**") should be processed
with an appropriate warning. [Documents](#document//) with a "**`YAML`**"
directive specifying a higher major version (e.g. "**`%YAML 2.0`**") should be
rejected with an appropriate error message.

A version 1.2 YAML [processor](#processor//) must also accept
[documents](#document//) with an explicit "**`%YAML 1.1`**" directive.
Note that version 1.2 is mostly a superset of version 1.1, defined for the
purpose of ensuring _JSON compatibility_.
Hence a version 1.2 [processor](#processor//) should process version 1.1
[documents](#document//) as if they were version 1.2, giving a warning on
points of incompatibility (handling of [non-ASCII line breaks](#line
break/non-ASCII/), as described [above](#non-ASCII line breaks)).

```
[86] ns-yaml-directive ::=
  "Y" "A" "M" "L"
  s-separate-in-line ns-yaml-version
```

```
[87] ns-yaml-version ::=
  ns-dec-digit+ "." ns-dec-digit+
```

**Example 6.14. "**`YAML`**" directive**

```
%`YAML `1.3`` # Attempt parsing
           # with a warning
---
"foo"
```

```
%YAML 1.2
---
!!str "foo"
```

```
 Legend:
   `[ns-yaml-directive](#ns-yaml-directive)` `[ns-yaml-version](#ns-yaml-version)`

```

It is an error to specify more than one "**`YAML`**" directive for the same
document, even if both occurrences give the same version number.

**Example 6.15. Invalid Repeated YAML directive**

```
%YAML 1.2
%`YAML` 1.1
foo
```

```
ERROR:
The `YAML` directive must only be
given at most once per document.
```

### 6.8.2. "**`TAG`**" Directives

The _"**`TAG`**" directive_ establishes a [tag shorthand](#tag/shorthand/)
notation for specifying [node tags](#tag//).
Each "**`TAG`**" directive associates a [handle](#tag/handle/) with a
[prefix](#tag/prefix/).
This allows for compact and readable [tag](#tag//) notation.

```
[88] ns-tag-directive ::=
  "T" "A" "G"
  s-separate-in-line c-tag-handle
  s-separate-in-line ns-tag-prefix
```

**Example 6.16. "**`TAG`**" directive**

```
%`TAG `!yaml!` tag:yaml.org,2002:`
---
!yaml!str "foo"
```

```
%YAML 1.2
---
!!str "foo"
```

```
Legend:
  `[ns-tag-directive](#ns-tag-directive)` `[c-tag-handle](#c-tag-handle)` [ns-tag-prefix](#ns-tag-prefix)

```

It is an error to specify more than one "**`TAG`**" directive for the same
[handle](#tag/handle/) in the same document, even if both occurrences give the
same [prefix](#tag/prefix/).

**Example 6.17. Invalid Repeated TAG directive**

```
%TAG ! !foo
%TAG `!` !foo
bar
```

```
ERROR:
The TAG directive must only
be given at most once per
`handle` in the same document.
```

#### 6.8.2.1. Tag Handles

The _tag handle_ exactly matches the prefix of the affected [tag
shorthand](#tag/shorthand/).
There are three tag handle variants:

```
[89] c-tag-handle ::=
    c-named-tag-handle
  | c-secondary-tag-handle
  | c-primary-tag-handle
```

Primary Handle

The _primary tag handle_ is a single _"**`!`**"_ character.
This allows using the most compact possible notation for a single "primary"
name space.
By default, the prefix associated with this handle is ["**`!`**"](#! tag
indicator/! local tag/).
Thus, by default, [shorthands](#tag/shorthand/) using this handle are
interpreted as [local tags](#tag/local/).

It is possible to override the default behavior by providing an explicit
"**`TAG`**" directive, associating a different prefix for this handle.
This provides smooth migration from using [local tags](#tag/local/) to using
[global tags](#tag/global/), by the simple addition of a single "**`TAG`**"
directive.

```
[90] c-primary-tag-handle ::= "!"
```

**Example 6.18. Primary Tag Handle**

```
# Private
`!`foo "bar"
...
# Global
%TAG `!` tag:example.com,2000:app/
---
`!`foo "bar"
```

```
%YAML 1.2
---
!<!foo> "bar"
...
---
!<tag:example.com,2000:app/foo> "bar"
```

```
Legend:
  `[c-primary-tag-handle](#c-primary-tag-handle)`

```

Secondary Handle

The _secondary tag handle_ is written as _"**`!!`**"_.
This allows using a compact notation for a single "secondary" name space.
By default, the prefix associated with this handle is
"**`tag:yaml.org,2002:`**".
This prefix is used by the [YAML tag repository](#tag/repository/).

It is possible to override this default behavior by providing an explicit
"**`TAG`**" directive associating a different prefix for this handle.

```
[91] c-secondary-tag-handle ::=
  "!" "!"
```

**Example 6.19. Secondary Tag Handle**

```
%TAG `!!` tag:example.com,2000:app/
---
`!!`int 1 - 3 # Interval, not integer
```

```
Legend:
  `[c-secondary-tag-handle](#c-secondary-tag-handle)`

```

```
%YAML 1.2
---
!<tag:example.com,2000:app/int> "1 - 3"
```

Named Handles

A _named tag handle_ surrounds a non-empty name with _"**`!`**"_ characters.
A handle name must not be used in a [tag shorthand](#tag/shorthand/) unless an
explicit "**`TAG`**" directive has associated some prefix with it.

The name of the handle is a [presentation detail](#presentation/detail/) and
must not be used to convey [content](#content//) information.
In particular, the YAML [processor](#processor//) need not preserve the handle
name once [parsing](#parse//) is completed.

```
[92] c-named-tag-handle ::=
  "!" ns-word-char+ "!"
```

**Example 6.20. Tag Handles**

```
%TAG `!e!` tag:example.com,2000:app/
---
`!e!`foo "bar"
```

```
Legend:
  `[c-named-tag-handle](#c-named-tag-handle)`

```

```
%YAML 1.2
---
!<tag:example.com,2000:app/foo> "bar"
```

#### 6.8.2.2. Tag Prefixes

There are two _tag prefix_ variants:

```
[93] ns-tag-prefix ::=
  c-ns-local-tag-prefix | ns-global-tag-prefix
```

Local Tag Prefix

If the prefix begins with a ["**`!`**"](#! tag indicator/! local tag/)
character, [shorthands](#tag/shorthand/) using the [handle](#tag/handle/) are
expanded to a [local tag](#tag/local/).
Note that such a [tag](#tag//) is intentionally not a valid URI, and its
semantics are specific to the [application](#application//).
In particular, two [documents](#document//) in the same [stream](#stream//) may
assign different semantics to the same [local tag](#tag/local/).

```
[94] c-ns-local-tag-prefix ::=
  "!" ns-uri-char*
```

**Example 6.21. Local Tag Prefix**

```
%TAG !m! `!my-`
--- # Bulb here
!m!light fluorescent
...
%TAG !m! `!my-`
--- # Color here
!m!light green
```

```
Legend:
  `[c-ns-local-tag-prefix](#c-ns-local-tag-prefix)`

```

```
%YAML 1.2
---
!<!my-light> "fluorescent"
...
%YAML 1.2
---
!<!my-light> "green"
```

Global Tag Prefix

If the prefix begins with a character other than ["**`!`**"](#! tag indicator/!
local tag/), it must be a valid URI prefix, and should contain at least the
scheme and the authority. [Shorthands](#tag/shorthand/) using the associated
[handle](#tag/handle/) are expanded to globally unique URI tags, and their
semantics is consistent across [applications](#application//).
In particular, every [documents](#document//) in every [stream](#stream//) must
assign the same semantics to the same [global tag](#tag/global/).

```
[95] ns-global-tag-prefix ::=
  ns-tag-char ns-uri-char*
```

**Example 6.22. Global Tag Prefix**

```
%TAG !e! `tag:example.com,2000:app/`
---
- !e!foo "bar"
```

```
Legend:
  `[ns-global-tag-prefix](#ns-global-tag-prefix)`

```

```
%YAML 1.2
---
!<tag:example.com,2000:app/foo> "bar"
```

## 6.9. Node Properties

Each [node](#node//) may have two optional _properties_, [anchor](#anchor//)
and [tag](#tag//), in addition to its [content](#content//).
Node properties may be specified in any order before the [node’s
content](#content//).
Either or both may be omitted.

```
[96] c-ns-properties(n,c) ::=
    ( c-ns-tag-property
      ( s-separate(n,c) c-ns-anchor-property )? )
  | ( c-ns-anchor-property
      ( s-separate(n,c) c-ns-tag-property )? )
```

**Example 6.23. Node Properties**

```
`!!str `&a1`` "foo":
  `!!str` bar
``&a2`` baz : *a1
```

```
Legend:
  `[c-ns-properties(n,c)](#c-ns-properties(n,c))`
  `[c-ns-anchor-property](#c-ns-anchor-property)`
  [c-ns-tag-property](#c-ns-tag-property)

```

```
%YAML 1.2
---
!!map {
  ? &B1 !!str "foo"
  : !!str "bar",
  ? !!str "baz"
  : *B1,
}
```

### 6.9.1. Node Tags

The _tag property_ identifies the type of the [native data structure](#native
data structure//) [presented](#present//) by the [node](#node//).
A tag is denoted by the _"**`!`**" indicator_.

```
[97] c-ns-tag-property ::=
    c-verbatim-tag
  | c-ns-shorthand-tag
  | c-non-specific-tag
```

Verbatim Tags

A tag may be written _verbatim_ by surrounding it with the _"**`<`**" and
"**`>`**"_ characters.
In this case, the YAML [processor](#processor//) must deliver the verbatim tag
as-is to the [application](#application//).
In particular, verbatim tags are not subject to [tag
resolution](#tag/resolution/).
A verbatim tag must either begin with a ["**`!`**"](#! tag indicator/! local
tag/) (a [local tag](#tag/local/)) or be a valid URI (a [global
tag](#tag/global/)).

```
[98] c-verbatim-tag ::=
  "!" "<" ns-uri-char+ ">"
```

**Example 6.24. Verbatim Tags**

```
`!<tag:yaml.org,2002:str>` foo :
  `!<!bar>` baz
```

```
Legend:
  `[c-verbatim-tag](#c-verbatim-tag)`

```

```
%YAML 1.2
---
!!map {
  ? !<tag:yaml.org,2002:str> "foo"
  : !<!bar> "baz",
}
```

**Example 6.25. Invalid Verbatim Tags**

```
- !<`!`\> foo
- !<`$:?`\> bar
```

```
ERROR:
- Verbatim tags aren't resolved,
  so `!` is invalid.
- The `$:?` tag is neither a global
  URI tag nor a local tag starting
  with "!".
```

Tag Shorthands

A _tag shorthand_ consists of a valid [tag handle](#tag/handle/) followed by a
non-empty suffix.
The [tag handle](#tag/handle/) must be associated with a
[prefix](#tag/prefix/), either by default or by using a ["**`TAG`**"
directive](#directive/TAG/).
The resulting [parsed](#parse//) [tag](#tag//) is the concatenation of the
[prefix](#tag/prefix/) and the suffix, and must either begin with
["**`!`**"](#! tag indicator/! local tag/) (a [local tag](#tag/local/)) or be a
valid URI (a [global tag](#tag/global/)).

The choice of [tag handle](#tag/handle/) is a [presentation
detail](#presentation/detail/) and must not be used to convey
[content](#content//) information.
In particular, the [tag handle](#tag/handle/) may be discarded once
[parsing](#parse//) is completed.

The suffix must not contain any ["**`!`**"](#! tag indicator/!…! named handle/)
character.
This would cause the tag shorthand to be interpreted as having a [named tag
handle](#tag/handle/named).
In addition, the suffix must not contain the ["**`[`**"](#[ start flow
sequence//), ["**`]`**"](#] end flow sequence//), ["**`{`**"](#{ start flow
mapping//), ["**`}`**"](#} end flow mapping//) and ["**`,`**"](#, end flow
entry//) characters.
These characters would cause ambiguity with [flow
collection](#style/flow/collection) structures.
If the suffix needs to specify any of the above restricted characters, they
must be [escaped](#% escaping in URI//) using the ["**`%`**"](#% escaping in
URI//) character.
This behavior is consistent with the URI character escaping rules
(specifically, section 2.3 of [RFC2396](http://www.ietf.org/rfc/rfc2396.txt)).

```
[99] c-ns-shorthand-tag ::=
  c-tag-handle ns-tag-char+
```

**Example 6.26. Tag Shorthands**

```
%TAG !e! tag:example.com,2000:app/
---
- `!local` foo
- `!!str` bar
- `!e!tag%21` baz
```

```
Legend:
  `[c-ns-shorthand-tag](#c-ns-shorthand-tag)`

```

```
%YAML 1.2
---
!!seq [
  !<!local> "foo",
  !<tag:yaml.org,2002:str> "bar",
  !<tag:example.com,2000:app/tag!> "baz"
]
```

**Example 6.27. Invalid Tag Shorthands**

```
%TAG !e! tag:example,2000:app/
---
- `!e!` foo
- `!h!`bar baz
```

```
ERROR:
- The `!o!` handle has no suffix.
- The `!h!` handle wasn't declared.
```

Non-Specific Tags

If a [node](#node//) has no tag property, it is assigned a [non-specific
tag](#tag/non-specific/) that needs to be [resolved](#tag/resolution/) to a
[specific](#tag/specific/) one.
This [non-specific tag](#tag/non-specific/) is ["**`!`**"](#! tag indicator/!
non-specific tag/) for non-[plain scalars](#style/flow/plain) and
["**`?`**"](#? non-specific tag//) for all other [nodes](#node//).
This is the only case where the [node style](#style//) has any effect on the
[content](#content//) information.

It is possible for the tag property to be explicitly set to the ["**`!`**"
non-specific tag](#! tag indicator/! non-specific tag/).
By [convention](#tag/resolution/convention), this "disables" [tag
resolution](#tag/resolution/), forcing the [node](#node//) to be interpreted as
"**`tag:yaml.org,2002:seq`**", "**`tag:yaml.org,2002:map`**", or
"**`tag:yaml.org,2002:str`**", according to its [kind](#kind//).

There is no way to explicitly specify the ["**`?`**" non-specific](#?
non-specific tag//) tag.
This is intentional.

```
[100] c-non-specific-tag ::= "!"
```

**Example 6.28. Non-Specific Tags**

```
# Assuming conventional resolution:
- "12"
- 12
- `!` 12
```

```
Legend:
  `[c-non-specific-tag](#c-non-specific-tag)`

```

```
%YAML 1.2
---
!!seq [
  !<tag:yaml.org,2002:str> "12",
  !<tag:yaml.org,2002:int> "12",
  !<tag:yaml.org,2002:str> "12",
]
```

### 6.9.2. Node Anchors

An anchor is denoted by the _"**`&`**" indicator_.
It marks a [node](#node//) for future reference.
An [alias node](#alias//) can then be used to indicate additional inclusions of
the anchored [node](#node//).
An anchored [node](#node//) need not be referenced by any [alias
nodes](#alias//); in particular, it is valid for all [nodes](#node//) to be
anchored.

```
[101] c-ns-anchor-property ::=
  "&" ns-anchor-name
```

Note that as a [serialization detail](#serialization/detail/), the anchor name
is preserved in the [serialization tree](#serialization//).
However, it is not reflected in the [representation](#representation//) graph
and must not be used to convey [content](#content//) information.
In particular, the YAML [processor](#processor//) need not preserve the anchor
name once the [representation](#representation//) is [composed](#compose//).

Anchor names must not contain the ["**`[`**"](#[ start flow sequence//),
["**`]`**"](#] end flow sequence//), ["**`{`**"](#{ start flow mapping//),
["**`}`**"](#} end flow mapping//) and ["**`,`**"](#, end flow entry//)
characters.
These characters would cause ambiguity with [flow
collection](#style/flow/collection) structures.

```
[102] ns-anchor-char ::=
  ns-char - c-flow-indicator
```

```
[103] ns-anchor-name ::= ns-anchor-char+
```

**Example 6.29. Node Anchors**

```
First occurrence: `&`anchor`` Value
Second occurrence: *`anchor`
```

```
Legend:
  `[c-ns-anchor-property](#c-ns-anchor-property)` `[ns-anchor-name](#ns-anchor-name)`

```

```
%YAML 1.2
---
!!map {
  ? !!str "First occurrence"
  : &A !!str "Value",
  ? !!str "Second occurrence"
  : *A,
}
```

# Chapter 7. Flow Styles

YAML’s _flow styles_ can be thought of as the natural extension of JSON to
cover [folding](#line folding//) long content lines for readability,
[tagging](#tag//) nodes to control [construction](#construct//) of [native data
structures](#native data structure//), and using [anchors](#anchor//) and
[aliases](#alias//) to reuse [constructed](#construct//) object instances.

## 7.1. Alias Nodes

Subsequent occurrences of a previously [serialized](#serialize//) node are
[presented](#present//) as _alias nodes_.
The first occurrence of the [node](#node//) must be marked by an
[anchor](#anchor//) to allow subsequent occurrences to be
[presented](#present//) as alias nodes.

An alias node is denoted by the _"**`*`**" indicator_.
The alias refers to the most recent preceding [node](#node//) having the same
[anchor](#anchor//).
It is an error for an alias node to use an [anchor](#anchor//) that does not
previously occur in the [document](#document//).
It is not an error to specify an [anchor](#anchor//) that is not used by any
alias node.

Note that an alias node must not specify any [properties](#node/property/) or
[content](#content//), as these were already specified at the first occurrence
of the [node](#node//).

```
[104] c-ns-alias-node ::=
  "*" ns-anchor-name
```

**Example 7.1. Alias Nodes**

```
First occurrence: &`anchor` Foo
Second occurrence: `*`anchor``
Override anchor: &`anchor` Bar
Reuse anchor: `*`anchor``
```

```
Legend:
  `[c-ns-alias-node](#c-ns-alias-node)` `[ns-anchor-name](#ns-anchor-name)`

```

```
%YAML 1.2
---
!!map {
  ? !!str "First occurrence"
  : &A !!str "Foo",
  ? !!str "Override anchor"
  : &B !!str "Bar",
  ? !!str "Second occurrence"
  : *A,
  ? !!str "Reuse anchor"
  : *B,
}
```

## 7.2. Empty Nodes

YAML allows the [node content](#content//) to be omitted in many cases.
[Nodes](#node//) with empty [content](#content//) are interpreted as if they
were [plain scalars](#style/flow/plain) with an empty value.
Such [nodes](#node//) are commonly resolved to a
["**`null`**"](#tag/repository/null) value.

```
[105] e-scalar ::=
  /* Empty */
```

In the examples, empty [scalars](#scalar//) are sometimes displayed as the
glyph "**`°`**" for clarity.
Note that this glyph corresponds to a position in the characters
[stream](#stream//) rather than to an actual character.

**Example 7.2. Empty Content**

```
{
  foo : !!str`°`,
  !!str`°` : bar,
}
```

```
Legend:
  `[e-scalar](#e-scalar)`

```

```
%YAML 1.2
---
!!map {
  ? !!str "foo" : !!str "",
  ? !!str ""    : !!str "bar",
}
```

Both the [node’s properties](#node/property/) and [node content](#content//)
are optional.
This allows for a _completely empty node_.
Completely empty nodes are only valid when following some explicit indication
for their existence.

```
[106] e-node ::= e-scalar
```

**Example 7.3. Completely Empty Flow Nodes**

```
{
  ? foo :`°`,
  `°`: bar,
}
```

```
Legend:
  `[e-node](#e-node)`

```

```
%YAML 1.2
---
!!map {
  ? !!str "foo" : !!null "",
  ? !!null ""   : !!str "bar",
}
```

## 7.3. Flow Scalar Styles

YAML provides three _flow scalar styles_:
[double-quoted](#style/flow/double-quoted),
[single-quoted](#style/flow/single-quoted) and [plain](#style/flow/plain)
(unquoted).
Each provides a different trade-off between readability and expressive power.

The [scalar style](#style/scalar/) is a [presentation
detail](#presentation/detail/) and must not be used to convey
[content](#content//) information, with the exception that [plain
scalars](#style/flow/plain) are distinguished for the purpose of [tag
resolution](#tag/resolution/).

### 7.3.1. Double-Quoted Style

The _double-quoted style_ is specified by surrounding _"**`"`**" indicators_.
This is the only [style](#style//) capable of expressing arbitrary strings, by
using ["**`\`**"](#\ escaping in double-quoted scalars//) [escape
sequences](#escaping/in double-quoted scalars/).
This comes at the cost of having to escape the ["**`\`**"](#\ escaping in
double-quoted scalars//) and "**`"`**" characters.

```
[107] nb-double-char ::=
  c-ns-esc-char | ( nb-json - "\" - '"' )
```

```
[108] ns-double-char ::=
  nb-double-char - s-white
```

Double-quoted scalars are restricted to a single line when contained inside an
[implicit key](#key/implicit/).

```
[109] c-double-quoted(n,c) ::=
  '"' nb-double-text(n,c) '"'
```

```
[110] nb-double-text(n,c) ::=
  c = flow-out  ⇒ nb-double-multi-line(n)
  c = flow-in   ⇒ nb-double-multi-line(n)
  c = block-key ⇒ nb-double-one-line
  c = flow-key  ⇒ nb-double-one-line
```

```
[111] nb-double-one-line ::= nb-double-char*
```

**Example 7.4. Double Quoted Implicit Keys**

```
`"`implicit block key`"` : [
  `"`implicit flow key`"` : value,
 ]
```

```
Legend:
  `[nb-double-one-line](#nb-double-one-line)`
  `[c-double-quoted(n,c)](#c-double-quoted(n,c))`

```

```
%YAML 1.2
---
!!map {
  ? !!str "implicit block key"
  : !!seq [
    !!map {
      ? !!str "implicit flow key"
      : !!str "value",
    }
  ]
}
```

In a multi-line double-quoted scalar, [line breaks](#line break//) are subject
to [flow line folding](#line folding/flow/), which discards any trailing [white
space](#space/white/) characters.
It is also possible to _escape_ the [line break](#line break//) character.
In this case, the [line break](#line break//) is excluded from the
[content](#content//), and the trailing [white space](#space/white/) characters
are preserved.
Combined with the ability to [escape](#escaping/in double-quoted scalars/)
[white space](#space/white/) characters, this allows double-quoted lines to be
broken at arbitrary positions.

```
[112] s-double-escaped(n) ::=
  s-white* "\" b-non-content
  l-empty(n,flow-in)* s-flow-line-prefix(n)
```

```
[113] s-double-break(n) ::=
  s-double-escaped(n) | s-flow-folded(n)
```

**Example 7.5. Double Quoted Line Breaks**

```
"folded`·↓`
to a space,`→↓
·↓`
to a line feed, or`·→\↓
·`\\·→non-content"
```

```
%YAML 1.2
---
!!str "folded to a space,\\n\\
      to a line feed, \\
      or \\t \\tnon-content"
```

```
Legend:
  `[s-flow-folded(n)](#s-flow-folded(n))` `[s-double-escaped(n)](#s-double-escaped(n))`

```

All leading and trailing [white space](#space/white/) characters are excluded
from the [content](#content//).
Each continuation line must therefore contain at least one
non-[space](#space/white/) character.
Empty lines, if any, are consumed as part of the [line folding](#line
folding//).

```
[114] nb-ns-double-in-line ::=
  ( s-white* ns-double-char )*
```

```
[115] s-double-next-line(n) ::=
  s-double-break(n)
  ( ns-double-char nb-ns-double-in-line
    ( s-double-next-line(n) | s-white* ) )?
```

```
[116] nb-double-multi-line(n) ::=
  nb-ns-double-in-line
  ( s-double-next-line(n) | s-white* )
```

**Example 7.6. Double Quoted Lines**

```
"`·1st non-empty``↓
↓
·`2nd non-empty```·
→`3rd non-empty``·"
```

```
%YAML 1.2
---
!!str " 1st non-empty\\n\\
      2nd non-empty \\
      3rd non-empty "
```

```
Legend:
  `[nb-ns-double-in-line](#nb-ns-double-in-line)` `[s-double-next-line(n)](#s-double-next-line(n))`

```

### 7.3.2. Single-Quoted Style

The _single-quoted style_ is specified by surrounding _"**`'`**" indicators_.
Therefore, within a single-quoted scalar, such characters need to be repeated.
This is the only form of _escaping_ performed in single-quoted scalars.
In particular, the "**`\`**" and "**`"`**" characters may be freely used.
This restricts single-quoted scalars to [printable](#printable character//)
characters.
In addition, it is only possible to break a long single-quoted line where a
[space](#space//) character is surrounded by non-[spaces](#space/white/).

```
[117] c-quoted-quote ::=
  "'" "'"
```

```
[118] nb-single-char ::=
  c-quoted-quote | ( nb-json - "'" )
```

```
[119] ns-single-char ::=
  nb-single-char - s-white
```

**Example 7.7. Single Quoted Characters**

```
 'here`''`s to "quotes"'
```

```
Legend:
  `[c-quoted-quote](#c-quoted-quote)`

```

```
%YAML 1.2
---
!!str "here's to \\"quotes\\""
```

Single-quoted scalars are restricted to a single line when contained inside a
[implicit key](#key/implicit/).

```
[120] c-single-quoted(n,c) ::=
  "'" nb-single-text(n,c) "'"
```

```
[121] nb-single-text(n,c) ::=
  c = flow-out  ⇒ nb-single-multi-line(n)
  c = flow-in   ⇒ nb-single-multi-line(n)
  c = block-key ⇒ nb-single-one-line
  c = flow-key  ⇒ nb-single-one-line
```

```
[122] nb-single-one-line ::= nb-single-char*
```

**Example 7.8. Single Quoted Implicit Keys**

```
`'`implicit block key`'` : [
  `'`implicit flow key`'` : value,
 ]
```

```
Legend:
  `[nb-single-one-line](#nb-single-one-line)`
  `[c-single-quoted(n,c)](#c-single-quoted(n,c))`

```

```
%YAML 1.2
---
!!map {
  ? !!str "implicit block key"
  : !!seq [
    !!map {
      ? !!str "implicit flow key"
      : !!str "value",
    }
  ]
}
```

All leading and trailing [white space](#space/white/) characters are excluded
from the [content](#content//).
Each continuation line must therefore contain at least one
non-[space](#space/white/) character.
Empty lines, if any, are consumed as part of the [line folding](#line
folding//).

```
[123] nb-ns-single-in-line ::=
  ( s-white* ns-single-char )*
```

```
[124] s-single-next-line(n) ::=
  s-flow-folded(n)
  ( ns-single-char nb-ns-single-in-line
    ( s-single-next-line(n) | s-white* ) )?
```

```
[125] nb-single-multi-line(n) ::=
  nb-ns-single-in-line
  ( s-single-next-line(n) | s-white* )
```

**Example 7.9. Single Quoted Lines**

```
'`·1st non-empty``↓
↓
·`2nd non-empty```·
→`3rd non-empty``·'
```

```
%YAML 1.2
---
!!str " 1st non-empty\\n\\
      2nd non-empty \\
      3rd non-empty "
```

```
Legend:
  `[nb-ns-single-in-line(n)](#nb-ns-single-in-line)` `[s-single-next-line(n)](#s-single-next-line(n))`

```

### 7.3.3. Plain Style

The _plain_ (unquoted) style has no identifying [indicators](#indicator//) and
provides no form of escaping.
It is therefore the most readable, most limited and most [context](#context//)
sensitive [style](#style//).
In addition to a restricted character set, a plain scalar must not be empty, or
contain leading or trailing [white space](#space/white/) characters.
It is only possible to break a long plain line where a [space](#space//)
character is surrounded by non-[spaces](#space/white/).

Plain scalars must not begin with most [indicators](#indicator//), as this
would cause ambiguity with other YAML constructs.
However, the ["**`:`**"](#: mapping value//), ["**`?`**"](#? mapping key//) and
["**`-`**"](#- block sequence entry//) [indicators](#indicator//) may be used
as the first character if followed by a non-[space](#space/white/) "safe"
character, as this causes no ambiguity.

```
[126] ns-plain-first(c) ::=
    ( ns-char - c-indicator )
  | ( ( "?" | ":" | "-" )
      /* Followed by an ns-plain-safe(c)) */ )
```

Plain scalars must never contain the ["**`:`** "](#: mapping value//) and ["
**`#`**"](## comment//) character combinations.
Such combinations would cause ambiguity with [mapping](#mapping//) [key: value
pairs](#key: value pair//) and [comments](#comment//).
In addition, inside [flow collections](#style/flow/collection), or when used as
[implicit keys](#key/implicit/), plain scalars must not contain the
["**`[`**"](#[ start flow sequence//), ["**`]`**"](#] end flow sequence//),
["**`{`**"](#{ start flow mapping//), ["**`}`**"](#} end flow mapping//) and
["**`,`**"](#, end flow entry//) characters.
These characters would cause ambiguity with [flow
collection](#style/flow/collection) structures.

```
[127] ns-plain-safe(c) ::=
  c = flow-out  ⇒ ns-plain-safe-out
  c = flow-in   ⇒ ns-plain-safe-in
  c = block-key ⇒ ns-plain-safe-out
  c = flow-key  ⇒ ns-plain-safe-in
```

```
[128] ns-plain-safe-out ::= ns-char
```

```
[129] ns-plain-safe-in ::=
  ns-char - c-flow-indicator
```

```
[130] ns-plain-char(c) ::=
    ( ns-plain-safe(c) - ":" - "#" )
  | ( /* An ns-char preceding */ "#" )
  | ( ":" /* Followed by an ns-plain-safe(c) */ )
```

**Example 7.10. Plain Characters**

```
# Outside flow collection:
- `:``:`vector
- ": - ()"
- Up`,` up, and away!
- `-`123
- http`:`//example.com/foo`#`bar
# Inside flow collection:
- [ `:``:`vector,
  ": - ()",
  "Up`,` up and away!",
  `-`123,
  http`:`//example.com/foo`#`bar ]
```

```
%YAML 1.2
---
!!seq [
  !!str "::vector",
  !!str ": - ()",
  !!str "Up, up, and away!",
  !!int "-123",
  !!str "http://example.com/foo#bar",
  !!seq [
    !!str "::vector",
    !!str ": - ()",
    !!str "Up, up, and away!",
    !!int "-123",
    !!str "http://example.com/foo#bar",
  ],
]
```

```
Legend:
  `[ns-plain-first(c)](#ns-plain-first(c))` Not ns-plain-first(c) `[ns-plain-char(c)](#ns-plain-char(c))` `Not ns-plain-char(c)`

```

Plain scalars are further restricted to a single line when contained inside an
[implicit key](#key/implicit/).

```
[131] ns-plain(n,c) ::=
  c = flow-out  ⇒ ns-plain-multi-line(n,c)
  c = flow-in   ⇒ ns-plain-multi-line(n,c)
  c = block-key ⇒ ns-plain-one-line(c)
  c = flow-key  ⇒ ns-plain-one-line(c)
```

```
[132] nb-ns-plain-in-line(c) ::=
  ( s-white* ns-plain-char(c) )*
```

```
[133] ns-plain-one-line(c) ::=
  ns-plain-first(c) nb-ns-plain-in-line(c)
```

**Example 7.11. Plain Implicit Keys**

```
`implicit block key` : [
  `implicit flow key` : value,
 ]
```

```
Legend:
  `[ns-plain-one-line(c)](#ns-plain-one-line(c))`

```

```
%YAML 1.2
---
!!map {
  ? !!str "implicit block key"
  : !!seq [
    !!map {
      ? !!str "implicit flow key"
      : !!str "value",
    }
  ]
}
```

All leading and trailing [white space](#space/white/) characters are excluded
from the [content](#content//).
Each continuation line must therefore contain at least one
non-[space](#space/white/) character.
Empty lines, if any, are consumed as part of the [line folding](#line
folding//).

```
[134] s-ns-plain-next-line(n,c) ::=
  s-flow-folded(n)
  ns-plain-char(c) nb-ns-plain-in-line(c)
```

```
[135] ns-plain-multi-line(n,c) ::=
  ns-plain-one-line(c)
  s-ns-plain-next-line(n,c)*
```

**Example 7.12. Plain Lines**

```
`1st non-empty``↓
↓
·`2nd non-empty```·
→`3rd non-empty``
```

```
%YAML 1.2
---
!!str "1st non-empty\\n\\
      2nd non-empty \\
      3rd non-empty"
```

```
Legend:
  `[nb-ns-plain-in-line(c)](#nb-ns-plain-in-line(c))` `[s-ns-plain-next-line(n,c)](#s-ns-plain-next-line(n,c))`

```

## 7.4. Flow Collection Styles

A _flow collection_ may be nested within a [block
collection](#style/block/collection) ([**`flow-out`**
context](#context/flow-out/)), nested within another flow collection
([**`flow-in`** context](#context/flow-in/)), or be a part of an [implicit
key](#key/implicit/) ([**`flow-key`** context](#context/flow-key/) or
[**`block-key`** context](#context/block-key/)).
Flow collection entries are terminated by the _"**`,`**" indicator_.
The final "**`,`**" may be omitted.
This does not cause ambiguity because flow collection entries can never be
[completely empty](#node/completely empty/).

```
[136] in-flow(c) ::=
  c = flow-out  ⇒ flow-in
  c = flow-in   ⇒ flow-in
  c = block-key ⇒ flow-key
  c = flow-key  ⇒ flow-key
```

### 7.4.1. Flow Sequences

_Flow sequence content_ is denoted by surrounding _"**`[`**"_ and _"**`]`**"_
characters.

```
[137] c-flow-sequence(n,c) ::=
  "[" s-separate(n,c)?
  ns-s-flow-seq-entries(n,in-flow(c))? "]"
```

Sequence entries are separated by a ["**`,`**"](#, end flow entry//) character.

```
[138] ns-s-flow-seq-entries(n,c) ::=
  ns-flow-seq-entry(n,c) s-separate(n,c)?
  ( "," s-separate(n,c)?
    ns-s-flow-seq-entries(n,c)? )?
```

**Example 7.13. Flow Sequence**

```
- `[` `one`, `two`, `]`
- `[``three` ,`four``]`
```

```
Legend:
  `[c-sequence-start](#c-sequence-start)` `[c-sequence-end](#c-sequence-end)`
  `[ns-flow-seq-entry(n,c)](#ns-flow-seq-entry(n,c))`

```

```
%YAML 1.2
---
!!seq [
  !!seq [
    !!str "one",
    !!str "two",
  ],
  !!seq [
    !!str "three",
    !!str "four",
  ],
]
```

Any [flow node](#style/flow/) may be used as a flow sequence entry.
In addition, YAML provides a [compact notation](#style/single key:value pair
mapping/) for the case where a flow sequence entry is a [mapping](#mapping//)
with a [single key: value pair](#style/single key:value pair mapping/).

```
[139] ns-flow-seq-entry(n,c) ::=
  ns-flow-pair(n,c) | ns-flow-node(n,c)
```

**Example 7.14. Flow Sequence Entries**

```
[
`"double
 quoted"`, `'single
           quoted'`,
`plain
 text`, `[ nested ]`,
`single: pair`,
]
```

```
Legend:
  `[ns-flow-node(n,c)](#ns-flow-node(n,c))` `[ns-flow-pair(n,c)](#ns-flow-pair(n,c))`

```

```
%YAML 1.2
---
!!seq [
  !!str "double quoted",
  !!str "single quoted",
  !!str "plain text",
  !!seq [
    !!str "nested",
  ],
  !!map {
    ? !!str "single"
    : !!str "pair",
  },
]
```

### 7.4.2. Flow Mappings

_Flow mappings_ are denoted by surrounding _"**`{`**"_ and _"**`}`**"_
characters.

```
[140] c-flow-mapping(n,c) ::=
  "{" s-separate(n,c)?
  ns-s-flow-map-entries(n,in-flow(c))? "}"
```

Mapping entries are separated by a ["**`,`**"](#, end flow entry//) character.

```
[141] ns-s-flow-map-entries(n,c) ::=
  ns-flow-map-entry(n,c) s-separate(n,c)?
  ( "," s-separate(n,c)?
    ns-s-flow-map-entries(n,c)? )?
```

**Example 7.15. Flow Mappings**

```
- `{` `one : two` , `three: four` , `}`
- `{``five: six`,`seven : eight``}`
```

```
Legend:
  `[c-mapping-start](#c-mapping-start)` `[c-mapping-end](#c-mapping-end)`
  `[ns-flow-map-entry(n,c)](#ns-flow-map-entry(n,c))`

```

```
%YAML 1.2
---
!!seq [
  !!map {
    ? !!str "one"   : !!str "two",
    ? !!str "three" : !!str "four",
  },
  !!map {
    ? !!str "five"  : !!str "six",
    ? !!str "seven" : !!str "eight",
  },
]
```

If the optional _"**`?`**" mapping key indicator_ is specified, the rest of the
entry may be [completely empty](#node/completely empty/).

```
[142] ns-flow-map-entry(n,c) ::=
    ( "?" s-separate(n,c)
      ns-flow-map-explicit-entry(n,c) )
  | ns-flow-map-implicit-entry(n,c)
```

```
[143] ns-flow-map-explicit-entry(n,c) ::=
    ns-flow-map-implicit-entry(n,c)
  | ( e-node /* Key */
      e-node /* Value */ )
```

**Example 7.16. Flow Mapping Entries**

```
{
? `explicit: entry`,
`implicit: entry`,
?°°
}
```

```
Legend:
  `[ns-flow-map-explicit-entry(n,c)](#ns-flow-map-explicit-entry(n,c))`
  `[ns-flow-map-implicit-entry(n,c)](#ns-flow-map-implicit-entry(n,c))`
  [e-node](#e-node)

```

```
%YAML 1.2
---
!!map {
  ? !!str "explicit" : !!str "entry",
  ? !!str "implicit" : !!str "entry",
  ? !!null "" : !!null "",
}
```

Normally, YAML insists the _"**`:`**" mapping value indicator_ be
[separated](#space/separation/) from the [value](#value//) by [white
space](#space/white/).
A benefit of this restriction is that the "**`:`**" character can be used
inside [plain scalars](#style/flow/plain), as long as it is not followed by
[white space](#space/white/).
This allows for unquoted URLs and timestamps.
It is also a potential source for confusion as "**`a:1`**" is a [plain
scalar](#style/flow/plain) and not a [key: value pair](#key: value pair//).

Note that the [value](#value//) may be [completely empty](#node/completely
empty/) since its existence is indicated by the "**`:`**".

```
[144] ns-flow-map-implicit-entry(n,c) ::=
    ns-flow-map-yaml-key-entry(n,c)
  | c-ns-flow-map-empty-key-entry(n,c)
  | c-ns-flow-map-json-key-entry(n,c)
```

```
[145] ns-flow-map-yaml-key-entry(n,c) ::=
  ns-flow-yaml-node(n,c)
  ( ( s-separate(n,c)?
      c-ns-flow-map-separate-value(n,c) )
  | e-node )
```

```
[146] c-ns-flow-map-empty-key-entry(n,c) ::=
  e-node /* Key */
  c-ns-flow-map-separate-value(n,c)
```

```
[147] c-ns-flow-map-separate-value(n,c) ::=
  ":" /* Not followed by an
         ns-plain-safe(c) */
  ( ( s-separate(n,c) ns-flow-node(n,c) )
  | e-node /* Value */ )
```

**Example 7.17. Flow Mapping Separate Values**

```
{
`unquoted`·`:·"separate"`,
`http://foo.com`,
`omitted value``:°`,
°`:·omitted key`,
}
```

```
Legend:
  `[ns-flow-yaml-node(n,c)](#ns-flow-yaml-node(n,c))` [e-node](#e-node)
  `[c-ns-flow-map-separate-value(n,c)](#c-ns-flow-map-separate-value(n,c))`

```

```
%YAML 1.2
---
!!map {
  ? !!str "unquoted" : !!str "separate",
  ? !!str "http://foo.com" : !!null "",
  ? !!str "omitted value" : !!null "",
  ? !!null "" : !!str "omitted key",
}
```

To ensure [JSON compatibility](#JSON compatibility//), if a [key](#key//)
inside a flow mapping is [JSON-like](#JSON-like//), YAML allows the following
[value](#value//) to be specified adjacent to the "**`:`**".
This causes no ambiguity, as all [JSON-like](#JSON-like//) [keys](#key//) are
surrounded by [indicators](#indicator//).
However, as this greatly reduces readability, YAML [processors](#processor//)
should [separate](#space/separation/) the [value](#value//) from the "**`:`**"
on output, even in this case.

```
[148] c-ns-flow-map-json-key-entry(n,c) ::=
  c-flow-json-node(n,c)
  ( ( s-separate(n,c)?
      c-ns-flow-map-adjacent-value(n,c) )
  | e-node )
```

```
[149] c-ns-flow-map-adjacent-value(n,c) ::=
  ":" ( ( s-separate(n,c)?
          ns-flow-node(n,c) )
      | e-node ) /* Value */
```

**Example 7.18. Flow Mapping Adjacent Values**

```
{
`"adjacent"`:`value`,
`"readable"`:`·value`,
`"empty"`:°
}
```

```
Legend:
  `[c-flow-json-node(n,c)](#c-flow-json-node(n,c))` [e-node](#e-node)
  `[c-ns-flow-map-adjacent-value(n,c)](#c-ns-flow-map-adjacent-value(n,c))`

```

```
%YAML 1.2
---
!!map {
  ? !!str "adjacent" : !!str "value",
  ? !!str "readable" : !!str "value",
  ? !!str "empty"    : !!null "",
}
```

A more compact notation is usable inside [flow
sequences](#style/flow/sequence), if the [mapping](#mapping//) contains a
_single key: value pair_.
This notation does not require the surrounding "**`{`**" and "**`}`**"
characters.
Note that it is not possible to specify any [node properties](#node/property/)
for the [mapping](#mapping//) in this case.

**Example 7.19. Single Pair Flow Mappings**

```
[
`foo: bar`
]
```

```
Legend:
  `[ns-flow-pair(n,c)](#ns-flow-pair(n,c))`

```

```
%YAML 1.2
---
!!seq [
  !!map { ? !!str "foo" : !!str "bar" }
]
```

If the "**`?`**" indicator is explicitly specified, [parsing](#parse//) is
unambiguous, and the syntax is identical to the general case.

```
[150] ns-flow-pair(n,c) ::=
    ( "?" s-separate(n,c)
      ns-flow-map-explicit-entry(n,c) )
  | ns-flow-pair-entry(n,c)
```

**Example 7.20. Single Pair Explicit Entry**

```
[
? `foo
 bar : baz`
]
```

```
Legend:
  `[ns-flow-map-explicit-entry(n,c)](#ns-flow-map-explicit-entry(n,c))`

```

```
%YAML 1.2
---
!!seq [
  !!map {
    ? !!str "foo bar"
    : !!str "baz",
  },
]
```

If the "**`?`**" indicator is omitted, [parsing](#parse//) needs to see past
the _implicit key_ to recognize it as such.
To limit the amount of lookahead required, the "**`:`**" indicator must appear
at most 1024 Unicode characters beyond the start of the [key](#key//).
In addition, the [key](#key//) is restricted to a single line.

Note that YAML allows arbitrary [nodes](#node//) to be used as [keys](#key//).
In particular, a [key](#key//) may be a [sequence](#sequence//) or a
[mapping](#mapping//).
Thus, without the above restrictions, practical one-pass [parsing](#parse//)
would have been impossible to implement.

```
[151] ns-flow-pair-entry(n,c) ::=
    ns-flow-pair-yaml-key-entry(n,c)
  | c-ns-flow-map-empty-key-entry(n,c)
  | c-ns-flow-pair-json-key-entry(n,c)
```

```
[152] ns-flow-pair-yaml-key-entry(n,c) ::=
  ns-s-implicit-yaml-key(flow-key)
  c-ns-flow-map-separate-value(n,c)
```

```
[153] c-ns-flow-pair-json-key-entry(n,c) ::=
  c-s-implicit-json-key(flow-key)
  c-ns-flow-map-adjacent-value(n,c)
```

```
[154] ns-s-implicit-yaml-key(c) ::=
  ns-flow-yaml-node(n/a,c) s-separate-in-line?
  /* At most 1024 characters altogether */
```

```
[155] c-s-implicit-json-key(c) ::=
  c-flow-json-node(n/a,c) s-separate-in-line?
  /* At most 1024 characters altogether */
```

**Example 7.21. Single Pair Implicit Entries**

```
- [ `YAML·``: separate` ]
- [ `°``: empty key entry` ]
- [ {JSON: like}`:adjacent` ]
```

```
Legend:
  `[ns-s-implicit-yaml-key](#ns-s-implicit-yaml-key(c))`
  [c-s-implicit-json-key](#c-s-implicit-json-key(c))
  `[e-node](#e-node)` `Value`

```

```
%YAML 1.2
---
!!seq [
  !!seq [
    !!map {
      ? !!str "YAML"
      : !!str "separate"
    },
  ],
  !!seq [
    !!map {
      ? !!null ""
      : !!str "empty key entry"
    },
  ],
  !!seq [
    !!map {
      ? !!map {
        ? !!str "JSON"
        : !!str "like"
      } : "adjacent",
    },
  ],
]
```

**Example 7.22. Invalid Implicit Keys**

```
[ `foo
 bar`: invalid,
 `"foo_...>1K characters..._bar"`: invalid ]
```

```
ERROR:
- The `foo bar` key spans multiple lines
- The `foo...bar` key is too long
```

## 7.5. Flow Nodes

_JSON-like_ [flow styles](#style/flow/) all have explicit start and end
[indicators](#indicator//).
The only [flow style](#style/flow/) that does not have this property is the
[plain scalar](#style/flow/plain).
Note that none of the "JSON-like" styles is actually acceptable by JSON.
Even the [double-quoted style](#style/flow/double-quoted) is a superset of the
JSON string format.

```
[156] ns-flow-yaml-content(n,c) ::= ns-plain(n,c)
```

```
[157] c-flow-json-content(n,c) ::=
    c-flow-sequence(n,c) | c-flow-mapping(n,c)
  | c-single-quoted(n,c) | c-double-quoted(n,c)
```

```
[158] ns-flow-content(n,c) ::=
  ns-flow-yaml-content(n,c) | c-flow-json-content(n,c)
```

**Example 7.23. Flow Content**

```
- `[ a, b ]`
- `{ a: b }`
- `"a"`
- `'b'`
- `c`
```

```
Legend:
  `[c-flow-json-content(n,c)](#c-flow-json-content(n,c))`
  `[ns-flow-yaml-content(n,c)](#ns-flow-yaml-content(n,c))`

```

```
%YAML 1.2
---
!!seq [
  !!seq [ !!str "a", !!str "b" ],
  !!map { ? !!str "a" : !!str "b" },
  !!str "a",
  !!str "b",
  !!str "c",
]
```

A complete [flow](#style/flow/) [node](#node//) also has optional [node
properties](#node/property/), except for [alias nodes](#alias//) which refer to
the [anchored](#anchor//) [node properties](#node/property/).

```
[159] ns-flow-yaml-node(n,c) ::=
    c-ns-alias-node
  | ns-flow-yaml-content(n,c)
  | ( c-ns-properties(n,c)
      ( ( s-separate(n,c)
          ns-flow-yaml-content(n,c) )
        | e-scalar ) )
```

```
[160] c-flow-json-node(n,c) ::=
  ( c-ns-properties(n,c) s-separate(n,c) )?
  c-flow-json-content(n,c)
```

```
[161] ns-flow-node(n,c) ::=
    c-ns-alias-node
  | ns-flow-content(n,c)
  | ( c-ns-properties(n,c)
      ( ( s-separate(n,c)
          ns-flow-content(n,c) )
        | e-scalar ) )
```

**Example 7.24. Flow Nodes**

```
- `!!str "a"`
- `'b'`
- `&anchor "c"`
- `*anchor`
- `!!str°`
```

```
Legend:
  `[c-flow-json-node(n,c)](#c-flow-json-node(n,c))`
  `[ns-flow-yaml-node(n,c)](#ns-flow-yaml-node(n,c))`

```

```
%YAML 1.2
---
!!seq [
  !!str "a",
  !!str "b",
  &A !!str "c",
  *A,
  !!str "",
]
```

# Chapter 8. Block Styles

YAML’s _block styles_ employ [indentation](#space/indentation/) rather than
[indicators](#indicator//) to denote structure.
This results in a more human readable (though less compact) notation.

## 8.1. Block Scalar Styles

YAML provides two _block scalar styles_, [literal](#style/block/literal) and
[folded](#style/block/folded).
Each provides a different trade-off between readability and expressive power.

### 8.1.1. Block Scalar Headers

[Block scalars](#style/block/scalar) are controlled by a few
[indicators](#indicator//) given in a _header_ preceding the
[content](#content//) itself.
This header is followed by a non-content [line break](#line break//) with an
optional [comment](#comment//).
This is the only case where a [comment](#comment//) must not be followed by
additional [comment](#comment//) lines.

```
[162] c-b-block-header(m,t) ::=
  ( ( c-indentation-indicator(m)
      c-chomping-indicator(t) )
  | ( c-chomping-indicator(t)
      c-indentation-indicator(m) ) )
  s-b-comment
```

**Example 8.1. Block Scalar Header**

```
- | `# Empty header↓`
 literal
- >`1 # Indentation indicator↓`
 ·folded
- |`+ # Chomping indicator↓`
 keep

- >`1- # Both indicators↓`
 ·strip
```

```
%YAML 1.2
---
!!seq [
  !!str "literal\\n",
  !!str "·folded\\n",
  !!str "keep\\n\\n",
  !!str "·strip",
]
```

```
 Legend:
   `[c-b-block-header(m,t)](#c-b-block-header(m,t))`

```

#### 8.1.1.1. Block Indentation Indicator

Typically, the [indentation](#space/indentation/) level of a [block
scalar](#style/block/scalar) is detected from its first non-[empty](#empty
line//) line.
It is an error for any of the leading [empty lines](#empty line//) to contain
more [spaces](#space//) than the first non-[empty line](#empty line//).

Detection fails when the first non-[empty line](#empty line//) contains leading
content [space](#space//) characters. [Content](#content//) may safely start
with a [tab](#tab//) or a ["**`#`**"](## comment//) character.

When detection would fail, YAML requires that the
[indentation](#space/indentation/) level for the [content](#content//) be given
using an explicit _indentation indicator_.
This level is specified as the integer number of the additional
[indentation](#space/indentation/) spaces used for the [content](#content//),
relative to its parent [node](#node//).

It is always valid to specify an indentation indicator for a [block
scalar](#style/block/scalar) node, though a YAML [processor](#processor//)
should only emit an explicit indentation indicator for cases where detection
will fail.

```
[163] c-indentation-indicator(m) ::=
  ns-dec-digit ⇒ m = ns-dec-digit - #x30
  /* Empty */  ⇒ m = auto-detect()
```

**Example 8.2. Block Indentation Indicator**

```
- |`°`
`·`detected
- >`°`
`·`
`··`
`··`\# detected
- |`1`
`·`·explicit
- >`°`
`·`→
`·`detected
```

```
%YAML 1.2
---
!!seq [
  !!str "detected\\n",
  !!str "\\n\\n# detected\\n",
  !!str "·explicit\\n",
  !!str "\\t·detected\\n",
]
```

```
 Legend:
   `[c-indentation-indicator(m)](#c-indentation-indicator(m))`
   `[s-indent(n)](#s-indent(n))`

```

**Example 8.3. Invalid Block Scalar Indentation Indicators**

```
- |
·`·`
·text
- >
··text
`·`text
- |2
·text
```

```
ERROR:
- A leading all-space line must
  not have too many `spaces`.
- A following text line must
  not be `less indented`.
- The text is less indented
  than the indicated level.
```

#### 8.1.1.2. Block Chomping Indicator

_Chomping_ controls how final [line breaks](#line break//) and trailing [empty
lines](#empty line//) are interpreted.
YAML provides three chomping methods:

Strip

_Stripping_ is specified by the _"**`-`**" chomping indicator_.
In this case, the final [line break](#line break//) and any trailing [empty
lines](#empty line//) are excluded from the [scalar’s content](#scalar//).

Clip

_Clipping_ is the default behavior used if no explicit chomping indicator is
specified.
In this case, the final [line break](#line break//) character is preserved in
the [scalar’s content](#scalar//).
However, any trailing [empty lines](#empty line//) are excluded from the
[scalar’s content](#scalar//).

Keep

_Keeping_ is specified by the _"**`+`**" chomping indicator_.
In this case, the final [line break](#line break//) and any trailing [empty
lines](#empty line//) are considered to be part of the [scalar’s
content](#scalar//).
These additional lines are not subject to [folding](#line folding//).

The chomping method used is a [presentation detail](#presentation/detail/) and
must not be used to convey [content](#content//) information.

```
[164] c-chomping-indicator(t) ::=
  "-"         ⇒ t = strip
  "+"         ⇒ t = keep
  /* Empty */ ⇒ t = clip
```

The interpretation of the final [line break](#line break//) of a [block
scalar](#style/block/scalar) is controlled by the chomping indicator specified
in the [block scalar header](#block scalar header//).

```
[165] b-chomped-last(t) ::=
  t = strip ⇒ b-non-content | /* End of file */
  t = clip  ⇒ b-as-line-feed | /* End of file */
  t = keep  ⇒ b-as-line-feed | /* End of file */
```

**Example 8.4. Chomping Final Line Break**

```
strip: |-
  text`↓`
clip: |
  text`↓`
keep: |+
  text`↓`
```

```
Legend:
  `[b-non-content](#b-non-content)` `[b-as-line-feed](#b-as-line-feed)`

```

```
%YAML 1.2
---
!!map {
  ? !!str "strip"
  : !!str "text",
  ? !!str "clip"
  : !!str "text\\n",
  ? !!str "keep"
  : !!str "text\\n",
}
```

The interpretation of the trailing [empty lines](#empty line//) following a
[block scalar](#style/block/scalar) is also controlled by the chomping
indicator specified in the [block scalar header](#block scalar header//).

```
[166] l-chomped-empty(n,t) ::=
  t = strip ⇒ l-strip-empty(n)
  t = clip  ⇒ l-strip-empty(n)
  t = keep  ⇒ l-keep-empty(n)
```

```
[167] l-strip-empty(n) ::=
  ( s-indent(≤n) b-non-content )*
  l-trail-comments(n)?
```

```
[168] l-keep-empty(n) ::=
  l-empty(n,block-in)*
  l-trail-comments(n)?
```

Explicit [comment](#comment//) lines may follow the trailing [empty
lines](#empty line//).
To prevent ambiguity, the first such [comment](#comment//) line must be less
[indented](#space/indentation/) than the [block scalar
content](#style/block/scalar).
Additional [comment](#comment//) lines, if any, are not so restricted.
This is the only case where the [indentation](#space/indentation/) of
[comment](#comment//) lines is constrained.

```
[169] l-trail-comments(n) ::=
  s-indent(<n) c-nb-comment-text b-comment
  l-comment*
```

**Example 8.5. Chomping Trailing Lines**

```
 # Strip
  # Comments:
strip: |-
  # text↓
`··⇓
·# Clip
··# comments:
↓`
clip: |
  # text↓
`·↓
·# Keep
··# comments:
↓`
keep: |+
  # text↓
`↓
·# Trail
··# comments.`
```

```
%YAML 1.2
---
!!map {
  ? !!str "strip"
  : !!str "# text",
  ? !!str "clip"
  : !!str "# text\\n",
  ? !!str "keep"
  : !!str "# text\\n\\n",
}
```

```
 Legend:
   `[l-strip-empty(n)](#l-strip-empty(n))`
   `[l-keep-empty(n)](#l-keep-empty(n))`
   [l-trail-comments(n)](#l-trail-comments(n))

```

If a [block scalar](#style/block/scalar) consists only of [empty lines](#empty
line//), then these lines are considered as trailing lines and hence are
affected by chomping.

**Example 8.6. Empty Scalar Chomping**

```
strip: >-
`↓`
clip: >
`↓`
keep: |+
`↓`
```

```
Legend:
  `[l-strip-empty(n)](#l-strip-empty(n))` `[l-keep-empty(n)](#l-keep-empty(n))`

```

```
%YAML 1.2
---
!!map {
  ? !!str "strip"
  : !!str "",
  ? !!str "clip"
  : !!str "",
  ? !!str "keep"
  : !!str "\\n",
}
```

### 8.1.2. Literal Style

The _literal style_ is denoted by the _"**`|`**" indicator_.
It is the simplest, most restricted, and most readable [scalar
style](#style/scalar/).

```
[170] c-l+literal(n) ::=
  "|" c-b-block-header(m,t)
  l-literal-content(n+m,t)
```

**Example 8.7. Literal Scalar**

```
`|↓
·literal↓
·→text↓
↓`
```

```
Legend:
  `[c-l+literal(n)](#c-l+literal(n))`

```

```
%YAML 1.2
---
!!str "literal\\n\\ttext\\n"
```

Inside literal scalars, all ([indented](#space/indentation/)) characters are
considered to be [content](#content//), including [white space](#space/white/)
characters.
Note that all [line break](#line break//) characters are [normalized](#line
break/normalization/).
In addition, [empty lines](#empty line//) are not
[folded](#style/block/folded), though final [line breaks](#line break//) and
trailing [empty lines](#empty line//) are [chomped](#chomping//).

There is no way to escape characters inside literal scalars.
This restricts them to [printable](#printable character//) characters.
In addition, there is no way to break a long literal line.

```
[171] l-nb-literal-text(n) ::=
  l-empty(n,block-in)*
  s-indent(n) nb-char+
```

```
[172] b-nb-literal-next(n) ::=
  b-as-line-feed
  l-nb-literal-text(n)
```

```
[173] l-literal-content(n,t) ::=
  ( l-nb-literal-text(n) b-nb-literal-next(n)*
    b-chomped-last(t) )?
  l-chomped-empty(n,t)
```

**Example 8.8. Literal Content**

```
|
`·
··
··literal``↓
`···```↓
`··
··text``↓
`↓
·# Comment`
```

```
%YAML 1.2
---
!!str "\\n\\nliteral\\n·\\n\\ntext\\n"
```

```
 Legend:
   `[l-nb-literal-text(n)](#l-nb-literal-text(n))`
   `[b-nb-literal-next(n)](#b-nb-literal-next(n))`
   [b-chomped-last(t)](#b-chomped-last(t))
   `[l-chomped-empty(n,t)](#l-chomped-empty(n,t))`

```

### 8.1.3. Folded Style

The _folded style_ is denoted by the _"**`>`**" indicator_.
It is similar to the [literal style](#style/block/literal); however, folded
scalars are subject to [line folding](#line folding/block/).

```
[174] c-l+folded(n) ::=
  ">" c-b-block-header(m,t)
  l-folded-content(n+m,t)
```

**Example 8.9. Folded Scalar**

```
`>↓
·folded↓
·text↓
↓`
```

```
%YAML 1.2
---
!!str "folded text\\n"
```

```
Legend:
  `[c-l+folded(n)](#c-l+folded(n))`

```

[Folding](#line folding//) allows long lines to be broken anywhere a single
[space](#space//) character separates two non-[space](#space/white/)
characters.

```
[175] s-nb-folded-text(n) ::=
  s-indent(n) ns-char nb-char*
```

```
[176] l-nb-folded-lines(n) ::=
  s-nb-folded-text(n)
  ( b-l-folded(n,block-in) s-nb-folded-text(n) )*
```

**Example 8.10. Folded Lines**

```
>
``·folded`↓
`·line`↓
↓
`·next`
`·line``↓
   * bullet

   * list
   * lines

``·last`↓
`·line``↓

# Comment
```

```
%YAML 1.2
---
!!str "\\n\\
      folded line\\n\\
      next line\\n\\
      \\  * bullet\\n
      \\n\\
      \\  * list\\n\\
      \\  * lines\\n\\
      \\n\\
      last line\\n"
```

```
 Legend:
   `[s-nb-folded-text(n)](#s-nb-folded-text(n))`
   `[l-nb-folded-lines(n)](#l-nb-folded-lines(n))`

```

(The following three examples duplicate this example, each highlighting
different productions.)

Lines starting with [white space](#space/white/) characters (_more-indented_
lines) are not [folded](#line folding//).

```
[177] s-nb-spaced-text(n) ::=
  s-indent(n) s-white nb-char*
```

```
[178] b-l-spaced(n) ::=
  b-as-line-feed
  l-empty(n,block-in)*
```

```
[179] l-nb-spaced-lines(n) ::=
  s-nb-spaced-text(n)
  ( b-l-spaced(n) s-nb-spaced-text(n) )*
```

**Example 8.11. More Indented Lines**

```
>
 folded
 line

 next
 line
``···* bullet`↓
↓
`···* list`↓
`···* lines``↓

 last
 line

# Comment
```

```
%YAML 1.2
---
!!str "\\n\\
      folded line\\n\\
      next line\\n\\
      \\  * bullet\\n
      \\n\\
      \\  * list\\n\\
      \\  * lines\\n\\
      \\n\\
      last line\\n"
```

```
 Legend:
   `[s-nb-spaced-text(n)](#s-nb-spaced-text(n))`
   `[l-nb-spaced-lines(n)](#l-nb-spaced-lines(n))`

```

[Line breaks](#line break//) and [empty lines](#empty line//) separating folded
and more-indented lines are also not [folded](#line folding//).

```
[180] l-nb-same-lines(n) ::=
  l-empty(n,block-in)*
  ( l-nb-folded-lines(n) | l-nb-spaced-lines(n) )
```

```
[181] l-nb-diff-lines(n) ::=
  l-nb-same-lines(n)
  ( b-as-line-feed l-nb-same-lines(n) )*
```

**Example 8.12. Empty Separation Lines**

```
>
`↓`
 folded
 line`↓`
`↓`
 next
 line`↓`
   * bullet

   * list
   * line`↓`
`↓`
 last
 line

# Comment
```

```
%YAML 1.2
---
!!str "\\n\\
      folded line\\n\\
      next line\\n\\
      \\  * bullet\\n
      \\n\\
      \\  * list\\n\\
      \\  * lines\\n\\
      \\n\\
      last line\\n"
```

```
 Legend:
   `[b-as-line-feed](#b-as-line-feed)`
   `(separation) [l-empty(n,c)](#l-empty(n,c))`

```

The final [line break](#line break//), and trailing [empty lines](#empty
line//) if any, are subject to [chomping](#chomping//) and are never
[folded](#line folding//).

```
[182] l-folded-content(n,t) ::=
  ( l-nb-diff-lines(n) b-chomped-last(t) )?
  l-chomped-empty(n,t)
```

**Example 8.13. Final Empty Lines**

```
>
 folded
 line

 next
 line
   * bullet

   * list
   * line

 last
 line`↓`
`↓
# Comment`
```

```
%YAML 1.2
---
!!str "\\n\\
      folded line\\n\\
      next line\\n\\
      \\  * bullet\\n
      \\n\\
      \\  * list\\n\\
      \\  * lines\\n\\
      \\n\\
      last line\\n"
```

```
 Legend:
   `[b-chomped-last(t)](#b-chomped-last(t))` `[l-chomped-empty(n,t)](#l-chomped-empty(n,t))`

```

## 8.2. Block Collection Styles

For readability, _block collections styles_ are not denoted by any
[indicator](#indicator//).
Instead, YAML uses a lookahead method, where a block collection is
distinguished from a [plain scalar](#style/flow/plain) only when a [key: value
pair](#key: value pair//) or a [sequence entry](#- block sequence entry//) is
seen.

### 8.2.1. Block Sequences

A _block sequence_ is simply a series of [nodes](#node//), each denoted by a
leading _"**`-`**" indicator_.
The "**`-`**" indicator must be [separated](#space/separation/) from the
[node](#node//) by [white space](#space/white/).
This allows "**`-`**" to be used as the first character in a [plain
scalar](#style/flow/plain) if followed by a non-space character (e.g.
"**`-1`**").

```
[183] l+block-sequence(n) ::=
  ( s-indent(n+m) c-l-block-seq-entry(n+m) )+
  /* For some fixed auto-detected m > 0 */
```

```
[184] c-l-block-seq-entry(n) ::=
  "-" /* Not followed by an ns-char */
  s-l+block-indented(n,block-in)
```

**Example 8.14. Block Sequence**

```
block sequence:
··`- one↓`
  `- two : three↓`
```

```
Legend:
  `[c-l-block-seq-entry(n)](#c-l-block-seq-entry(n))`
  `auto-detected [s-indent(n)](#s-indent(n))`

```

```
%YAML 1.2
---
!!map {
  ? !!str "block sequence"
  : !!seq [
    !!str "one",
    !!map {
      ? !!str "two"
      : !!str "three"
    },
  ],
}
```

The entry [node](#node//) may be either [completely empty](#node/completely
empty/), be a nested [block node](#style/block/), or use a _compact in-line
notation_.
The compact notation may be used when the entry is itself a nested [block
collection](#style/block/collection).
In this case, both the "**`-`**" indicator and the following [spaces](#space//)
are considered to be part of the [indentation](#space/indentation/) of the
nested [collection](#style/block/collection).
Note that it is not possible to specify [node properties](#node/property/) for
such a [collection](#style/block/collection).

```
[185] s-l+block-indented(n,c) ::=
    ( s-indent(m)
      ( ns-l-compact-sequence(n+1+m)
      | ns-l-compact-mapping(n+1+m) ) )
  | s-l+block-node(n,c)
  | ( e-node s-l-comments )
```

```
[186] ns-l-compact-sequence(n) ::=
  c-l-block-seq-entry(n)
  ( s-indent(n) c-l-block-seq-entry(n) )*
```

**Example 8.15. Block Sequence Entry Types**

```
-`° # Empty`
- `|
 block node`
-·- one # Compact
··- two # sequence
- `one: two # Compact mapping`
```

```
Legend:
  `Empty`
  `[s-l+block-node(n,c)](#s-l+block-node(n,c))`
  [ns-l-compact-sequence(n)](#ns-l-compact-sequence(n))
  `[ns-l-compact-mapping(n)](#ns-l-compact-mapping(n))`

```

```
%YAML 1.2
---
!!seq [
  !!null "",
  !!str "block node\\n",
  !!seq [
    !!str "one"
    !!str "two",
  ],
  !!map {
    ? !!str "one"
    : !!str "two",
  },
]
```

### 8.2.2. Block Mappings

A _Block mapping_ is a series of entries, each [presenting](#present//) a
[key: value pair](#key: value pair//).

```
[187] l+block-mapping(n) ::=
  ( s-indent(n+m) ns-l-block-map-entry(n+m) )+
  /* For some fixed auto-detected m > 0 */
```

**Example 8.16. Block Mappings**

```
block mapping:
`·``key: value↓`
```

```
Legend:
  `[ns-l-block-map-entry(n)](#ns-l-block-map-entry(n))`
  `auto-detected [s-indent(n)](#s-indent(n))`

```

```
%YAML 1.2
---
!!map {
  ? !!str "block mapping"
  : !!map {
    ? !!str "key"
    : !!str "value",
  },
}
```

If the ["**`?`**"](#? mapping key//) indicator is specified, the optional value
node must be specified on a separate line, denoted by the ["**`:`**"](#:
mapping value//) indicator.
Note that YAML allows here the same [compact in-line notation](#style/compact
block collection/) described above for [block sequence](#style/block/sequence)
entries.

```
[188] ns-l-block-map-entry(n) ::=
    c-l-block-map-explicit-entry(n)
  | ns-l-block-map-implicit-entry(n)
```

```
[189] c-l-block-map-explicit-entry(n) ::=
  c-l-block-map-explicit-key(n)
  ( l-block-map-explicit-value(n)
  | e-node )
```

```
[190] c-l-block-map-explicit-key(n) ::=
  "?" s-l+block-indented(n,block-out)
```

```
[191] l-block-map-explicit-value(n) ::=
  s-indent(n)
  ":" s-l+block-indented(n,block-out)
```

**Example 8.17. Explicit Block Mapping Entries**

```
`? explicit key # Empty value↓`°
`? |
  block key↓`
`:·- one # Explicit compact
··- two # block value↓`
```

```
Legend:
  `[c-l-block-map-explicit-key(n)](#c-l-block-map-explicit-key(n))`
  `[l-block-map-explicit-value(n)](#l-block-map-explicit-value(n))`
  [e-node](#e-node)

```

```
%YAML 1.2
---
!!map {
  ? !!str "explicit key"
  : !!str "",
  ? !!str "block key\\n"
  : !!seq [
    !!str "one",
    !!str "two",
  ],
}
```

If the "**`?`**" indicator is omitted, [parsing](#parse//) needs to see past
the [implicit key](#key/implicit/), in the same way as in the [single
key: value pair](#style/single key:value pair mapping/) [flow
mapping](#style/flow/mapping).
Hence, such [keys](#key//) are subject to the same restrictions; they are
limited to a single line and must not span more than 1024 Unicode characters.

```
[192] ns-l-block-map-implicit-entry(n) ::=
  ( ns-s-block-map-implicit-key
  | e-node )
  c-l-block-map-implicit-value(n)
```

```
[193] ns-s-block-map-implicit-key ::=
    c-s-implicit-json-key(block-key)
  | ns-s-implicit-yaml-key(block-key)
```

In this case, the [value](#value//) may be specified on the same line as the
[implicit key](#key/implicit/).
Note however that in block mappings the [value](#value//) must never be
adjacent to the "**`:`**", as this greatly reduces readability and is not
required for [JSON compatibility](#JSON compatibility//) (unlike the case in
[flow mappings](#style/flow/mapping)).

There is no compact notation for in-line [values](#value//).
Also, while both the [implicit key](#key/implicit/) and the [value](#value//)
following it may be empty, the ["**`:`**"](#: mapping value//) indicator is
mandatory.
This prevents a potential ambiguity with multi-line [plain
scalars](#style/flow/plain).

```
[194] c-l-block-map-implicit-value(n) ::=
  ":" ( s-l+block-node(n,block-out)
      | ( e-node s-l-comments ) )
```

**Example 8.18. Implicit Block Mapping Entries**

```
`plain key``: in-line value`
`°``:° # Both empty`
`"quoted key"``:
- entry`
```

```
Legend:
  `[ns-s-block-map-implicit-key](#ns-s-block-map-implicit-key)`
  `[c-l-block-map-implicit-value(n)](#c-l-block-map-implicit-value(n))`

```

```
%YAML 1.2
---
!!map {
  ? !!str "plain key"
  : !!str "in-line value",
  ? !!null ""
  : !!null "",
  ? !!str "quoted key"
  : !!seq [ !!str "entry" ],
}
```

A [compact in-line notation](#style/compact block collection/) is also
available.
This compact notation may be nested inside [block
sequences](#style/block/sequence) and explicit block mapping entries.
Note that it is not possible to specify [node properties](#node/property/) for
such a nested mapping.

```
[195] ns-l-compact-mapping(n) ::=
  ns-l-block-map-entry(n)
  ( s-indent(n) ns-l-block-map-entry(n) )*
```

**Example 8.19. Compact Block Mappings**

```
- `sun: yellow↓`
- `? `earth: blue↓`
  : `moon: white↓``
```

```
Legend:
  `[ns-l-compact-mapping(n)](#ns-l-compact-mapping(n))`

```

```
%YAML 1.2
---
!!seq [
  !!map {
     !!str "sun" : !!str "yellow",
  },
  !!map {
    ? !!map {
      ? !!str "earth"
      : !!str "blue"
    },
    : !!map {
      ? !!str "moon"
      : !!str "white"
    },
  }
]
```

### 8.2.3. Block Nodes

YAML allows [flow nodes](#style/flow/) to be embedded inside [block
collections](#style/block/collection) (but not vice-versa). [Flow
nodes](#style/flow/) must be [indented](#space/indentation/) by at least one
more [space](#space//) than the parent [block
collection](#style/block/collection).
Note that [flow nodes](#style/flow/) may begin on a following line.

It is at this point that [parsing](#parse//) needs to distinguish between a
[plain scalar](#style/flow/plain) and an [implicit key](#key/implicit/)
starting a nested [block mapping](#style/block/mapping).

```
[196] s-l+block-node(n,c) ::=
  s-l+block-in-block(n,c) | s-l+flow-in-block(n)
```

```
[197] s-l+flow-in-block(n) ::=
  s-separate(n+1,flow-out)
  ns-flow-node(n+1,flow-out) s-l-comments
```

**Example 8.20. Block Node Types**

```
-`↓
··"flow in block"↓`
-·`>
 Block scalar↓`
-·`!!map # Block collection
  foo : bar↓`
```

```
Legend:
  `[s-l+flow-in-block(n)](#s-l+flow-in-block(n))`
  `[s-l+block-in-block(n,c)](#s-l+block-in-block(n,c))`

```

```
%YAML 1.2
---
!!seq [
  !!str "flow in block",
  !!str "Block scalar\\n",
  !!map {
    ? !!str "foo"
    : !!str "bar",
  },
]
```

The block [node’s properties](#node/property/) may span across several lines.
In this case, they must be [indented](#space/indentation/) by at least one more
[space](#space//) than the [block collection](#style/block/collection),
regardless of the [indentation](#space/indentation/) of the [block
collection](#style/block/collection) entries.

```
[198] s-l+block-in-block(n,c) ::=
  s-l+block-scalar(n,c) | s-l+block-collection(n,c)
```

```
[199] s-l+block-scalar(n,c) ::=
  s-separate(n+1,c)
  ( c-ns-properties(n+1,c) s-separate(n+1,c) )?
  ( c-l+literal(n) | c-l+folded(n) )
```

**Example 8.21. Block Scalar Nodes**

```
literal: `|2
··value`
folded:`↓
···!foo
··>1
·value`
```

```
Legend:
  `[c-l+literal(n)](#c-l+literal(n))` `[c-l+folded(n)](#c-l+folded(n))`

```

```
%YAML 1.2
---
!!map {
  ? !!str "literal"
  : !!str "value\\n",
  ? !!str "folded"
  : !<!foo> "value\\n",
}
```

Since people perceive the ["**`-`**" indicator](#- block sequence entry//) as
[indentation](#space/indentation/), nested [block
sequences](#style/block/sequence) may be [indented](#space/indentation/) by one
less [space](#space//) to compensate, except, of course, if nested inside
another [block sequence](#style/block/sequence) ([**`block-out`**
context](#context/block-out/) vs. [**`block-in`**
context](#context/block-in/)).

```
[200] s-l+block-collection(n,c) ::=
  ( s-separate(n+1,c) c-ns-properties(n+1,c) )?
  s-l-comments
  ( l+block-sequence(seq-spaces(n,c))
  | l+block-mapping(n) )
```

```
[201] seq-spaces(n,c) ::=
  c = block-out ⇒ n-1
  c = block-in  ⇒ n
```

**Example 8.22. Block Collection Nodes**

```
sequence: !!seq
`- entry
- !!seq
 - nested`
mapping: !!map
 `foo: bar`
```

```
Legend:
  `[l+block-sequence(n)](#l+block-sequence(n))`
  `[l+block-mapping(n)](#l+block-mapping(n))`
  [s-l+block-collection(n,c)](#s-l+block-collection(n,c))

```

```
%YAML 1.2
---
!!map {
  ? !!str "sequence"
  : !!seq [
    !!str "entry",
    !!seq [ !!str "nested" ],
  ],
  ? !!str "mapping"
  : !!map {
    ? !!str "foo" : !!str "bar",
  },
}
```

# Chapter 9. YAML Character Stream

## 9.1. Documents

A YAML character [stream](#stream//) may contain several _documents_.
Each document is completely independent from the rest.

### 9.1.1. Document Prefix

A document may be preceded by a _prefix_ specifying the [character
encoding](#character encoding//), and optional [comment](#comment//) lines.
Note that all [documents](#document//) in a stream must use the same [character
encoding](#character encoding//).
However it is valid to re-specify the [encoding](#character encoding//) using a
[byte order mark](#byte order mark//) for each [document](#document//) in the
stream.
This makes it easier to concatenate streams.

The existence of the optional prefix does not necessarily indicate the
existence of an actual [document](#document//).

```
[202] l-document-prefix ::=
  c-byte-order-mark? l-comment*
```

**Example 9.1. Document Prefix**

```
`⇔# Comment
# lines`
Document
```

```
Legend:
  `[l-document-prefix](#l-document-prefix)`

```

```
%YAML 1.2
---
!!str "Document"
```

### 9.1.2. Document Markers

Using [directives](#directive//) creates a potential ambiguity.
It is valid to have a ["**`%`**"](#% directive//) character at the start of a
line (e.g. as the first character of the second line of a [plain
scalar](#style/flow/plain)).
How, then, to distinguish between an actual [directive](#directive//) and a
[content](#content//) line that happens to start with a ["**`%`**"](#%
directive//) character?

The solution is the use of two special _marker_ lines to control the processing
of [directives](#directive//), one at the start of a [document](#document//)
and one at the end.

At the start of a [document](#document//), lines beginning with a
["**`%`**"](#% directive//) character are assumed to be
[directives](#directive//).
The (possibly empty) list of [directives](#directive//) is terminated by a
_directives end marker_ line.
Lines following this marker can safely use ["**`%`**"](#% directive//) as the
first character.

At the end of a [document](#document//), a _document end marker_ line is used
to signal the [parser](#parse//) to begin scanning for
[directives](#directive//) again.

The existence of this optional _document suffix_ does not necessarily indicate
the existence of an actual following [document](#document//).

Obviously, the actual [content](#content//) lines are therefore forbidden to
begin with either of these markers.

```
[203] c-directives-end ::=
  "-" "-" "-"
```

```
[204] c-document-end ::=
  "." "." "."
```

```
[205] l-document-suffix ::=
  c-document-end s-l-comments
```

```
[206] c-forbidden ::=
  /* Start of line */
  ( c-directives-end | c-document-end )
  ( b-char | s-white | /* End of file */ )
```

**Example 9.2. Document Markers**

```
%YAML 1.2
`---`
Document
`...` # Suffix
```

```
%YAML 1.2
---
!!str "Document"
```

```
Legend:
  `[c-directives-end](#c-directives-end)` `[c-document-end](#c-document-end)`
  [l-document-suffix](#l-document-suffix)

```

### 9.1.3. Bare Documents

A _bare document_ does not begin with any [directives](#directive//) or
[marker](#marker//) lines.
Such documents are very "clean" as they contain nothing other than the
[content](#content//).
In this case, the first non-comment line may not start with a ["**`%`**"](#%
directive//) first character.

Document [nodes](#node//) are [indented](#space/indentation/) as if they have a
parent [indented](#space/indentation/) at -1 [spaces](#space//).
Since a [node](#node//) must be more [indented](#space/indentation/) than its
parent [node](#node//), this allows the document’s [node](#node//) to be
[indented](#space/indentation/) at zero or more [spaces](#space//).

```
[207] l-bare-document ::=
  s-l+block-node(-1,block-in)
  /* Excluding c-forbidden content */
```

**Example 9.3. Bare Documents**

```
`Bare
document`
...
# No document
...
`|
%!PS-Adobe-2.0 # Not the first line`
```

```
%YAML 1.2
---
!!str "Bare document"
...
%YAML 1.2
---
!!str "%!PS-Adobe-2.0 # Not the first line\\n"
```

```
 Legend:
   `[l-bare-document](#l-bare-document)`

```

### 9.1.4. Explicit Documents

An _explicit document_ begins with an explicit [directives end
marker](#marker/directives end/) line but no [directives](#directive//).
Since the existence of the [document](#document//) is indicated by this
[marker](#marker//), the [document](#document//) itself may be [completely
empty](#node/completely empty/).

```
[208] l-explicit-document ::=
  c-directives-end
  ( l-bare-document
  | ( e-node s-l-comments ) )
```

**Example 9.4. Explicit Documents**

```
`---
{ matches
% : 20 }`
...
`---
# Empty`
...
```

```
 Legend:
   `[l-explicit-document](#l-explicit-document)`

```

```
%YAML 1.2
---
!!map {
  !!str "matches %": !!int "20"
}
...
%YAML 1.2
---
!!null ""
```

### 9.1.5. Directives Documents

A _directives document_ begins with some [directives](#directive//) followed by
an explicit [directives end marker](#marker/directives end/) line.

```
[209] l-directive-document ::=
  l-directive+
  l-explicit-document
```

**Example 9.5. Directives Documents**

```
`%YAML 1.2
--- |
%!PS-Adobe-2.0`
...
`%YAML1.2
---
# Empty`
...
```

```
 Legend:
   `[l-explicit-document](#l-explicit-document)`

```

```
%YAML 1.2
---
!!str "%!PS-Adobe-2.0\\n"
...
%YAML 1.2
---
!!null ""
```

## 9.2. Streams

A YAML _stream_ consists of zero or more [documents](#document//).
Subsequent [documents](#document//) require some sort of separation
[marker](#marker//) line.
If a [document](#document//) is not terminated by a [document end
marker](#marker/document end/) line, then the following [document](#document//)
must begin with a [directives end marker](#marker/directives end/) line.

The stream format is intentionally "sloppy" to better support common use cases,
such as stream concatenation.

```
[210] l-any-document ::=
    l-directive-document
  | l-explicit-document
  | l-bare-document
```

```
[211] l-yaml-stream ::=
  l-document-prefix* l-any-document?
  ( l-document-suffix+ l-document-prefix* l-any-document?
  | l-document-prefix* l-explicit-document? )*
```

**Example 9.6. Stream**

```
`Document`
`---
# Empty`
...
%YAML 1.2
---
matches %: 20
```

```
 Legend:
   `[l-any-document](#l-any-document)`
   `[l-document-suffix](#l-document-suffix)`
   [l-explicit-document](#l-explicit-document)

```

```
%YAML 1.2
---
!!str "Document"
...
%YAML 1.2
---
!!null ""
...
%YAML 1.2
---
!!map {
  !!str "matches %": !!int "20"
}
```

A sequence of bytes is a _well-formed stream_ if, taken as a whole, it complies
with the above **`l-yaml-stream`** production.

Some common use case that can take advantage of the YAML stream structure are:

Appending to Streams

Allowing multiple [documents](#document//) in a single stream makes YAML
suitable for log files and similar [applications](#application//).
Note that each [document](#document//) is independent of the rest, allowing for
heterogeneous log file entries.

Concatenating Streams

Concatenating two YAML streams requires both to use the same [character
encoding](#character encoding//).
In addition, it is necessary to separate the last [document](#document//) of
the first stream and the first [document](#document//) of the second stream.
This is easily ensured by inserting a [document end marker](#marker/document
end/) between the two streams.
Note that this is safe regardless of the content of either stream.
In particular, either or both may be empty, and the first stream may or may not
already contain such a marker.

Communication Streams

The [document end marker](#marker/document end/) allows signaling the end of a
[document](#document//) without closing the stream or starting the next
[document](#document//).
This allows the receiver to complete processing a [document](#document//)
without having to wait for the next one to arrive.
The sender may also transmit "keep-alive" messages in the form of
[comment](#comment//) lines or repeated [document end markers](#marker/document
end/) without signalling the start of the next [document](#document//).

# Chapter 10. Recommended Schemas

A YAML _schema_ is a combination of a set of [tags](#tag//) and a mechanism for
[resolving](#tag/resolution/) [non-specific tags](#tag/non-specific/).

## 10.1. Failsafe Schema

The _failsafe schema_ is guaranteed to work with any YAML
[document](#document//).
It is therefore the recommended [schema](#schema//) for generic YAML tools.
A YAML [processor](#processor//) should therefore support this
[schema](#schema//), at least as an option.

### 10.1.1. Tags

#### 10.1.1.1. Generic Mapping

URI:

**`tag:yaml.org,2002:map`**

Kind:

[Mapping](#mapping//).

Definition:

[Represents](#represent//) an associative container, where each [key](#key//)
is [unique](#equality//) in the association and mapped to exactly one
[value](#value//).
YAML places no restrictions on the type of [keys](#key//); in particular, they
are not restricted to being [scalars](#scalar//).
Example [bindings](#construct//) to [native](#native data structure//) types
include Perl’s hash, Python’s dictionary, and Java’s Hashtable.

Equality:

Two mappings are [equal](#equality//) if and only if they are
[identical](#identity//).

**Example 10.1. `!!map` Examples**

```
Block style: !!map
  Clark : Evans
  Ingy  : döt Net
  Oren  : Ben-Kiki

Flow style: !!map { Clark: Evans, Ingy: döt Net, Oren: Ben-Kiki }
```

#### 10.1.1.2. Generic Sequence

URI:

**`tag:yaml.org,2002:seq`**

Kind:

[Sequence](#sequence//).

Definition:

[Represents](#represent//) a collection indexed by sequential integers starting
with zero.
Example [bindings](#construct//) to [native](#native data structure//) types
include Perl’s array, Python’s list or tuple, and Java’s array or Vector.

Equality:

Two sequences are [equal](#equality//) if and only if they are
[identical](#identity//).

**Example 10.2. `!!seq` Examples**

```
Block style: !!seq
- Clark Evans
- Ingy döt Net
- Oren Ben-Kiki

Flow style: !!seq [ Clark Evans, Ingy döt Net, Oren Ben-Kiki ]
```

#### 10.1.1.3. Generic String

URI:

**`tag:yaml.org,2002:str`**

Kind:

[Scalar](#scalar//).

Definition:

[Represents](#represent//) a Unicode string, a sequence of zero or more Unicode
characters.
This type is usually [bound](#construct//) to the [native](#native data
structure//) language’s string type, or, for languages lacking one (such as C),
to a character array.

Equality:

Two strings are [equal](#equality//) if and only if they have the same length
and contain the same characters in the same order.

Canonical Form:

The obvious.

**Example 10.3. `!!str` Examples**

```
String: !!str "Just a theory."
```

### 10.1.2. Tag Resolution

All [nodes](#node//) with the ["**`!`**" non-specific tag](#! tag indicator/!
non-specific tag/) are [resolved](#tag/resolution/), by the standard
[convention](#tag/resolution/convention), to "**`tag:yaml.org,2002:seq`**",
"**`tag:yaml.org,2002:map`**", or "**`tag:yaml.org,2002:str`**", according to
their [kind](#kind//).

All [nodes](#node//) with the ["**`?`**" non-specific tag](#? non-specific
tag//) are left [unresolved](#tag/resolution/).
This constrains the [application](#application//) to deal with a [partial
representation](#representation/partial/).

## 10.2. JSON Schema

The _JSON schema_ is the lowest common denominator of most modern computer
languages, and allows [parsing](#parse//) JSON files.
A YAML [processor](#processor//) should therefore support this
[schema](#schema//), at least as an option.
It is also strongly recommended that other [schemas](#schema//) should be based
on it.

### 10.2.1. Tags

The JSON [schema](#schema//) uses the following [tags](#tag//) in addition to
those defined by the [failsafe](#schema/failsafe/) schema:

#### 10.2.1.1. Null

URI:

**`tag:yaml.org,2002:null`**

Kind:

[Scalar](#scalar//).

Definition:

[Represents](#represent//) the lack of a value.
This is typically [bound](#construct//) to a [native](#native data structure//)
null-like value (e.g., **`undef`** in Perl, **`None`** in Python).
Note that a null is different from an empty string.
Also, a [mapping](#mapping//) entry with some [key](#key//) and a null
[value](#value//) is valid, and different from not having that [key](#key//) in
the [mapping](#mapping//).

Equality:

All **`null`** values are [equal](#equality//).

Canonical Form:

**`null`**.

**Example 10.4. `!!null` Examples**

```
!!null null: value for null key
key with null value: !!null null
```

#### 10.2.1.2. Boolean

URI:

**`tag:yaml.org,2002:bool`**

Kind:

[Scalar](#scalar//).

Definition:

[Represents](#represent//) a true/false value.
In languages without a [native](#native data structure//) Boolean type (such as
C), is usually [bound](#construct//) to a native integer type, using one for
true and zero for false.

Equality:

All **`true`** values are [equal](#equality//).
Similarly, all **`false`** values are [equal](#equality//).

Canonical Form:

Either **`true`** or **`false`**.

**Example 10.5. `!!bool` Examples**

```
YAML is a superset of JSON: !!bool true
Pluto is a planet: !!bool false
```

#### 10.2.1.3. Integer

URI:

**`tag:yaml.org,2002:int`**

Kind:

[Scalar](#scalar//).

Definition:

[Represents](#represent//) arbitrary sized finite mathematical integers.
Scalars of this type should be [bound](#construct//) to a [native](#native data
structure//) integer data type, if possible.

Some languages (such as Perl) provide only a "number" type that allows for both
integer and floating-point values.
A YAML [processor](#processor//) may use such a type for integers, as long as
they round-trip properly.

In some languages (such as C), an integer may overflow the [native](#native
data structure//) type’s storage capability.
A YAML [processor](#processor//) may reject such a value as an error, truncate
it with a warning, or find some other manner to round-trip it.
In general, integers representable using 32 binary digits should safely
round-trip through most systems.

Equality:

An integer value is [equal](#equality//) to any other numeric value that
evaluates to the integer value.
For example, the integer **`1`** is equal to the floating-point **`1.0`**.

Canonical Form:

Decimal integer notation, with a leading "**`-`**" character for negative
values, matching the regular expression **`0 | -? [1-9] [0-9]*`**

**Example 10.6. `!!int` Examples**

```
negative: !!int -12
zero: !!int 0
positive: !!int 34
```

#### 10.2.1.4. Floating Point

URI:

**`tag:yaml.org,2002:float`**

Kind:

[Scalar](#scalar//).

Definition:

[Represents](#represent//) an approximation to real numbers, including three
special values (positive and negative infinity, and "not a number").

Some languages (such as Perl) provide only a "number" type that allows for both
integer and floating-point values.
A YAML [processor](#processor//) may use such a type for floating-point
numbers, as long as they round-trip properly.

Not all floating-point values can be stored exactly in any given
[native](#native data structure//) type.
Hence a float value may change by "a small amount" when round-tripped.
The supported range and accuracy depends on the implementation, though 32 bit
IEEE floats should be safe.
Since YAML does not specify a particular accuracy, using floating-point
[mapping keys](#key//) requires great care and is not recommended.

Equality:

A floating-point value is [equal](#equality//) to any other numeric value that
evaluates to the floating-point value.
For example, floating-point **`1.0`** is [equal](#equality//) to the the
integer **`1`**.
Note that for the purpose of [key](#key//) [uniqueness](#equality//), all
**`.nan`** values are considered to be [equal](#equality//).
Note that in some languages (such as Ruby and Python) "not a number" has
[identity](#identity//) semantics and therefore is not properly
[represented](#representation//) in YAML as **`!!float .nan`**.

Canonical Form:

Either **`0`**, **`.inf`**, **`-.inf`**, **`.nan`**, or scientific notation
matching the regular expression
**`-? [1-9] ( \. [0-9]* [1-9] )? ( e [-+] [1-9] [0-9]* )?`**.

**Example 10.7. `!!float` Examples**

```
negative: !!float -1
zero: !!float 0
positive: !!float 2.3e4
infinity: !!float .inf
not a number: !!float .nan
```

### 10.2.2. Tag Resolution

The [JSON schema](#schema/JSON/) [tag resolution](#tag/resolution/) is an
extension of the [failsafe schema](#schema/failsafe/) [tag
resolution](#tag/resolution/).

All [nodes](#node//) with the ["**`!`**" non-specific tag](#! tag indicator/!
non-specific tag/) are [resolved](#tag/resolution/), by the standard
[convention](#tag/resolution/convention), to "**`tag:yaml.org,2002:seq`**",
"**`tag:yaml.org,2002:map`**", or "**`tag:yaml.org,2002:str`**", according to
their [kind](#kind//).

[Collections](#collection//) with the ["**`?`**" non-specific tag](#?
non-specific tag//) (that is, [untagged](#tag/non-specific/)
[collections](#collection//)) are [resolved](#tag/resolution/) to
"**`tag:yaml.org,2002:seq`**" or "**`tag:yaml.org,2002:map`**" according to
their [kind](#kind//).

[Scalars](#scalar//) with the ["**`?`**" non-specific tag](#? non-specific
tag//) (that is, [plain scalars](#style/flow/plain)) are matched with a list of
regular expressions (first match wins, e.g. **`0`** is resolved as **`!!int`**).
In principle, JSON files should not contain any [scalars](#scalar//) that do
not match at least one of these.
Hence the YAML [processor](#processor//) should consider them to be an error.

| Regular expression | Resolved to tag
| -- | --
| null | tag:yaml.org,2002:null
| true | false | tag:yaml.org,2002:bool
| -? ( 0 | [1-9] [0-9]* ) | tag:yaml.org,2002:int
| -? ( 0 | [1-9] [0-9]* ) ( \. [0-9]* )? ( [eE] [-+]? [0-9]+ )? | tag:yaml.org,2002:float
| * | Error

**Example 10.8. JSON Tag Resolution**

```
A null: null
Booleans: [ true, false ]
Integers: [ 0, -0, 3, -19 ]
Floats: [ 0., -0.0, 12e03, -2E+05 ]
Invalid: [ True, Null, 0o7, 0x3A, +12.3 ]
```

```
%YAML 1.2
---
!!map {
  !!str "A null" : !!null "null",
  !!str "Booleans: !!seq [
    !!bool "true", !!bool "false"
  ],
  !!str "Integers": !!seq [
    !!int "0", !!int "-0",
    !!int "3", !!int "-19"
  ],
  !!str "Floats": !!seq [
    !!float "0.", !!float "-0.0",
    !!float "12e03", !!float "-2E+05"
  ],
  !!str "Invalid": !!seq [
    # Rejected by the schema
    True, Null, 0o7, 0x3A, +12.3,
  ],
}
...
```

## 10.3. Core Schema

The _Core schema_ is an extension of the [JSON schema](#schema/JSON/), allowing
for more human-readable [presentation](#present//) of the same types.
This is the recommended default [schema](#schema//) that YAML
[processor](#processor//) should use unless instructed otherwise.
It is also strongly recommended that other [schemas](#schema//) should be based
on it.

### 10.3.1. Tags

The core [schema](#schema//) uses the same [tags](#tag//) as the [JSON
schema](#schema/JSON/).

### 10.3.2. Tag Resolution

The [core schema](#schema/core/) [tag resolution](#tag/resolution/) is an
extension of the [JSON schema](#schema/JSON/) [tag
resolution](#tag/resolution/).

All [nodes](#node//) with the ["**`!`**" non-specific tag](#! tag indicator/!
non-specific tag/) are [resolved](#tag/resolution/), by the standard
[convention](#tag/resolution/convention), to "**`tag:yaml.org,2002:seq`**",
"**`tag:yaml.org,2002:map`**", or "**`tag:yaml.org,2002:str`**", according to
their [kind](#kind//).

[Collections](#collection//) with the ["**`?`**" non-specific tag](#?
non-specific tag//) (that is, [untagged](#tag/non-specific/)
[collections](#collection//)) are [resolved](#tag/resolution/) to
"**`tag:yaml.org,2002:seq`**" or "**`tag:yaml.org,2002:map`**" according to
their [kind](#kind//).

[Scalars](#scalar//) with the ["**`?`**" non-specific tag](#? non-specific
tag//) (that is, [plain scalars](#style/flow/plain)) are matched with an
extended list of regular expressions.
However, in this case, if none of the regular expressions matches, the
[scalar](#scalar//) is [resolved](#tag/resolution/) to
**`tag:yaml.org,2002:str`** (that is, considered to be a string).

| Regular expression | Resolved to tag
| -- | --
| null | Null | NULL | ~ | tag:yaml.org,2002:null
| /* Empty */ | tag:yaml.org,2002:null
| true | True | TRUE | false | False | FALSE | tag:yaml.org,2002:bool
| [-+]? [0-9]+ | tag:yaml.org,2002:int (Base 10)
| 0o [0-7]+ | tag:yaml.org,2002:int (Base 8)
| 0x [0-9a-fA-F]+ | tag:yaml.org,2002:int (Base 16)
| [-+]? ( \. [0-9]+ | [0-9]+ ( \. [0-9]* )? ) ( [eE] [-+]? [0-9]+ )? | tag:yaml.org,2002:float (Number)
| [-+]? ( \.inf | \.Inf | \.INF ) | tag:yaml.org,2002:float (Infinity)
| \.nan | \.NaN | \.NAN | tag:yaml.org,2002:float (Not a number)
| * | tag:yaml.org,2002:str (Default)

**Example 10.9. Core Tag Resolution**

```
A null: null
Also a null: # Empty
Not a null: ""
Booleans: [ true, True, false, FALSE ]
Integers: [ 0, 0o7, 0x3A, -19 ]
Floats: [ 0., -0.0, .5, +12e03, -2E+05 ]
Also floats: [ .inf, -.Inf, +.INF, .NAN ]
```

```
%YAML 1.2
---
!!map {
  !!str "A null" : !!null "null",
  !!str "Also a null" : !!null "",
  !!str "Not a null" : !!str "",
  !!str "Booleans: !!seq [
    !!bool "true", !!bool "True",
    !!bool "false", !!bool "FALSE",
  ],
  !!str "Integers": !!seq [
    !!int "0", !!int "0o7",
    !!int "0x3A", !!int "-19",
  ],
  !!str "Floats": !!seq [
    !!float "0.", !!float "-0.0", !!float ".5",
    !!float "+12e03", !!float "-2E+05"
  ],
  !!str "Also floats": !!seq [
    !!float ".inf", !!float "-.Inf",
    !!float "+.INF", !!float ".NAN",
  ],
}
...
```

## 10.4. Other Schemas

None of the above recommended [schemas](#schema//) preclude the use of
arbitrary explicit [tags](#tag//).
Hence YAML [processors](#processor//) for a particular programming language
typically provide some form of [local tags](#tag/local/) that map directly to
the language’s [native data structures](#native data structure//) (e.g.,
**`!ruby/object:Set`**).

While such [local tags](#tag/local/) are useful for ad-hoc
[applications](#application//), they do not suffice for stable, interoperable
cross-[application](#application//) or cross-platform data exchange.

Interoperable [schemas](#schema//) make use of [global tags](#tag/global/)
(URIs) that [represent](#represent//) the same data across different
programming languages.
In addition, an interoperable [schema](#schema//) may provide additional [tag
resolution](#tag/resolution/) rules.
Such rules may provide additional regular expressions, as well as consider the
path to the [node](#node//).
This allows interoperable [schemas](#schema//) to use
[untagged](#tag/non-specific/) [nodes](#node//).

It is strongly recommended that such [schemas](#schema//) be based on the [core
schema](#schema/core/) defined above.
In addition, it is strongly recommended that such [schemas](#schema//) make as
much use as possible of the the _YAML tag repository_ at
[http://yaml.org/type/](http://yaml.org/type/).
This repository provides recommended [global tags](#tag/global/) for increasing
the portability of YAML [documents](#document//) between different
[applications](#application//).

The tag repository is intentionally left out of the scope of this specification.
This allows it to evolve to better support YAML [applications](#application//).
Hence, developers are encouraged to submit new "universal" types to the
repository.
The yaml-core mailing list at
[http://lists.sourceforge.net/lists/listinfo/yaml-core](http://lists.sourceforg
e.net/lists/listinfo/yaml-core) is the preferred method for such submissions,
as well as raising any questions regarding this draft.

# Index

### Indicators

! tag indicator, [Tags](#idm786), [Indicator Characters](#idm3570), [Node Tags](#idm6461)

! local tag, [Tags](#idm1620), [Tag Handles](#idm6064), [Tag
Prefixes](#idm6270), [Node Tags](#idm6461)

! non-specific tag, [Resolved Tags](#idm2564), [Node Tags](#idm6461), [Tag
Resolution](#idm11057), [Tag Resolution](#idm11448), [Tag
Resolution](#idm11627)

! primary tag handle, [Tag Handles](#idm6064)

!! secondary tag handle, [Tag Handles](#idm6064)

!…! named handle, [Tag Handles](#idm6064), [Node Tags](#idm6461)

" double-quoted style, [Indicator Characters](#idm3570), [Double-Quoted Style](#idm7210)

\# comment, [Collections](#idm406), [Indicator Characters](#idm3570), [Comments](#idm5481), [Plain Style](#idm7632), [Block Indentation Indicator](#idm8865)

% directive, [Indicator Characters](#idm3570), [Directives](#idm5738), [Document Markers](#idm10381), [Bare Documents](#idm10520)

% escaping in URI, [Tags](#idm1620), [Miscellaneous Characters](#idm4386), [Node Tags](#idm6461)

& anchor, [Structures](#idm531), [Indicator Characters](#idm3570), [Node Anchors](#idm6842)

' reserved indicator, [Indicator Characters](#idm3570)

' single-quoted style, [Indicator Characters](#idm3570), [Single-Quoted Style](#idm7447)

\* alias, [Structures](#idm531), [Indicator Characters](#idm3570), [Alias Nodes](#idm6989)

\+ keep chomping, [Block Chomping Indicator](#idm8990)

, end flow entry, [Collections](#idm406), [Indicator Characters](#idm3570), [Miscellaneous Characters](#idm4386), [Node Tags](#idm6461), [Node Anchors](#idm6842), [Plain Style](#idm7632), [Flow Collection Styles](#idm7932), [Flow Sequences](#idm7993), [Flow Mappings](#idm8114)

\- block sequence entry, [Introduction](#Introduction), [Collections](#idm406), [Structures](#idm531), [Production Parameters](#idm3014), [Indicator Characters](#idm3570), [Indentation Spaces](#idm4883), [Plain Style](#idm7632), [Block Collection Styles](#idm9640), [Block Sequences](#idm9663), [Block Nodes](#idm10091)

\- strip chomping, [Block Chomping Indicator](#idm8990)

: mapping value, [Introduction](#Introduction), [Collections](#idm406), [Structures](#idm531), [Indicator Characters](#idm3570), [Indentation Spaces](#idm4883), [Plain Style](#idm7632), [Flow Mappings](#idm8114), [Block Mappings](#idm9826)

<…> verbatim tag, [Node Tags](#idm6461)

\> folded style, [Scalars](#idm656), [Indicator Characters](#idm3570), [Folded Style](#idm9400)

? mapping key, [Structures](#idm531), [Indicator Characters](#idm3570), [Indentation Spaces](#idm4883), [Plain Style](#idm7632), [Flow Mappings](#idm8114), [Block Mappings](#idm9826)

? non-specific tag, [Resolved Tags](#idm2564), [Node Tags](#idm6461), [Tag Resolution](#idm11057), [Tag Resolution](#idm11448), [Tag Resolution](#idm11627)

@ reserved indicator, [Indicator Characters](#idm3570)

\[ start flow sequence, [Collections](#idm406), [Indicator Characters](#idm3570), [Miscellaneous Characters](#idm4386), [Node Tags](#idm6461), [Node Anchors](#idm6842), [Plain Style](#idm7632), [Flow Sequences](#idm7993)

\\ escaping in double-quoted scalars, [Escaped Characters](#idm4551), [Double-Quoted Style](#idm7210)

\] end flow sequence, [Collections](#idm406), [Indicator Characters](#idm3570), [Miscellaneous Characters](#idm4386), [Node Tags](#idm6461), [Node Anchors](#idm6842), [Plain Style](#idm7632), [Flow Sequences](#idm7993)

{ start flow mapping, [Collections](#idm406), [Indicator Characters](#idm3570), [Miscellaneous Characters](#idm4386), [Node Tags](#idm6461), [Node Anchors](#idm6842), [Plain Style](#idm7632), [Flow Mappings](#idm8114)

| literal style, [Scalars](#idm656), [Indicator Characters](#idm3570), [Literal Style](#idm9265)

} end flow mapping, [Collections](#idm406), [Indicator Characters](#idm3570), [Miscellaneous Characters](#idm4386), [Node Tags](#idm6461), [Node Anchors](#idm6842), [Plain Style](#idm7632), [Flow Mappings](#idm8114)

### A

alias, [Introduction](#Introduction), [Prior Art](#idm141), [Structures](#idm531), [Dump](#idm1059), [Serialization Tree](#idm1931), [Anchors and Aliases](#idm2042), [Loading Failure Points](#idm2408), [Well-Formed Streams and Identified Aliases](#idm2524), [Resolved Tags](#idm2564), [Indicator Characters](#idm3570), [Node Anchors](#idm6842), [Flow Styles](#Flow), [Alias Nodes](#idm6989), [Flow Nodes](#idm8623)

identified, [Structures](#idm531), [Anchors and Aliases](#idm2042),
[Well-Formed Streams and Identified Aliases](#idm2524)

unidentified, [Loading Failure Points](#idm2408), [Well-Formed Streams and
Identified Aliases](#idm2524)

anchor, [Structures](#idm531), [Dump](#idm1059), [Serialization Tree](#idm1931), [Anchors and Aliases](#idm2042), [Well-Formed Streams and Identified Aliases](#idm2524), [Resolved Tags](#idm2564), [Indicator Characters](#idm3570), [Node Properties](#idm6397), [Flow Styles](#Flow), [Alias Nodes](#idm6989), [Flow Nodes](#idm8623)

application, [Introduction](#Introduction), [Prior Art](#idm141), [Tags](#idm786), [Processing YAML Information](#Processing), [Dump](#idm1059), [Information Models](#idm1384), [Tags](#idm1620), [Serialization Tree](#idm1931), [Keys Order](#idm1978), [Resolved Tags](#idm2564), [Available Tags](#idm2940), [Tag Prefixes](#idm6270), [Node Tags](#idm6461), [Streams](#idm10693), [Tag Resolution](#idm11057), [Other Schemas](#idm11801)

### B

block scalar header, [Comments](#idm5481), [Block Scalar Headers](#idm8804), [Block Chomping Indicator](#idm8990)

byte order mark, [Character Encodings](#idm3338), [Document Prefix](#idm10327)

### C

character encoding, [Character Encodings](#idm3338), [Document Prefix](#idm10327), [Streams](#idm10693)

in URI, [Miscellaneous Characters](#idm4386)

chomping, [Production Parameters](#idm3014), [Line Folding](#idm5242), [Block Chomping Indicator](#idm8990), [Literal Style](#idm9265), [Folded Style](#idm9400)

clip, [Production Parameters](#idm3014), [Block Chomping Indicator](#idm8990)

keep, [Production Parameters](#idm3014), [Block Chomping Indicator](#idm8990)

strip, [Production Parameters](#idm3014), [Block Chomping Indicator](#idm8990)

collection, [Prior Art](#idm141), [Representation Graph](#idm1469), [Nodes](#idm1550), [Node Comparison](#idm1720), [Anchors and Aliases](#idm2042), [Node Styles](#idm2176), [Comments](#idm2341), [Resolved Tags](#idm2564), [Recognized and Valid Tags](#idm2858), [Tag Resolution](#idm11448), [Tag Resolution](#idm11627)

comment, [Collections](#idm406), [Processes](#idm1002), [Dump](#idm1059), [Load](#idm1263), [Presentation Stream](#idm2106), [Comments](#idm2341), [Resolved Tags](#idm2564), [Indicator Characters](#idm3570), [Comments](#idm5481), [Separation Lines](#idm5659), [Plain Style](#idm7632), [Block Scalar Headers](#idm8804), [Block Chomping Indicator](#idm8990), [Document Prefix](#idm10327), [Streams](#idm10693)

compose, [Processes](#idm1002), [Load](#idm1263), [Keys Order](#idm1978), [Anchors and Aliases](#idm2042), [Resolved Tags](#idm2564), [Recognized and Valid Tags](#idm2858), [Available Tags](#idm2940), [Node Anchors](#idm6842)

construct, [Processes](#idm1002), [Load](#idm1263), [Node Comparison](#idm1720), [Serialization Tree](#idm1931), [Loading Failure Points](#idm2408), [Recognized and Valid Tags](#idm2858), [Available Tags](#idm2940), [Flow Styles](#Flow), [Generic Mapping](#idm10872), [Generic Sequence](#idm10943), [Generic String](#idm11000), [Null](#idm11140), [Boolean](#idm11216), [Integer](#idm11280)

content, [Structures](#idm531), [Dump](#idm1059), [Nodes](#idm1550), [Tags](#idm1620), [Node Comparison](#idm1720), [Loading Failure Points](#idm2408), [Resolved Tags](#idm2564), [Recognized and Valid Tags](#idm2858), [Character Encodings](#idm3338), [Line Break Characters](#idm4188), [Escaped Characters](#idm4551), [Indentation Spaces](#idm4883), [Separation Spaces](#idm5049), [Line Prefixes](#idm5106), [Empty Lines](#idm5197), [Line Folding](#idm5242), [Comments](#idm5481), [Directives](#idm5738), [Tag Handles](#idm6064), [Node Properties](#idm6397), [Node Tags](#idm6461), [Node Anchors](#idm6842), [Alias Nodes](#idm6989), [Empty Nodes](#idm7075), [Flow Scalar Styles](#idm7165), [Double-Quoted Style](#idm7210), [Single-Quoted Style](#idm7447), [Plain Style](#idm7632), [Block Scalar Headers](#idm8804), [Block Indentation Indicator](#idm8865), [Block Chomping Indicator](#idm8990), [Literal Style](#idm9265), [Document Markers](#idm10381), [Bare Documents](#idm10520)

valid, [Recognized and Valid Tags](#idm2858)

context, [Production Parameters](#idm3014), [Plain Style](#idm7632)

block-in, [Production Parameters](#idm3014), [Block Nodes](#idm10091)

block-key, [Production Parameters](#idm3014), [Flow Collection
Styles](#idm7932)

block-out, [Production Parameters](#idm3014), [Block Nodes](#idm10091)

flow-in, [Production Parameters](#idm3014), [Flow Collection Styles](#idm7932)

flow-key, [Production Parameters](#idm3014), [Flow Collection Styles](#idm7932)

flow-out, [Production Parameters](#idm3014), [Flow Collection Styles](#idm7932)

### D

directive, [Structures](#idm531), [Dump](#idm1059), [Load](#idm1263), [Presentation Stream](#idm2106), [Directives](#idm2369), [Indicator Characters](#idm3570), [Directives](#idm5738), [Document Markers](#idm10381), [Bare Documents](#idm10520), [Explicit Documents](#idm10601), [Directives Documents](#idm10655)

reserved, [Directives](#idm2369), [Directives](#idm5738)

TAG, [Tags](#idm1620), [Directives](#idm2369), [Indicator
Characters](#idm3570), [Directives](#idm5738), ["TAG" Directives](#idm5971),
[Node Tags](#idm6461)

YAML, [Directives](#idm2369), [Directives](#idm5738), ["YAML"
Directives](#idm5841)

document, [Prior Art](#idm141), [Structures](#idm531), [Presentation Stream](#idm2106), [Directives](#idm2369), [Loading Failure Points](#idm2408), [Resolved Tags](#idm2564), [Recognized and Valid Tags](#idm2858), [Character Encodings](#idm3338), [Line Break Characters](#idm4188), ["YAML" Directives](#idm5841), [Tag Prefixes](#idm6270), [Alias Nodes](#idm6989), [Documents](#idm10317), [Document Prefix](#idm10327), [Document Markers](#idm10381), [Explicit Documents](#idm10601), [Streams](#idm10693), [Failsafe Schema](#idm10850), [Other Schemas](#idm11801)

bare, [Bare Documents](#idm10520)

directives, [Directives Documents](#idm10655)

explicit, [Explicit Documents](#idm10601)

prefix, [Document Prefix](#idm10327)

suffix, [Document Markers](#idm10381)

dump, [Processes](#idm1002), [Dump](#idm1059)

### E

empty line, [Prior Art](#idm141), [Scalars](#idm656), [Empty Lines](#idm5197), [Line Folding](#idm5242), [Block Indentation Indicator](#idm8865), [Block Chomping Indicator](#idm8990), [Literal Style](#idm9265), [Folded Style](#idm9400)

equality, [Relation to JSON](#idm318), [Dump](#idm1059), [Representation Graph](#idm1469), [Nodes](#idm1550), [Tags](#idm1620), [Node Comparison](#idm1720), [Scalar Formats](#idm2300), [Loading Failure Points](#idm2408), [Recognized and Valid Tags](#idm2858), [Generic Mapping](#idm10872), [Generic Sequence](#idm10943), [Generic String](#idm11000), [Null](#idm11140), [Boolean](#idm11216), [Integer](#idm11280), [Floating Point](#idm11355)

escaping

in double-quoted scalars, [Prior Art](#idm141), [Scalars](#idm656), [Character
Set](#idm3255), [Character Encodings](#idm3338), [Miscellaneous
Characters](#idm4386), [Escaped Characters](#idm4551), [Double-Quoted
Style](#idm7210)

in single-quoted scalars, [Single-Quoted Style](#idm7447)

in URIs, [Miscellaneous Characters](#idm4386)

non-content line break, [Double-Quoted Style](#idm7210)

### I

identity, [Node Comparison](#idm1720), [Generic Mapping](#idm10872), [Generic Sequence](#idm10943), [Floating Point](#idm11355)

indicator, [Introduction](#Introduction), [Prior Art](#idm141), [Collections](#idm406), [Node Styles](#idm2176), [Production Parameters](#idm3014), [Indicator Characters](#idm3570), [Line Folding](#idm5242), [Plain Style](#idm7632), [Flow Mappings](#idm8114), [Flow Nodes](#idm8623), [Block Styles](#Block), [Block Scalar Headers](#idm8804), [Block Collection Styles](#idm9640)

indentation, [Block Indentation Indicator](#idm8865)

reserved, [Indicator Characters](#idm3570)

information model, [Information Models](#idm1384)

invalid content, [Loading Failure Points](#idm2408), [Recognized and Valid Tags](#idm2858)

### J

JSON compatibility, [Character Set](#idm3255), [Character Encodings](#idm3338), [Line Break Characters](#idm4188), [Escaped Characters](#idm4551), [Comments](#idm5481), ["YAML" Directives](#idm5841), [Flow Mappings](#idm8114), [Block Mappings](#idm9826)

JSON-like, [Flow Mappings](#idm8114), [Flow Nodes](#idm8623)

### K

key, [Relation to JSON](#idm318), [Structures](#idm531), [Dump](#idm1059), [Information Models](#idm1384), [Representation Graph](#idm1469), [Nodes](#idm1550), [Node Comparison](#idm1720), [Serialization Tree](#idm1931), [Keys Order](#idm1978), [Resolved Tags](#idm2564), [Indicator Characters](#idm3570), [Flow Mappings](#idm8114), [Block Mappings](#idm9826), [Generic Mapping](#idm10872), [Null](#idm11140), [Floating Point](#idm11355)

implicit, [Separation Lines](#idm5659), [Double-Quoted Style](#idm7210),
[Single-Quoted Style](#idm7447), [Plain Style](#idm7632), [Flow Collection
Styles](#idm7932), [Flow Mappings](#idm8114), [Block Mappings](#idm9826),
[Block Nodes](#idm10091)

order, [Processes](#idm1002), [Dump](#idm1059), [Load](#idm1263), [Information
Models](#idm1384), [Serialization Tree](#idm1931), [Keys Order](#idm1978)

key: value pair, [Introduction](#Introduction), [Collections](#idm406), [Structures](#idm531), [Nodes](#idm1550), [Keys Order](#idm1978), [Node Styles](#idm2176), [Plain Style](#idm7632), [Flow Mappings](#idm8114), [Block Collection Styles](#idm9640), [Block Mappings](#idm9826)

kind, [Dump](#idm1059), [Representation Graph](#idm1469), [Nodes](#idm1550), [Tags](#idm1620), [Node Styles](#idm2176), [Resolved Tags](#idm2564), [Node Tags](#idm6461), [Tag Resolution](#idm11057), [Tag Resolution](#idm11448), [Tag Resolution](#idm11627)

### L

line break, [Prior Art](#idm141), [Scalars](#idm656), [Production Parameters](#idm3014), [Production Naming Conventions](#idm3178), [Line Break Characters](#idm4188), [White Space Characters](#idm4316), [Empty Lines](#idm5197), [Line Folding](#idm5242), [Comments](#idm5481), [Double-Quoted Style](#idm7210), [Block Scalar Headers](#idm8804), [Block Chomping Indicator](#idm8990), [Literal Style](#idm9265), [Folded Style](#idm9400)

non-ASCII, [Line Break Characters](#idm4188), ["YAML" Directives](#idm5841)

normalization, [Line Break Characters](#idm4188), [Literal Style](#idm9265)

line folding, [Prior Art](#idm141), [Scalars](#idm656), [Line Folding](#idm5242), [Flow Styles](#Flow), [Double-Quoted Style](#idm7210), [Single-Quoted Style](#idm7447), [Plain Style](#idm7632), [Block Chomping Indicator](#idm8990), [Folded Style](#idm9400)

block, [Line Folding](#idm5242), [Folded Style](#idm9400)

flow, [Line Folding](#idm5242), [Double-Quoted Style](#idm7210)

line prefix, [Line Prefixes](#idm5106), [Empty Lines](#idm5197)

load, [Processes](#idm1002), [Load](#idm1263), [Loading Failure Points](#idm2408)

failure point, [Load](#idm1263), [Loading Failure Points](#idm2408)

### M

mapping, [Introduction](#Introduction), [Prior Art](#idm141), [Relation to JSON](#idm318), [Collections](#idm406), [Structures](#idm531), [Dump](#idm1059), [Representation Graph](#idm1469), [Nodes](#idm1550), [Tags](#idm1620), [Node Comparison](#idm1720), [Keys Order](#idm1978), [Resolved Tags](#idm2564), [Plain Style](#idm7632), [Flow Sequences](#idm7993), [Flow Mappings](#idm8114), [Generic Mapping](#idm10872), [Null](#idm11140)

marker, [Presentation Stream](#idm2106), [Document Markers](#idm10381), [Bare Documents](#idm10520), [Explicit Documents](#idm10601), [Streams](#idm10693)

directives end, [Structures](#idm531), [Document Markers](#idm10381), [Explicit
Documents](#idm10601), [Directives Documents](#idm10655), [Streams](#idm10693)

document end, [Structures](#idm531), [Document Markers](#idm10381),
[Streams](#idm10693)

more-indented, [Scalars](#idm656), [Line Folding](#idm5242), [Folded Style](#idm9400)

### N

native data structure, [Introduction](#Introduction), [Goals](#idm127), [Prior Art](#idm141), [Relation to JSON](#idm318), [Processing YAML Information](#Processing), [Processes](#idm1002), [Dump](#idm1059), [Load](#idm1263), [Representation Graph](#idm1469), [Nodes](#idm1550), [Tags](#idm1620), [Node Comparison](#idm1720), [Serialization Tree](#idm1931), [Loading Failure Points](#idm2408), [Recognized and Valid Tags](#idm2858), [Available Tags](#idm2940), [Node Tags](#idm6461), [Flow Styles](#Flow), [Generic Mapping](#idm10872), [Generic Sequence](#idm10943), [Generic String](#idm11000), [Null](#idm11140), [Boolean](#idm11216), [Integer](#idm11280), [Floating Point](#idm11355), [Other Schemas](#idm11801)

need not, [Terminology](#idm357)

node, [Structures](#idm531), [Dump](#idm1059), [Representation Graph](#idm1469), [Nodes](#idm1550), [Tags](#idm1620), [Node Comparison](#idm1720), [Serialization Tree](#idm1931), [Keys Order](#idm1978), [Anchors and Aliases](#idm2042), [Presentation Stream](#idm2106), [Node Styles](#idm2176), [Comments](#idm2341), [Loading Failure Points](#idm2408), [Well-Formed Streams and Identified Aliases](#idm2524), [Resolved Tags](#idm2564), [Recognized and Valid Tags](#idm2858), [Syntax Conventions](#Syntax), [Indentation Spaces](#idm4883), [Node Properties](#idm6397), [Node Tags](#idm6461), [Node Anchors](#idm6842), [Alias Nodes](#idm6989), [Empty Nodes](#idm7075), [Flow Mappings](#idm8114), [Flow Nodes](#idm8623), [Block Indentation Indicator](#idm8865), [Block Sequences](#idm9663), [Bare Documents](#idm10520), [Tag Resolution](#idm11057), [Tag Resolution](#idm11448), [Tag Resolution](#idm11627), [Other Schemas](#idm11801)

completely empty, [Empty Nodes](#idm7075), [Flow Collection Styles](#idm7932),
[Flow Mappings](#idm8114), [Block Sequences](#idm9663), [Explicit
Documents](#idm10601)

property, [Node Properties](#idm6397), [Alias Nodes](#idm6989), [Empty
Nodes](#idm7075), [Flow Mappings](#idm8114), [Flow Nodes](#idm8623), [Block
Sequences](#idm9663), [Block Mappings](#idm9826), [Block Nodes](#idm10091)

root, [Representation Graph](#idm1469), [Resolved Tags](#idm2564)

### P

parse, [Load](#idm1263), [Node Comparison](#idm1720), [Presentation Stream](#idm2106), [Resolved Tags](#idm2564), [Production Parameters](#idm3014), [Line Break Characters](#idm4188), [Escaped Characters](#idm4551), [Tag Handles](#idm6064), [Node Tags](#idm6461), [Flow Mappings](#idm8114), [Block Mappings](#idm9826), [Block Nodes](#idm10091), [Document Markers](#idm10381), [JSON Schema](#idm11107)

present, [Processing YAML Information](#Processing), [Dump](#idm1059), [Load](#idm1263), [Nodes](#idm1550), [Node Comparison](#idm1720), [Presentation Stream](#idm2106), [Scalar Formats](#idm2300), [Character Set](#idm3255), [Miscellaneous Characters](#idm4386), [Node Tags](#idm6461), [Alias Nodes](#idm6989), [Block Mappings](#idm9826), [Core Schema](#idm11590)

presentation, [Processing YAML Information](#Processing), [Information Models](#idm1384), [Node Comparison](#idm1720), [Presentation Stream](#idm2106), [Production Parameters](#idm3014)

detail, [Dump](#idm1059), [Load](#idm1263), [Information Models](#idm1384),
[Presentation Stream](#idm2106), [Node Styles](#idm2176), [Scalar
Formats](#idm2300), [Comments](#idm2341), [Directives](#idm2369), [Resolved
Tags](#idm2564), [Character Encodings](#idm3338), [Line Break
Characters](#idm4188), [Escaped Characters](#idm4551), [Indentation
Spaces](#idm4883), [Separation Spaces](#idm5049), [Line Prefixes](#idm5106),
[Line Folding](#idm5242), [Comments](#idm5481), [Directives](#idm5738), [Tag
Handles](#idm6064), [Node Tags](#idm6461), [Flow Scalar Styles](#idm7165),
[Block Chomping Indicator](#idm8990)

printable character, [Introduction](#Introduction), [Prior Art](#idm141), [Character Set](#idm3255), [White Space Characters](#idm4316), [Escaped Characters](#idm4551), [Single-Quoted Style](#idm7447), [Literal Style](#idm9265)

processor, [Terminology](#idm357), [Processing YAML Information](#Processing), [Dump](#idm1059), [Node Comparison](#idm1720), [Presentation Stream](#idm2106), [Directives](#idm2369), [Well-Formed Streams and Identified Aliases](#idm2524), [Resolved Tags](#idm2564), [Recognized and Valid Tags](#idm2858), [Available Tags](#idm2940), [Character Set](#idm3255), [Character Encodings](#idm3338), [Line Break Characters](#idm4188), [Miscellaneous Characters](#idm4386), [Comments](#idm5481), [Directives](#idm5738), ["YAML" Directives](#idm5841), [Tag Handles](#idm6064), [Node Tags](#idm6461), [Node Anchors](#idm6842), [Flow Mappings](#idm8114), [Block Indentation Indicator](#idm8865), [Failsafe Schema](#idm10850), [JSON Schema](#idm11107), [Integer](#idm11280), [Floating Point](#idm11355), [Tag Resolution](#idm11448), [Core Schema](#idm11590), [Other Schemas](#idm11801)

### R

represent, [Introduction](#Introduction), [Prior Art](#idm141), [Dump](#idm1059), [Tags](#idm1620), [Node Comparison](#idm1720), [Keys Order](#idm1978), [Generic Mapping](#idm10872), [Generic Sequence](#idm10943), [Generic String](#idm11000), [Null](#idm11140), [Boolean](#idm11216), [Integer](#idm11280), [Floating Point](#idm11355), [Other Schemas](#idm11801)

representation, [Processing YAML Information](#Processing), [Processes](#idm1002), [Dump](#idm1059), [Load](#idm1263), [Information Models](#idm1384), [Representation Graph](#idm1469), [Nodes](#idm1550), [Node Comparison](#idm1720), [Serialization Tree](#idm1931), [Keys Order](#idm1978), [Anchors and Aliases](#idm2042), [Presentation Stream](#idm2106), [Node Styles](#idm2176), [Scalar Formats](#idm2300), [Comments](#idm2341), [Directives](#idm2369), [Available Tags](#idm2940), [Node Anchors](#idm6842), [Floating Point](#idm11355)

complete, [Loading Failure Points](#idm2408), [Resolved Tags](#idm2564),
[Recognized and Valid Tags](#idm2858), [Available Tags](#idm2940)

partial, [Loading Failure Points](#idm2408), [Resolved Tags](#idm2564),
[Recognized and Valid Tags](#idm2858), [Tag Resolution](#idm11057)

required, [Terminology](#idm357)

### S

scalar, [Introduction](#Introduction), [Prior Art](#idm141), [Scalars](#idm656), [Dump](#idm1059), [Representation Graph](#idm1469), [Nodes](#idm1550), [Tags](#idm1620), [Node Comparison](#idm1720), [Scalar Formats](#idm2300), [Comments](#idm2341), [Recognized and Valid Tags](#idm2858), [Line Break Characters](#idm4188), [Separation Spaces](#idm5049), [Line Prefixes](#idm5106), [Comments](#idm5481), [Empty Nodes](#idm7075), [Block Chomping Indicator](#idm8990), [Generic Mapping](#idm10872), [Generic String](#idm11000), [Null](#idm11140), [Boolean](#idm11216), [Integer](#idm11280), [Floating Point](#idm11355), [Tag Resolution](#idm11448), [Tag Resolution](#idm11627)

canonical form, [Prior Art](#idm141), [Tags](#idm1620), [Node
Comparison](#idm1720), [Scalar Formats](#idm2300), [Loading Failure
Points](#idm2408)

content format, [Dump](#idm1059), [Load](#idm1263), [Tags](#idm1620), [Node
Comparison](#idm1720), [Presentation Stream](#idm2106), [Scalar
Formats](#idm2300), [Loading Failure Points](#idm2408)

schema, [Recommended Schemas](#Schema), [Failsafe Schema](#idm10850), [JSON Schema](#idm11107), [Tags](#idm11127), [Core Schema](#idm11590), [Tags](#idm11614), [Other Schemas](#idm11801)

core, [Core Schema](#idm11590), [Tag Resolution](#idm11627), [Other
Schemas](#idm11801)

failsafe, [Tags](#idm786), [Failsafe Schema](#idm10850), [Tags](#idm11127),
[Tag Resolution](#idm11448)

JSON, [Tags](#idm786), [JSON Schema](#idm11107), [Tag Resolution](#idm11448),
[Core Schema](#idm11590), [Tags](#idm11614), [Tag Resolution](#idm11627)

sequence, [Introduction](#Introduction), [Prior Art](#idm141), [Dump](#idm1059), [Representation Graph](#idm1469), [Nodes](#idm1550), [Tags](#idm1620), [Keys Order](#idm1978), [Resolved Tags](#idm2564), [Flow Mappings](#idm8114), [Generic Sequence](#idm10943)

serialization, [Processing YAML Information](#Processing), [Processes](#idm1002), [Dump](#idm1059), [Load](#idm1263), [Information Models](#idm1384), [Serialization Tree](#idm1931), [Anchors and Aliases](#idm2042), [Presentation Stream](#idm2106), [Node Styles](#idm2176), [Scalar Formats](#idm2300), [Comments](#idm2341), [Directives](#idm2369), [Node Anchors](#idm6842)

detail, [Dump](#idm1059), [Load](#idm1263), [Information Models](#idm1384),
[Keys Order](#idm1978), [Anchors and Aliases](#idm2042), [Node
Anchors](#idm6842)

serialize, [Introduction](#Introduction), [Prior Art](#idm141), [Relation to JSON](#idm318), [Dump](#idm1059), [Load](#idm1263), [Keys Order](#idm1978), [Anchors and Aliases](#idm2042), [Alias Nodes](#idm6989)

shall, [Terminology](#idm357)

space, [Prior Art](#idm141), [Scalars](#idm656), [White Space Characters](#idm4316), [Indentation Spaces](#idm4883), [Line Folding](#idm5242), [Single-Quoted Style](#idm7447), [Plain Style](#idm7632), [Block Indentation Indicator](#idm8865), [Folded Style](#idm9400), [Block Sequences](#idm9663), [Block Nodes](#idm10091), [Bare Documents](#idm10520)

indentation, [Introduction](#Introduction), [Prior Art](#idm141),
[Collections](#idm406), [Dump](#idm1059), [Load](#idm1263), [Information
Models](#idm1384), [Node Styles](#idm2176), [Resolved Tags](#idm2564),
[Production Parameters](#idm3014), [Production Naming Conventions](#idm3178),
[Indentation Spaces](#idm4883), [Separation Spaces](#idm5049), [Line
Prefixes](#idm5106), [Line Folding](#idm5242), [Comments](#idm5481),
[Separation Lines](#idm5659), [Directives](#idm5738), [Block Styles](#Block),
[Block Indentation Indicator](#idm8865), [Block Chomping Indicator](#idm8990),
[Literal Style](#idm9265), [Block Sequences](#idm9663), [Block
Nodes](#idm10091), [Bare Documents](#idm10520)

separation, [Separation Spaces](#idm5049), [Comments](#idm5481), [Flow
Mappings](#idm8114), [Block Sequences](#idm9663)

white, [Production Naming Conventions](#idm3178), [White Space
Characters](#idm4316), [Separation Spaces](#idm5049), [Line
Prefixes](#idm5106), [Line Folding](#idm5242), [Comments](#idm5481),
[Double-Quoted Style](#idm7210), [Single-Quoted Style](#idm7447), [Plain
Style](#idm7632), [Flow Mappings](#idm8114), [Literal Style](#idm9265), [Folded
Style](#idm9400), [Block Sequences](#idm9663)

stream, [Prior Art](#idm141), [Processing YAML Information](#Processing), [Processes](#idm1002), [Dump](#idm1059), [Load](#idm1263), [Presentation Stream](#idm2106), [Loading Failure Points](#idm2408), [Well-Formed Streams and Identified Aliases](#idm2524), [Resolved Tags](#idm2564), [Syntax Conventions](#Syntax), [Character Set](#idm3255), [Character Encodings](#idm3338), [Miscellaneous Characters](#idm4386), [Comments](#idm5481), [Tag Prefixes](#idm6270), [Empty Nodes](#idm7075), [Documents](#idm10317), [Streams](#idm10693)

ill-formed, [Load](#idm1263), [Loading Failure Points](#idm2408), [Well-Formed
Streams and Identified Aliases](#idm2524)

well-formed, [Well-Formed Streams and Identified Aliases](#idm2524),
[Streams](#idm10693)

style, [Dump](#idm1059), [Load](#idm1263), [Information Models](#idm1384), [Presentation Stream](#idm2106), [Node Styles](#idm2176), [Scalar Formats](#idm2300), [Resolved Tags](#idm2564), [Node Tags](#idm6461), [Double-Quoted Style](#idm7210), [Plain Style](#idm7632)

block, [Prior Art](#idm141), [Scalars](#idm656), [Node Styles](#idm2176),
[Production Parameters](#idm3014), [Indentation Spaces](#idm4883), [Block
Styles](#Block), [Block Sequences](#idm9663)

collection, [Collections](#idm406), [Structures](#idm531), [Indentation
Spaces](#idm4883), [Flow Collection Styles](#idm7932), [Block Collection
Styles](#idm9640), [Block Sequences](#idm9663), [Block Nodes](#idm10091)

folded, [Scalars](#idm656), [Node Styles](#idm2176), [Indicator
Characters](#idm3570), [Line Folding](#idm5242), [Block Scalar
Styles](#idm8785), [Literal Style](#idm9265), [Folded Style](#idm9400)

literal, [Prior Art](#idm141), [Scalars](#idm656), [Node Styles](#idm2176),
[Indicator Characters](#idm3570), [Block Scalar Styles](#idm8785), [Literal
Style](#idm9265), [Folded Style](#idm9400)

mapping, [Node Styles](#idm2176), [Production Parameters](#idm3014), [Block
Mappings](#idm9826), [Block Nodes](#idm10091)

scalar, [Node Styles](#idm2176), [Block Scalar Styles](#idm8785), [Block Scalar
Headers](#idm8804), [Block Indentation Indicator](#idm8865), [Block Chomping
Indicator](#idm8990)

sequence, [Collections](#idm406), [Node Styles](#idm2176), [Production
Parameters](#idm3014), [Indicator Characters](#idm3570), [Block
Sequences](#idm9663), [Block Mappings](#idm9826), [Block Nodes](#idm10091)

compact block collection, [Node Styles](#idm2176), [Block Sequences](#idm9663),
[Block Mappings](#idm9826)

flow, [Prior Art](#idm141), [Collections](#idm406), [Scalars](#idm656), [Node
Styles](#idm2176), [Production Parameters](#idm3014), [Line Folding](#idm5242),
[Flow Styles](#Flow), [Flow Sequences](#idm7993), [Flow Nodes](#idm8623),
[Block Nodes](#idm10091)

collection, [Syntax Conventions](#Syntax), [Production Parameters](#idm3014),
[Indicator Characters](#idm3570), [Miscellaneous Characters](#idm4386), [Node
Tags](#idm6461), [Node Anchors](#idm6842), [Plain Style](#idm7632), [Flow
Collection Styles](#idm7932)

double-quoted, [Prior Art](#idm141), [Scalars](#idm656), [Node
Styles](#idm2176), [Syntax Conventions](#Syntax), [Character Set](#idm3255),
[Character Encodings](#idm3338), [Indicator Characters](#idm3570), [Escaped
Characters](#idm4551), [Flow Scalar Styles](#idm7165), [Double-Quoted
Style](#idm7210), [Flow Nodes](#idm8623)

mapping, [Collections](#idm406), [Node Styles](#idm2176), [Production
Parameters](#idm3014), [Indicator Characters](#idm3570), [Flow
Mappings](#idm8114), [Block Mappings](#idm9826)

plain, [Scalars](#idm656), [Node Styles](#idm2176), [Resolved Tags](#idm2564),
[Production Parameters](#idm3014), [Indicator Characters](#idm3570), [Node
Tags](#idm6461), [Empty Nodes](#idm7075), [Flow Scalar Styles](#idm7165),
[Plain Style](#idm7632), [Flow Mappings](#idm8114), [Flow Nodes](#idm8623),
[Block Collection Styles](#idm9640), [Block Sequences](#idm9663), [Block
Mappings](#idm9826), [Block Nodes](#idm10091), [Document Markers](#idm10381),
[Tag Resolution](#idm11448), [Tag Resolution](#idm11627)

scalar, [Scalars](#idm656), [Node Styles](#idm2176), [Line Prefixes](#idm5106),
[Line Folding](#idm5242), [Flow Scalar Styles](#idm7165)

sequence, [Collections](#idm406), [Node Styles](#idm2176), [Indicator
Characters](#idm3570), [Flow Sequences](#idm7993), [Flow Mappings](#idm8114)

single-quoted, [Node Styles](#idm2176), [Production Parameters](#idm3014),
[Indicator Characters](#idm3570), [Flow Scalar Styles](#idm7165),
[Single-Quoted Style](#idm7447)

scalar, [Node Styles](#idm2176), [Escaped Characters](#idm4551), [Empty
Lines](#idm5197), [Flow Scalar Styles](#idm7165), [Literal Style](#idm9265)

single key:value pair mapping, [Keys Order](#idm1978), [Node Styles](#idm2176),
[Flow Sequences](#idm7993), [Flow Mappings](#idm8114), [Block
Mappings](#idm9826)

### T

tab, [Prior Art](#idm141), [Character Set](#idm3255), [White Space Characters](#idm4316), [Indentation Spaces](#idm4883), [Separation Spaces](#idm5049), [Line Prefixes](#idm5106), [Block Indentation Indicator](#idm8865)

tag, [Prior Art](#idm141), [Tags](#idm786), [Dump](#idm1059), [Representation Graph](#idm1469), [Nodes](#idm1550), [Tags](#idm1620), [Node Comparison](#idm1720), [Scalar Formats](#idm2300), [Loading Failure Points](#idm2408), [Resolved Tags](#idm2564), [Recognized and Valid Tags](#idm2858), [Available Tags](#idm2940), [Syntax Conventions](#Syntax), [Production Parameters](#idm3014), [Indicator Characters](#idm3570), [Miscellaneous Characters](#idm4386), ["TAG" Directives](#idm5971), [Tag Prefixes](#idm6270), [Node Properties](#idm6397), [Node Tags](#idm6461), [Flow Styles](#Flow), [Recommended Schemas](#Schema), [Tags](#idm11127), [Tags](#idm11614), [Other Schemas](#idm11801)

available, [Available Tags](#idm2940)

global, [Prior Art](#idm141), [Tags](#idm786), [Dump](#idm1059),
[Tags](#idm1620), [Resolved Tags](#idm2564), [Tag Handles](#idm6064), [Tag
Prefixes](#idm6270), [Node Tags](#idm6461), [Other Schemas](#idm11801)

handle, [Tags](#idm786), [Processes](#idm1002), [Dump](#idm1059), [Indicator
Characters](#idm3570), ["TAG" Directives](#idm5971), [Tag Handles](#idm6064),
[Tag Prefixes](#idm6270), [Node Tags](#idm6461)

named, [Miscellaneous Characters](#idm4386), [Tag Handles](#idm6064), [Node
Tags](#idm6461)

primary, [Tag Handles](#idm6064)

secondary, [Tag Handles](#idm6064)

local, [Prior Art](#idm141), [Tags](#idm786), [Dump](#idm1059),
[Tags](#idm1620), [Resolved Tags](#idm2564), [Indicator Characters](#idm3570),
[Tag Handles](#idm6064), [Tag Prefixes](#idm6270), [Node Tags](#idm6461),
[Other Schemas](#idm11801)

non-specific, [Tags](#idm786), [Dump](#idm1059), [Node Comparison](#idm1720),
[Loading Failure Points](#idm2408), [Resolved Tags](#idm2564), [Indicator
Characters](#idm3570), [Node Tags](#idm6461), [Recommended Schemas](#Schema),
[Tag Resolution](#idm11448), [Tag Resolution](#idm11627), [Other
Schemas](#idm11801)

prefix, ["TAG" Directives](#idm5971), [Tag Prefixes](#idm6270), [Node
Tags](#idm6461)

property, [Resolved Tags](#idm2564), [Indicator Characters](#idm3570), [Node
Tags](#idm6461)

recognized, [Recognized and Valid Tags](#idm2858)

repository, [Tags](#idm786), [Tag Handles](#idm6064), [Other
Schemas](#idm11801)

bool, [Boolean](#idm11216)

float, [Tags](#idm786), [Floating Point](#idm11355)

int, [Tags](#idm786), [Integer](#idm11280)

map, [Tags](#idm786), [Generic Mapping](#idm10872)

null, [Tags](#idm786), [Empty Nodes](#idm7075), [Null](#idm11140)

seq, [Tags](#idm786), [Generic Sequence](#idm10943)

str, [Tags](#idm786), [Generic String](#idm11000)

resolution, [Tags](#idm1620), [Node Comparison](#idm1720), [Loading Failure
Points](#idm2408), [Resolved Tags](#idm2564), [Node Tags](#idm6461), [Flow
Scalar Styles](#idm7165), [Recommended Schemas](#Schema), [Tag
Resolution](#idm11057), [Tag Resolution](#idm11448), [Tag
Resolution](#idm11627), [Other Schemas](#idm11801)

convention, [Resolved Tags](#idm2564), [Node Tags](#idm6461), [Tag
Resolution](#idm11057), [Tag Resolution](#idm11448), [Tag
Resolution](#idm11627)

shorthand, [Tags](#idm786), [Miscellaneous Characters](#idm4386), ["TAG"
Directives](#idm5971), [Tag Handles](#idm6064), [Tag Prefixes](#idm6270), [Node
Tags](#idm6461)

specific, [Resolved Tags](#idm2564), [Node Tags](#idm6461)

unavailable, [Load](#idm1263), [Loading Failure Points](#idm2408), [Available
Tags](#idm2940)

unrecognized, [Loading Failure Points](#idm2408), [Recognized and Valid
Tags](#idm2858)

unresolved, [Loading Failure Points](#idm2408), [Resolved Tags](#idm2564)

verbatim, [Node Tags](#idm6461)

trimming, [Line Folding](#idm5242)

### V

value, [Dump](#idm1059), [Nodes](#idm1550), [Resolved Tags](#idm2564), [Indicator Characters](#idm3570), [Flow Mappings](#idm8114), [Block Mappings](#idm9826), [Generic Mapping](#idm10872), [Null](#idm11140)

### Y

YAML 1.1 processing, [Line Break Characters](#idm4188), ["YAML" Directives](#idm5841)