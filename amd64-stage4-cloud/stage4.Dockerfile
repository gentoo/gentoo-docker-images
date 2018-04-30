# This Dockerfile creates a gentoo stage3 container image. By default it 
# creates a stage4-amd64 image. It utilizes a multi-stage build and requires 
# docker-17.05.0 or later. It fetches a daily snapshot from the official 
# sources and verifies its checksum as well as its gpg signature.

# As gpg keyservers sometimes are unreliable, we use multiple gpg server pools
# to fetch the signing key.

ARG BOOTSTRAP
FROM ${BOOTSTRAP:-alpine:3.7} as builder

WORKDIR /gentoo

ARG ARCH=amd64
ARG MICROARCH=amd64
ARG SUFFIX=systemd
ARG DIST="https://ftp-osl.osuosl.org/pub/gentoo/releases/${ARCH}/autobuilds"
ARG SIGNING_KEY="0xBB572E0E2D182910"

RUN echo "Building Gentoo Container image for ${ARCH} ${SUFFIX} fetching from ${DIST}" \
 && apk --no-cache add gnupg tar wget xz \
 && STAGE4PATH="$(wget -O- "${DIST}/latest-stage4-${MICROARCH}${SUFFIX}.txt" | tail -n 1 | cut -f 1 -d ' ')" \
 && echo "STAGE4PATH:" $STAGE4PATH \
 && STAGE4="$(basename ${STAGE4PATH})" \
 && wget -q "${DIST}/${STAGE4PATH}" "${DIST}/${STAGE4PATH}.CONTENTS" "${DIST}/${STAGE4PATH}.DIGESTS.asc" \
 && gpg --list-keys \
 && echo "standard-resolver" >> ~/.gnupg/dirmngr.conf \
 && echo "honor-http-proxy" >> ~/.gnupg/dirmngr.conf \
 && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf \
 && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys ${SIGNING_KEY} \
 && gpg --verify "${STAGE4}.DIGESTS.asc" \
 && awk '/# SHA512 HASH/{getline; print}' ${STAGE4}.DIGESTS.asc | sha512sum -c \
 && tar xpf "${STAGE4}" --xattrs --numeric-owner \
 && sed -i -e 's/#rc_sys=""/rc_sys="docker"/g' etc/rc.conf \
 && echo 'UTC' > etc/timezone \
 && rm ${STAGE4}.DIGESTS.asc ${STAGE4}.CONTENTS ${STAGE4}

FROM scratch

WORKDIR /
COPY --from=builder /gentoo/ /
CMD ["/bin/bash"]
## add cloud openstack tools.
emerge-webrsync
emerge  dev-python/setuptools dev-python/pbr dev-python/Babel dev-python/networkx dev-python/pyyaml dev-python/flake8 dev-python/six dev-python/stevedore
emerge  app-emulation/qemu sys-block/parted sys-fs/multipath-tools sys-fs/dosfstools sys-apps/gptfdisk dev-python/dib-utils app-emulation/diskimage-builder