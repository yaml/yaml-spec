DOCKER_TOOL := github-pages
include ../../tool/make/init.mk

#------------------------------------------------------------------------------
PUBLISH_CNAME := spec.yaml.io
JEKYLL_BUILD := jekyll build --trace
JEKYLL_SERVE := jekyll serve --host 0.0.0.0

WWW := ..
EXT := $(WWW)/ext
SITE := $(WWW)/spec.yaml.io
HTML := $(WWW)/html
O := o

SITEDIR ?= $(shell $(ROOT)/tool/bin/get-sitedir)

HTML_FILES := $(wildcard $(SPEC)/*.md)
HTML_FILES := $(HTML_FILES:$(SPEC)/%.md=%.html)
HTML_FILES := $(HTML_FILES:ReadMe.html=)

STRIP_HTML := \
    perl -p0e ' \
	s{.*<body>\n*}{}s; \
	s{</body>.*}{}s; \
	s{\n*<script.*?</script>\n*}{\n}sg; \
    '

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

SPEC_MD := $(wildcard $(SPEC)/*.md)
SPEC_MD := $(SPEC_MD:%/ReadMe.md=)
SPEC_MD := $(SPEC_MD:$(SPEC)/%=src/%)

SPEC_LINKS := $(SPEC)/links.yaml

SPEC_IMAGE := $(wildcard $(SPEC)/tex/*.tex)
SPEC_IMAGE := $(SPEC_IMAGE:$(SPEC)/tex/%.tex=img/%.png)
SPEC_IMAGE := $(SPEC_IMAGE:%=src/%)

SPEC_FILES := \
    $(SPEC_MD) \
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
FILES := $(FILES:%=$O/%)

#------------------------------------------------------------------------------
list-files:
	@printf "%s\n" $(FILES)

files: $O $(EXT_DIRS) $(FILES)
	rm -fr $(SITEDIR)
	mv src $(SITEDIR)
	rm -f $O

.PHONY: build
build: files $(SITE)
	$(eval override export YAML_SPEC_DIR := www/build)
	$(call docker-run,run $(JEKYLL_BUILD),$(DOCKER_BUILD_OPTS))
	cd site && \
	    find . | cpio -dump ../$(SITE)
	echo $(PUBLISH_CNAME) > $(SITE)/CNAME

serve: main files
	$(eval override export YAML_SPEC_DIR := www/build)
	$(call docker-run,run $(JEKYLL_SERVE),$(DOCKER_SERVE_OPTS))

shell: files
	$(eval override export YAML_SPEC_DIR := www/build)
	$(call docker-run,run $(DOCKER_SHELL_CMD),$(DOCKER_SHELL_OPTS))

.PHONY: main
main:
	$(eval override export SITEDIR := main)

force:

html: force
	$(MAKE) force build SITEDIR=XXXHTMLXXX
	@mkdir -p $(HTML)
	cp -r \
	    site/XXXHTMLXXX/img \
	    site/XXXHTMLXXX/spec.css \
	    $(HTML)/

	@for f in $(HTML_FILES); do \
	    ( \
		set -x; \
		mkdir -p $$(dirname $(HTML)/$$f); \
		$(STRIP_HTML) $(SITE)/XXXHTMLXXX/$$f > $(HTML)/$$f; \
	    ) \
	done

force: clean
	rm -fr $(SITE)
	$(MAKE) -C $(EXT) $<

clean:
	rm -fr site $(FILES:$O/%=%)
	while [[ $$( find . -type d -empty ) ]]; do \
	    find . -type d -empty | xargs rm -fr; \
	done
	@for f in $$(shopt -s nullglob; echo */index.md); do \
	    (set -x; rm -fr "$$(dirname "$$f")"); \
	done
	rm -f $O

# XXX Nasty hack to make pattern matching work with ../
$O:
	ln -s . $@

#------------------------------------------------------------------------------
$O/_config.yml: $O/config.yaml
	@mkdir -p $(dir $@)
	cp $< $@
	echo >> $@
	echo '# Added by build system:' >> $@
	echo "baseurl: '$(BASEURL)'" >> $@

$O/%: $(WWW)/%
	@mkdir -p $(dir $@)
	cp $< $@

$O/%/: $(WWW)/%
	mkdir -p $(shell dirname $@)
	cp -r $< $(shell dirname $@)

$O/%.coffee: $(WWW)/%.coffee
	@mkdir -p $(dir $@)
	(echo '---'; echo '---'; cat $<) > $@

$O/%.scss: $(WWW)/%.scss
	@mkdir -p $(dir $@)
	(echo '---'; echo '---'; cat $<) > $@

$O/%.md: $(WWW)/%.md
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

$O/src/doc/%.md: $(DOC)/%.md
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

$O/src/story/%.md: $(STORY)/%.md
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

$O/src/%.md: $(SPEC)/%.md
	@mkdir -p $(dir $@)
	(printf '---\n---\n'; cat $<) > $@

$O/src/spec.md: $(SPEC)/spec.md $(SPEC_LINKS)
	@mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

$O/src/img/%: $(SPEC)/img/%
	@mkdir -p $(dir $@)
	cp -r $< $@

$(SPEC)/img/%:
	$(MAKE) -C $(SPEC) build-img YAML_SPEC_DIR=

$O/src/review/spec-12.html: $(EXT)/spec-2009/yaml-spec-12.html
	cp $< $@
	perl -pi -e 's{"(.*?\.png)"}{"../img/$$1"}' $@

$O/src/review/markdown.html: $(SPEC)/spec.md
	( \
	    echo '<pre style="overflow:hidden">'; \
	    perl -Mstrict -p0 \
		-e 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g;' \
		-e 's{^(#.*)}{<code>$$1</code>}gm;' \
		-e 's{^(\*\*(?!Legend).*(\n.*)?\*\*)$$}{<code>$$1</code>}gm' $<; \
	    echo '</pre>' \
	) > $@

$O/src/review/spec-plain.md: src/spec.md
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
	git -C $(SITE) reset --hard origin/gh-pages
