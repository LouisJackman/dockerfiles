CONTAINER_STORE := registry.gitlab.com/louis.jackman/dockerfiles
DEFAULT_PLATFORMS := linux/arm64,linux/amd64
ADDITIONAL_DOCKER_BUILD_FLAGS :=
LOCAL_REGISTRY := http://localhost:5000
REMOTE_REGISTRY := registry.gitlab.com/louis.jackman/dockerfiles
STOP_ON_FIRST_BUILD_ERROR := true

export

.PHONY: build
build:
	./scripts/build_images.py \
		--remaining-docker-build-args="$$ADDITIONAL_DOCKER_BUILD_ARGS" \
		--image-store="$$CONTAINER_STORE" \
		--default-platforms="$$DEFAULT_PLATFORMS" \
		--only-local-arch=true \
		--secure-manifest-inspections=false \
		--stop-on-first-build-error="$$STOP_ON_FIRST_BUILD_ERROR"

.PHONY: help
help:
	@echo
	@echo 'dockerfiles - Dockerfiles for programs and development environments I use.'
	@echo
	@echo Usage:
	@echo '   make                                   Build the images for just the current'
	@echo '                                          architecture, and load locally.'
	@echo
	@echo '   make help                              See this help section.'
	@echo
	@echo '   make upload-all-to-local-registry      Pull the images of all supported'
	@echo '                                          architectures from the default remote'
	@echo "                                          registry $$REMOTE_REGISTRY, assuming"
	@echo '                                          they are already pushed, and upload'
	@echo '                                          them to the default local registry'
	@echo "                                          $$LOCAL_REGISTRY."
	@echo
	@echo '   make pull-latest-from-local-registry   Pull the current latest image versions'
	@echo '                                          from the default local registry'
	@echo "                                          $$LOCAL_REGISTRY to the current"
	@echo '                                          container store.'
	@echo
	@echo '   make pull-latest-from-remote-registry  Pull the current latest image versions'
	@echo '                                          from the default remote registry'
	@echo "                                          $$REMOTE_REGISTY to the current"
	@echo '                                          container store.'
	@echo
	@echo '   make publish-locally                   Build the local images just for the'
	@echo '                                          current architecture and publish them'
	@echo '                                          to the default local registry'
	@echo "                                          $$LOCAL_REGISTRY."
	@echo
	@echo '   make publish                           Build the local images for all'
	@echo '                                          supported architectures and publish'
	@echo '                                          them to the default remote registry'
	@echo "                                          $$REMOTE_REGISTRY."
	@echo
	@echo '   make cascade-version-updates           Cascade written version bumps to'
	@echo '                                          descendent images; for example, if'
	@echo '                                          `base-dev` has been bumped, rewrite'
	@echo '                                          all descendent images to use that'
	@echo '                                          latest as their parent, and bump'
	@echo '                                          the versions of the images'
	@echo '                                          themselves.'
	@echo

.PHONY: upload-all-to-local-registry
upload-all-to-local-registry:
	./scripts/upload_to_local_registry.py \
		--local-registry="$$LOCAL_REGISTRY" \
		--remote-registry="$$REMOTE_REGISTRY" \
		--secure-manifest-inspections=false

.PHONY: pull-latest-from-local-registry
pull-latest-from-local-registry:
	./scripts/pull_from_registry.py \
		--registry="$$LOCAL_REGISTRY" \
		--secure-manifest-inspections=false

.PHONY: pull-latest-from-remote-registry
pull-latest-from-remote-registry:
	./scripts/pull_from_registry.py \
		--registry="$$REMOTE_REGISTRY"

.PHONY: publish-locally
publish-locally:
	./scripts/build_images.py \
		--remaining-docker-build-args="$$ADDITIONAL_DOCKER_BUILD_FLAGS" \
		--image-store="$$LOCAL_REGISTRY" \
		--default-platforms="$$DEFAULT_PLATFORMS" \
		--push=true \
		--only-local-arch=true \
		--secure-manifest-inspections=false \
		--stop-on-first-error="$$STOP_ON_FIRST_BUILD_ERROR"

.PHONY: publish
publish:
	./scripts/build_images.py \
		--remaining-docker-build-args="$$ADDITIONAL_DOCKER_BUILD_FLAGS" \
		--image-store="$$REMOTE_REGISTRY" \
		--default-platforms="$$DEFAULT_PLATFORMS" \
		--push=true \
		--stop-on-first-error="$$STOP_ON_FIRST_BUILD_ERROR"

.PHONY: cascade-version-updates
cascade-version-updates:
	./scripts/cascade_version_updates.py
