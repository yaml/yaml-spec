YAML 1.3 Specification Proposal
===============================

# Overview

It's been 10 years since the YAML 1.2 spec was "finalized".
The YAML data language is now widely used throughout the software world.
It's time to move the language forward.

YAML has always had 3 main goals:

* Be a complete software data serialization language
* Work in and across any programming language(s)
* Be easy for humans to understand and work with

These are still YAML's goals.
To date it has been somewhat successful in achieving them.
It fails mostly in the cross language arena; and even between implementations in the same language.
It probably tried to do too much.

There are also problems with the quality and quantity of information about how YAML works.
YAML was made to appear simple to users, but truly understanding all of YAML is very hard.
YAML 1.3 intends to provide not just a grammar and spec, but a complete test suite and implementer guides.

We know that YAML's current primary role in the wild is for configuration of software.
This was not originally intended, but it is understandable why projects would adopt YAML.
It is fairly human friendly, and yet can express some pretty complicated real-life scenarios.
On the other hand, people are trying to bolt extensions onto YAML in their own non-standard ways.
Adding standard extension facilities is on the roadmap, but will likely come in version 2.0, not version 1.3.



# 1.3 Change Guidelines

YAML 1.2 is quite complex.
Defining it happens at multiple layers (not just a grammar).
The current grammar has ambiguities and unintended consequences.

YAML 1.3 is meant to make the YAML spec intentions easier to understand for implementers.
It will focus primarily on removing troublesome things that are in the 1.2 spec.
These will be things that aren't known to be used much, if at all, in the wild.

YAML 1.3 won't be spec backwards compatible with 1.2.
The point is to fix some of the mistakes, bad ideas and ambiguities of the 1.2 spec.
That said, it should "feel" backwards compatible.
Nothing in common usage will be removed.
Some things might be deprecated to prepare for bigger changes in YAML 2.0.

Every change to the language will have a corresponding RFC document explaining the change and the rationales behind it.
Every RFC will have a GitHub Issues page for public discussion.

The following is a list of the basic criteria considering for an RFC change proposal to make it into the 1.3 spec:

* Does the change make the YAML language better?
  * Does the change make YAML easier to use?
  * Does it make a YAML framework easier to implement?
* Is a current feature/behavior:
  * Ambiguous?
  * Unintended?
  * Hard to implement?
  * Rarely implemented correctly?
* Is it rarely or never seen in the wild?
* Does it prepare the language for bigger 2.0 changes?
* What does LibYAML do?
  * LibYAML is used in many YAML frameworks
  * LibYAML is very well thought out and implemented
  * LibYAML broke with the spec in a few good ways



# Preliminary Thoughts

Before starting into the long list of change proposals, this section has some ideas about the project, and how it could be accomplished.

## Document Formatting

This document and other new stuff will use Markdown as much as possible.

One main style rule is that each sentence is on its own line.
This should help make revision diffs easier to comprehend.

## 1.3 Spec Process Outputs

* A new grammar
* A written specification covering:
  * The parsing grammar
  * Language rules and constraints
  * Schema and tag/type resolution
* A complete test suite
  * Will be the SSoT for defining the language
  * Will test / define different parts of YAML stack
* An implementors guide
* Formal schema definitions
  * Core, JSON and Safe schemas at a minimum
  * Revised yaml.org,2002 tag set
* A new, generated parser module for most languages
  * Generated from grammar
  * Should be 100% correct
  * Should pass all tests in the suite
  * Not optimized for speed

## Generated Parsers

The YAML 1.2 Spec BNF was recently converted to a YAML document.
Currently an effort is underway to generate a compliant parser from the spec data.
The targeted implementation style is easily implemented in any language.

The hardest part of rolling out 1.3 will be implementation/adoption.
Many frameworks haven't even made it to 1.2.
Implementing YAML has been extremely hard to date and no implementation does it 100% correctly.
See: http://matrix.yaml.io/ for a comparison of framework parsers.

## On Schema

YAML was intentionally created as an "incomplete" serialization language.
By this, we mean that any YAML document taken out of context, has an ambiguous meaning.

To process YAML you need a corpus of extra information that indicates which values mean what.
The term "schema" is a blanket concept that means "all the extra information needed to process the YAML in the manner implied by the context".

A document's meaning cannot be ascertained without knowledge of what "schema" it is adhering to.
YAML always intended to have a schema language but that just hasn't happened yet.
There have been some various starts.
One of them is called SchemaType and is both general purpose and intended to supply all YAML's needs.

In the real world, this "schema" is simply the code that was used to create a given YAML processor.
Some of the more sophisticated YAML frameworks support more than one schema option to use.

In the future, we want to have a textual schema language, that can used like:
```
my-object = yaml.load("file.yaml", "file.schema")
```

In a world where anyone can create a schema and all YAML documents have a declared or implied concretely defined schema, several of the current language components can be removed.
Things like directives, and long form tag URLs, that are a big source of making YAML buggy and/or hard to implement correctly.

YAML does define a default schema that should be used as closely as the implementation can possibly support.

## On Versioning

YAML has a parser directive to indicate the version of the YAML spec intended for the document.
To make YAML simpler, it is desirable to simply get rid of that.
People rarely if ever use the versioning syntax.

