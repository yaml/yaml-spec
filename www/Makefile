include ../tool/make/init.mk

#------------------------------------------------------------------------------
BUILD := build
EXT := ext

SITE := spec.yaml.io
HTML := html

PUBLISH_CNAME := spec.yaml.io
USER_ID ?= $(shell $(ROOT)/tool/bin/get-user-id)
REMOTE_NAME ?= $(shell $(ROOT)/tool/bin/get-remote-name)
REPO_NAME := $(shell $(ROOT)/tool/bin/get-repo-name)

SITEDIR ?= $(shell $(ROOT)/tool/bin/get-sitedir)
ifneq ($(shell git status -s --untracked-files --ignored),)
SITEDIR=main
endif

#------------------------------------------------------------------------------
.PHONY: build
build serve shell html:
	$(MAKE) -C $(BUILD) $@ SITEDIR=$(SITEDIR)

publish: build
	@( \
	    set -x ; \
	    git -C $(SITE) add -A . && \
	    git -C $(SITE) commit --allow-empty -m 'Publish' && \
	    git -C $(SITE) push -f $(REMOTE_NAME) gh-pages \
	)
	@echo
	@echo "Published: https://$(PUBLISH_CNAME)/$(SITEDIR)"
	@echo

# Remove generated files to force rebuild:
force:
	$(MAKE) -C $(BUILD) clean
	$(MAKE) -C $(EXT) clean
	rm -fr $(SITE) $(HTML)

clean:
	$(MAKE) -C $(BUILD) $@
	$(MAKE) -C $(SPEC) $@
	$(MAKE) -C $(EXT) $@
	rm -fr $(SITE) $(HTML)

diff: build
	(cd $(SITE) && git diff)
