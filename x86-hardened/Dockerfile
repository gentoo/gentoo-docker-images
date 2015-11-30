FROM scratch
MAINTAINER Necrose99 necrose99@protonmail.net
ADD http://distfiles.gentoo.org/releases/x86/autobuilds/current-stage3-i686/hardened/stage3-i686-hardened-20151124.tar.bz2 /
RUN ["/bin/bash"]
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

#Add portage
ADD http://distfiles.gentoo.org/snapshots/portage-latest.tar.bz2 /
RUN bzcat /portage-latest.tar.bz2 | tar -xf - -C /usr
RUN mkdir -p /usr/portage/distfiles /usr/portage/metadata /usr/portage/packages
RUN rm /portage-latest.tar.bz2

#Add Layman
Run emerge-webrsync -q 
Run Emerge -v sys-fs/squashfs-tools app-arch/p7zip 
RUN emerge -v =dev-lang/python-2* =dev-lang/python-3* 
Run Emerge -v git layman potage
CMD ["/bin/bash"]
