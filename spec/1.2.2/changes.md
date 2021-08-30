# YAML Specification Changes

The current version of the YAML language is **1.2** and the current YAML
specification version is **1.2.2**.

## Changes in v1.2.2 (YYYY-MM-DD)

* Host the YAML specification sources in a [public repository^]
* Change the source format from DocBook to Markdown
* Correct known errata from the previous specification
* Address many [reported issues^]
* Clarify wording and examples
* Removed sentences that are no longer relevant in 2021
* Fixed known bugs in the grammar productions

## Changes in v1.2.1 (2009-10-01)

Patches and error corrections:

* 1.1. Goals: Switched the order between goals 2 and 3 (pointed out by BlueGM).
* 1.3. Relation to JSON: Added paragraph 4 to section 1.3 to clarify JSON
  compatibility in the presence of duplicate mapping keys (pointed out by Osamu
  Takeuchi).
* 3.1. Processes: Changed "`refernced`" to "`referenced`" (pointed out by Brad
  Baxter).
* 4.1. Production Parameters: Changed "`sensitivity`" to "`context
  sensitivity`" (pointed out by Brad Baxter).
* 4.1. Production Parameters / Context c: Changed "`as values inside one
  (flow-out)`" to "`as values outside one (flow-out)`" (pointed out by Brad
  Baxter).
* 4.1. Production Parameters / (Block) Chomping t: Changed "`either case`" to
  "`all cases`" (pointed out by Brad Baxter).
* 5.3. Indicator Characters: Changed all cases of "`#XX`" to "`#xXX`" (pointed
  out by Brad Baxter).
* 5.4. Line Break Characters: Changed "`the above line breaks`" to "`the above
  non-ASCII line breaks`" (pointed out by Osamu Takeuchi). Also, Changed "`Note
  these`" to "`Note that these`" (pointed out by Brad Baxter).
* 5.6. Miscellaneous Characters: Changed "`URIs`" to "`URI`" (pointed out by
  Brad Baxter).
* 5.7. Escaped Characters: Changed "`#xA`" to "`#xC`" (pointed out by Brad
  Baxter).
* 6.3. Line Prefixes / Example 6.4. Line Prefixes: Added a missing line break
  on the right hand side (pointed out by Osamu Takeuchi and Jesse Beder).
* 6.8.1. YAML Directive: Changed "`Note version`" to "`Note that version`"
  (pointed out by Brad Baxter).
* 7.3.1. Double-Quoted Style / Example 7.6. Double Quoted Lines: Removed all
  "`,`" characters (pointed out by Brad Baxter).
* 7.3.2. Single-Quoted Style / Example 7.9. Single Quoted Lines: Removed all
  "`,`" characters (pointed out by Brad Baxter).
* 7.3.3. Plain Style / [126] ns-plain-first(c): Changed lookahead from
  "`ns-char`" to "`ns-plain-safe(c)`" (pointed out by Osamu Takeuchi).
* 7.3.3. Plain Style / [127-129] ns-plain-safe(c): Changed to be "safe for use
  in lookahead" instead of "safe for use in content", to support the lookahead
  fixes pointed out by Osamu Takeuchi.
* 7.3.3. Plain Style / [130] ns-plain-char(c): Changed lookahead from
  "`ns-char`" to "`ns-plain-safe(c)`" (pointed out by Osamu Takeuchi).
* 7.3.3. Plain Style / Example 7.10. Plain Characters: Added missing right hand
  side entries (pointed out by Brad Baxter).
* 7.3.3. Plain Style / Example 7.12. Plain Lines: Removed all "`,`" characters
  (pointed out by Brad Baxter).
* 7.4.2. Flow mappings: Changed "`Note the`" to "`Note that the`" (pointed out
  by Brad Baxter).
* 7.4.2. Flow mappings / [147] c-ns-flow-map-separate-value(n,c): Added
  negative lookahead for "`ns-plain-safe(c)`" after the "`c-mapping-value`"
  (pointed out by Oren Ben-Kiki). This actually existed in the YamlReference
  implementation (as a negative lookahead for "`ns-char`", which also needs to
  be fixed).
* 8.1.1.1. Block Indentation Indicator: Changed "`Content Content`" to
  "`Content`" (pointed out by Brad Baxter).
* 8.1.1.1. Block Indentation Indicator / Example 8.2. Block Indentation
  Indicator: Changed "`Detected`" to "`detected`" on the left hand side
  (pointed out by Brad Baxter).
