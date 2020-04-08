SHELL := bash

BRANCHES := \
    gh-pages \
    spec-1.2 \

REPOS:= \
    grammar \
    wiki \

WORK := $(BRANCHES) $(REPOS)

default: status

status:
	@for w in $(WORK); do \
	    if [[ -d $$w ]]; then \
		echo "=== $$w"; \
		( \
		    cd "$$w"; \
		    git status -s; \
		) \
	    fi \
	done
	@echo "=== master"
	@git status

work: $(WORK)

grammar:
	git clone --branch=spec git@github.com:yaml/yaml-grammar $@

wiki:
	git clone git@github.com:yaml/yaml-spec.wiki $@

$(BRANCHES):
	git branch --track $@ origin/$@ 2>/dev/null || true
	git worktree add -f $@ $@

realclean:
	rm -fr $(WORK)
