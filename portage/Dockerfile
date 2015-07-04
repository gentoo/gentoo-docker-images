FROM busybox:latest
MAINTAINER Gentoo Container Team <containers@gentoo.org>

ADD http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2 /

RUN mkdir -p /usr
RUN bzcat /portage-latest.tar.bz2 | tar -xf - -C /usr
RUN mkdir -p /usr/portage/{distfiles,metadata,packages}
