FROM busybox:latest
MAINTAINER Gentoo Container Team <containers@gentoo.org>

ADD http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2 /
RUN mkdir /usr && bzcat /portage-latest.tar.bz2 | tar -xf - -C /usr