* 8.1.1.2. Block Chomping Indicator / [165] b-chomped-last: Added EOF as a
  valid option (pointed out by Osamu Takeuchi).
* 8.1.2. Literal Style: Changed "`Note all`" to "`Note that all`" (pointed out
  by Brad Baxter).
* 8.1.3. Folded Style: Changed "`separating between`" to "`separating`"
  (pointed out by Brad Baxter).
* 8.1.3. Folded Style / [178] - b-chomped-last: Changed "`folded`" to the
  correct "`block-in`" (Pointed out by Osamu Takeuchi).
* 8.2.1. Block Sequences: Changed "`Note it`" to "`Note that it`" (pointed out
  by Brad Baxter).
* 8.2.2. Block Mappings: Changed "`Note YAML`" to "`Note that YAML`" and "`Note
  it`" to "`Note that it`" (pointed out by Brad Baxter).
* 9.1.3. Bare Documents / Example 9.3. Bare Documents: Changed "`%PS`" to
  "`%!PS`" on the right hand side (pointed out by Brad Baxter).
* 9.1.5. Directives Documents / Example 9.5. Directives Documents: Removes the
  "`!!map`" on the right hand side (pointed out by Osamu Takeuchi).
* 9.2. Streams / Concatenating Streams: Changed "`separate between`" to
  "`separate`""`an document`" to "`a document`", and "`Note this`" to "`Note
  that this`", (pointed out by Brad Baxter).
* 10. Recommended Schemas: Changed "`a a`" to "`a`" (pointed out by Brad
  Baxter).
* 10.2.1.2. Boolean: Changed "`an native`" to "`a native`" (pointed out by Brad
  Baxter).

## Changes in v1.2.0 (2009-07-21)

The most significant difference between YAML 1.1 and YAML 1.2 is the
introduction of the core data schema as the recommended default, replacing the
YAML 1.1 type library.

* Only `true` and `false` strings are parsed as booleans (including `True` and
  `TRUE`); `y`, `yes`, `on`, and their negative counterparts are parsed as
  strings.
* Underlines `_` cannot be used within numerical values.
* Octal values need a `0o` prefix; e.g. `010` is now parsed with the value 10
  rather than 8.
* The binary and sexagesimal integer formats have been dropped.
* The `!!pairs`, `!!omap`, `!!set`, `!!timestamp` and `!!binary` types have
  been dropped.
* The merge `<<` and value `=` special mapping keys have been removed.

The other major change has been to make sure that YAML 1.2 is a valid superset
of JSON.
Additionally there are some minor differences between the parsing rules:

* The next-line `\x85`, line-separator `\u2028` and paragraph-separator
  `\u2029` characters are no longer considered line-break characters. Within
  scalar values, this means that next-line characters will not be included in
  the white-space normalization. Using any of these outside scalar values is
  likely to result in errors during parsing. For a relatively robust solution,
  try replacing `\x85` and `\u2028` with `\n` and `\u2029` with `\n\n`.
* Tag shorthands can no longer include any of the characters `,[]{}`, but can
  include `#`. To work around this, either fix your tag names or use verbatim
  tags.
* Anchors can no longer include any of the characters `,[]{}`.
* Inside double-quoted strings `\/` is now a valid escape for the `/`
  character.
* No space is required after the colon in flow style if the key is quoted, e.g.
  `{"key":value}`.
* The maximum key length of 1024 characters has been removed for flow mapping
  keys.
* Quoted content can include practically all Unicode characters.
* Documents in streams are now independent of each other, and no longer inherit
  preceding document directives if they do not define their own.
* Explicit document-end marker is now always required before a directive.

## Changes in v1.1 (2005-01-18)

The most significant difference between these versions is the complete
refactoring of the tag syntax.

* The `%TAG` directive has been added, along with the `!foo!` tag prefix
  shorthand notation.
* The `^` character no longer enables tag prefixing.
* The private vs. default scoping of `!` and `!!` tag prefixes has been
  switched around; `!!str` is now a default tag while `!bar` is an
  application-specific tag.
* Verbatim `!<baz>` tag notation has been added.
* The formal `tag:domain,date/path` format for tag names has been dropped as a
  requirement.

Additionally, the formal description of the language describing the document
structure has been completely refactored between these versions, but the
described intent has not changed.
Other changes include:

* A `\` escape has been added for the tab character, in addition to the
  pre-existing `\t`.
* The `\^` escape has been removed.
* Directives now use a blank space `' '` rather than `:` as the separator
  between the name and its parameter/value.

## First published as v1.0 (2004-01-29)

First release!
