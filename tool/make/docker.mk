DOCKER_DIR ?= .
DOCKER_SHELL_CMD ?= tmux

docker-build:
	docker build \
	    -t $(DOCKER_IMAGE) \
	    -f $$(./Dockerfile.yaml) \
	    $(DOCKER_DIR)

docker-shell: docker-build
	$(call docker-run,$(DOCKER_SHELL_CMD))

docker-push: docker-build
	docker push $(DOCKER_IMAGE)

include $(ROOT)/tool/make/docker-run.mk
