#!/bin/bash

base_url="http://distfiles.gentoo.org/releases/amd64/autobuilds"

latest_stage3=$(curl "${base_url}/latest-stage3-amd64.txt" 2>/dev/null | grep -v '#')
stage3=$(basename "${latest_stage3}")

if [ -f "${stage3}" ]; then
	echo "Skipping download, I already have the tarball."
	if [ -f stage3-amd64.tar.xz ]; then
		xz=false
	else
		xz=true
	fi
else
	wget "${base_url}/${latest_stage3}" -O "${stage3}" || exit 1
	echo "I got the tarball alright."
	xz=true
fi

if [ ${xz} == true ]; then
	echo "I'm transforming the bz2 tarball to xz (golang bug). This will take some time..."
	bunzip2 -c "${stage3}" | xz -z > stage3-amd64.tar.xz || exit 2
fi
echo "I'm done with the tarball."

echo "Building docker Gentoo image now..."
docker build -t gentoo .