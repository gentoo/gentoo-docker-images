# syntax=docker/dockerfile:1

# FIRST LINE IS VERY IMPORTANT. DO NOT MODIFY

# This Dockerfile creates a portage snapshot that can be mounted as a
# container volume. It utilizes a multi-stage build and requires
# docker-17.05.0 or later. It fetches a daily snapshot from the official
# sources and verifies its checksum as well as its gpg signature.

FROM --platform=$BUILDPLATFORM alpine:3.19 as builder

WORKDIR /portage

ARG SNAPSHOT="portage-latest.tar.xz"
ARG DIST="https://ftp-osl.osuosl.org/pub/gentoo/snapshots"
ARG SIGNING_KEY="0xEC590EEAC9189250"

RUN <<-EOF
    set -e

    apk add --no-cache ca-certificates gnupg tar wget xz
    wget -q "${DIST}/${SNAPSHOT}" "${DIST}/${SNAPSHOT}.gpgsig" "${DIST}/${SNAPSHOT}.md5sum"

    # setup GPG
    gpg --list-keys
    # make sure to have <tab> in following heredoc
    # https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_07_04
    cat <<-GPG >> ~/.gnupg/dirmngr.conf
	honor-http-proxy
	disable-ipv6
	GPG
    gpg --keyserver hkps://keys.gentoo.org --recv-keys ${SIGNING_KEY} || \
    	gpg --auto-key-locate=clear,nodefault,wkd --locate-key infrastructure@gentoo.org
    gpg --verify "${SNAPSHOT}.gpgsig" "${SNAPSHOT}"
    md5sum -c ${SNAPSHOT}.md5sum
    mkdir -p var/db/repos var/cache/binpkgs var/cache/distfiles
    tar xJpf ${SNAPSHOT} -C var/db/repos
    mv var/db/repos/portage var/db/repos/gentoo
    rm ${SNAPSHOT} ${SNAPSHOT}.gpgsig ${SNAPSHOT}.md5sum
EOF

FROM busybox:latest

WORKDIR /
COPY --from=builder /portage/ /
CMD /bin/true
VOLUME /var/db/repos/gentoo
