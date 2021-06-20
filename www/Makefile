DOCKER_TOOL := github-pages
include ../tool/make/init.mk

PUBLISH_CNAME := spec.yaml.io

SPEC12 := $(ROOT)/1.2
SPEC := $(ROOT)/spec
STORY := $(ROOT)/story
WORK := $(ROOT)/work
STAGE := _stage
GH_PAGES := _gh-pages

SPEC_LINKS := $(SPEC)/links.yaml
SPEC_IMAGE := $(shell ls $(SPEC)/img/)
SPEC_MD_HTML := $(WORK)/markdown.html
INPUT_HTML := $(WORK)/spec-1.2.html

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

STAGE_FILES := \
    $(WWW_FILES) \
    spec.md \
    $(SPEC_IMAGE) \
    $(STORY_MD) \
    Gemfile \
    _config.yml \
    _layouts \
    review.html \
    spec.scss \
    img \

STAGE_FILES := $(STAGE_FILES:%=$(STAGE)/%)
STAGE_FILES := $(STAGE_FILES:%.swp=)

JEKYLL_BUILD := jekyll build
JEKYLL_SERVE := jekyll serve --host 0.0.0.0


stage-files:
	@printf "%s\n" $(STAGE_FILES) | sort

stage: $(STAGE) $(STAGE_FILES) $(GH_PAGES)

build: stage
	$(eval override export YAML_SPEC_DIR := www/$(STAGE))
	$(call docker-run,run $(JEKYLL_BUILD),$(DOCKER_BUILD_OPTS))
	echo $(PUBLISH_CNAME) > $(GH_PAGES)/CNAME
	cp $(GH_PAGES)/spec.html $(WORK)/

serve: stage
	$(eval override export YAML_SPEC_DIR := www/$(STAGE))
	$(call docker-run,run $(JEKYLL_SERVE),$(DOCKER_SERVE_OPTS))

shell: stage
	$(eval override export YAML_SPEC_DIR := www/$(STAGE))
	$(call docker-run,run $(SHELL_CMD),$(DOCKER_SHELL_OPTS))

publish: build
	( \
	    cd $(GH_PAGES) && \
	    git add -A . && \
	    git commit -m 'Publish' && \
	    git push \
	)

# Remove generated files to force rebuild:
force:
	$(call clean,$(GH_PAGES))
	rm -fr $(STAGE)

# Also touch the original spec-1.2 html:
force-all: force
	make -C $(SPEC) force

clean:
	rm -fr $(STAGE) $(GH_PAGES)

$(SPEC)/spec.md: $(INPUT_HTML)
	make -C $(SPEC) spec.md YAML_SPEC_DIR=

$(STAGE)/%: % $(STAGE)
	cp -r $< $@

$(STAGE)/%: jekyll/% $(STAGE)
	cp -r $< $@

$(STAGE)/%.md: $(ROOT) %.md
	mkdir -p $(dir $@)
	render-markdown $^ > $@

$(STAGE)/%.md: $(ROOT) $(SPEC)/%.md $(SPEC_LINKS)
	mkdir -p $(dir $@)
	render-markdown $^ > $@
	cp $@ $(WORK)/

$(STAGE)/story/%.md: $(ROOT) $(STORY)/%.md
	mkdir -p $(dir $@)
	render-markdown $^ > $@

$(STAGE)/%.png: $(SPEC)/img/%.png
	cp $< $@

$(STAGE)/%.css: %.css $(STAGE)
	cp -r $< $@

$(STAGE): $(SPEC_MD_HTML) $(WORK)
	mkdir -p $@
	cp $< $@/
	cp $(WORK)/1.2/* $@/

$(STAGE)/img: $(SPEC)/img
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
