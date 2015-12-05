FROM scratch
MAINTAINER Necrose99 necrose99@protonmail.net
ADD http://distfiles.gentoo.org/releases/x86/autobuilds/current-stage3-i686/hardened/stage3-i686-hardened-20151124.tar.bz2 /
VOLUME /usr/portage:rw", /usr/portage/distfiles:rw, /usr/portage/distfiles:rw

RUN env-update
RUN source /etc/profile 
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

ADD build-more.sh /
RUN /build-more.sh
#add more stuff via bash. and or add provisoning stub back. 
RUN ["/bin/bash"]
CMD ["/bin/bash"]
