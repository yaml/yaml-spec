include ../../.common.mk

ALL_MD := $(wildcard *.md) $(wildcard ext/*.md)
ALL_FORMAT := $(ALL_MD:%=format-%)
ALL_CHECK := $(ALL_MD:%=check-%)
ALL_TEX := $(wildcard src/*.tex)
ALL_IMG := $(ALL_TEX:src/%.tex=img/%.svg)
BUILD_TEX :=

#------------------------------------------------------------------------------
.PHONY: build test

build: build-img

test:
	check-spec-file $(ALL_CHECK:check-%=%)

format: $(ALL_FORMAT)

$(ALL_FORMAT):
	format-markdown $(@:format-%=%) > /tmp/file.md
	mv /tmp/file.md $(@:format-%=%)

clean:
	rm -fr img html build bin/lib/__pycache__

build-img: $(ALL_IMG) build-img-all

html/%.html: build/%.md
	jekyll-runner $(JEKYLL_BUILD)

build/%.md: %.md
	markydown-to-kramdown $(ROOT) $^ > /tmp/$@

img/%.svg: src/%.tex src/include/*
	@mkdir -p $(dir $@)
ifeq ($(MAKECMDGOALS),build)
	$(eval override BUILD_TEX += $<)
else
	tex-to-img img/ $<
endif

build-img-all:
	@[[ -z '$(BUILD_TEX)' ]] || \
	    (set -x; tex-to-img img/ $(BUILD_TEX))
