SHELL := bash

TTY := $(shell [ -t 0 ] && echo 1)
UID := $(shell id -u)
GID := $(shell id -g)

ifneq ($(wildcard /.dockerenv),)
IN_DOCKER := true
endif

ifdef IN_DOCKER
    export YAML_SPEC_ROOT := /host
else
ifndef YAML_SPEC_ROOT
    $(info YAML_SPEC_ROOT is not set)
    $(info Run 'source .rc' before using 'make' commands)
    $(error Environment error)
endif
endif

ROOT := $(YAML_SPEC_ROOT)

SPEC12 := $(ROOT)/1.2
SPEC := $(ROOT)/spec
DOC := $(ROOT)/doc
GRAMMAR := $(ROOT)/grammar
RFC := $(ROOT)/rfc
STORY := $(ROOT)/story
TOOL := $(ROOT)/tool
WWW := $(ROOT)/www

export PATH := $(TOOL)/docker/bin:$(TOOL)/bin:$(PATH)

ifeq ($(YAML_SPEC_DIR),)
base := $(shell dirname $(abspath $(firstword $(MAKEFILE_LIST))))
override YAML_SPEC_DIR := $(base:$(ROOT)%=%)
override YAML_SPEC_DIR := $(YAML_SPEC_DIR:/%=%)
endif
export YAML_SPEC_DIR

# Make sure Mac uses coreutils where needed:
TOUCH := touch
ostype := $(shell uname -s)
ifeq ($(ostype),Darwin)
ifeq ($(shell command -v gtouch),)
$(info Need coreutils for Mac)
$(info Try 'brew install coreutils')
$(error)
endif
TOUCH := gtouch
endif

.SECONDEXPANSION:
.DELETE_ON_ERROR:
default:

ifdef DOCKER_TOOL
include $(ROOT)/tool/docker/$(DOCKER_TOOL)/docker.mk
include $(ROOT)/tool/make/docker-run.mk

docker-build:
	make -C $(ROOT)/tool/docker/$(DOCKER_TOOL) $@

else
ifdef DOCKER_IMAGE_NAME
include $(ROOT)/tool/make/docker.mk
endif
endif
