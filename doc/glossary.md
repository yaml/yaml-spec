YAML Vocabulary Glossary
========================

The YAML language has its own vocabulary.
It is important to use the correct terms when developers discuss YAML topics.
For example the terms: `list`, `array` and `sequence` seem like they are the
same thing and can be used interchangably, but in YAML they have different
meanings.

## A

* Alias

  An alias is a reference to another YAML node.
  It similar to a pointer in the C programming language.
  The alias `*foo` is a reference to a node with an anchor `&foo`.

* Anchor

  An anchor is a label attached to a node.
  The node can be used elsewhere by referencing it with an alias.
  A node with the anchor `&foo` can be referenced elsewhere with the alias
  `*foo`.

* Application

  An end user program using a YAML framework.

* Array

  The word array is sometimes used to refer to a native data structure
  typically constructed from a sequence node.

## B

* Block / Block Collection Style

  Block collections are written in the indentation-based scoping style that
  YAML is most known for.

* Boolean

  Boolean is a native state consisting of the values true and false.
  Most constructors/schemas support booleans.
  It is typical for a schema to use the plain scalars `true` and `false` to
  assign the boolean tag function.

## C

* Comment

  Text in a YAML file that is typically intended for humans to read, but not
  considered part of the YAML data model.
  Comment text may be discarded entirely by a parser.
  It may also be reported as events and stored in the DOM or possibly in a
  native data structure.
  Syntactically, comments are text starting with a `#` character and continuing
  to the end of the line.

  Comments may be used within YAML documents or before/between/after them (in
  the YAML stream).

* Composer

  A composer is the processor in a load stack that gets events from a parser
  and uses them to create the DOM state.

* Constructor

  A constructor is the processor in a load stack that iterates over a DOM tree
  and creates a native representation.

## D

* Directive

  A directive is an instruction to the parser.
  YAML 1.2 defines 2 directives: `%YAML ...` and `%TAG ...`.
  Directives are part of a YAML stream, but not part of YAML documents or the
  YAML data model.

* Document

  A document is a top level YAML node.
  Most YAML files consist of a single YAML document, although they may also
  have zero or multiple documents.

* Double quoted scalar

  Scalar values written in the double quote style are capable of expressing any
  possible string value.
  The double quoted style is the only scalar style capable of that.
  They use a number of escape sequences to represent non-printable characters.

* DOM

  A DOM is an information state that is a tree of nodes created by a composer
  or a representer and consumed by a constructor or a serializer.
  A DOM may also be consumed directly by an application.
  A DOM API can offer a lot more information and processing options than a
  native data structure.

  Frameworks do not need to implement a DOM as part of their stacks, as long as
  they adhere to the YAML specification rules for moving information through
  the DOM.

* Dumper / Dump

  A dumper is a processor that links all the processors of a dump stack, taking
  information all the way from native to file states.

* Dump Stack

  The set of processors that move YAML information from a native state to a
  file state.

## E

* Emitter / Emit

  An emitter is the process in the dump stack that turns events into tokens.
  In the dump stack the events come from the serializer.
  In stream processing the events would come from an application filter process
  that would typically be reading events from a parser.

* Event

  An event is an information state produced by a parser or serializer and
  consumed by a composer or emitter.
  Event types include:

  * stream-start
  * stream-end
  * document-start
  * document-end
  * mapping-start
  * mapping-end
  * sequence-start
  * sequence-end
  * scalar-value
  * alias-name

## F

* File

  File is the term for YAML information in a final textual state, external to
  the YAML stack.
  A YAML framework loads from a file and dumps to a file.
  The term is abstract and doesn't have to be a file stored to disk.
  It might be a socket or other external data source/target.

* Flow / Flow Collection Style

  In YAML, mappings and sequences can be represented in a style that uses curly
  braces and square brackets in the same manner that JSON does.
  Block collections may contain any collection nodes in the flow style, but
  flow collections may only contain collections in the flow style.

* Folded Scalar Style

  Folded scalars occur only in block collections.
  They are indicated by a greater-than sign.
  The indented lines that follow replace newlines with a space, and two or more
  consecutive newlines with n-1 literal newlines.

* Framework / YAML Framework

  A full YAML processing implementation in a given programming language.
  A framework almost always has at least a Loader and a Dumper.
  A complete, full-featured YAML framework would also support things like
  schema processors, path referencing, DOM API and standard library support,
  among many other details.

## H

* Hash

  The word hash is sometimes used to refer to a native data structure typically
  constructed from a mapping node.

## I

* Information

  Any of the various data bits flowing through a YAML stack.

## J

* JSON

  When used with the JSON Schema or a derivative of that schema, YAML is a
  syntactic and semantic superset of the JSON data format.
  That is, a YAML loader using such a schema (which is typical) can load a JSON
  file and produce the same result as a JSON loading (often called `parse`)
  process.

## K

* Kind

  There are 3 kinds of nodes in YAML: mappings, sequences and scalars.
  A kind refers to the raw structure.
  A kind should not be confused with a type.

## L

* Library

  The DOM resolves tags to functions.
  These functions come from the library that is registered to the DOM; often
  the YAML standard library.

* List

  A list is a property of a type.
  List types are often made from sequence nodes, but they can be result of any
  tag function whose return type is a list type.

* Literal / Literal Scalar Style

  The literal scalar is similar to the heredoc style found in some programming
  languages like Perl and Bash.
  No character escaping is allowed and newlines are literal.
  Any valid YAML file's content can be encoded in the literal style by simply
  indenting it.

* Loader / Load

  A dumper is a processor that links all the processors of a dump stack, taking
  information all the way from native to file states.

