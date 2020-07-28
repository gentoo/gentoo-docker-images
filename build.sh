#!/bin/bash

# Used to create Gentoo stage3 and portage containers simply by specifying a 
# TARGET env variable.
# Example usage: TARGET=stage3-amd64 ./build.sh

if [[ -z "$TARGET" ]]; then
	echo "TARGET environment variable must be set e.g. TARGET=stage3-amd64."
	exit 1
fi

# Split the TARGET variable into three elements separated by hyphens
IFS=- read -r NAME ARCH SUFFIX <<< "${TARGET}"
DOCKER_ARCH="${ARCH}"

# Ensure upstream directories for stage3-amd64-hardened+nomultilib work
# unless we're building for musl targets (vanilla/hardened)
if [[ "${SUFFIX}" != *musl* ]]; then
	SUFFIX=${SUFFIX/-/+}
fi

VERSION=${VERSION:-$(date -u +%Y%m%d)}

ORG=${ORG:-gentoo}

# x86 requires the i686 subfolder
if [[ "${ARCH}" == "x86" ]]; then
	DOCKER_ARCH="386"
	MICROARCH="i686"
	BOOTSTRAP="multiarch/alpine:x86-v3.7"
elif [[ "${ARCH}" = ppc* ]]; then
	MICROARCH="${ARCH}"
	ARCH=ppc
elif [[ "${ARCH}" = arm* ]]; then
	DOCKER_ARCH=$(echo $ARCH | sed -e 's-\(v.\).*-/\1-g')
	MICROARCH="${ARCH}"
	ARCH=arm
else
	MICROARCH="${ARCH}"
fi

# Prefix the suffix with a hyphen to make sure the URL works
if [[ -n "${SUFFIX}" ]]; then
	SUFFIX="-${SUFFIX}"
fi

set -x
docker build --build-arg ARCH="${ARCH}" --build-arg MICROARCH="${MICROARCH}" --build-arg BOOTSTRAP="${BOOTSTRAP}" --build-arg SUFFIX="${SUFFIX}"  -t "${ORG}/${TARGET}:${VERSION}" -f "${NAME}.Dockerfile" .
docker-copyedit/docker-copyedit.py FROM "${ORG}/${TARGET}:${VERSION}" INTO "${ORG}/${TARGET}:${VERSION}" -vv \
    set arch ${DOCKER_ARCH}
docker tag "${ORG}/${TARGET}:${VERSION}" "${ORG}/${TARGET}:latest"
