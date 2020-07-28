#!/bin/bash
docker manifest create gentoo/stage3 \
	gentoo/stage3-amd64  \
	gentoo/stage3-x86    \
	gentoo/stage3-amd64  \
	gentoo/stage3-ppc    \
	gentoo/stage3-ppc64  \
	gentoo/stage3-ppc64le
