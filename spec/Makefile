DOCKER_TOOL := html-to-markydown
include ../tool/make/init.mk

ALL_TEX := $(shell echo tex/*.tex)
ALL_PNG := $(ALL_TEX:tex/%.tex=img/%.png)
BUILD_TEX :=

ALL := \
    $(ALL_PNG) \

default:
	@printf '%s\n' $(ALL_PNG)

build-img: $(ALL) build-img-all

clean:
	rm -f $(ALL_PNG)

img/%.png: tex/%.tex tex/include/*
	@mkdir -p img
ifeq ($(MAKECMDGOALS),build)
	$(eval override BUILD_TEX += $<)
else
	tex-to-png img/ $<
endif

build-img-all:
	@[[ -z '$(BUILD_TEX)' ]] || \
	    (set -x; tex-to-png img/ $(BUILD_TEX))
