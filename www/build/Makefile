DOCKER_TOOL := github-pages
include ../../tool/make/init.mk

#------------------------------------------------------------------------------
PUBLISH_CNAME := spec.yaml.io
JEKYLL_BUILD := jekyll build --trace
JEKYLL_SERVE := jekyll serve --host 0.0.0.0

WWW  := ..
SITE := $(WWW)/spec.yaml.io
EXT  := $(WWW)/ext

BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
BRANCH ?= $(shell git rev-parse --short HEAD)

BRANCH := main

#------------------------------------------------------------------------------
BASEURL ?=
serve : BASEURL :=

#------------------------------------------------------------------------------
DOCKER_BUILD_OPTS := \
    --user $(UID):$(GID) \

DOCKER_SERVE_OPTS := \
    $(DOCKER_BUILD_OPTS) \
    --publish 4000:4000 \

DOCKER_SHELL_OPTS := \
    $(DOCKER_SERVE_OPTS) \
    --volume $(HISTORY_FILE):/home/jekyll/.bash_history \

DOCKER_SHELL_CMD ?= bash

#------------------------------------------------------------------------------
WWW_FILES := $(shell \
    find $(WWW)/src -type f | \
    cut -c4- \
)

include $(EXT)/ext.mk

SPEC_LINKS := $(SPEC)/links.yaml
SPEC_IMAGE := $(shell cd $(SPEC) && echo tex/*.tex)
SPEC_IMAGE := $(SPEC_IMAGE:%.tex=%.png)

.SECONDARY: $(SPEC_IMAGE:%=$(SPEC)/%)

SPEC_IMAGE := $(SPEC_IMAGE:tex/%=src/img/%)

SPEC_FILES := \
    src/spec.md \
    $(SPEC_IMAGE)

REVIEW_FILES := \
    src/review/markdown.html \
    src/review/spec-plain.md \
    src/review/spec-12.html \
    src/review/single_html.css \

DOC_FILES := $(shell \
    cd $(DOC) && \
    find . -name '*.md' | \
    grep -v ReadMe.md | \
    sed 's/^\./doc/' \
)
DOC_FILES := $(DOC_FILES:%=src/%)

STORY_FILES := $(shell \
    cd $(STORY) && \
    find . -name '*.md' | \
    grep -v ReadMe.md | \
    sed 's/^\./story/' \
)
STORY_FILES := $(STORY_FILES:%=src/%)

FILES := \
    _config.yml \
    $(WWW_FILES) \
    $(EXT_FILES) \
    $(SPEC_FILES) \
    $(REVIEW_FILES) \
    $(DOC_FILES) \
    $(STORY_FILES) \

FILES := $(FILES:%.swp=)
FILES := $(FILES:%=o/%)


#------------------------------------------------------------------------------
list-files:
	@printf "%s\n" $(FILES)

files: o $(EXT_DIRS) $(FILES)
	rm -fr $(BRANCH)
	mv src $(BRANCH)
	rm -f o

.PHONY: build
build: files $(SITE)
	$(eval override export YAML_SPEC_DIR := www/build)
	$(call docker-run,run $(JEKYLL_BUILD),$(DOCKER_BUILD_OPTS))
	echo $(PUBLISH_CNAME) > $(SITE)/CNAME

serve: files
	$(eval override export YAML_SPEC_DIR := www/build)
	$(call docker-run,run $(JEKYLL_SERVE),$(DOCKER_SERVE_OPTS))

shell: files
	$(eval override export YAML_SPEC_DIR := www/build)
	$(call docker-run,run $(DOCKER_SHELL_CMD),$(DOCKER_SHELL_OPTS))

force: clean
	rm -fr $(SITE)
	$(MAKE) -C $(EXT) $<

clean:
	rm -fr $(FILES:o/%=%)
	while [[ $$( find . -type d -empty ) ]]; do \
	    find . -type d -empty | xargs rm -fr; \
	done
	@for f in $$(shopt -s nullglob; echo */index.md); do \
	    (set -x; rm -fr "$$(dirname "$$f")"); \
	done
	rm -f o

# XXX Nasty hack to make pattern matching work with ../
o:
	ln -s . o

#------------------------------------------------------------------------------
o/_config.yml: o/config.yaml
	@mkdir -p $(dir $@)
	cp $< $@
	echo >> $@
	echo '# Added by build system:' >> $@
	echo "baseurl: '$(BASEURL)'" >> $@

o/%: $(WWW)/%
	@mkdir -p $(dir $@)
	cp $< $@

o/%/: $(WWW)/%
	mkdir -p $(shell dirname $@)
	cp -r $< $(shell dirname $@)

o/%.coffee: $(WWW)/%.coffee
	@mkdir -p $(dir $@)
	(echo '---'; echo '---'; cat $<) > $@

o/%.scss: $(WWW)/%.scss
	@mkdir -p $(dir $@)
	(echo '---'; echo '---'; cat $<) > $@

o/%.md: $(WWW)/%.md
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

o/src/doc/%.md: $(DOC)/%.md
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

o/src/story/%.md: $(STORY)/%.md
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

o/src/%.md: $(SPEC)/%.md $(SPEC_LINKS)
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

o/src/img/%: $(SPEC)/img/%
	@mkdir -p $(dir $@)
	cp -r $< $@

$(SPEC)/img/%:
	$(MAKE) -C $(SPEC) build-img YAML_SPEC_DIR=

o/src/review/spec-12.html: $(EXT)/spec-2009/yaml-spec-12.html
	cp $< $@
	perl -pi -e 's{"(.*?\.png)"}{"../img/$$1"}' $@

o/src/review/markdown.html: $(SPEC)/spec.md
	( \
	    echo '<pre style="overflow:hidden">'; \
	    perl -Mstrict -p0 \
		-e 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g;' \
		-e 's{^(#.*)}{<code>$$1</code>}gm;' \
		-e 's{^(\*\*(?!Legend).*(\n.*)?\*\*)$$}{<code>$$1</code>}gm' $<; \
	    echo '</pre>' \
	) > $@

o/src/review/spec-plain.md: src/spec.md
	( \
	    echo '---'; \
	    echo 'layout: spec'; \
	    echo 'plain: true'; \
	    echo '---'; \
	    tail -n+3 $<; \
	) > $@
	perl -pi -e 's{\(img/}{(../img/}' $@

#------------------------------------------------------------------------------
$(EXT_DIRS):
	$(MAKE) -C $(EXT) build

$(SITE):
	-git branch --track gh-pages origin/gh-pages
	git worktree add -f $@ gh-pages
