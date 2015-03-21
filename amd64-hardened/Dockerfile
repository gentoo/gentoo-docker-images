FROM busybox

MAINTAINER Gentoo Docker Team

# This one should be present by running the container-build.sh script
ADD container-build.sh /

RUN /container-build.sh amd64 x86_64 -hardened
