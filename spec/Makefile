DOCKER_TOOL := html-to-markydown
include ../tool/make/init.mk


WORK := $(ROOT)/work
INPUT_HTML := $(WORK)/spec-1.2.html
LEGEND := $(ROOT)/spec/legend.yaml

ALL := \
    spec.md \

build: $(ALL)

force: $(INPUT_HTML)
	touch $<

spec.md: $(INPUT_HTML) $(LEGEND)
	html-to-markydown $^ > $@

$(INPUT_HTML): $(WORK)
	touch $@

$(WORK):
	make -C $(ROOT) work
