include ../.common.mk

#------------------------------------------------------------------------------
# Makefile variables defined here:
#------------------------------------------------------------------------------

BUILD := build
SITE := site
HTML := html
EXT := external

include $(EXT)/ext.mk

BASEURL ?=
serve : BASEURL :=

PUBLISH_CNAME := spec.yaml.io
REMOTE_NAME ?= $(shell $(ROOT)/bin/get-remote-name)

DOCKER_SHELL_CMD ?= bash

JEKYLL_BUILD := jekyll build --trace
ifdef GITHUB_ACTIONS
    JEKYLL_BUILD += --verbose
endif
JEKYLL_SERVE := jekyll serve --host 0.0.0.0
HISTORY_FILE := /tmp/docker-bash_history

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

files := \
    $(wildcard $(SPEC_122)/*.md) \
    $(wildcard $(SPEC_122)/ext/*.md) \
    title.html
files := $(files:%/spec.md=%/index.md)
files := $(files:$(SPEC_122)/%.md=%.html)
files := $(files:ReadMe.html=)
files += spec.css img/
HTML_FILES += $(files:%=1.2.2/%)

files := \
    $(wildcard $(SPEC_130)/*.md) \
    $(wildcard $(SPEC_130)/ext/*.md) \
    title.html
files := $(files:%/spec.md=%/index.md)
files := $(files:$(SPEC_130)/%.md=%.html)
files := $(files:ReadMe.html=)
files += spec.css img/
HTML_FILES += $(files:%=1.3.0/%)

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

SPEC_122_MD := \
    $(wildcard $(SPEC_122)/*.md) \
    $(wildcard $(SPEC_122)/ext/*.md) \

SPEC_122_MD := $(SPEC_122_MD:%/ReadMe.md=)
SPEC_122_MD := $(SPEC_122_MD:$(SPEC_122)/%=main/spec/1.2.2/%)

SPEC_122_LINKS := $(SPEC_122)/links.yaml

SPEC_122_IMAGE := $(wildcard $(SPEC_122)/src/*.tex)
SPEC_122_IMAGE := $(SPEC_122_IMAGE:$(SPEC_122)/src/%.tex=img/%.svg)
.PRECIOUS: $(SPEC_122_IMAGE:%=$(SPEC_122)/%)
SPEC_122_IMAGE := $(SPEC_122_IMAGE:%=main/spec/1.2.2/%)

SPEC_122_FILES := \
    $(SPEC_122_MD:%/spec.md=%/index.md) \
    $(SPEC_122_IMAGE)

SPEC_130_MD := \
    $(wildcard $(SPEC_130)/*.md) \
    $(wildcard $(SPEC_130)/ext/*.md) \

SPEC_130_MD := $(SPEC_130_MD:%/ReadMe.md=)
SPEC_130_MD := $(SPEC_130_MD:$(SPEC_130)/%=main/spec/1.3.0/%)

SPEC_130_LINKS := $(SPEC_130)/links.yaml

SPEC_130_IMAGE := $(wildcard $(SPEC_130)/src/*.tex)
SPEC_130_IMAGE := $(SPEC_130_IMAGE:$(SPEC_130)/src/%.tex=img/%.svg)
.PRECIOUS: $(SPEC_130_IMAGE:%=$(SPEC_130)/%)
SPEC_130_IMAGE := $(SPEC_130_IMAGE:%=main/spec/1.3.0/%)

SPEC_130_FILES := \
    $(SPEC_130_MD:%/spec.md=%/index.md) \
    $(SPEC_130_IMAGE)

REVIEW_FILES := \
    main/review/markdown.html \
    main/review/spec-plain.md \
    main/review/spec-12.html \
    main/review/single_html.css \

FILES := \
    _config.yml \
    favicon.svg \
    Gemfile \
    $(EXT_FILES) \
    $(SPEC_122_FILES) \
    $(SPEC_130_FILES) \
    $(REVIEW_FILES) \
    jekyll/_includes/sitedir-pulldown.html \

FILES := $(FILES:%.swp=)


#------------------------------------------------------------------------------
# Makefile rules start here:
#------------------------------------------------------------------------------
.PHONY: build html site

list-html:
	@printf "%s\n" $(HTML_FILES)

list-files:
	@printf "%s\n" $(FILES)

files: $(EXT_DIRS) $(FILES) track-gh-pages

build: files
	jekyll-runner $(JEKYLL_BUILD)
ifneq (,$(SITEDIR))
ifneq (main,$(SITEDIR))
	mv $(BUILD)/main $(BUILD)/$(SITEDIR)
endif
endif

site: build
	git worktree add -f $@ gh-pages
	git -C $(SITE) reset --hard origin/gh-pages
	cd $(BUILD) && find . | grep -v Gemfile | cpio -dump ../$(SITE)
	echo $(PUBLISH_CNAME) > $(SITE)/CNAME
	touch $(SITE)/.nojekyll

serve: files
	RUN_OR_DOCKER_OPTIONS='--publish 4000:4000' \
	jekyll-runner $(JEKYLL_SERVE)

shell: files
	RUN_OR_DOCKER_OPTIONS='--volume $(HISTORY_FILE):/home/jekyll/.bash_history' \
	jekyll-runner $(DOCKER_SHELL_CMD)

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
	rm -fr main/spec main/review/*.png

clean: force
	$(MAKE) -C $(EXT) $@

clean-all:
	make -C .. clean

diff: build
	(cd $(SITE) && git diff)

#------------------------------------------------------------------------------
# Support rules:
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

#------------------------------------------------------------------------------
# 1.2.2 spec files:
#------------------------------------------------------------------------------
main/spec/1.2.2/%.md: $(SPEC_122)/%.md
	@mkdir -p $(dir $@)
	(echo '---'; echo '---'; cat $<) > $@

main/spec/1.2.2/ext/%.md: $(SPEC_122)/ext/%.md $(SPEC_122_LINKS)
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

main/spec/1.2.2/index.md: $(SPEC_122)/spec.md $(SPEC_122_LINKS)
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

main/spec/1.2.2/img/%: $(SPEC_122)/img/%
	@mkdir -p $(dir $@)
	cp -r $< $@

$(SPEC_122)/img/%:
	$(MAKE) -C $(SPEC_122) build-img YAML_SPEC_DIR=

#------------------------------------------------------------------------------
# 1.3.0 spec files:
#------------------------------------------------------------------------------
main/spec/1.3.0/%.md: $(SPEC_130)/%.md
	@mkdir -p $(dir $@)
	(echo '---'; echo '---'; cat $<) > $@

main/spec/1.3.0/ext/%.md: $(SPEC_130)/ext/%.md $(SPEC_130_LINKS)
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

main/spec/1.3.0/index.md: $(SPEC_130)/spec.md $(SPEC_130_LINKS)
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

main/spec/1.3.0/img/%: $(SPEC_130)/img/%
	@mkdir -p $(dir $@)
	cp -r $< $@

$(SPEC_130)/img/%:
	$(MAKE) -C $(SPEC_130) build-img YAML_SPEC_DIR=


#------------------------------------------------------------------------------
# 1.2.2 review files:
#------------------------------------------------------------------------------
main/review/spec-12.html: $(EXT)/spec-2009/yaml-spec-12.html
	cp $< $@
	cp $(SPEC_2009)/*.png $(dir $@)

main/review/single_html.css: $(SPEC_2009)/single_html.css
	cp $< $@

main/review/markdown.html: $(SPEC_122)/spec.md
	make-review-spec-html $< > $@

main/review/spec-plain.md: $(SPEC_122)/spec.md $(SPEC_122_LINKS)
	markydown-to-kramdown $(ROOT) $^ > /tmp/kramdown
	make-review-spec-md /tmp/kramdown > $@

jekyll/_includes/sitedir-pulldown.html:
	./bin/generate-sitedir-pulldown > $@

#------------------------------------------------------------------------------
# HTML rules:
#------------------------------------------------------------------------------
# 1.2.0 & 1.2.1:
html/%: $(SPEC)/%
	@mkdir -p $(dir $@)
	cp $< $@

html/%.html: $(SPEC)/%.html
	@mkdir -p $(dir $@)
	$(STRIP_HTML) $< > $@

html/%/title.html: $(SPEC)/%/spec.html
	@mkdir -p $(dir $@)
	grep '<title>' $< | head -n1 > $@

# 1.2.2 & 1.3.0:
html/%: $(SITE)/main/%
	@mkdir -p $(dir $@)
	cp $< $@

html/%/: $(SITE)/main/spec/%
	mkdir -p $(shell dirname $@)
	cp -r $< $(shell dirname $@)

html/%.css: $(SITE)/main/spec.css
	@mkdir -p $(dir $@)
	cp $< $@

html/%.html: $(SITE)/main/spec/%.html
	@mkdir -p $(dir $@)
	$(STRIP_HTML) $< > $@

html/%/title.html: $(SITE)/main/spec/%/index.html
	@mkdir -p $(dir $@)
	grep '<title>' $< | head -n1 > $@

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

track-gh-pages:
	git show-ref -q origin/gh-pages || \
	  git fetch origin gh-pages
	-git branch --track gh-pages origin/gh-pages
