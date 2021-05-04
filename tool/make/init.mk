SHELL := bash

ifeq ($(wildcard /.dockerenv),)
ifndef YAML_SPEC_ROOT
    $(info YAML_SPEC_ROOT is not set)
    $(info Run 'source .rc' before using 'make' commands)
    $(error Environment error)
endif
else
    export YAML_SPEC_ROOT := /host
endif

ROOT := $(YAML_SPEC_ROOT)

export PATH := $(ROOT)/tool/bin:$(PATH)

pwd := $(shell dirname $(abspath $(firstword $(MAKEFILE_LIST))))
CWD := $(pwd:$(ROOT)/%=%)

TTY := $(shell [ -t 0 ] && echo 1)

.DELETE_ON_ERROR:
default:

ifdef DOCKER_TOOL
include $(ROOT)/tool/docker/$(DOCKER_TOOL)/docker.mk
include $(ROOT)/tool/make/docker-run.mk

docker-%:
	make -C $(ROOT)/tool/docker/$(DOCKER_TOOL) $@
endif