* Load Stack

  The set of processors that move YAML information from the file state to the
  native state: read, lex, parse, compose, construct.

## M

* Mapping

  A mapping is a kind of YAML node that consists of a set of zero or more
  key/value pairs.
  Any kind of node is allowed to be a key, even though native models rarely
  support this.
  Equivalent keys (if they can be detected) are not supported.

* Model / Data Model

  This word describes elementary kinds of data that YAML represents.
  A YAML file is a stream of YAML documents each of which have one root node.
  Nodes may be mappings, sequences or scalars.
  Nodes may be annotated with anchors and/or tags.
  An alias may be used for any node.

## N

* Native / Native Object

  A language specific state that is the final result of a loader, or the
  initial state given to a dumper.
  This state is defined by the programming language being used, or maybe a form
  crafted by the author of the application.
  Some YAML frameworks may use the DOM state as their native state.

  As an example, in Python, generic native states include dictionaries, lists,
  tuples and values.
  Custom native states include the instance objects of Python classes.

* Node

  A node is an addressable point in a YAML document.
  Mappings, sequences, scalars are nodes.
  An alias is a reference to a node.
  Anchors and tags are annotations to nodes.

* Null

  Null is a native value supported by most schemas.
  The plain value `null` as well as the plain empty value is most often used to
  represent it.

## P

* Parser / Parse

  A parser is the processor in the load stack that reads tokens, matches them
  against a grammar and write events.
  It may also throw an error if the tokens don't match the grammar.
  The events are usually consumed by the composer to create a DOM, but they
  might also be processed directly by a streaming application.

* Plain Scalar

  Plain refers to the quoting style of a scalar where the value is unquoted; as
  opposed to single/double quoted or literal or folded styles.
  A scalar-value event contains a flag as to whether the scalar was plain or
  not.
  Plain scalars are often assigned tags based on their content value.

* Processor

  A component in the load stack or dump stack to transforms data from one state
  to another.
  Load stack processors include: reader, lexer, parser, composer and
  constructor.
  Dump stack processors include: representer, serializer, emitter, streamer and
  writer.

## R

* Reader / Read

  A reader is a processor in the load stack that reads a file and produces a
  stream of unicode characters.

* Reference

  A reference can be thought of as a pointer to another node in the DOM.
  In YAML 1.2 the only references are aliases.

* Representer / Represent

  A representer is a process that turns native programming data into a YAML DOM
  state.

## S

* Scalar

  A scalar is a a leaf node that contains exactly one value.
  Strings, numbers and booean values are examples of scalars.

* Schema

  Schema in YAML refers to all the external information required to process a
  YAML stream.
  Unlike traditional schemas which typically enforce the structural typing of
  information, a YAML schema can alter the semantic meaning of a YAML file.

  In YAML 1.2, schemas are almost always expressed in the source code of the
  framework.
  In future versions, a YAML Schema language can be used to control the
  behavior of a framework (if the framework supports it).

* Sequence

  A sequence is a collection node that consists of zero or more nodes.

* Serializer / Serialize

  A serializer is the process in the dump stack that iterates over the DOM and
  produces events that are typically sent to an emitter.

* Single quoted scalar

  Scalar values written in the single quote style can contain any sequence of
  printable characters except the single quote itself.
  The single quotes must be escaped using two single quotes (`''`).

* Stack / YAML Stack

  YAML processing occurs as 2 stacks of processors, each moving data (in
  opposite directions) between YAML formatted text and computer memory states.
  They are called the load stack and the dump stack.
  Collectively the 2 stacks may be referred to as "the YAML stack".

* Standard Library

  Versions of YAML after 1.2 define a standard library of tag functions.

* State

  A form that YAML information is in during various stages of the stack.
  States include: files, characters, tokens, events, DOMs and native objects.
  For instance an "event" is a data state produced by a parser or a serializer,
  and consumed by a composer or an emitter.

* Stream (Character Stream)

  The set of unicode characters produced by a reader or streamer and consumed
  by a lexer or writer.

* Stream (YAML Stream or Document Stream)

  A YAML file is considered a "stream" of zero or more documents.
  A stream may also have directives and/or comments before, between or after
  the documents.
  This is the typical meaning when the word "stream" is used with no qualifier.

* Streamer

  This is the dump stack sister process to the lexer.
  It simply joins tokens into a character stream.

* String

  String is a heavily overloaded term in YAML and depends on the context in
  which it is used.

* Style

  YAML has multiple styles to represent collections and scalars.
  Collection styles are "block" and "flow".
  Scalar styles are "plain", "single quoted", "double quoted", "literal" and
  "folded".

## T

* Tag

  A tag is an annotation on a node.
  Tags are identifers preceded by a `!`, like `!foo` or `!!str`.
  A tag identifier is used to identify a function that will be applied to a
  node when it is retrieved from the DOM.
  The function's return type is can be considered the "type" of the node.

  While tags may be written explicitly into a YAML file using the `!abc`
  syntax, it is quite common for tags to be added to nodes implicitly according
  to the rules of a schema.

* Token

  A token is a piece of information that is produced by a lexer or emitter.
  A token has a name and a value.
  The value is a sequence of zero or more contiguous characters from (or for) a
  character stream.

* Type

  A type is a set of constraints on a node.
  Types are defined by schemas.

## W

* Writer / Write

  A writer is the processor in a dump stack that encodes unicode characters and
  writes them to a file state.

## Y

* YAML

  YAML is a programming-language-agnostic data serialization language.
  "YAML" rhymes with "camel".
  YAML is a recursive backronym that stands for "YAML Ain't Markup Language".
  People often think YAML is Yet Another Markup Language, but it Ain't!
