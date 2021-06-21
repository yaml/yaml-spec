include tool/make/init.mk

SHELL := bash

default:

docker-build-all docker-push-all:
	make -C tool/docker $@

build serve stage publish:
	make -C www $@

clean:
	rm -fr work
	git worktree prune
	make -C www $@
	make -C tool/docker clean-all

work:
	-git branch --track $@ origin/$@
	git worktree add -f $@ $@
