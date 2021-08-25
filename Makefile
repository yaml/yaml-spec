SHELL := bash

BRANCHES := $(shell \
    git branch -a | \
    cut -c3- | \
    grep ^remotes/ | \
    grep -Ev '/(RFC|HEAD|PR|_|main|gh-pages|work)' | \
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

create-branch:
ifndef NAME
	$(error Set NAME=branch-name-to-create)
endif
	git branch $(NAME) main
	git push origin -u $(NAME):$(NAME)
	$(MAKE) $(NAME)

delete-branch:
ifndef NAME
	$(error Set NAME=branch-name-to-delete)
endif
ifeq ($(wildcard $(NAME)/),)
	$(error No '$(NAME)' directory here)
endif
	rm -fr $(NAME)
	git worktree prune
	git branch -D $(NAME)
	git push origin :$(NAME)

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
