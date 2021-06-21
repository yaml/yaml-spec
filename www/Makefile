DOCKER_TOOL := github-pages
include ../tool/make/init.mk

PUBLISH_CNAME := spec.yaml.io

SPEC12 := $(ROOT)/1.2
SPEC := $(ROOT)/spec
DOC := $(ROOT)/doc
STORY := $(ROOT)/story
WORK := $(ROOT)/work
SITE := _site
GH_PAGES := _gh-pages

SPEC_LINKS := $(SPEC)/links.yaml
SPEC_IMAGE := $(shell ls $(SPEC)/img/)
SPEC_MD_HTML := $(WORK)/markdown.html
INPUT_HTML := $(WORK)/spec-1.2.html

DOC_MD := $(shell \
    find $(DOC) -name '*.md' | \
    grep -v ReadMe.md \
)
DOC_MD := $(DOC_MD:$(ROOT)/%=%)

STORY_MD := $(shell \
    find $(STORY) -name '*.md' | \
    grep -v ReadMe.md \
)
STORY_MD := $(STORY_MD:$(ROOT)/%=%)

DOCKER_BUILD_OPTS := \
    --user $(UID):$(GID) \

DOCKER_SERVE_OPTS := \
    $(DOCKER_BUILD_OPTS) \
    --publish 4000:4000 \

DOCKER_SHELL_OPTS := \
    $(DOCKER_SERVE_OPTS) \
    --volume $(HISTORY_FILE):/home/jekyll/.bash_history \

SHELL_CMD ?= bash

WWW_FILES := $(shell \
    find . -type f -name '*.md*' | \
    grep -v ReadMe | \
    grep -v /_ \
)
WWW_FILES := $(WWW_FILES:./%=%)
WWW_FILES := $(WWW_FILES:%.yaml=%)

SITE_FILES := \
    $(WWW_FILES) \
    spec.md \
    $(SPEC_IMAGE) \
    $(DOC_MD) \
    $(STORY_MD) \
    Gemfile \
    _config.yml \
    _layouts \
    review.html \
    spec.scss \
    img \

SITE_FILES := $(SITE_FILES:%=$(SITE)/%)
SITE_FILES := $(SITE_FILES:%.swp=)

JEKYLL_BUILD := jekyll build
JEKYLL_SERVE := jekyll serve --host 0.0.0.0

FORK_USER_ID := $(shell $(ROOT)/tool/bin/get-fork-id)

site-files:
	@printf "%s\n" $(SITE_FILES) | sort

site: $(SITE) $(SITE_FILES) $(GH_PAGES)

build: site
	$(eval override export YAML_SPEC_DIR := www/$(SITE))
	$(call docker-run,run $(JEKYLL_BUILD),$(DOCKER_BUILD_OPTS))
	echo $(PUBLISH_CNAME) > $(GH_PAGES)/CNAME
	cp $(GH_PAGES)/spec.html $(WORK)/

serve: site
	$(eval override export YAML_SPEC_DIR := www/$(SITE))
	$(call docker-run,run $(JEKYLL_SERVE),$(DOCKER_SERVE_OPTS))

shell: site
	$(eval override export YAML_SPEC_DIR := www/$(SITE))
	$(call docker-run,run $(SHELL_CMD),$(DOCKER_SHELL_OPTS))

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

clean:
	rm -fr $(SITE) $(GH_PAGES)

$(SPEC)/spec.md: $(INPUT_HTML)
	make -C $(SPEC) spec.md YAML_SPEC_DIR=

$(SITE)/%: % $(SITE)
	cp -r $< $@

$(SITE)/%: jekyll/% $(SITE)
	cp -r $< $@

$(SITE)/%.md: $(ROOT) %.md
	mkdir -p $(dir $@)
	render-markdown $^ > $@

$(SITE)/%.md: $(ROOT) $(SPEC)/%.md $(SPEC_LINKS)
	mkdir -p $(dir $@)
	render-markdown $^ > $@
	cp $@ $(WORK)/

$(SITE)/doc/%.md: $(ROOT) $(DOC)/%.md
	mkdir -p $(dir $@)
	render-markdown $^ > $@

$(SITE)/story/%.md: $(ROOT) $(STORY)/%.md
	mkdir -p $(dir $@)
	render-markdown $^ > $@

$(SITE)/%.png: $(SPEC)/img/%.png
	cp $< $@

$(SITE)/%.css: %.css $(SITE)
	cp -r $< $@

$(SITE): $(SPEC_MD_HTML) $(WORK)
	mkdir -p $@
	cp $< $@/
	cp $(WORK)/1.2/* $@/

$(SITE)/img: $(SPEC)/img
	mkdir -p $@
	cp -r $</* $@/

$(SPEC_MD_HTML): $(SPEC)/spec.md
	( \
	    echo '<pre>'; \
	    perl -Mstrict -p0 \
		-e 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g;' \
		-e 's{^(#.*)}{<code>$$1</code>}gm;' \
		-e 's{^(\*\*(?!Legend).*(\n.*)?\*\*)$$}{<code>$$1</code>}gm' $<; \
	    echo '</pre>' \
	) > $@


$(GH_PAGES):
	-git branch --track gh-pages origin/gh-pages
	git worktree add -f $@ gh-pages

$(INPUT_HTML): $(WORK)

$(WORK):
	make -C $(ROOT) work

define clean
find $1 -mindepth 1 -type f -o -type d | \
    ( grep -Ev '(\.git|ReadMe\.md)' || true) | \
    (set -x; xargs rm -fr dummy)
endef
