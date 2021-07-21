DOCKER_TOOL := html-to-markydown
include ../tool/make/init.mk


ALL := \
    errata.md \

build: $(ALL)

%.md: $(SPEC12)/%.html
	html-to-markydown $< > $@

$(SPEC12)/%.html: $(SPEC12)/spec.html $(SPEC12)/%.dbk
	make -C $(SPEC12) $(@:$(SPEC12)/%=%) YAML_SPEC_DIR=

$(SPEC12)/spec.html:
	make -C $(SPEC12) spec.html YAML_SPEC_DIR=
