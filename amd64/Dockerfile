FROM scratch

MAINTAINER Gentoo_Community

# This one should be present by running the build.sh script
ADD stage3-amd64.tar.xz /

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

# Used when this image is the base of another
#
# Setup the portage directory and permissions
ONBUILD RUN mkdir -p /usr/portage/{distfiles,metadata,packages}
ONBUILD RUN chown -R portage:portage /usr/portage
ONBUILD RUN echo "masters = gentoo" > /usr/portage/metadata/layout.conf
# Sync portage
ONBUILD RUN emerge-webrsync -q
ONBUILD RUN eselect news read new
# Finalization
ONBUILD RUN env-update
