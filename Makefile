SHELL := bash

BRANCHES := $(shell \
    git branch -a | \
    cut -c3- | \
    grep ^remotes/ | \
    grep -Ev '/(RFC|HEAD|_|main|gh-pages|work)' | \
    sed 's/remotes\/origin\///' \
)

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
	@git branch --track $@ origin/$@ 2>/dev/null || true
	@git worktree prune
	git worktree add $@ $@
