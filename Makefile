include .common.mk

export SPEC

TESTS ?= $(wildcard test/test-*)

BPAN := .bpan
COMMON := ../yaml-common

QUICK := \
    test/test-lint-shell.sh \
    test/test-format-markdown.sh \
    test/test-lint-spec.sh \

export PATH := $(ROOT)/bin:$(PATH)

ifneq (,$(DOCKER))
  export RUN_OR_DOCKER := $(DOCKER)
endif

default:

files build html site serve publish force diff:
	$(MAKE) -C www $@

format:
	$(MAKE) -C $(SPEC) $@

.PHONY: test
test: $(TESTS)
	$(MAKE) clean &>/dev/null

test-noclean: $(TESTS)

test-quick: $(QUICK)

test-docker:
	export RUN_OR_DOCKER=force && \
	$(MAKE) test TESTS='$(TESTS)'

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

docker-push-all: docker-push-jekyll docker-push-marky docker-push-tex

docker-push-jekyll:
	RUN_OR_DOCKER_PUSH=true jekyll-runner

docker-push-marky:
	RUN_OR_DOCKER_PUSH=true markydown-to-kramdown

docker-push-tex:
	RUN_OR_DOCKER_PUSH=true tex-to-img

common:
	cp $(COMMON)/bpan/run-or-docker.bash $(BPAN)/

clean:
	@git worktree prune
	$(MAKE) --no-print-directory -C $(SPEC) $@ &>/dev/null
	$(MAKE) --no-print-directory -C www $@ &>/dev/null
