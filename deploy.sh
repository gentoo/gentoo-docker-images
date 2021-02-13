#!/bin/bash

if [[ -z "$TARGET" ]]; then
	echo "TARGET environment variable must be set e.g. TARGET=stage3-amd64."
	exit 1
fi

# Split the TARGET variable into three elements separated by hyphens
IFS=- read -r NAME ARCH SUFFIX <<< "${TARGET}"

# Push built images
docker push --all-tags "${ORG}/${NAME}"

if [[ "${TARGET}" != stage* ]]; then
	echo "Done! No manifests to push for TARGET=${TARGET}."
	exit 0
fi

VERSION=${VERSION:-$(date -u +%Y%m%d)}

declare -A MANIFEST_ARCHES=(
	[stage3:latest]="amd64;arm64;armv5tel;armv6j_hardfp;armv7a_hardfp;ppc64le;s390x;x86"
	[stage3:hardened]="amd64;x86"
	[stage3:hardened-nomultilib]="amd64"
	[stage3:musl-hardened]="amd64"
	[stage3:musl-vanilla]="amd64;x86"
	[stage3:nomultilib]="amd64"
	[stage3:systemd]="amd64;arm64;x86"
	[stage3:uclibc-hardened]="amd64;x86"
	[stage3:uclibc-vanilla]="amd64;x86"
)

# Latest manifests
MANIFEST="${NAME}:${SUFFIX:-latest}"
IFS=';' read -ra ARCHES <<< "${MANIFEST_ARCHES[${MANIFEST}]}"

TAGS=()
for ARCH in "${ARCHES[@]}"; do
	TAG="${ORG}/${NAME}:${ARCH}${SUFFIX:+-${SUFFIX}}"
	if docker manifest inspect "${TAG}" 1>/dev/null 2>&1; then
		TAGS+=("${TAG}")
	fi
done

docker manifest create "${ORG}/${MANIFEST}" "${TAGS[@]}"
docker manifest push "${ORG}/${MANIFEST}"

# Dated manifests
MANIFEST="${NAME}:${SUFFIX:+${SUFFIX}-}${VERSION}"

TAGS=()
for ARCH in "${ARCHES[@]}"; do
	TAG="${ORG}/${NAME}:${ARCH}${SUFFIX:+-${SUFFIX}}-${VERSION}"
	if docker manifest inspect "${TAG}" 1>/dev/null 2>&1; then
		TAGS+=("${TAG}")
	fi
done

docker manifest create "${ORG}/${MANIFEST}" "${TAGS[@]}"
docker manifest push "${ORG}/${MANIFEST}"
