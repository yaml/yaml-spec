SHELL := bash

TTY := $(shell [ -t 0 ] && echo 1)
UID := $(shell id -u)
GID := $(shell id -g)

ifneq ($(wildcard /.dockerenv),)
IN_DOCKER := true
endif

ifdef IN_DOCKER
    export ROOT := /host
else
    export ROOT := $(shell git rev-parse --show-toplevel)
endif

ifdef TEX_LOG
    export TEX_LOG
endif

SPEC12 := $(ROOT)/1.2
SPEC := $(ROOT)/spec
SPEC_2009 := $(SPEC)/1.2/docbook
SPEC_120 := $(SPEC)/1.2.0
SPEC_121 := $(SPEC)/1.2.1
SPEC_122 := $(SPEC)/1.2.2
SPEC_130 := $(SPEC)/1.3.0
DOC := $(ROOT)/doc
GRAMMAR := $(ROOT)/grammar
RFC := $(ROOT)/rfc
STORY := $(ROOT)/story
TOOL := $(ROOT)/tool
WWW := $(ROOT)/www

export PATH := $(ROOT)/bin:$(PATH)

ifeq ($(YAML_SPEC_DIR),)
base := $(shell dirname $(abspath $(firstword $(MAKEFILE_LIST))))
override YAML_SPEC_DIR := $(base:$(ROOT)%=%)
override YAML_SPEC_DIR := $(YAML_SPEC_DIR:/%=%)
endif
export YAML_SPEC_DIR

export RUN_OR_DOCKER_WORKDIR := $(YAML_SPEC_DIR)

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
