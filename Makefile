include tool/make/init.mk

TESTS ?= $(wildcard test/test-*)

default:

docker-build-all docker-push-all docker-pull-all:
	$(MAKE) -C tool/docker $@

build html site serve publish publish-fork force diff:
	$(MAKE) -C www $@

format:
	$(MAKE) -C $(SPEC) $@

test: $(TESTS)

test-docker:
	$(MAKE) test TESTS='$(TESTS)' YAML_SPEC_USE_DOCKER=1

$(TESTS): force
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
