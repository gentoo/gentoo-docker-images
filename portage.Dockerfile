# syntax=docker/dockerfile:1

# FIRST LINE IS VERY IMPORTANT. DO NOT MODIFY

# This Dockerfile creates a portage snapshot that can be mounted as a
# container volume. It utilizes a multi-stage build and requires
# docker-17.05.0 or later. It fetches a daily snapshot from the official
# sources and verifies its checksum as well as its gpg signature.

FROM --platform=$BUILDPLATFORM alpine:3.23 as builder

WORKDIR /portage

ARG SNAPSHOT="gentoo-latest.tar.xz"
ARG DIST="https://ftp-osl.osuosl.org/pub/gentoo/snapshots"
ARG SIGNING_KEY="0xDCD05B71EAB94199527F44ACDB6B8C1F96D8BF6D"

RUN apk --no-cache add bash
SHELL ["/bin/bash", "-c"]

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
    gpg --batch --keyserver hkps://keys.gentoo.org --recv-keys ${SIGNING_KEY} || \
    	gpg --batch --auto-key-locate=clear,nodefault,wkd --locate-key infrastructure@gentoo.org
    gpg --batch --passphrase '' --no-default-keyring --quick-generate-key me@localhost
    gpg --batch --no-default-keyring --quick-lsign-key ${SIGNING_KEY}

    gpg_temp=$(mktemp -d)
    gpg --batch --status-fd 3 --verify -- "${SNAPSHOT}.gpgsig" "${SNAPSHOT}" 3> ${gpg_temp}/gpg.status
    for token in GOODSIG VALIDSIG TRUST_FULLY; do
        [[ $'\n'$(<${gpg_temp}/gpg.status) == *$'\n[GNUPG:] '"${token} "* ]] || exit 1
    done

    md5sum -c -- ${SNAPSHOT}.md5sum
    mkdir -p var/db/repos var/cache/binpkgs var/cache/distfiles
    tar xJpf ${SNAPSHOT} -C var/db/repos
    mv var/db/repos/gentoo-* var/db/repos/gentoo
    rm -- ${SNAPSHOT} ${SNAPSHOT}.gpgsig ${SNAPSHOT}.md5sum
    rm -- ${gpg_temp}/gpg.status
    rmdir -- ${gpg_temp}
EOF

FROM busybox:latest

WORKDIR /
COPY --from=builder /portage/ /
CMD /bin/true
VOLUME /var/db/repos/gentoo
