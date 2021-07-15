ifndef DOCKER_IMAGE_NAME
$(error DOCKER_IMAGE_NAME not set)
endif

DOCKER_IMAGE_ORG ?= yamlio
DOCKER_IMAGE ?= \
    $(DOCKER_IMAGE_ORG)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

HISTORY_FILE := /tmp/docker-bash_history

DOCKER_SHELL_OPTS := \
    --volume $(HISTORY_FILE):/root/.bash_history \

IT :=
ifdef TTY
    IT := -it
endif

define docker-run
touch $(HISTORY_FILE)
docker run $(IT) --rm \
    --volume $(ROOT):/host \
    --workdir /host/$(YAML_SPEC_DIR) \
    --entrypoint= \
    $(DOCKER_RUN_OPTS) \
    $2 \
    $(DOCKER_IMAGE) \
    $1
endef

docker-shell: docker-build
	$(call docker-run,bash)
