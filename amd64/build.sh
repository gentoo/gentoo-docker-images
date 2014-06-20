#!/bin/bash

die()
{
	echo "$1"
	exit 1
}

base_url="http://distfiles.gentoo.org/releases/amd64/autobuilds"

latest_stage3=$(curl "${base_url}/latest-stage3-amd64.txt" 2>/dev/null | grep -v '#')
stage3=$(basename "${latest_stage3}")

if [ ! -f "${stage3}" ]; then
	xz=true
else
	xz=false
fi

wget -nc "${base_url}/${latest_stage3}" || die "couldn't download stage3"
wget -nc "${base_url}/${latest_stage3}.DIGESTS.asc" || die "couldn't download digests"
wget -nc "${base_url}/${latest_stage3}.CONTENTS" || die "couldn't download contents"
sha512_digests=$(grep -A1 SHA512 "${stage3}.DIGESTS.asc" | grep -v '^--')
gpg --verify "${stage3}.DIGESTS.asc" || die "insecure digests"
echo "${sha512_digests}" | sha512sum -c || die "checksum validation failed"

if [ ${xz} == true ] || [ ! -f stage3-amd64.tar.xz ]; then
	echo "I'm transforming the bz2 tarball to xz (golang bug). This will take some time..."
	bunzip2 -c "${stage3}" | xz -z > stage3-amd64.tar.xz || die "failed to recompress to xz"
fi
echo "I'm done with the stage3."

echo "Building docker Gentoo image now..."
docker build -t gentoo .