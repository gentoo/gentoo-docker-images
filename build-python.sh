#!/usr/bin/env bash

NAME=python
VERSION=${VERSION:-$(date -u +%Y%m%d)}
VERSION_SUFFIX="-${VERSION}"

ORG=${ORG:-gentoo}

docker buildx build \
	--file "${NAME}.Dockerfile" \
	--build-arg ARCH="amd64" \
	--build-arg MICROARCH="amd64" \
	--tag "${ORG}/python" \
	--platform "linux/amd64" \
	--progress plain \
	--load \
	.
