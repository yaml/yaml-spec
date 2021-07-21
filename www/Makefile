DOCKER_TOOL := github-pages
include ../tool/make/init.mk

#------------------------------------------------------------------------------
PUBLISH_CNAME := spec.yaml.io
JEKYLL_BUILD := jekyll build --trace
JEKYLL_SERVE := jekyll serve --host 0.0.0.0
FORK_USER_ID := $(shell $(ROOT)/tool/bin/get-fork-id)
SITE := _site
GH_PAGES := _gh-pages

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
    find . -name '*.md' \
        -o -name '*.html' \
        -o -name '*.scss' \
        -o -name '*.coffee' \
        -o -name '*.js' \
        -o -name '*.yaml' \
        | \
    grep -v ReadMe | \
    grep -v /_ | \
    cut -c3- | \
    cat \
)

include _ext/ext.mk

SPEC_LINKS := $(SPEC)/links.yaml
SPEC_FILES := \
    spec.md \
    img \

REVIEW_FILES := \
    review/markdown.html \
    review/spec-plain.md \
    review/spec-12.html \
    review/single_html.css \

DOC_FILES := $(shell \
    cd $(DOC) && \
    find . -name '*.md' | \
    grep -v ReadMe.md | \
    sed 's/^\./doc/' \
)

STORY_FILES := $(shell \
    cd $(STORY) && \
    find . -name '*.md' | \
    grep -v ReadMe.md | \
    sed 's/^\./story/' \
)

JEKYLL_FILES := $(shell \
    cd _jekyll/ && \
    find . -type f | \
    cut -c3- \
)

SITE_FILES := \
    $(WWW_FILES) \
    $(EXT_FILES) \
    $(SPEC_FILES) \
    $(REVIEW_FILES) \
    $(DOC_FILES) \
    $(STORY_FILES) \
    $(JEKYLL_FILES) \

SITE_FILES := $(SITE_FILES:%=$(SITE)/%)
SITE_FILES := $(SITE_FILES:%.swp=)


#------------------------------------------------------------------------------
site-files:
	@printf "%s\n" $(SITE_FILES)

site: $(EXT) $(SITE_FILES) $(GH_PAGES)

build: site
	$(eval override export YAML_SPEC_DIR := www/$(SITE))
	$(call docker-run,run $(JEKYLL_BUILD),$(DOCKER_BUILD_OPTS))
	echo $(PUBLISH_CNAME) > $(GH_PAGES)/CNAME

serve: site
	$(eval override export YAML_SPEC_DIR := www/$(SITE))
	$(call docker-run,run $(JEKYLL_SERVE),$(DOCKER_SERVE_OPTS))

shell: site
	$(eval override export YAML_SPEC_DIR := www/$(SITE))
	$(call docker-run,run $(DOCKER_SHELL_CMD),$(DOCKER_SHELL_OPTS))

stage: build
ifeq ($(FORK_USER_ID),)
	@echo '*** ERROR'
	@echo "No git remote called 'fork' found"
	@echo "It should have a url like 'git@github.com:<user>/yaml-spec.git'"
	@exit 1
endif
	( \
	    cd $(GH_PAGES) && \
	    perl -pi -e "s/spec/$(FORK_USER_ID)-spec/" CNAME && \
	    git add -A . && \
	    git commit -m 'Stage' && \
	    git push -f fork gh-pages \
	) || true
	@echo
	@echo "Staged: http://$(FORK_USER_ID)-$(PUBLISH_CNAME)"
	@echo

publish: build
ifneq ($(shell git rev-parse --abbrev-ref HEAD),main)
	@echo '*** Error'
	@echo "You may only 'publish' from the 'main' branch"
	@exit 1
endif
	( \
	    cd $(GH_PAGES) && \
	    git add -A . && \
	    git commit -m 'Publish' && \
	    git push -f \
	) || true
	@echo
	@echo "Published: https://$(PUBLISH_CNAME)"
	@echo

# Remove generated files to force rebuild:
force:
	$(call clean,$(GH_PAGES))
	rm -fr $(SITE)

# Also touch the original spec-1.2 html:
force-all: force
	make -C $(SPEC) force

clean: force
	rm -fr $(SITE) $(GH_PAGES)
	make -C _ext clean

#------------------------------------------------------------------------------
$(SITE)/%: % $$(dir $$@)
	cp -r $< $@
$(SITE)/%: _% $$(dir $$@)
	cp -r $< $@

$(SITE)/%.coffee: %.coffee $$(dir $$@)
	(echo '---'; echo '---'; cat $<) > $@
$(SITE)/%.coffee: _%.coffee $$(dir $$@)
	(echo '---'; echo '---'; cat $<) > $@

$(SITE)/%.scss: %.scss $$(dir $$@)
	(echo '---'; echo '---'; cat $<) > $@
$(SITE)/%.scss: _%.scss $$(dir $$@)
	(echo '---'; echo '---'; cat $<) > $@

$(SITE)/%: _jekyll/% $$(dir $$@)
	cp -r $< $@

$(SITE)/%.md: %.md
	mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

$(SITE)/%.md: $(SPEC)/%.md $(SPEC_LINKS)
	mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

$(SITE)/doc/%.md: $(DOC)/%.md
	mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

$(SITE)/story/%.md: $(STORY)/%.md
	mkdir -p $(dir $@)
	markydown-to-kramdown $(ROOT) $^ > $@

$(SITE)/img: $(SPEC)/img
	cp -r $< $@

$(SITE)/:
	mkdir -p $@

$(SITE)/%/:
	mkdir -p $@

$(SITE)/review/spec-12.html: _ext/yaml-spec-12.html
	cp $< $@
	perl -pi -e 's{"(.*?\.png)"}{"../img/$$1"}' $@

$(SITE)/review/markdown.html: $(SPEC)/spec.md
	( \
	    echo '<pre style="overflow:hidden">'; \
	    perl -Mstrict -p0 \
		-e 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g;' \
		-e 's{^(#.*)}{<code>$$1</code>}gm;' \
		-e 's{^(\*\*(?!Legend).*(\n.*)?\*\*)$$}{<code>$$1</code>}gm' $<; \
	    echo '</pre>' \
	) > $@

$(SITE)/review/spec-plain.md: $(SITE)/spec.md
	( \
	    echo '---'; \
	    echo 'layout: default'; \
	    echo 'plain: true'; \
	    echo '---'; \
	    tail -n+3 $<; \
	) > $@
	perl -pi -e 's{\(img/}{(../img/}' $@

#------------------------------------------------------------------------------
$(EXT):
	make -C _ext build

$(GH_PAGES):
	-git branch --track gh-pages origin/gh-pages
	git worktree add -f $@ gh-pages

#------------------------------------------------------------------------------
define clean
find $1 -mindepth 1 -type f -o -type d | \
    ( grep -Ev '(\.git|ReadMe\.md)' || true) | \
    (set -x; xargs rm -fr dummy)
endef