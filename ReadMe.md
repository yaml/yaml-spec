The YAML Specification
======================

This is the official repository for the YAML specification.

This project has several independent branches and repos:

* [spec-1.2](../../tree/spec-1.2/)
  The original YAML (1.0, 1.1 and 1.2) specification setup.
  This used to be the master branch of this repository.
* [spec-1.3](../../tree/spec-1.3/)
  The new YAML 1.3 specification
* [grammar](../../../yaml-grammar/)
  The YAML grammar in various forms
* [rfc](../../tree/rfc/)
  The RFCs for changes to the YAML language
* [wiki](../../wiki/)
  The (deprecated) wiki for this repository

## Working with this repository

The `master` branch just has this ReadMe file and a `Makefile`.
You can run `make work` to make subdirectories containing all the work branches.
The subdirectories are git worktrees or clones, so you can git pull, commit, push, etc.

You can run `make status` to see the status of each work branch subdirectory.
