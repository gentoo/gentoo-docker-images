#!/bin/bash

if [[ -z "$TARGET" ]]; then
	echo "TARGET environment variable must be set e.g. TARGET=stage3:latest."
	exit 1
fi

# Split the TARGET variable into two elements separated by colons
IFS=: read -r NAME MANIFEST_TAG <<< "${TARGET}"

VERSION=${VERSION:-$(date -u +%Y%m%d)}

ORG=${ORG:-gentoo}

declare -A MANIFEST_TAGS=(
	[stage3:latest]="amd64-openrc;armv5tel-openrc;armv6j_hardfp-openrc;armv7a_hardfp-openrc;arm64-openrc;i686-openrc;ppc64le-openrc;rv64_lp64d-openrc;s390x"
	[stage3:desktop]="amd64-desktop-openrc;arm64-desktop-openrc"
	[stage3:hardened]="amd64-hardened-openrc;i686-hardened-openrc"
	[stage3:hardened-nomultilib]="amd64-hardened-nomultilib-openrc"
	[stage3:musl]="amd64-musl;armv7a_hardfp_musl-openrc;arm64-musl;i686-musl"
	[stage3:musl-hardened]="amd64-musl-hardened;arm64-musl-hardened;ppc64le-musl-hardened-openrc"
	[stage3:nomultilib]="amd64-nomultilib-openrc"
	[stage3:nomultilib-systemd]="amd64-nomultilib-systemd"
	[stage3:systemd]="amd64-systemd;armv5tel-systemd;armv6j_hardfp-systemd;armv7a_hardfp-systemd;arm64-systemd;i686-systemd;ppc64le-systemd;rv64_lp64d-systemd"
)

IFS=';' read -ra TAGS <<< "${MANIFEST_TAGS[${TARGET}]}"
if [[ -z "${TAGS+x}" ]]; then
	echo "Done! No manifests to push for TARGET=${TARGET}."
	exit 0
fi
MANIFEST="${TARGET}"

# Latest manifests
IMAGES=()
for TAG in "${TAGS[@]}"; do
	IMAGE="${ORG}/${NAME}:${TAG}"
	if docker manifest inspect "${IMAGE}" &>/dev/null; then
		IMAGES+=("${IMAGE}")
	fi
done

docker manifest create "${ORG}/${MANIFEST}" "${IMAGES[@]}"
docker manifest push "${ORG}/${MANIFEST}"

# Dated manifests
MANIFEST="${MANIFEST}-${VERSION}"
MANIFEST="${MANIFEST/:latest-/:}"  # Remove "latest" tag prefix

IMAGES=()
for TAG in "${TAGS[@]}"; do
	IMAGE="${ORG}/${NAME}:${TAG}-${VERSION}"
	if docker manifest inspect "${IMAGE}" &>/dev/null; then
		IMAGES+=("${IMAGE}")
	fi
done

docker manifest create "${ORG}/${MANIFEST}" "${IMAGES[@]}"
docker manifest push "${ORG}/${MANIFEST}"
