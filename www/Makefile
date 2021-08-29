include ../tool/make/init.mk

#------------------------------------------------------------------------------
BUILD := build
SITE := spec.yaml.io
EXT := ext

PUBLISH_CNAME := spec.yaml.io
USER_ID ?= $(shell $(ROOT)/tool/bin/get-user-id)
REMOTE_NAME ?= $(shell $(ROOT)/tool/bin/get-remote-name)
REPO_NAME := $(shell $(ROOT)/tool/bin/get-repo-name)

ifeq ($(USER_ID),yaml)
BRANCH ?= $(shell git rev-parse --abbrev-ref HEAD)
BRANCH ?= $(shell git rev-parse --short HEAD)
else
BRANCH := main
endif

#------------------------------------------------------------------------------
.PHONY: build
build serve shell:
	$(MAKE) -C $(BUILD) $@ BRANCH=$(BRANCH)

publish: build
	@( \
	    set -x ; \
	    git -C $(SITE) add -A . && \
	    git -C $(SITE) commit --allow-empty -m 'Publish' && \
	    git -C $(SITE) push -f $(REMOTE_NAME) gh-pages \
	)
	@echo
	@echo "Published: https://$(PUBLISH_CNAME)/$(BRANCH)"
	@echo

# Remove generated files to force rebuild:
force:
	$(MAKE) -C $(BUILD) clean
	rm -fr $(SITE)/$(BRANCH)

clean:
	$(MAKE) -C $(BUILD) $@
	$(MAKE) -C $(SPEC) $@
	$(MAKE) -C $(EXT) $@
	rm -fr $(SITE)

diff: build
	(cd $(SITE) && git diff)
