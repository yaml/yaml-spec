YAML Spec RFCs
==============

The planning for the upcoming versions of the YAML Specification is being
facilitated by public **Request For Comment** (RFC) documents.
Currently the [YAML core team](https://github.com/orgs/yaml/teams/core/members)
is working on the next version(s) of the YAML specification.
All RFC documents, regardless of their intended target version, will reside in
this directory.

## RFC Process

RFCs start out as GitHub Pull Requests (PRs) and should be based on the
[RFC Template](RFC-0000-template.md) file.
Each PR is reviewed by the core team to make sure it is something that should
be under consideration/discussion.

When an RFC is approved by the core team it is merged to the yaml-spec `main`
branch.
At that point it is assigned a permanent RFC # and has a document that lives in
the `rfc` directory.

Anyone is welcome to submit an RFC as a PR, but it might make sense to file an
issue to discuss it first.
The core team has about 50 ideas that are being worked into RFC PRs.

When an RFC becomes permanent, it also will be assigned a discussion link.
We'll be using GitHub Issues initially.

Please keep comments brief and to the point.
Contentless opinions such as thumbs up and down or "+1" comments will not have
an effect on the outcome of an RFC and are highly discouraged.

## YAML Specification Process

YAML 1.0, 1.1 and 1.2 were specified in one large document.
Future YAML versions will be specified as multiple parts including:

* [YAML Syntax EBNF Grammar]()
* [YAML Test Suite]()
* [YAML Language Guide]()
* [YAML DOM Specification]()
* [YAML Schema Specifications]()
* [YAML Implementers Guide]()
* [YAML Spec Change Log]()

The various parts will be robustly cross-referenced to form a cohesive whole.
