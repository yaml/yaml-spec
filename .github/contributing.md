Contributing to the YAML Specification
======================================

Want to change the YAML Data Language?
You've come to the right place.

YAML is a versioned language and we're currently working on the next YAML
versions and specification revisions.

This is the official repository for the YAML Specification source files.
The project has an active [core team](spec/1.2.2/core.md) but we do all changes
publicly and take some direction from issues and pull requests.

Some good ways to get involved include:

* Reporting typos, mistakes, bugs etc
* Discussing ideas
* Submitting fixes for the build system


## RFC Process

Changes to the YAML language itself will be made using an RFC process.
We are still working out the final details of this process, but we intend to
have it all worked out by the end of October 2021.

For now we ask that you **don't submit RFCs** or comment on the ones that we
attempted to start earlier.


## Using the Build System

This repository has a build system for turning the spec source files into HTML
pages.
Even though the project is built with a lot of open source frameworks, the only
required local prerequisites are GNU `make`, Docker and NodeJS.

The system is currently set up to publish things to <https://spec.yaml.io>.

Everything you need to do with the build system is available as a `make`
command.
The most important ones are:

* `make serve` - Build the web contents and start a local serve to view.
  The system is all based on Jekyll, which is the system used internally by
  GitHub Pages.
  It's all taken care of for you by a Docker container, so don't bother
  installing Jekyll locally.

* `make test` - Runs lots of tests that make sure your changes are good.
  Even catches spelling mistakes!

* `make quick-test` - Run the basic tests in a blink.

* `make clean` - The `make` commands make a mess with generated files and this
  cleans it all up.


## Talk to Us

YAML tries to make data simple but specifying the language is admittedly very
hard.
If you think you have a good idea on how to change the language you might want
to chat with us first.

We hang out daily at <https://matrix.to/#/#chat:yaml.io>.
If you haven't tried Matrix yet, just click.
It's pretty cool.
We also hang out on [IRC](https://web.libera.chat/?channels#yaml) if that's
more your style.

Also have a look at our [other community resources](../spec/ext/community.md).
