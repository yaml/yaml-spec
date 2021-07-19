YAML Spec Website Generation
============================

This directory is responsible for publishing the content of this (yaml-spec)
repository to <https://spec.yaml.io/>.

# Build System

Building, testing and publishing the website content is controlled by the
Makefile.
The Makefile supports:

* `make publish`

  Build and publish the content to <https://spec.yaml.io/>.
  This can only be run in `main` branch.

* `make stage`

  Build and publish the content to
  `https://<your-github-username>-spec.yaml.io/`.
  This can only be run in a non `main` branch.

* `make serve`

  Build and serve locally to <http://0.0.0.0:4000/>.

* `make build`

  Build the site content into a finalized `./_gh-pages/` directory.

* `make site`

  Gather the site content into a `./_site/` Jekyll source directory.

* `make shell`

  Open a shell in the `github-pages` Docker container that builds the website
  content.

* `make force ...`

  The force rule will make sure everthing is rebuilt from scratch.

* `make clean`

  Remove generated files.

# Prerequisite Software

The build system uses various open source software.

## Required

At a minimum you'll need:

* `make`

  Of course.

* `bash`

  Required to be installed on you system.
  Not required to be the interactive shell you are using.

* `docker`

  Everything else is encapsulated in Docker images.
  If you have the required components installed locally they will be used,
  otherwise `docker` will be invoked.
  Docker is required for some complicated steps.

## Optional

Even though everything can be run by Docker, some build steps will run faster
with these local components installed.

* Perl
* Perl CPAN modules:
  * `YAML::PP`
  * `XXX`
* NodeJS
* Node NPM modules:
  * CoffeeScript (`npm install -g coffeescript`)
  * `ingy-prelude`
  * `turndown`
  * `domino`
  * `smartwrap`

# Build Process

This system is made out of Markdown, YAML, SCSS and images.
It is currently using Jekyll to build the final result.

It gathers all the content in various directories throughout the repository and
puts them into the `./_site/` directory in a standard Jekyll layout.

The intent is to not tie things too close to Jekyll or any other build system.

The Jekyll build system is captured in the `github-pages` Docker image.
It is the same build process that GitHub Pages uses when you push Jekyll
content to it.
It builds the final HTML/CSS/JavaScript into the `./_gh-pages/` directory.
The `_gh-pages` content is pushed directly to the `gh-pages` branch of the
repository, and in turn served as <https://spec.yaml.io/>.
No further Jekyll processing happens on the GitHub side after pushing.

The Markdown files in the repository get preprocessed into a more complicated
but less readable Markdown form and put into `_site` directory.
For instance the post-processed forms might have a lot more Markdown HTML in
them.

The intent is to:
* Keep the sources as simple and clean as possible.
* Have the Markdown files render pretty good in the GitHub views of them.
* Introduce a few powerful but not Markdown syntaxes.
* Have the final result on the website be amazing.

We only introduce new syntax when absolutely necessary and try to keep it
minimal and non-disruptive.
Sometimes we use `<!-- ... -->` Markdown HTML comments so you don't see it in
the standard Makrdown renderings.
