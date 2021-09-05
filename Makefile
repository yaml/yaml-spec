include tool/make/init.mk

TEST_FILES := $(wildcard test/test-*)

ACT := /tmp/act
ACT_VERSION := v0.2.24
ACT_TARBALL := act_Linux_x86_64.tar.gz
ACT_URL := https://github.com/nektos/act/releases/download
ACT_RELEASE := $(ACT_URL)/$(ACT_VERSION)/$(ACT_TARBALL)

default:

docker-build-all docker-push-all docker-pull-all:
	$(MAKE) -C tool/docker $@

build html site serve publish publish-fork force diff:
	$(MAKE) -C www $@

test: test-spec $(TEST_FILES)

test-spec:
	$(MAKE) -C spec test

$(TEST_FILES): force
	bash $@

force:

actions: actions-check $(ACT)
	$(ACT)

_:
	git worktree prune
	git worktree add $@ $@
	$(MAKE) -C $@ all

clean:
	git worktree prune
	$(MAKE) -C spec/2009 $@
	$(MAKE) -C www $@
	$(MAKE) -C tool/docker clean-all

actions-check:
ifneq (linux-gnu,$(shell echo $$OSTYPE))
	$(error `make actions` only runs on Linux currently)
endif

$(ACT): /tmp/$(ACT_TARBALL)
	tar xzf $< act
	mv act $@

/tmp/$(ACT_TARBALL):
	wget -P /tmp $(ACT_RELEASE)
