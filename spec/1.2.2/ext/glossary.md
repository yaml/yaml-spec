YAML Vocabulary Glossary
========================

The YAML data language and its specification has its own vocabulary.
It is important to use the correct terms when developers discuss YAML topics.

## A

Alias
:
A serialization tree node that refers to another node.
The alias `*foo` is a reference to a node with an anchor `&foo`.
Aliases are not part of the representation graph.

Anchor
:
A label attached to a node in the serialization tree.
The node can be used elsewhere in the serialization tree by referencing it with
an alias.
A node with the anchor `&foo` can be referenced elsewhere with the alias
`*foo`.
Anchors are not part of the representation graph.

Application
:
An end user program using a YAML framework.

## B

Block Style
:
The indentation-based scoping style that YAML is best known for.
Block style nodes may contain either block or flow style nodes.

Boolean
:
A data type consisting of the values true and false.
Represented in YAML by the tag `tag:yaml.org,2002:bool`.
Typically, schemas will interpret the plain scalars `true` and `false` as
booleans.

## C

Canonical form
:
A standard form of a scalar node's content.
The canonical form depends on the node's tag and on it's formatted content.
For example, the canonical form of a node with tag `tag:yaml.org,2002:number`
and formatted content `0xabc` is `2748`.
During composition, each node's formatted content is replaced by its canonical
form, so the content of scalar nodes in the representation graph is always in
canonical form.

Comment
:
Text in a YAML file that is intended for humans to read, and which is ignored
by processors.
Comments begin with the `#` character and continue to the end of the line.

Composition
:
The process that turns a serialization tree into a representation graph.
As part of composition, aliases are identified with anchored nodes,
non-specific tags are resolved, and scalar node content is converted to
canonical form.
Composition depends on a schema, which determines how tags are resolved.

Construction
:
The process that turns a representation graph into native data structures.
The details of construction will vary by implementation.

## D

Data model
:
One of the data models defined by the YAML spec: the presentation stream,
serialization tree, and representation graph.

Directive
:
An instruction to the parser beginning with `%`.
YAML 1.2 defines 2 directives: `%YAML ...` and `%TAG ...`.
Directives are not part of the serialization tree or the representation graph.

Document
:
Part of a stream that will be loaded as a representation graph.
Most YAML files consist of a single YAML document, although they may also have
zero or multiple documents.

Double-quoted scalar
:
A scalar surrounded by double quotes.
Any string can be represented as a double-quoted string using escape sequences.

Dumping
:
The process of turning native data structures into a presentation stream.
Dumping consists of the sub-processes of representation, serialization, and
presentation.

## F

Flow style
:
The node style that uses curly braces to present mappings and square brackets
to present sequences.
Flow style is similar to JSON.
Flow style nodes may only contain other flow style nodes, not block style
nodes.

Folded scalar style
:
Block scalars defined with the `>` indicator.
Single newlines in folded block scalars are replaced by spaces, and *n*
consecutive newlines are replaced by *n* - 1 newlines.

Formatted content
:
The content of a scalar node in the serialization tree, independent of
presentation details such as node style but not necessarily in canonical form.
For instance, the plain scalar `1.0` and the quoted scalars `"1.0"` and `'1.0'`
all have the same formatted content, but the plain scalar `1.00` has different
formatted content.

## K

Kind
:
There are three kinds of nodes in a representation graph: mappings, sequences,
and scalars.


## L

Literal scalar style
:
Block scalars defined with the `|` indicator.
Newlines in literal scalars are preserved.

Loading
:
The process of turning a presentation stream into native data structures.
Loading consists of the sub-processes of parsing, composition, and
construction.

## M

Mapping
:
A kind of YAML node whose content is an unordered set of zero or more key/value
pairs.
Keys and values may be any kind of node.
Mapping keys must be unique.

## N

Native data structures
:
Values in some implementation that are the final product of loading or the
initial inputs to dumping.
Native data structures will vary by implementation.
For instance, an implementation written in Python might use the Python types
`list`, `dict`, `str`, `int`, and so on.

Node
:
An element of a representation graph or serialization tree.
Mappings, sequences, scalars are nodes.
An alias is a reference to a node.
Anchors and tags are annotations to nodes.

Null
:
A data type representing nothing or the lack of a value.
Represented in YAML by the tag `tag:yaml.org,2002:null`.
Typically, schemas will interpret the plain scalar `null` as a null value.

## P

Parsing
:
The process in the load stack turns a presentation stream into a serialization
tree.

Plain scalar
:
A scalar whose value is unquoted.
Plain scalars without explicit tags are usually resolved during composition.
Not all scalars can be presented in the plain style.

Presentation stream
:
A sequence of Unicode characters that can be parsed into a serialization tree.
The presentation stream includes presentational details such as node style,
directives, comments, and whitespace that do not exist in the other data
models.

Process
:
One of the defined processes in the spec that turns one data model into
another.
The top-level processes are loading and dumping.
Loading includes the processes of parsing, composition, and construction, and
dumping includes the processes of representation, serialization, and
presentation.

## R

Representation
:
The process that turns native data structures into a representation graph.

Representation graph
:
A graph of mapping, sequence, and scalar nodes that is the result of
composition or representation.
The representation graph does not contain any presentational information such
as node style or document directives, nor does it contain aliases.
All nodes in the representation graph have resolved tags and their content is
in canonical form.
The representation graph may contain cycles — nodes that contain themselves.

## S

Scalar
:
A leaf node whose content is a single string of characters.
Native data structures such as strings, numbers, and booleans can be
represented as scalars.

Schema
:
A set of tags, and rules for resolving non-specific tags.
Schemas are used in composition, and may also be used in serialization.

Sequence
:
A node whose content is an ordered list of zero or more nodes.

Serialization
:
The process that turns a representation graph into a serialization tree.
Serialization may introduce anchors and alias nodes to avoid cycles.
It may also remove explicit tags when the schema renders them unnecessary.

Serialization tree
:
A tree of mapping, sequence, and alias nodes that is the result of parsing or
serialization.
The serialization tree does not contain any presentational information such as
node style or document directives.
Node tags may be unresolved and their content may not be in canonical form.
The serialization tree cannot contain cycles.
Instead, alias nodes and anchors are used to represent cyclic data.

Single-quoted scalar
:
A scalar surrounded by single quotes.
Single-quoted scalars can contain any printable characters.
The single quote character itself must be escaped using two single quotes (e.g.
`'YAML ain''t a markup language'`).

Style
:
The way that a node is presented in the presentation stream.
Mappings and collections may be presented in the block or flow styles.
Scalars may be presented in the plain, single-quotes, double-quoted, literal,
or folded styles.
Node style is only part of the presentation stream, not the serialization tree
or representation graph.

## T

Tag
:
A tag is an annotation on a node that roughly corresponds to a data type.
In the presentation stream, tags are identifers preceded by a `!`, like `!foo`
or `!!str`.
In the serialization tree, every node has either a specific or a non-specific
tag.
During composition, non-specific tags are resolved to specific tags, so every
node in the representation graph has a specific tag.

## Y

YAML
:
YAML is a programming-language-agnostic data serialization language.
"YAML" rhymes with "camel".
YAML is a recursive acronym that stands for "YAML Ain't Markup Language".
People often think YAML is Yet Another Markup Language, but it Ain't!
