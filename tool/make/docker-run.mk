ifndef DOCKER_IMAGE_NAME
$(error DOCKER_IMAGE_NAME not set)
endif

DOCKER_IMAGE_ORG ?= yamlio
DOCKER_IMAGE ?= $(DOCKER_IMAGE_ORG)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

IT :=
ifdef TTY
    IT := -it
endif

define docker-run
docker run $(IT) --rm \
    --volume $(ROOT):/host \
    --workdir /host/$(CWD) \
    $2 \
    $(DOCKER_IMAGE) \
    $1
endef
