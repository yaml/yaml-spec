DOCKER_DIR ?= .
CMD ?= bash

docker-build: $(DOCKER_DEPS) $(DOCKER_BIN)
	docker build \
	    -t $(DOCKER_IMAGE) \
	    $(DOCKERFILE) \
	    $(DOCKER_DIR)

$(DOCKER_BIN):
	cp $(ROOT)/tool/lib/$@.* $@
	chmod +x $@

docker-shell: docker-build
	$(call docker-run,$(CMD))

docker-push: docker-build
	docker push $(DOCKER_IMAGE)

clean:
	rm -f $(DOCKER_BIN)

include $(ROOT)/tool/make/docker-run.mk
