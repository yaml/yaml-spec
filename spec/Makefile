DOCKER_TOOL := html-to-markydown
include ../tool/make/init.mk

ALL_TEX := $(shell echo tex/*.tex)
ALL_PNG := $(ALL_TEX:tex/%.tex=img/%.png)
BUILD_TEX :=

ALL := \
    $(ALL_PNG) \

default:
	@printf '%s\n' $(ALL_PNG)

build: $(ALL) build-img

clean:
	rm -f $(ALL_PNG)

img/%.png: tex/%.tex
ifeq ($(MAKECMDGOALS),build)
	$(eval override BUILD_TEX += $<)
else
	tex-to-png img/ $<
endif

build-img:
	@[[ -z '$(BUILD_TEX)' ]] || \
	    (set -x; tex-to-png img/ $(BUILD_TEX))
