DOCKER_TOOL := github-pages
include ../tool/make/init.mk

PUBLISH_CNAME := spec.yaml.io

SPEC12 := $(ROOT)/1.2
SPEC := $(ROOT)/spec
WORK := $(ROOT)/work
STAGE := _stage
PAGES := _gh-pages
LINKS := $(ROOT)/spec/links.yaml
IMAGE := $(shell ls $(SPEC)/img/)
SPEC_MD_HTML := $(WORK)/markdown.html
INPUT_HTML := $(WORK)/spec-1.2.html

DOCKER_BUILD_OPTS := \
    --user $(UID):$(GID) \

DOCKER_SERVE_OPTS := \
    $(DOCKER_BUILD_OPTS) \
    --publish 4000:4000 \

DOCKER_SHELL_OPTS := \
    $(DOCKER_SERVE_OPTS) \
    --volume $(HISTORY_FILE):/home/jekyll/.bash_history \

CMD ?= bash

FILES := $(shell \
    find . -type f -name '*.md*' | \
    grep -v ReadMe | \
    grep -v /_ \
)
FILES := $(FILES:./%=%)
FILES := $(FILES:%.yaml=%)

FILES := \
    $(FILES) \
    $(IMAGE) \
    Gemfile \
    _config.yml \
    _layouts \
    index.md \
    review.html \
    spec-plain.md \
    spec.scss \
    img \

FILES := $(FILES:%=$(STAGE)/%)

JEKYLL_BUILD := jekyll build
JEKYLL_SERVE := jekyll serve --host 0.0.0.0


list-files:
	@printf "%s\n" $(FILES)

stage: $(FILES) $(PAGES)

build: stage
	$(eval override export YAML_SPEC_DIR := www/$(STAGE))
	$(call docker-run,run $(JEKYLL_BUILD),$(DOCKER_BUILD_OPTS))
	echo $(PUBLISH_CNAME) > $(PAGES)/CNAME
	cp $(PAGES)/spec.html $(WORK)/

serve: stage
	$(eval override export YAML_SPEC_DIR := www/$(STAGE))
	$(call docker-run,run $(JEKYLL_SERVE),$(DOCKER_SERVE_OPTS))

shell: stage
	$(eval override export YAML_SPEC_DIR := www/$(STAGE))
	$(call docker-run,run $(CMD),$(DOCKER_SHELL_OPTS))

publish: build
	( \
	    cd $(PAGES) && \
	    git add -A . && \
	    git commit -m 'Publish' && \
	    git push \
	)

# Remove generated files to force rebuild:
force:
	$(call clean,$(PAGES))
	rm -fr $(STAGE)

# Also touch the original spec-1.2 html:
force-all: force
	make -C $(SPEC) force

clean:
	rm -fr $(STAGE) $(PAGES)

$(SPEC)/spec.md: $(INPUT_HTML)
	make -C $(SPEC) spec.md YAML_SPEC_DIR=

$(STAGE)/%: % $(STAGE)
	cp -r $< $@

$(STAGE)/%: jekyll/% $(STAGE)
	cp -r $< $@

$(STAGE)/%.md: %.md $(STAGE)
	cat $< > $@

$(STAGE)/%.md: %.md.yaml $(SPEC)/%.md $(LINKS) $(STAGE)
	render-spec-markdown $^ > $@
	cp $@ $(WORK)/

$(STAGE)/spec-plain.md: spec-plain.md.yaml $(SPEC)/spec.md $(LINKS) $(STAGE)
	render-spec-markdown $^ > $@

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


$(PAGES):
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
