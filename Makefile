SHELL := bash

BRANCHES := $(shell git branch | cut -c3- | grep -Ev '^(main|gh-pages|_)$$')

default:

all: $(BRANCHES)

status:
	@for b in $(BRANCHES); do \
	    [[ -d $$b ]] || continue; \
	    s=$$(git -C $$b status -s); \
	    if [[ $$s ]]; then git -C $$b status; echo ...; fi; \
	done

clean:
	@for b in $(BRANCHES); do \
	    [[ -d $$b ]] || continue; \
	    s=$$(git -C $$b status -s); \
	    if [[ -z $$s ]]; then (set -x; rm -fr $$b); fi; \
	done

list:
	@printf "%s\n" $(BRANCHES)

$(BRANCHES):
	@git worktree prune
	git worktree add $@ $@
