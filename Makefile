include tool/make/init.mk

SHELL := bash

default:

docker-build-all docker-push-all docker-pull-all:
	$(MAKE) -C tool/docker $@

build site serve publish publish-fork force diff:
	$(MAKE) -C www $@

_:
	git worktree prune
	git worktree add $@ $@
	$(MAKE) -C $@ all

clean:
	git worktree prune
	$(MAKE) -C spec/2009 $@
	$(MAKE) -C www $@
	$(MAKE) -C tool/docker clean-all
