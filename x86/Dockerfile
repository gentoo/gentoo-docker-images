FROM 32bit/debian:jessie

MAINTAINER Gentoo Docker Team

#ADD http://www.busybox.net/downloads/binaries/latest/busybox-i686 /busybox

# This one should be present by running the build.sh script
ADD build.sh /

RUN apt-get update && apt-get install -y \
	wget bzip2

RUN /build.sh x86 i686

# Setup the (virtually) current runlevel
RUN echo "default" > /run/openrc/softlevel

# Setup the rc_sys
RUN sed -e 's/#rc_sys=""/rc_sys="lxc"/g' -i /etc/rc.conf

# Setup the net.lo runlevel
RUN ln -s /etc/init.d/net.lo /run/openrc/started/net.lo

# Setup the net.eth0 runlevel
RUN ln -s /etc/init.d/net.lo /etc/init.d/net.eth0
RUN ln -s /etc/init.d/net.eth0 /run/openrc/started/net.eth0

# By default, UTC system
RUN echo 'UTC' > /etc/timezone

VOLUME ["${PORTAGE}:/usr/portage:rw", "${PORTAGE}/distfiles:/usr/portage/distfiles:rw"] 
 
RUN mkdir /etc/portage/package.accept_keywords 
RUN mkdir -p /etc/portage/package.use 
# avoid a Python 2 dependency 
RUN echo 'dev-vcs/git -python' >> /etc/portage/package.use/layman 
RUN echo 'app-portage/layman ~amd64' >> /etc/portage/package.accept_keywords/layman 
# required by app-portage/layman-2.1.0-r2 
# =dev-python/ssl-fetch-0.2.1 ~amd64 
RUN echo 'dev-python/ssl-fetch ~x86' >> /etc/portage/package.accept_keywords/layman 
 
 
38 RUN emerge -v layman python-2.7.10-r3
39 RUN eselect news read new 
40 RUN echo 'source /var/lib/layman/make.conf' >> /etc/portage/make.conf 
41 RUN sed -i 's/^check_official.*/check_official : no/' /etc/layman/layman.cfg 
42 RUN layman --fetch 
