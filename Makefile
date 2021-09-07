include tool/make/init.mk

TESTS ?= $(wildcard test/test-*)

QUICK := \
    test/test-line-wrap.sh \
    test/test-format-markdown.sh \
    test/test-lint-shell.sh \

default:

docker-build-all docker-push-all docker-pull-all:
	$(MAKE) -C tool/docker $@

build html site serve publish publish-fork force diff:
	$(MAKE) -C www $@

format:
	$(MAKE) -C $(SPEC) $@

test: $(TESTS) XXX-spell-check

quick-test: $(QUICK) XXX-spell-check

XXX-spell-check:
	make -C spec test

docker-test:
	$(MAKE) test TESTS='$(TESTS) XXX-spell-check' YAML_SPEC_USE_DOCKER=1

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
