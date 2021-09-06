include tool/make/init.mk

ifdef test
TEST_FILES := $(test)
else
TEST_FILES := $(wildcard test/test-*)
endif

default:

docker-build-all docker-push-all docker-pull-all:
	$(MAKE) -C tool/docker $@

build html site serve publish publish-fork force diff:
	$(MAKE) -C www $@

format:
	$(MAKE) -C $(SPEC) $@

test: $(TEST_FILES)

test-docker:
	$(MAKE) test YAML_SPEC_USE_DOCKER=1

$(TEST_FILES): force
	bash $@

force:

_:
	git worktree prune
	git worktree add $@ $@
	$(MAKE) -C $@ all

clean:
	git worktree prune
	$(MAKE) -C spec/2009 $@
	$(MAKE) -C www $@
	$(MAKE) -C tool/docker clean-all
