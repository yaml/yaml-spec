DOCKER_TOOL := html-to-markydown
include ../tool/make/init.mk

#------------------------------------------------------------------------------
ALL_TEX := $(wildcard tex/*.tex)
ALL_IMG := $(ALL_TEX:tex/%.tex=img/%.png)
BUILD_TEX :=

ALL_MD := $(wildcard *.md)
ALL_HTML := $(ALL_MD:%.md=build/%.md)

#------------------------------------------------------------------------------
build: build-html build-img

build-html: $(ALL_HTML)

build-img: $(ALL_IMG) build-img-all

clean:
	rm -fr img html build

html/%.html: build/%.md
	$(call docker-run,run $(JEKYLL_BUILD),$(DOCKER_BUILD_OPTS))

build/%.md: %.md
	markydown-to-kramdown $(ROOT) $^ > /tmp/$@

img/%.png: tex/%.tex tex/include/*
	@mkdir -p $(dir $@)
ifeq ($(MAKECMDGOALS),build)
	$(eval override BUILD_TEX += $<)
else
	tex-to-png img/ $<
endif

build-img-all:
	@[[ -z '$(BUILD_TEX)' ]] || \
	    (set -x; tex-to-png img/ $(BUILD_TEX))

.PHONY: build
