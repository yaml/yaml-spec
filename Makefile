include tool/make/init.mk

export ROOT SPEC

TESTS ?= $(wildcard test/test-*)

QUICK := \
    test/test-lint-shell.sh \
    test/test-format-markdown.sh \
    test/test-lint-spec.sh \

default:

docker-build-all docker-push-all docker-pull-all:
	$(MAKE) -C tool/docker $@

files build html site serve publish publish-fork force diff:
	$(MAKE) -C www $@

format:
	$(MAKE) -C $(SPEC) $@

.PHONY: test
test: $(TESTS)
	$(MAKE) clean &>/dev/null

test-noclean: $(TESTS)

quick-test: $(QUICK)

docker-test:
	$(MAKE) test TESTS='$(TESTS)' YAML_SPEC_USE_DOCKER=1

edit-spec:
	@$${EDITOR:-vim} $(SPEC)/spec.md

edit-spec-dir:
	@$${EDITOR:-vim} $(SPEC)

grammar-report:
	@grammar-report < $(SPEC)/spec.md | less -FReX

grammar-report-quiet:
	@grammar-report -q < $(SPEC)/spec.md | less -FReX

$(TESTS): always
	bash $@

always:

_:
	git worktree prune
	git worktree add $@ $@
	$(MAKE) -C $@ all

clean:
	@git worktree prune
	$(MAKE) --no-print-directory -C spec $@ &>/dev/null
	$(MAKE) --no-print-directory -C www $@ &>/dev/null
	$(MAKE) --no-print-directory -C tool/docker clean-all