Like we said above, a given YAML document on its own, is incomplete.
It needs context and schema to be processed.
Therefore the version of YAML being used is just a context or schema detail.

The processor being used is going to expect the YAML in a certain version format.
In situations where more than one version is in play, it is up to the user or the framework to differentiate.

That said, we should make every attempt to not have something that was valid in 1.2, be valid but semantically different in 1.3.

## On Stack

YAML processing should be discussed as a stack of transformations that happen
when taking information from text-to-native (the "load" stack) and
native-to-text (the "dump" stack). Certain dicreet operations can be discussed
to happen at each stack layer.

By defining a typical processing stack, we have the ability to discuss what
may, must or must not occur at each phase.

It is not a requirement that any YAML processor be implemented using this exact
stack (or even a stack at all) but it allows us to talk about YAML processing
in a more specific and granular way.

### Basic Load Stack

This set of transforms takes YAML text as a byte stream of unicode encoded
character (UTF8, UTF16, etc), from a file, socket, string etc and transforms
them towards a form that a computer program can work with. It may take the
inforation all the way into a language native data structure, or it may stop
short, depending on the application.

At each level of the load stack certain details may be discarded (BOMs,
indentation, quoting styles, comments, line numbers, etc) although it is up to
the implementor where those things happen.

* Read - `Byte Stream -> Unicode Character Stream`
* Scan - `Unicode Character Stream -> Substrings`
* Lex - `Substrings -> Tokens`
* Parse - `Tokens -> Events`
* Compose - `Events -> YAML Representation Graph`
* Construct - `YAML Representation Graph -> Native Data Structure`

The Scan and Lex levels are often combined, but it is useful to talk about them
separately.

### Basic Dump Stack

This set of transforms take data from a program's in-memory state and move them
towards a YAML byte stream.

At each level of the dump stack certain details must be
provided/gleaned/guessed (indentation, quoting style, character encoding, etc)
to move the data along. This might be part of a "schema" or it might need to be
provided by the user of the YAML processor.

* Represent - `Native Data Structure -> YAML Representation Graph`
* Serialize - `YAML Representation Graph -> Events`
* Emit - `Events -> Tokens`
* Format - `Tokens -> Substrings`
* Join - `Substrings -> Unicode Character Stream`
* Write - `Unicode Character Stream -> Byte Stream`

The Emit Format and Join levels are often combined.



# YAML 1.3 Proposed Changes

This is the meat of this YAML 1.3 spec proposal document.
There will likely be a few dozen RFCs/proposals in here.
As the RFCs are discussed, some will be discarded or targeted to a later YAML version.


## Top level nodes are always unindented

See [RFC-030](../rfc/RFC-030.md).

Indentation of the top level nodes is not useful and makes indentation rules harder to reason about and implement.


## Maximum of 8 spaces for indentation

See [RFC-029](../rfc/RFC-029.md).

Arbitrary indentation is not very useful, complicates the language, and complicates implementation.


## Top level literal nodes must be indented

See [RFC-011](../rfc/RFC-011.md).

Unindented top level scalar text leads parser ambiguities.


## Tighten rules regarding `---` indicator

See [RFC-002](../rfc/RFC-002.md).


## Disallow implicit maps in flow sequences

```
# Not OK:
[ foo: 1, bar: 2 ]
# OK:
[ { foo: 1 }, { bar: 2 } ]
```


## Disallow flow collections as implicit block keys

See [RFC-007](../rfc/RFC-007.md).

```
# Not OK:
[1, 2]: true

# OK:
? [1, 2]: true
```


## Disallow carriage return (\r) as a break

See [RFC-006](../rfc/RFC-006.md).


## Remove 1024 character limits

See [RFC-001](../rfc/RFC-001.md).


## Characters that can appear in an anchor name

See [RFC-003](../rfc/RFC-003.md).


## Only allow empty values as block mapping values

See [RFC-015](../rfc/RFC-015.md).


## Disallow tabs as syntax whitespace

**Needs RFC**.

Only allowed in literal scalar content.


## Allow anchors to come after their aliases

**Needs RFC**.


## Allow aliases that have not anchors in document

**Needs RFC**.

Must come from another source.
Could be a variables document in the stream.


## Require string keys with whitespace to be quoted

**Needs RFC**.


## Allow an alias to have an anchor

**Needs RFC**.


## Allow a node to have multiple anchors

**Needs RFC**.


## Remove wiki-like syntax from folded block scalars

See [RFC-012](../rfc/RFC-012.md).


## Disallow mixing implicit and explicit mapping style

See [RFC-013](../rfc/RFC-013.md).


## Fixed position of node properties and block scalar indicators

See [RFC-010](../rfc/RFC-010.md).


## Disallow colon at the end of plain scalars

See [RFC-017](../rfc/RFC-017.md).


## Remove Tag URI Expansion

See [RFC-019](../rfc/RFC-019.md).


## Fix Regexp for Floats in JSON Schema

See [RFC-025](../rfc/RFC-025.md).


## Forbid bare documents (except the first)

See [RFC-028](../rfc/RFC-028.md).

