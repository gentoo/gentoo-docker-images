FROM amd64:latest
MAINTAINER Gentoo Container Team <containers@gentoo.org>

ENV PORTAGE_TARBALL portage-latest.tar.xz

ADD http://distfiles.gentoo.org/snapshots/$PORTAGE_TARBALL /
RUN mkdir -p /usr && xzcat /$PORTAGE_TARBALL | tar -xf - -C /usr \
	&& mkdir -p /usr/portage/{distfiles,metadata,packages} \
	&& chown -R portage:portage /usr/portage \
	&& echo "masters = gentoo" > /usr/portage/metadata/layout.conf \
	&& eselect news read new \
	&& env-update \
	&& rm -f /$PORTAGE_TARBALL
