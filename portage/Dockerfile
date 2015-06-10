FROM busybox:latest
MAINTAINER Gentoo Container Team <containers@gentoo.org>

ADD http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2 /
RUN mkdir -p /usr && bzcat /portage-latest.tar.bz2 | tar -xf - -C /usr \
	&& mkdir -p /usr/portage/{distfiles,metadata,packages} \
	&& echo "masters = gentoo" > /usr/portage/metadata/layout.conf \
	&& rm -f /portage-latest.tar.bz2
