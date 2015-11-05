FROM busybox:latest
MAINTAINER Gentoo Container Team <containers@gentoo.org>

RUN mkdir -p /usr \
  && wget -O- -q http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2 \
  | zcat \
  | tar -xf - -C /usr \
  && mkdir -p /usr/portage/distfiles /usr/portage/metadata /usr/portage/packages 

VOLUME /usr/portage
