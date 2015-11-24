FROM 32bit/debian:jessie

MAINTAINER Gentoo Docker Team

#ADD http://www.busybox.net/downloads/binaries/latest/busybox-i686 /busybox

# This one should be present by running the build.sh script
ADD build.sh /

RUN apt-get update && apt-get install -y \
	wget bzip2

RUN /build.sh x86

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
=======
FROM necrose99/gentoo-docker-x86
# Hardend dont wana build the normal Way so OVERLAY it on a good Gentoo,
MAINTAINER   Necrose99 #Gentoo Docker Team

RUN eselect profile set i686-pc-linux-gnu-4.5.3-hardenednopie
RUN source /etc/profile
RUN emerge --oneshot gcc
RUN emerge --oneshot binutils virtual/libc
RUN emerge --depclean prelink
RUN emerge --emptytree --verbose @world
#Add portage
RUN cd /
RUN wget -q -c  http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2 /
RUN bzcat /portage-latest.tar.bz2 | tar -xf - -C /usr
RUN mkdir -p /usr/portage/distfiles /usr/portage/metadata /usr/portage/packages

RUN rm /portage-latest.tar.bz2
RUN rm /stage3-i686-hardened-20151117.tar.bz2
#Add Layman
Run emerge --sync
RUN emerge -v =dev-lang/python-2* =dev-lang/python-3* 
RUN Emerge -v git layman potage
RUN  Emerge -v sys-fs/squashfs-tools app-arch/p7zip
>>>>>>> origin/master
