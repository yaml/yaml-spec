# Errata For The YAML 1.2 Specification

## Last Updated On 2009-10-01

----

[%toc%]

# Chapter 1.  Errata For the latest patched [2009-10-01](http://yaml.org/spec/1.2/spec.html) revision

None known.

# Chapter 2.  Errata For the original [2009-07-21](http://yaml.org/spec/1.2/2009-07-21/spec.html) revision

1.1. Goals

Switched the order between goals 2 and 3 (pointed out by BlueGM).

1.3. Relation to JSON

Added paragraph 4 to section 1.3 to clarify JSON compatibility in the presence
of duplicate mapping keys (pointed out by Osamu Takeuchi).

3.1. Processes

Changed "refernced" to "referenced" (pointed out by Brad Baxter).

4.1. Production Parameters

Changed "sensitivity" to "context sensitivity" (pointed out by Brad Baxter).

4.1. Production Parameters / Context c

Changed "as values inside one (flow-out)" to "as values outside one (flow-out)"
(pointed out by Brad Baxter).

4.1. Production Parameters / (Block) Chomping t

Changed "either case" to "all cases" (pointed out by Brad Baxter).

5.3. Indicator Characters

Changed all cases of "#`XX`" to "#x`XX`" (pointed out by Brad Baxter).

5.4. Line Break Characters

Changed "the above line breaks" to "the above non-ASCII line breaks" (pointed
out by Osamu Takeuchi).
Also, Changed "Note these" to "Note that these" (pointed out by Brad Baxter).

5.6. Miscellaneous Characters

Changed "URIs" to "URI" (pointed out by Brad Baxter).

5.7. Escaped Characters

Changed "#xA" to "#xC" (pointed out by Brad Baxter).

6.3. Line Prefixes / Example 6.4. Line Prefixes

Added a missing line break on the right hand side (pointed out by Osamu
Takeuchi and Jesse Beder).

6.8.1. YAML Directive

Changed "Note version" to "Note that version" (pointed out by Brad Baxter).

7.3.1. Double-Quoted Style / Example 7.6. Double Quoted Lines

Removed all "," characters (pointed out by Brad Baxter).

7.3.2. Single-Quoted Style / Example 7.9. Single Quoted Lines

Removed all "," characters (pointed out by Brad Baxter).

7.3.3. Plain Style / \[126\] ns-plain-first(c)

Changed lookahead from "ns-char" to "ns-plain-safe(c)" (pointed out by Osamu
Takeuchi).

7.3.3. Plain Style / \[127-129\] ns-plain-safe(c)

Changed to be "safe for use in lookahead" instead of "safe for use in content",
to support the lookahead fixes pointed out by Osamu Takeuchi.

7.3.3. Plain Style / \[130\] ns-plain-char(c)

Changed lookahead from "ns-char" to "ns-plain-safe(c)" (pointed out by Osamu
Takeuchi).

7.3.3. Plain Style / Example 7.10. Plain Characters

Added missing right hand side entries (pointed out by Brad Baxter).

7.3.3. Plain Style / Example 7.12. Plain Lines

Removed all "," characters (pointed out by Brad Baxter).

7.4.2. Flow mappings

Changed "Note the" to "Note that the" (pointed out by Brad Baxter).

7.4.2. Flow mappings / \[147\] c-ns-flow-map-separate-value(n,c)

Added negative lookahead for "ns-plain-safe(c)" after the "c-mapping-value"
(pointed out by Oren Ben-Kiki).
This actually existed in the YamlReference implementation (as a negative
lookahead for "ns-char", which also needs to be fixed).

8.1.1.1. Block Indentation Indicator

Changed "Content Content" to "Content" (pointed out by Brad Baxter).

8.1.1.1. Block Indentation Indicator / Example 8.2. Block Indentation Indicator

Changed "Detected" to "detected" on the left hand side (pointed out by Brad
Baxter).

8.1.1.2. Block Chomping Indicator / \[165\] b-chomped-last

Added EOF as a valid option (pointed out by Osamu Takeuchi).

8.1.2. Literal Style

Changed "Note all" to "Note that all" (pointed out by Brad Baxter).

8.1.3. Folded Style

Changed "separating between" to "separating" (pointed out by Brad Baxter).

8.1.3. Folded Style / \[178\] - b-chomped-last

Changed "folded" to the correct "block-in" (Pointed out by Osamu Takeuchi).

8.2.1. Block Sequences

Changed "Note it" to "Note that it" (pointed out by Brad Baxter).

8.2.2. Block Mappings

Changed "Note YAML" to "Note that YAML" and "Note it" to "Note that it"
(pointed out by Brad Baxter).

9.1.3. Bare Documents / Example 9.3. Bare Documents

Changed "%PS" to "%!PS" on the right hand side (pointed out by Brad Baxter).

9.1.5. Directives Documents / Example 9.5. Directives Documents

Removes the "!!map" on the right hand side (pointed out by Osamu Takeuchi).

9.2. Streams / Concatenating Streams

Changed "separate between" to "separate""an document" to "a document", and
"Note this" to "Note that this", (pointed out by Brad Baxter).

10\. Recommended Schemas

Changed "a a" to "a" (pointed out by Brad Baxter).

10.2.1.2. Boolean

Changed "an native" to "a native" (pointed out by Brad Baxter).