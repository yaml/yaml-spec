include tool/make/init.mk

SHELL := bash

default:

docker-build-all docker-push-all:
	make -C tool/docker $@

build site serve stage publish force diff:
	make -C www $@

clean:
	git worktree prune
	make -C 1.2 $@
	make -C www $@
	make -C tool/docker clean-all
