# This Dockerfile creates a shallow ::gentoo git snapshot that can be
# mounted as a container volume. It utilizes a multi-stage build and
# requires docker-17.05.0 or later. It performs a shallow clone of the
# sync friendly ::gentoo git repository from the official sources and
# verifies its checksum as well as its gpg signature.

FROM --platform=$BUILDPLATFORM alpine:3.11 as builder

ARG GIT_REPO="https://github.com/gentoo-mirror/gentoo.git"
ARG SIGNING_KEY="F748E9B3C47E393CC24C8FAF7C2AC09CD98F2EDF"

RUN apk add --no-cache ca-certificates gnupg git
RUN git clone --depth 1 "${GIT_REPO}" /gentoo-git

RUN gpg --list-keys \
 && echo "honor-http-proxy" >> ~/.gnupg/dirmngr.conf \
 && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
 && gpg --keyserver hkps://keys.gentoo.org --recv-keys ${SIGNING_KEY} \
 && git -C gentoo-git verify-commit @

FROM busybox:latest

WORKDIR /
COPY --from=builder /gentoo-git/ /
CMD /bin/true
VOLUME /var/db/repos/gentoo
