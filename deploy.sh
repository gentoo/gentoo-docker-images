#!/bin/bash

if [[ -z "$TARGET" ]]; then
	echo "TARGET environment variable must be set e.g. TARGET=stage3-amd64-openrc."
	exit 1
fi

# Split the TARGET variable into three elements separated by hyphens
IFS=- read -r NAME ARCH SUFFIX <<< "${TARGET}"

ORG=${ORG:-gentoo}

# Push built images
docker push --all-tags "${ORG}/${NAME}"
