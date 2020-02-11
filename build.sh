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

# Ensure upstream directories for stage3-amd64-hardened+nomultilib work
SUFFIX=${SUFFIX/-/+}

VERSION=${VERSION:-$(date -u +%Y%m%d)}

ORG=${ORG:-gentoo}

# x86 requires the i686 subfolder
if [[ "${ARCH}" == "x86" ]]; then
	MICROARCH="i686"
	BOOTSTRAP="multiarch/alpine:x86-v3.7"
elif [[ "${ARCH}" = ppc* ]]; then
	MICROARCH="${ARCH}"
	ARCH=ppc
elif [[ "${ARCH}" = arm* ]]; then
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
docker tag "${ORG}/${TARGET}:${VERSION}" "${ORG}/${TARGET}:latest"
