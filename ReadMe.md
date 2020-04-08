The YAML Specification
======================

This is the official repository for the YAML specification.

# Repository Layout and Organization

* The code for the YAML spec 1.0-1.2 (used to be the master branch) is now in a branch called `spec-1.2`.

* The repository has a [wiki](../../wiki/) but its contents are currently deprecated.
  The relevant content has been moved into this repo.
  The wiki may be used for other purposes in the future.

## Subdirectories

* `rfc/`
  A set of RFC files, where each one is the full details of a possible change to the language.
  This directory contains all the RFCs, regardless of the YAML spec version they are targeted for, or whether or not they are currently considered applicable.

* `spec-1.3/`
  All the relevant assets for defining the YAML 1.3 specification.
  * `rfc/`
    This directory contains symlinks to the RFC files that are currently considered applicable to the 1.3 spec.

## Branches

* `gh-pages`
  This is where the current online [YAML Spec](https://yaml.org/spec/) is served from.

* `spec-1.2`
  The code and content files for generating the current 1.0-1.2 specs.

## Related Repositories

* [grammar](../../../yaml-grammar/)
  The YAML grammar in various forms
* [wiki](../../wiki/)
  The (deprecated) wiki for this repository

## Working with this repository

You can run `make work` to make subdirectories containing all the work branches and related repo clones.

You can run `make status` to see the status of each work subdirectory.
