FROM busybox

MAINTAINER Gentoo Docker Team

# This one should be present by running the build.sh script
ADD build.sh /

RUN /build.sh amd64 x86_64 -nomultilib

# Setup the rc_sys
RUN sed -e 's/#rc_sys=""/rc_sys="docker"/g' -i /etc/rc.conf

# By default, UTC system
RUN echo 'UTC' > /etc/timezone
