include ../.common.mk

#------------------------------------------------------------------------------
# Makefile variables defined here:
#------------------------------------------------------------------------------

export OPATH := $(PATH)

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

define older-html-files
files := $$(wildcard $$(SPEC_$1)/*) $$(SPEC_$1)/title.html
files := $$(files:$$(SPEC_$1)/%=$2/%)
HTML_FILES += $$(files)
endef

define get-html-files
files := \
    $$(wildcard $$(SPEC_$1)/*.md) \
    $$(wildcard $$(SPEC_$1)/ext/*.md) \
    title.html
files := $$(files:%/spec.md=%/index.md)
files := $$(files:$$(SPEC_$1)/%.md=%.html)
files := $$(files:ReadMe.html=)
files += spec.css img/
HTML_FILES += $$(files:%=$2/%)
endef

HTML_FILES :=

ifdef MAKE_FULL
$(eval $(call older-html-files,120,1.2.0))
$(eval $(call older-html-files,121,1.2.1))
$(eval $(call get-html-files,122,1.2.2))
$(eval $(call get-html-files,123,1.2.3))
endif
$(eval $(call get-html-files,130,1.3.0))

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

# Get spec markdown and image files:
define get-spec-files
SPEC_$1_MD := $$(wildcard $$(SPEC_$1)/*.md)
SPEC_$1_MD := $$(SPEC_$1_MD:%/ReadMe.md=)
ifdef MAKE_FULL
SPEC_$1_MD += $$(wildcard $$(SPEC_$1)/ext/*.md)
endif
SPEC_$1_MD := $$(SPEC_$1_MD:$$(SPEC_$1)/%=main/spec/$2/%)

SPEC_$1_FILES := $$(SPEC_$1_MD:%/spec.md=%/index.md)
SPEC_$1_FILES := $$(SPEC_$1_FILES:%.md=%.html)

SPEC_$1_LINKS := $$(SPEC_$1)/links.yaml

ifdef MAKE_FULL
SPEC_$1_IMAGE := $$(wildcard $$(SPEC_$1)/src/*.tex)
SPEC_$1_IMAGE := $$(SPEC_$1_IMAGE:$$(SPEC_$1)/src/%.tex=img/%.svg)
.PRECIOUS: $$(SPEC_$1_IMAGE:%=$$(SPEC_$1)/%)
SPEC_$1_IMAGE := $$(SPEC_$1_IMAGE:%=main/spec/$2/%)
SPEC_$1_FILES += $$(SPEC_$1_IMAGE)
endif
endef

$(eval $(call get-spec-files,122,1.2.2))
$(eval $(call get-spec-files,123,1.2.3))
$(eval $(call get-spec-files,130,1.3.0))

# Review files:
REVIEW_FILES := \
    main/review/markdown.html \
    main/review/spec-plain.md \
    main/review/spec-12.html \
    main/review/single_html.css \

FILES := \
    _config.yml \
    favicon.svg \
    Gemfile
ifdef MAKE_FULL
FILES += \
    $(SPEC_122_FILES) \
    $(SPEC_123_FILES) \
    $(REVIEW_FILES)
endif
FILES += \
    $(SPEC_130_FILES) \
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
	$(MAKE) clean
	$(MAKE) site
	$(MAKE) html-files

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
	$(MAKE) -C .. clean

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
# Spec version specific files:
#------------------------------------------------------------------------------

define make-spec-files
main/spec/$2/ext/%.html: $$(SPEC_$1)/ext/%.md $$(SPEC_$1_LINKS)
	@mkdir -p $$(dir $$@)
	$$(eval override PATH := $$(ROOT)/spec/$2/bin:$$(PATH))
	markydown-to-html $$(ROOT) $$^ > $$@

main/spec/$2/index.html: $$(SPEC_$1)/spec.md $$(SPEC_$1_LINKS)
	@mkdir -p $$(dir $$@)
	$$(eval override PATH := $$(ROOT)/spec/$2/bin:$$(PATH))
	markydown-to-html $$(ROOT) $$^ > $$@

main/spec/$2/img/%: $$(SPEC_$1)/img/%
	@mkdir -p $$(dir $$@)
	cp -r $$< $$@

$$(SPEC_$1)/img/%:
	$$(MAKE) -C $$(SPEC_$1) build-img YAML_SPEC_DIR=
endef

$(eval $(call make-spec-files,122,1.2.2))
$(eval $(call make-spec-files,123,1.2.3))
$(eval $(call make-spec-files,130,1.3.0))

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
	$(eval override PATH := $(ROOT)/spec/1.2.2/bin:$(PATH))
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
ifeq (,$(findstring main,$(shell git rev-parse --abbrev-ref HEAD)))
	$(error Must be on branch main (or main-1.3) to use SITEDIR=main)
endif
endif

track-gh-pages:
	git show-ref -q origin/gh-pages || \
	  git fetch origin gh-pages
	-git branch --track gh-pages origin/gh-pages
