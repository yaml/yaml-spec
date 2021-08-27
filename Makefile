SHELL := bash

BRANCHES := $(shell \
    git branch -a | \
    cut -c3- | \
    grep ^remotes/ | \
    grep -Ev '/(RFC|HEAD|PR|_|gh-pages|work)' | \
    sed 's/remotes\/origin\///' \
)

BRANCHES_NOT_121 := \
    annotate-1.3 \
    eatme-full-support \
    grammar \
    main-wip \
    mermaid \
    playground \
    rfc-publish \
    stack-playground \
    story-ideas \

BRANCHES_121 := $(filter-out $(BRANCHES_NOT_121),$(BRANCHES))

default:

all: $(BRANCHES)

121: $(BRANCHES_121)

list-all:
	@printf "%s\n" $(BRANCHES)

list-121:
	@printf "%s\n" $(BRANCHES_121)

shell-all:
	@.bin/shell-dirs $(BRANCHES)

shell-121:
	@.bin/shell-dirs $(BRANCHES_121)

pull-report-all:
	@.bin/pull-report $(BRANCHES)

pull-report-121:
	@.bin/pull-report $(BRANCHES_121)

project-report:
	@.bin/project-report

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

rebase-main:
	@for b in $(BRANCHES); do \
	    .bin/rebase-main $$b || exit; \
	done

$(BRANCHES):
	@git branch --track $@ origin/$@ 2>/dev/null || true
	@git worktree prune
	git worktree add $@ $@
