FROM 32bit/debian:jessie

MAINTAINER Gentoo Docker Team

#ADD http://www.busybox.net/downloads/binaries/latest/busybox-i686 /busybox

# This one should be present by running the build.sh script
ADD build.sh /

RUN apt-get update && apt-get install -y \
	wget bzip2

RUN /build.sh x86 i686

# Setup the rc_sys
RUN sed -e 's/#rc_sys=""/rc_sys="docker"/g' -i /etc/rc.conf

# By default, UTC system
RUN echo 'UTC' > /etc/timezone
