DOCKER_TOOL := html-to-markdown
include ../tool/make/init.mk

RULES := $(GRAMMAR)/rules.yaml

ALL := \
    spec.md \

build: $(ALL)

force:
	touch $(RULES)

spec.md: $(RULES)
	insert-rules $@ $< > /tmp/$@
	mv /tmp/$@ $@

$(WORK):
	make -C $(ROOT) work
