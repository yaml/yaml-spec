SHELL := bash

DIRS := $(shell \
    printf "%s\n" */.git | \
      sed 's/\/\.git//' \
)
DIRS := $(DIRS:*%=)

BRANCHES := $(shell \
    git branch -a | \
    cut -c3- | \
    grep ^remotes/ | \
    grep -Ev '/(_|HEAD|PR|gh-pages)' | \
    sed 's/remotes\/origin\///' \
)

BRANCHES_NOT_13 := \
    bundle-jekyll-theme \
    bundle-jekyll-theme-2 \
    uncanonicalizable-scalars \
    valid-formatted-content \

BRANCHES_13 := $(filter-out $(BRANCHES_NOT_13),$(BRANCHES))

default:

fetch:
	git fetch

all: $(BRANCHES)

1.3: $(BRANCHES_13)

list-all:
	@printf "%s\n" $(BRANCHES)

list-1.3:
	@printf "%s\n" $(BRANCHES_13)

shell-dirs \
rebase-main \
status \
pull-report:
	@.bin/$@ $(DIRS)

project-report:
	@.bin/project-report

create-branch:
ifndef NAME
	$(error Set NAME=branch-name-to-create)
endif
	$(eval override NAME := $(NAME:%/=%))
	git branch $(NAME) main-1.3
	git push origin -u $(NAME):$(NAME)
	$(MAKE) $(NAME)

delete-branch:
ifndef NAME
	$(error Set NAME=branch-name-to-delete)
endif
ifeq ($(wildcard $(NAME)/),)
	$(error No '$(NAME)' directory here)
endif
	$(eval override NAME := $(NAME:%/=%))
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

$(BRANCHES):
	@git branch --track $@ origin/$@ 2>/dev/null || true
	@git worktree prune
	git worktree add $@ $@
