PREFIX?=registry.home.renwei.net:5000/ragflow
BASEIMAGE?=registry.home.renwei.net:5000/ragflow/base:v0.25.6-12-gaed60da29
RAGFLOW_VERSION?=$(shell git describe --tags --match=v* --first-parent --always)
TAG:=$(RAGFLOW_VERSION)
GIT_COMMIT=$(shell git rev-parse --short HEAD)
TIMETAG:=$(shell date +'%Y%m%d%H%M')

docker=podman
dockerbuildflags= --format docker
frontend:
	@echo "$@: $(TAG)"
	@${docker} build ${dockerbuildflags} -f Dockerfile.frontend -t $(PREFIX)/fe:$(TAG) \
		--build-arg ADMIN_UPSTREAM=api.ragflow.svc \
		--build-arg API_UPSTREAM=api.ragflow.svc \
		--build-arg RAGFLOW_VERSION=${RAGFLOW_VERSION} \
		.
	@echo "push image: ${docker} push $(PREFIX)/fe:$(TAG)"

ragflowbase:
	@echo "$@: $(TAG)"
	@${docker} build ${dockerbuildflags} -f Dockerfile.base -t $(PREFIX)/base:$(TAG) \
		--build-arg RAGFLOW_VERSION=${RAGFLOW_VERSION} \
		--build-arg NEED_MIRROR=1 \
		--build-arg BASEIMAGE=registry.home.renwei.net:5000/nvidia/cuda:12.9.2-cudnn-runtime-ubuntu24.04 \
		.
	@echo "push image: ${docker} push $(PREFIX)/base:$(TAG)"

ragflow:
	@echo "$@: $(TAG)"
	@${docker} build ${dockerbuildflags} -f Dockerfile -t $(PREFIX)/ragflow:$(TAG) \
		--build-arg RAGFLOW_VERSION=${RAGFLOW_VERSION} \
		--build-arg NEED_MIRROR=1 \
		--build-arg BASEIMAGE=${BASEIMAGE} \
		.
	@echo "push image: ${docker} push $(PREFIX)/ragflow:$(TAG)"

all: frontend ragflow
.PHONY: all
