FROM 32bit/debian:jessie

MAINTAINER Gentoo Docker Team

#ADD http://www.busybox.net/downloads/binaries/latest/busybox-i686 /busybox

# This one should be present by running the container-build.sh script
ADD container-build.sh /

RUN apt-get update && apt-get install -y \
	wget bzip2

RUN /container-build.sh x86 i686
