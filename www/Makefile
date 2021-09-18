DOCKER_TOOL := github-pages
include ../tool/make/init.mk

#------------------------------------------------------------------------------
# Makefile variables defined here:
#------------------------------------------------------------------------------

BUILD := build
SITE := site
HTML := html
SPEC := ../spec
SPEC_120 := $(SPEC)/1.2.0
SPEC_121 := $(SPEC)/1.2.1
SPEC_122 := $(SPEC)/1.2.2
SPEC_2009 := ../spec/2009
EXT := external

include $(EXT)/ext.mk

BASEURL ?=
serve : BASEURL :=

PUBLISH_CNAME := spec.yaml.io
REMOTE_NAME ?= $(shell $(ROOT)/tool/bin/get-remote-name)

DOCKER_BUILD_OPTS := \
    --user $(UID):$(GID) \

DOCKER_SERVE_OPTS := \
    $(DOCKER_BUILD_OPTS) \
    --publish 4000:4000 \

DOCKER_SHELL_OPTS := \
    $(DOCKER_SERVE_OPTS) \
    --volume $(HISTORY_FILE):/home/jekyll/.bash_history \

DOCKER_SHELL_CMD ?= bash

JEKYLL_BUILD := jekyll build --trace
JEKYLL_SERVE := jekyll serve --host 0.0.0.0

#------------------------------------------------------------------------------
# Files for `make html`:
#------------------------------------------------------------------------------

HTML_FILES :=

