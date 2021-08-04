#!/bin/bash

# Used to create Gentoo stage3 and portage containers simply by specifying a 
# TARGET env variable.
# Example usage: TARGET=stage3-amd64 ./build.sh

if [[ -z "$TARGET" ]]; then
	echo "TARGET environment variable must be set e.g. TARGET=stage3-amd64-openrc."
	exit 1
fi

# Split the TARGET variable into three elements separated by hyphens
IFS=- read -r NAME ARCH SUFFIX <<< "${TARGET}"

VERSION=${VERSION:-$(date -u +%Y%m%d)}
if [[ "${NAME}" == "portage" ]]; then
	VERSION_SUFFIX=":${VERSION}"
else
	VERSION_SUFFIX="-${VERSION}"
fi

ORG=${ORG:-gentoo}

case $ARCH in
	"amd64" | "arm64")
		DOCKER_ARCH="${ARCH}"
		MICROARCH="${ARCH}"
		;;
	"armv"*)
		# armv6j_hardfp -> arm/v6
		# armv7a_hardfp -> arm/v7
		DOCKER_ARCH=$(echo "$ARCH" | sed -e 's#arm\(v.\).*#arm/\1#g')
		MICROARCH="${ARCH}"
		ARCH="arm"
		;;
	"i686")
		DOCKER_ARCH="386"
		MICROARCH="${ARCH}"
		ARCH="x86"
		;;
	"ppc64le")
		DOCKER_ARCH="${ARCH}"
		MICROARCH="${ARCH}"
		ARCH="ppc"
		;;
	"s390x")
		DOCKER_ARCH="${ARCH}"
		MICROARCH="${ARCH}"
		ARCH="s390"
		;;
	*)  # portage
		DOCKER_ARCH="amd64"
		;;
esac

# Prefix the suffix with a hyphen to make sure the URL works
if [[ -n "${SUFFIX}" ]]; then
	SUFFIX="-${SUFFIX}"
fi

docker buildx build \
	--file "${NAME}.Dockerfile" \
	--build-arg ARCH="${ARCH}" \
	--build-arg MICROARCH="${MICROARCH}" \
	--build-arg SUFFIX="${SUFFIX}" \
	--tag "${ORG}/${TARGET/-/:}" \
	--tag "${ORG}/${TARGET/-/:}${VERSION_SUFFIX}" \
	--platform "linux/${DOCKER_ARCH}" \
	--progress plain \
	--load \
	.
