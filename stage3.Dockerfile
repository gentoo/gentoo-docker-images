# syntax=docker/dockerfile:1

# FIRST LINE IS VERY IMPORTANT. DO NOT MODIFY

# This Dockerfile creates a gentoo stage3 container image. By default it
# creates a stage3-amd64 image. It utilizes a multi-stage build and requires
# docker-17.05.0 or later. It fetches a daily snapshot from the official
# sources and verifies its checksum as well as its gpg signature.

ARG BOOTSTRAP
FROM --platform=$BUILDPLATFORM ${BOOTSTRAP:-alpine:3.23} as builder

WORKDIR /gentoo

ARG ARCH=amd64
ARG MICROARCH=amd64
ARG SUFFIX
ARG DIST="https://ftp-osl.osuosl.org/pub/gentoo/releases/${ARCH}/autobuilds"
ARG SIGNING_KEY="0x13EBBDBEDE7A12775DFDB1BABB572E0E2D182910"

RUN apk --no-cache add bash
SHELL ["/bin/bash", "-c"]

RUN <<-EOF
    set -e

    echo "Building Gentoo Container image for ${ARCH} ${SUFFIX} fetching from ${DIST}"

    apk --no-cache add ca-certificates gnupg tar wget xz

    # setup GPG
    gpg --list-keys
    # make sure to have <tab> in following heredoc
    # https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_07_04
     cat <<-GPG >> ~/.gnupg/dirmngr.conf
	honor-http-proxy
	disable-ipv6
	GPG
    gpg --keyserver hkps://keys.gentoo.org --recv-keys ${SIGNING_KEY} || \
    	gpg --auto-key-locate=clear,nodefault,wkd --locate-key releng@gentoo.org
    gpg --batch --passphrase '' --no-default-keyring --quick-generate-key me@localhost
    gpg --no-default-keyring --quick-lsign-key ${SIGNING_KEY}

    # obtain and extract stage3
    wget -q "${DIST}/latest-stage3-${MICROARCH}${SUFFIX}.txt"
    gpg --verify "latest-stage3-${MICROARCH}${SUFFIX}.txt"
    STAGE3PATH="$(sed -n '6p' "latest-stage3-${MICROARCH}${SUFFIX}.txt" | cut -f 1 -d ' ')"
    echo "STAGE3PATH:" ${STAGE3PATH}
    STAGE3="$(basename ${STAGE3PATH})"
    wget -q "${DIST}/${STAGE3PATH}" "${DIST}/${STAGE3PATH}.asc"
    gpg_temp=$(mktemp -d)
    gpg --batch --status-fd 3 --verify "${STAGE3}.asc" "${STAGE3}" 3> ${gpg_temp}/gpg.status
    for token in GOODSIG VALIDSIG TRUST_FULLY; do
        [[ $'\n'$(<${gpg_temp}/gpg.status) == *$'\n[GNUPG:] '"${token} "* ]] || exit 1
    done
    tar xpf "${STAGE3}" --xattrs-include='*.*' --numeric-owner

    # modify stage3
    ( sed -i -e 's/#rc_sys=""/rc_sys="docker"/g' etc/rc.conf 2>/dev/null || true )
    echo 'UTC' > etc/timezone

    # cleanup
    rm "${STAGE3}".asc "${STAGE3}" "${gpg_temp}"/gpg.status
    rmdir "${gpg_temp}"
EOF

FROM scratch

WORKDIR /
COPY --from=builder /gentoo/ /
CMD ["/bin/bash"]