files := $(wildcard $(SPEC_120)/*) $(SPEC_120)/title.html
files := $(files:$(SPEC_120)/%=1.2.0/%)
HTML_FILES += $(files)

files := $(wildcard $(SPEC_121)/*) $(SPEC_121)/title.html
files := $(files:$(SPEC_121)/%=1.2.1/%)
HTML_FILES += $(files)

files := $(wildcard $(SPEC_122)/*.md) title.html
files := $(files:$(SPEC_122)/%.md=%.html)
files := $(files:ReadMe.html=)
files += spec.css img/
HTML_FILES += $(files:%=1.2.2/%)

HTML_FILES := $(HTML_FILES:%/Makefile=)
HTML_FILES := $(HTML_FILES:%=html/%)

STRIP_HTML := \
    perl -p0e ' \
	s{.*<body[^>]*?>\n*}{}s; \
	s{</body>.*}{}s; \
	s{\s*<script.*?</script>\s*}{}sg; \
    '

#------------------------------------------------------------------------------
# Gather all the build files:
#------------------------------------------------------------------------------

SPEC_MD := \
    $(wildcard $(SPEC_122)/*.md) \
    $(wildcard $(SPEC_122)/ext/*.md) \

SPEC_MD := $(SPEC_MD:%/ReadMe.md=)
SPEC_MD := $(SPEC_MD:$(SPEC_122)/%=main/%)

SPEC_LINKS := $(SPEC_122)/links.yaml

SPEC_IMAGE := $(wildcard $(SPEC_122)/src/*.tex)
SPEC_IMAGE := $(SPEC_IMAGE:$(SPEC_122)/src/%.tex=img/%.svg)
.PRECIOUS: $(SPEC_IMAGE:%=$(SPEC_122)/%)
SPEC_IMAGE := $(SPEC_IMAGE:%=main/%)

SPEC_FILES := \
    $(SPEC_MD) \
    $(SPEC_IMAGE)

REVIEW_FILES := \
    main/review/markdown.html \
    main/review/spec-plain.md \
    main/review/spec-12.html \
    main/review/single_html.css \

DOC_FILES := $(shell \
    cd $(DOC) && \
    find . -name '*.md' | \
    grep -v ReadMe.md | \
    sed 's/^\./doc/' \
)
DOC_FILES := $(DOC_FILES:%=main/%)

STORY_FILES := $(shell \
    cd $(STORY) && \
    find . -name '*.md' | \
    grep -v ReadMe.md | \
    sed 's/^\./story/' \
)
STORY_FILES := $(STORY_FILES:%=main/%)

FILES := \
    _config.yml \
    favicon.svg \
    Gemfile \
    $(EXT_FILES) \
    $(SPEC_FILES) \
    $(REVIEW_FILES) \
    $(DOC_FILES) \
    $(STORY_FILES) \

FILES := $(FILES:%.swp=)


#------------------------------------------------------------------------------
# Makefile rules start here:
#------------------------------------------------------------------------------
.PHONY: build html site

list-html:
	@printf "%s\n" $(HTML_FILES)

list-files:
	@printf "%s\n" $(FILES)

files: $(EXT_DIRS) $(FILES)

build: files
	$(call docker-run,run $(JEKYLL_BUILD),$(DOCKER_BUILD_OPTS))
ifneq (,$(SITEDIR))
	mv $(BUILD)/main $(BUILD)/$(SITEDIR)
endif

site: build
	git show-ref -q origin/gh-pages || \
	  git fetch origin gh-pages
	-git branch --track gh-pages origin/gh-pages
	git worktree add -f $@ gh-pages
	git -C $(SITE) reset --hard origin/gh-pages
	cd $(BUILD) && find . | grep -v Gemfile | cpio -dump ../$(SITE)
	echo $(PUBLISH_CNAME) > $(SITE)/CNAME
	touch $(SITE)/.nojekyll

serve: files
	$(call docker-run,run $(JEKYLL_SERVE),$(DOCKER_SERVE_OPTS))

shell: files
	$(call docker-run,run $(DOCKER_SHELL_CMD),$(DOCKER_SHELL_OPTS))

html:
	make clean
	make site
	make html-files

publish: check-publish site
	@(set -x ; \
	  git -C $(SITE) add -A . && \
	  git -C $(SITE) commit --allow-empty -m 'Publish' && \
	  git -C $(SITE) push -f $(REMOTE_NAME) gh-pages )
	@echo
	@echo "Published: https://$(PUBLISH_CNAME)/$(SITEDIR)"
	@echo


# Remove generated files to force rebuild:
force:
	rm -fr ext $(BUILD) $(SITE) $(HTML) $(FILES)

clean: force
	$(MAKE) -C $(EXT) $@

clean-all:
	make -C .. clean

diff: build
	(cd $(SITE) && git diff)

#------------------------------------------------------------------------------
html-files: $(HTML_FILES)

_config.yml: jekyll/_config.yml
	@mkdir -p $(dir $@)
	cp $< $@
	echo >> $@
	echo '# Added by build system:' >> $@
	echo "baseurl: '$(BASEURL)'" >> $@

favicon.svg: $(EXT)/yaml-common/image/yaml-logo.svg
	cp $< $@

$(EXT_DIRS):
	$(MAKE) -C $(EXT) build

ext/%: $(EXT)/%
	@mkdir -p $(dir $@)
	cp $< $@

ext/%/: $(EXT)/%
	mkdir -p $(shell dirname $@)
	cp -r $< $(shell dirname $@)

ext/%.coffee: $(EXT)/%.coffee
	@mkdir -p $(dir $@)
	(echo '---'; echo '---'; cat $<) > $@

ext/%.scss: $(EXT)/%.scss
	@mkdir -p $(dir $@)
	(echo '---'; echo '---'; cat $<) > $@

Gemfile:
	touch $@

main/doc/%.md: $(DOC)/%.md
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

main/story/%.md: $(STORY)/%.md
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

main/%.md: $(SPEC_122)/%.md
	@mkdir -p $(dir $@)
	(echo '---'; echo '---'; cat $<) > $@

main/spec.md: $(SPEC_122)/spec.md $(SPEC_LINKS)
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

main/img/%: $(SPEC_122)/img/%
	@mkdir -p $(dir $@)
	cp -r $< $@

$(SPEC_122)/img/%:
	$(MAKE) -C $(SPEC_122) build-img YAML_SPEC_DIR=

main/review/spec-12.html: $(EXT)/spec-2009/yaml-spec-12.html
	cp $< $@
	perl -pi -e 's{"(.*?\.png)"}{"../img/$$1"}' $@

main/review/single_html.css: $(SPEC_2009)/single_html.css
	cp $< $@

main/review/markdown.html: $(SPEC_122)/spec.md
	make-review-spec-html $< > $@

main/review/spec-plain.md: main/spec.md
	make-review-spec-md $< > $@

#------------------------------------------------------------------------------
check-publish:
ifeq ($(SITEDIR),)
	$(error Please set SITEDIR=<word>)
endif
ifneq ($(wildcard $(SITE)),)
	$(error Please make clean before make publish)
endif
ifeq ($(SITEDIR),main)
ifneq ($(shell git rev-parse --abbrev-ref HEAD), main)
	$(error Must be on branch main to use SITEDIR=main)
endif
endif

html/%: $(SPEC)/%
	@mkdir -p $(dir $@)
	cp $< $@

html/%.html: $(SPEC)/%.html
	@mkdir -p $(dir $@)
	$(STRIP_HTML) $< > $@

html/%/title.html: $(SPEC)/%/spec.html
	@mkdir -p $(dir $@)
	grep '<title>' $< | head -n1 > $@

html/1.2.2/%: $(SITE)/main/%
	@mkdir -p $(dir $@)
	cp $< $@

html/1.2.2/%/: $(SITE)/main/%
	mkdir -p $(shell dirname $@)
	cp -r $< $(shell dirname $@)

html/1.2.2/%.css: $(SITE)/main/%.css
	@mkdir -p $(dir $@)
	cp $< $@

html/1.2.2/%.html: $(SITE)/main/%.html
	@mkdir -p $(dir $@)
	$(STRIP_HTML) $< > $@

html/1.2.2/title.html: $(SITE)/main/spec.html
	@mkdir -p $(dir $@)
	grep '<title>' $< | head -n1 > $@
