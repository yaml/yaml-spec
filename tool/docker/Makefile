ALL := $(shell echo */Dockerfile)
ALL := $(ALL:%/Dockerfile=%)

ALL_BUILD := $(ALL:%=%-BUILD)
ALL_PUSH := $(ALL:%=%-PUSH)
ALL_PULL := $(ALL:%=%-PULL)
ALL_CLEAN := $(ALL:%=%-CLEAN)

default:

docker-build-all: $(ALL_BUILD)

docker-push-all: $(ALL_PUSH)

docker-pull-all: $(ALL_PULL)

clean-all: $(ALL_CLEAN)

%-BUILD:
	make -C $(@:%-BUILD=%) docker-build

%-PUSH:
	make -C $(@:%-PUSH=%) docker-push

%-PULL:
	make -C $(@:%-PULL=%) docker-pull

%-CLEAN:
	make -C $(@:%-CLEAN=%) clean
