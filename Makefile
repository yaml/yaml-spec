include tool/make/init.mk

SHELL := bash

default:

docker-build-all docker-push-all docker-pull-all:
	make -C tool/docker $@

build site serve publish publish-fork force diff:
	make -C www $@

_:
	git worktree prune
	git worktree add $@ $@
	make -C $@ all

clean:
	git worktree prune
	make -C 1.2 $@
	make -C spec $@
	make -C www $@
	make -C tool/docker clean-all
