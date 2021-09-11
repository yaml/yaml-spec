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
	$(MAKE) -C $(@:%-BUILD=%) docker-build

%-PUSH:
	$(MAKE) -C $(@:%-PUSH=%) docker-push

%-PULL:
	$(MAKE) -C $(@:%-PULL=%) docker-pull

%-CLEAN:
	@$(MAKE) --no-print-directory -C $(@:%-CLEAN=%) clean
