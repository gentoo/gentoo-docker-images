# This Dockerfile creates a portage snapshot that can be mounted as a 
# container volume. It utilizes a multi-stage build and requires 
# docker-17.05.0 or later. It fetches a daily snapshot from the official 
# sources and verifies its checksum as well as its gpg signature.

# As gpg keyservers sometimes are unreliable, we use multiple gpg server pools
# to fetch the signing key.

FROM alpine:3.5 as builder

WORKDIR /portage

ARG SNAPSHOT="portage-latest.tar.xz"
ARG DIST="http://distfiles.gentoo.org/snapshots"
ARG SIGNING_KEY="0xEC590EEAC9189250"

RUN apk add --no-cache gnupg tar wget xz \
 && wget -q -c "${DIST}/${SNAPSHOT}" "${DIST}/${SNAPSHOT}.gpgsig" "${DIST}/${SNAPSHOT}.md5sum" \
 && gpg --keyserver hkps.pool.sks-keyservers.net --recv-keys ${SIGNING_KEY} \
 && gpg --verify "${SNAPSHOT}.gpgsig" "${SNAPSHOT}" \
 || gpg --keyserver keys.gnupg.net --recv-keys ${SIGNING_KEY} \
 || gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys ${SIGNING_KEY} \
 && md5sum -c ${SNAPSHOT}.md5sum \
 && mkdir -p usr/portage/distfiles usr/portage/packages \
 && tar xJpf ${SNAPSHOT} -C usr \
 && rm ${SNAPSHOT} ${SNAPSHOT}.gpgsig ${SNAPSHOT}.md5sum

FROM scratch

WORKDIR /

COPY --from=builder /portage/ /
