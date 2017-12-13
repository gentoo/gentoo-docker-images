# This Dockerfile creates a portage snapshot that can be mounted as a 
# container volume. It utilizes a multi-stage build and requires 
# docker-17.05.0 or later. It fetches a daily snapshot from the official 
# sources and verifies its checksum as well as its gpg signature.

# As gpg keyservers sometimes are unreliable, we use multiple gpg server pools
# to fetch the signing key.

FROM alpine:3.7 as builder

WORKDIR /portage

ARG SNAPSHOT="portage-latest.tar.xz"
ARG DIST="https://ftp-osl.osuosl.org/pub/gentoo/snapshots"
ARG SIGNING_KEY="0xEC590EEAC9189250"

RUN apk add --no-cache gnupg tar wget xz \
 && wget -q -c "${DIST}/${SNAPSHOT}" "${DIST}/${SNAPSHOT}.gpgsig" "${DIST}/${SNAPSHOT}.md5sum" \
 && gpg --list-keys \
 && echo "standard-resolver" >> ~/.gnupg/dirmngr.conf \
 && echo "honor-http-proxy" >> ~/.gnupg/dirmngr.conf \
 && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys ${SIGNING_KEY} \
 && gpg --verify "${SNAPSHOT}.gpgsig" "${SNAPSHOT}" \
 && md5sum -c ${SNAPSHOT}.md5sum \
 && mkdir -p usr/portage/distfiles usr/portage/packages \
 && tar xJpf ${SNAPSHOT} -C usr \
 && rm ${SNAPSHOT} ${SNAPSHOT}.gpgsig ${SNAPSHOT}.md5sum

FROM busybox:latest

WORKDIR /
COPY --from=builder /portage/ /
CMD /bin/true
VOLUME /usr/portage
