---
rfc: RFC-0000
title: Template for a new YAML RFC
status: new
requires: RFC-XXXX RFC-XXXX
related: RFC-XXXX RFC-XXXX
discuss:
tags: foo bar
---
<!--
This is a template file for creating a new RFC for the YAML specification.

These instructions in this Markdown/HTML comment should be deleted.

The section above this comment section is the "front matter" YAML.
It has to start on line 1.

## Instructions

* First come up with a 'title' for your RFC.
  * It should be around 20-50 chanracters long.
  * Something like "Support tabs for indentation".
* Fashion a 'name' for the RFC.
  * Is should be 3 to 5 words, lowercase and dash separated.
  * Something like 'tab-indentation-support'.
* Copy this template to a file called `RFC-tab-indentation-support.md`.
* Delete this comment section.
* Edit the front matter as follows:
  * Change 'title' to your RFC's title.
  * Set or remove the 'requires' and 'related' values.
  * Set the 'tags' to a list of values from the `rfc/tags` file.
  * Leave the other values asis.
* Edit the markdown below to suit your needs.
* Commit, push and create a Pull Request.

## Style

All sentences should start on a new line.
All lines should not exceed 79 characters if possible.
-->

## Problem

Succinctly state the problem be solved by this RFC.
One to two paragraphs.
Don't use examples unless absolutely necessary.


## Proposal

Succintly state the proposed solution to problem.
One to two paragraphs.
Don't use examples unless absolutely necessary.


## Explanation

This is where you should put a full discussion history, details and
implications of the problem and the solution.
Reference all the details about current common usage and implementations.
The tone and style can be more casual than the sections above.

This section may also contain code block examples here of how things will be
after the solution is in place.

OK:
```
{ null: bar }
```

Error:
```
{ : bar }
```


## See Also

This should be a list of external links if relevant.
If there is nothing else to see you can leave this section out.

* http://...
